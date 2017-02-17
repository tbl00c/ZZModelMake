//
//  ViewController.m
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/16.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZModelMakeViewController.h"
#import "ZZModelConfig.h"
#import "ZZClass.h"

@interface ZZModelMakeViewController () <NSTextFieldDelegate>

/// JSON文件路径Label
@property (weak) IBOutlet NSTextField *pathLabel;

/// Model类路径
@property (nonatomic, strong) NSString *targetPath;
@property (weak) IBOutlet NSTextField *targetPathLabel;

/// 用户名
@property (weak) IBOutlet NSTextField *authorNameLabel;

/// 第三方库
@property (weak) IBOutlet NSComboBox *libComboBox;

/// Model类类名
@property (weak) IBOutlet NSTextField *classNameTF;

/// 生成Model类
@property (weak) IBOutlet NSButton *createButton;

/// 警告Label
@property (weak) IBOutlet NSTextField *warningLabel;

@end

@implementation ZZModelMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.classNameTF setEnabled:NO];
    [self.createButton setEnabled:NO];
    self.targetPathLabel.stringValue = self.targetPath;
    
    NSString *authorName = [ZZModelConfig sharedInstance].authorName;
    self.authorNameLabel.stringValue = authorName ? authorName : @"";
    
    [self.libComboBox selectItemAtIndex:[ZZModelConfig sharedInstance].thirdPartLibType];
    
    [self.classNameTF setPlaceholderString:[NSString stringWithFormat:@"%@*%@", [ZZModelConfig sharedInstance].classPrefix, [ZZModelConfig sharedInstance].classSuffix]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(namedRulesDidChanged) name:@"NamedRulesDidChanged" object:nil];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self.view.window makeFirstResponder:self.view];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - # Event Response
- (IBAction)loadJsonFileButtonClick:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:@[@"json", @"txt"]];
    __weak typeof(self)weakSelf = self;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSString *pathString = [panel.URLs.firstObject path];
            weakSelf.pathLabel.stringValue = pathString;
            NSString *fileName = [[pathString lastPathComponent] stringByDeletingPathExtension];
            NSString *className = [ZZProperty classNameByKey:fileName];
            self.classNameTF.stringValue = className;
            self.warningLabel.stringValue = @"JSON文件导入成功";
            [self.classNameTF setEnabled:YES];
            [self.createButton setEnabled:YES];
            
        }
        else {
            weakSelf.warningLabel.stringValue = @"已取消";
        }
    }];
}

- (IBAction)targetPathExchangeButtonClick:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    __weak typeof(self)weakSelf = self;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSString *pathString = [panel.URLs.firstObject path];
            weakSelf.targetPath = pathString;
            weakSelf.targetPathLabel.stringValue = pathString;
        }
    }];
}

- (IBAction)createButtonClick:(id)sender {
    NSString *jsonFilePath = self.pathLabel.stringValue;
    NSString *targetPath = self.targetPath;
    NSString *className = self.classNameTF.stringValue;
    
    // 更新用户名
    [[ZZModelConfig sharedInstance] setAuthorName:self.authorNameLabel.stringValue];
    
    // 如果目标路径不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            self.warningLabel.stringValue = [error description];
            return;
        }
    }
    
    // 加载json文件数据
    NSError *error;
    NSString *jsonStr = [NSString stringWithContentsOfFile:jsonFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        self.warningLabel.stringValue = [error description];
        return;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        self.warningLabel.stringValue = [error description];
        return;
    }
    
    // 生成class模型
    ZZClass *classModel = [[ZZClass alloc] initWithClassName:className andJson:jsonDic];
    if([classModel createFilesAtPath:targetPath]) {
        self.warningLabel.stringValue = [NSString stringWithFormat:@"%@及相关类生成成功", className];
        [[NSWorkspace sharedWorkspace] openFile:self.targetPath];
    }
    else {
        self.warningLabel.stringValue = [NSString stringWithFormat:@"%@及相关类创建失败", className];
    }
}

- (IBAction)thirdPartComboBoxChanged:(id)sender {
    NSInteger index = [(NSComboBox *)sender indexOfSelectedItem];
    [[ZZModelConfig sharedInstance] setThirdPartLibType:index];
}

- (void)namedRulesDidChanged
{
    NSString *pathString = self.pathLabel.stringValue;
    NSString *fileName = [[pathString lastPathComponent] stringByDeletingPathExtension];
    fileName = fileName.length > 0 ? fileName : @"*";
    NSString *className = [ZZProperty classNameByKey:fileName];
    self.classNameTF.stringValue = className;
}

#pragma mark - # Delegate
//MARK: NSTextFieldDelegate
- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    NSString *authorName = [(NSTextField *)obj.object stringValue];
    [[ZZModelConfig sharedInstance] setAuthorName:authorName];
}

#pragma mark - # Getter
- (NSString *)targetPath
{
    if (!_targetPath) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        _targetPath = [docPath stringByAppendingPathComponent:@"ModelClass"];
    }
    return _targetPath;
}


@end
