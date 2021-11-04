//
//  GLBIntentionListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBIntentionListController.h"

#import "GLBIntentionListCell.h"

static NSString *const listCellID = @"GLBIntentionListCell";

@interface GLBIntentionListController ()

@property (nonatomic, strong) NSMutableArray<GLBIntentionModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBIntentionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTableView];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestIntentionData:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestIntentionData:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBIntentionListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.intentionModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *params = [NSString stringWithFormat:@"id=%ld",[self.dataArray[indexPath.section] orderId]];
    [self dc_pushWebController:@"/qiye/personal_info.html" params:params];
}


#pragma mark - 请求 请求订购意向
- (void)requestIntentionData:(BOOL)isReload
{
    NSString *state = nil;
    if (_intentionType == GLBIntenTionTypeWait) {
        state = @"0";
    } else if (_intentionType == GLBIntenTionTypeConfirm) {
        state = @"1";
    } else if (_intentionType == GLBIntenTionTypeUnpass) {
        state = @"2";
    }
    
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestIntentionListWithCurrentPage:_page state:state success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 36, kScreenW , kScreenH - kNavBarHeight - 36);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (NSMutableArray<GLBIntentionModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
