//
//  GLBOrderListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOrderListController.h"
#import "GLBOrderListCell.h"

static NSString *const listCellID = @"GLBOrderListCell";

@interface GLBOrderListController ()

@property (nonatomic, strong) NSMutableArray<GLBOrderModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBOrderListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTableView];
    
    [self addRefresh:NO];
}

#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestOrderList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestOrderList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.orderModel = self.dataArray[indexPath.section];
    WEAKSELF;
    cell.orderBlock = ^(NSString *title) {
        
        if (weakSelf.sellerFirmName) {
            
            if (weakSelf.orderBlock) {
                weakSelf.orderBlock(weakSelf.dataArray[indexPath.section]);
            }
            
        } else {
            
            NSString * params = [NSString stringWithFormat:@"id=%ld",[weakSelf.dataArray[indexPath.section] orderNo]];
            [weakSelf dc_pushWebController:@"/qiye/order_detail.html" params:params];
        }
        
//        NSString *params = [NSString stringWithFormat:@"id=%ld",[weakSelf.dataArray[indexPath.section] orderNo]];
//        [weakSelf dc_pushWebController:@"/qiye/order_detail.html" params:params];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.sellerFirmName) {
        
        if (_orderBlock) {
            _orderBlock(self.dataArray[indexPath.section]);
        }
        
    } else {
        
        NSString * params = [NSString stringWithFormat:@"id=%ld",[self.dataArray[indexPath.section] orderNo]];
        [self dc_pushWebController:@"/qiye/order_detail.html" params:params];
    }
    
}


#pragma mark - 请求 获取订单列表
- (void)requestOrderList:(BOOL)isReload
{
    NSString *state = nil;
    if (_orderType != GLBOrderTypeAll) {
        state = [NSString stringWithFormat:@"%ld",(long)_orderType];
    }
    
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestOrderListWithCurrentPage:_page orderState:state firmName:self.sellerFirmName success:^(NSArray *array, BOOL hasNextPage) {
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
    self.tableView.frame = CGRectMake(10, kNavBarHeight + 32, kScreenW - 10*2, kScreenH - kNavBarHeight - 32);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (NSMutableArray<GLBOrderModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
