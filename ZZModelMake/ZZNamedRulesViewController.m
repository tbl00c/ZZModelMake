//
//  ZZNamedRulesViewController.m
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZNamedRulesViewController.h"
#import "ZZModelConfig.h"

@interface ZZNamedRulesViewController () <NSTableViewDataSource>

@property (weak) IBOutlet NSTextField *prefixLabel;
@property (weak) IBOutlet NSTextField *suffixLabel;
@property (weak) IBOutlet NSButton *originPrefixCheckBoox;
@property (weak) IBOutlet NSTableView *prefixTableView;
@property (weak) IBOutlet NSTableView *suffixTableView;

@property (nonatomic, strong) NSMutableArray *classPrefixIgnoreWords;
@property (nonatomic, strong) NSMutableArray *classSuffixIgnoreWords;

@end

@implementation ZZNamedRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self.view.window makeFirstResponder:self.view];
}

- (void)loadData
{
    self.prefixLabel.stringValue = [ZZModelConfig sharedInstance].classPrefix;
    self.suffixLabel.stringValue = [ZZModelConfig sharedInstance].classSuffix;
    self.originPrefixCheckBoox.state = [ZZModelConfig sharedInstance].userOriginClassNamsAsPrefix;
    self.classPrefixIgnoreWords = [ZZModelConfig sharedInstance].classPrefixIgnoreWords.mutableCopy;
    [self.prefixTableView reloadData];
    self.classSuffixIgnoreWords = [ZZModelConfig sharedInstance].classSuffixIgnoreWords.mutableCopy;
    [self.suffixTableView reloadData];
}

#pragma mark - Event Reponse
- (IBAction)addButtonClick:(NSButton *)sender {
    [self.view.window makeFirstResponder:self.view];
    NSMutableArray *array = @[@"New Item"].mutableCopy;
    if (sender.tag == 0) {
        [self.view.window makeFirstResponder:self.prefixTableView];
        [array addObjectsFromArray:self.classPrefixIgnoreWords];
        self.classPrefixIgnoreWords = array;
        [self.prefixTableView reloadData];
        [self.prefixTableView deselectRow:self.prefixTableView.selectedRow];
        [self.prefixTableView editColumn:0 row:0 withEvent:nil select:YES];
    }
    else if (sender.tag == 1) {
        [self.view.window makeFirstResponder:self.suffixTableView];
        [array addObjectsFromArray:self.classSuffixIgnoreWords];
        self.classSuffixIgnoreWords = array;
        [self.suffixTableView reloadData];
        [self.suffixTableView deselectRow:self.suffixTableView.selectedRow];
        [self.suffixTableView editColumn:0 row:0 withEvent:nil select:YES];
    }
}

- (IBAction)subButtonClick:(NSButton *)sender {
    [self.view.window makeFirstResponder:self.view];
    if (sender.tag == 0) {
        [self.view.window makeFirstResponder:self.prefixTableView];
        NSInteger selectIndex = self.prefixTableView.selectedRow;
        if (selectIndex >= 0 && selectIndex < self.classPrefixIgnoreWords.count) {
            [self.classPrefixIgnoreWords removeObjectAtIndex:selectIndex];
            [self.prefixTableView reloadData];
        }
    }
    else if (sender.tag == 1) {
        [self.view.window makeFirstResponder:self.suffixTableView];
        NSInteger selectIndex = self.suffixTableView.selectedRow;
        if (selectIndex >= 0 && selectIndex < self.classSuffixIgnoreWords.count) {
            [self.classSuffixIgnoreWords removeObjectAtIndex:selectIndex];
            [self.suffixTableView reloadData];
        }
    }
}

- (IBAction)okButtonClick:(id)sender {
    [self.view.window makeFirstResponder:self.view];
    [ZZModelConfig sharedInstance].classPrefix = self.prefixLabel.stringValue;
    [ZZModelConfig sharedInstance].classSuffix = self.suffixLabel.stringValue;
    [ZZModelConfig sharedInstance].userOriginClassNamsAsPrefix = self.originPrefixCheckBoox.state;
    [ZZModelConfig sharedInstance].classPrefixIgnoreWords = self.classPrefixIgnoreWords;
    [ZZModelConfig sharedInstance].classSuffixIgnoreWords = self.classSuffixIgnoreWords;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NamedRulesDidChanged" object:nil];
    [self.view.window close];
}

- (IBAction)resetButtonClick:(id)sender {
    [[ZZModelConfig sharedInstance] resetToDefaultConfig];
    [self loadData];
}

#pragma mark - # Delegate
//MARK: NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView.tag == 0) {
        return self.classPrefixIgnoreWords.count;
    }
    else if (tableView.tag == 1) {
        return self.classSuffixIgnoreWords.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView.tag == 0) {
        NSString *title = self.classPrefixIgnoreWords[row];
        return title;
    }
    else if (tableView.tag == 1) {
        NSString *title = self.classSuffixIgnoreWords[row];
        return title;
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView.tag == 0) {
        if (row < self.classPrefixIgnoreWords.count) {
            [self.classPrefixIgnoreWords replaceObjectAtIndex:row withObject:object];
        }
    }
    else if (tableView.tag == 1) {
        if (row < self.classSuffixIgnoreWords.count) {
            [self.classSuffixIgnoreWords replaceObjectAtIndex:row withObject:object];
        }
    }
}

@end
