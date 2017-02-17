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
@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic, strong) NSMutableArray *classIgnoreWords;

@end

@implementation ZZNamedRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData
{
    self.prefixLabel.stringValue = [ZZModelConfig sharedInstance].classPrefix;
    self.suffixLabel.stringValue = [ZZModelConfig sharedInstance].classSuffix;
    self.originPrefixCheckBoox.state = [ZZModelConfig sharedInstance].userOriginClassNamsAsPrefix;
    self.classIgnoreWords = [ZZModelConfig sharedInstance].classIgnoreWords.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - Event Reponse
- (IBAction)addButtonClick:(id)sender {
    [self.view.window makeFirstResponder:self.view];
    NSMutableArray *array = @[@"New Item"].mutableCopy;
    [array addObjectsFromArray:self.classIgnoreWords];
    self.classIgnoreWords = array;
    [self.tableView reloadData];
    [self.tableView deselectRow:self.tableView.selectedRow];
    [self.tableView editColumn:0 row:0 withEvent:nil select:YES];
}

- (IBAction)subButtonClick:(id)sender {
    [self.view.window makeFirstResponder:self.tableView];
    NSInteger selectIndex = self.tableView.selectedRow;
    if (selectIndex >= 0 && selectIndex < self.classIgnoreWords.count) {
        [self.classIgnoreWords removeObjectAtIndex:selectIndex];
        [self.tableView reloadData];
    }
}

- (IBAction)okButtonClick:(id)sender {
    [ZZModelConfig sharedInstance].classPrefix = self.prefixLabel.stringValue;
    [ZZModelConfig sharedInstance].classSuffix = self.suffixLabel.stringValue;
    [ZZModelConfig sharedInstance].userOriginClassNamsAsPrefix = self.originPrefixCheckBoox.state;
    [ZZModelConfig sharedInstance].classIgnoreWords = self.classIgnoreWords;
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
    return self.classIgnoreWords.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *title = self.classIgnoreWords[row];
    return title;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row < self.classIgnoreWords.count) {
        [self.classIgnoreWords replaceObjectAtIndex:row withObject:object];
    }
}

@end
