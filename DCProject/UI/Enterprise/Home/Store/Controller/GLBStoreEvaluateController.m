//
//  GLBStoreEvaluateController.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreEvaluateController.h"

#import "GLBStoreEvaluateHeadView.h"
#import "GLBStoreEvaluateCell.h"

//#import "GLBEvaluateDetailModel.h"

static NSString *const listCellID = @"GLBStoreEvaluateCell";

@interface GLBStoreEvaluateController ()

@property (nonatomic, strong) GLBStoreEvaluateHeadView *headView;

@property (nonatomic, strong) NSMutableArray<GLBStoreEvaluateModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger selectType; // 选择的类型
@property (nonatomic, strong) GLBEvaluateDetailModel *detailModel;

@end

@implementation GLBStoreEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUpTableView];
    [self.view addSubview:self.headView];
    
    [self addRefresh:YES];
    [self requestEvaluateAnalysis];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestEvaluateList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestEvaluateList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBStoreEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithModel:self.dataArray[indexPath.row] type:self.selectType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 请求 评价列表
- (void)requestEvaluateList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSString *type = @"";
    if (self.selectType == 0) {
        type = @"";
    } else if (self.selectType == 1) {
        type = @"1";
    } else if (self.selectType == 2) {
        type = @"2";
    } else if (self.selectType == 3) {
        type = @"3";
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestStoreEvaluateListWithCurrentPage:_page firmId:_storeModel.storeInfoVO.firmId type:type success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求 评价详情
- (void)requestEvaluateAnalysis
{
    self.detailModel = nil;
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestStoreEvaluateAnalyzeWithFirmId:_storeModel.storeInfoVO.firmId success:^(id response) {
        if (response && [response isKindOfClass:[GLBEvaluateDetailModel class]]) {
            weakSelf.detailModel = response;
            weakSelf.headView.detailModel = weakSelf.detailModel;
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, 105, kScreenW, kScreenH - kNavBarHeight - 61 - 105);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (GLBStoreEvaluateHeadView *)headView{
    if (!_headView) {
        _headView = [[GLBStoreEvaluateHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 105)];
        WEAKSELF;
        _headView.evaluetaBtnBlock = ^(NSInteger tag) {
            weakSelf.selectType = tag - 800;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _headView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
