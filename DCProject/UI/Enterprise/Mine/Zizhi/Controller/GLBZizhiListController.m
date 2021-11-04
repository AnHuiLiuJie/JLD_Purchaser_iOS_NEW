//
//  GLBZizhiListController.m
//  DCProject
//
//  Created by bigbing on 2019/8/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBZizhiListController.h"
#import "GLBZizhiListCell.h"



static NSString *const listCellID = @"GLBZizhiListCell";

@interface GLBZizhiListController ()

@property (nonatomic, strong) NSMutableArray<GLBQualificateListModel *> *dataArray;

@end

@implementation GLBZizhiListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTableView];
    
    [self addHeaderRefresh:NO];
}

#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestOrderList:YES];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBZizhiListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.listModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 请求 获取订单列表
- (void)requestOrderList:(BOOL)isReload
{
    if (isReload) {
        [self.dataArray removeAllObjects];
    }
    
    WEAKSELF;
    if (_zizhiType == GLBZizhiTypeCertified) {
        
        [[DCAPIManager shareManager] dc_requestCertifiedQualificateWithSuccess:^(id response) {
            
            if (response && [response isKindOfClass:[GLBQualificateModel class]]) {
                GLBQualificateModel *model = response;
                if (model.qcList && [model.qcList count] > 0) {
                    [weakSelf.dataArray addObjectsFromArray:model.qcList];
                }
            }
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
            
        } failture:^(NSError *error) {
            
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
        }];
        
    } else {
        
        [[DCAPIManager shareManager] dc_requestUnverifiedQualificateWithSuccess:^(id response) {
            
            if (response && [response isKindOfClass:[GLBQualificateModel class]]) {
                GLBQualificateModel *model = response;
                if (model.qcList && [model.qcList count] > 0) {
                    [weakSelf.dataArray addObjectsFromArray:model.qcList];
                }
            }
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
            
        } failture:^(NSError *error) {
            
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
        }];
    }
    
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, 0, kScreenW , kScreenH - kNavBarHeight - 32 - self.height);
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
- (NSMutableArray<GLBQualificateListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
