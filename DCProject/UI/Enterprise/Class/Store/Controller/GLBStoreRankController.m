//
//  GLBStoreRankController.m
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreRankController.h"
#import "GLBRankFiltrateCell.h"

static NSString *const listCellID = @"GLBRankFiltrateCell";

@interface GLBStoreRankController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation GLBStoreRankController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.cancelBtn];
    
    [self setUpTableView];
    
    [self.dataArray addObjectsFromArray:@[@"综合排序",@"按销量排序",@"按评价数从高到低",@"按起配金额从低到高",@"按入驻时间从新到旧"]];
    [self reloadTableViewWithDatas:self.dataArray hasNextPage:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBRankFiltrateCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithArray:self.dataArray indexPath:indexPath selectIndexPath:_selectIndexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndexPath && _selectIndexPath == indexPath) {
        return;
    }
    
    _selectIndexPath = indexPath;
    [tableView reloadData];
    
    [self cancelBtnClick:nil];
}


#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view removeFromSuperview];
    
    if (_cancelBlock) {
        _cancelBlock(self.dataArray[_selectIndexPath.row]);
    }
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, 50*5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40)];
        _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    }
    return _bgView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = [UIScreen mainScreen].bounds;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - setter
- (void)setRankStr:(NSString *)rankStr
{
    _rankStr = rankStr;
    
    if ([_rankStr isEqualToString:@"综合排序"]) {
        _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else if ([_rankStr isEqualToString:@"按销量排序"]) {
        _selectIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    } else if ([_rankStr isEqualToString:@"按评价数从高到低"]) {
        _selectIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    } else if ([_rankStr isEqualToString:@"按起配金额从低到高"]) {
        _selectIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    } else if ([_rankStr isEqualToString:@"按入驻时间从新到旧"]) {
        _selectIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    }
}

@end
