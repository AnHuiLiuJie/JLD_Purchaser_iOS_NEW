//
//  GLBStoreListController.m
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreListController.h"
#import "GLBStoreFiltrateView.h"
#import "GLBGoodsNavigationBar.h"
#import "GLBCareListCell.h"

#import "GLBStoreOtherFiltrateController.h"
#import "GLBStoreRankController.h"
#import "GLBStorePageController.h"
#import "GLBGoodsDetailController.h"

#import "GLBRangModel.h"

static NSString *const listCellID = @"GLBCareListCell";

@interface GLBStoreListController ()

@property (nonatomic, strong) GLBGoodsNavigationBar *navBar;
@property (nonatomic, strong) GLBStoreFiltrateView *filtrateView;
@property (nonatomic, strong) NSMutableArray<GLBStoreListModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

// 选择的排序方式
@property (nonatomic, strong) NSString *rankStr;
// 选择的优惠
@property (nonatomic, strong) NSMutableArray *selectDiscountArray;
// 选择的起配金额
@property (nonatomic, strong) NSMutableArray *selectPriceArray;
// 选择的经营范围
@property (nonatomic, strong) NSMutableArray *selectRangArray;

@end

@implementation GLBStoreListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rankStr = @"综合排序";
    [self setUpTableView];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.filtrateView];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top);
        make.right.equalTo(self.view.right);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.filtrateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.navBar.bottom);
        make.right.equalTo(self.view.right);
        make.height.equalTo(40);
    }];
    
    
    [self addRefresh:YES];
    
    if (self.firmName) {
        self.navBar.searchTF.text = self.firmName;
    }
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestStoreList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestStoreList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBCareListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.storeModel = self.dataArray[indexPath.section];
    WEAKSELF;
    cell.goodsBlock = ^(NSInteger tag) {
        [weakSelf dc_goodsItemClick:indexPath tag:tag];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBStorePageController *vc = [GLBStorePageController new];
    vc.firmId = [self.dataArray[indexPath.section] firmId];
    [self dc_pushNextController:vc];
}


#pragma mark - action
- (void)dc_filtrateViewBtnClick:(NSInteger)index
{
    WEAKSELF;
    if (index == 900) { // 排序
        
        GLBStoreRankController *vc = [GLBStoreRankController new];
        vc.rankStr = self.rankStr;
        vc.cancelBlock = ^(NSString *rankStr) {
            if (!weakSelf.rankStr || ![weakSelf.rankStr isEqualToString:rankStr]) {
                weakSelf.rankStr = rankStr;
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            
            [weakSelf.filtrateView dc_recoverInit];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if (index == 901) { // 筛选
        
        GLBStoreOtherFiltrateController *vc = [GLBStoreOtherFiltrateController new];
        vc.userDiscountArray = self.selectDiscountArray;
        vc.userPriceArray = self.selectPriceArray;
        vc.userRangArray = self.selectRangArray;
        vc.cancelBlock = ^{
            [weakSelf.filtrateView dc_recoverInit];
        };
        vc.successBlock = ^(NSArray *discountArray, NSArray *priceArray, NSArray *rangArray) {
            [weakSelf.selectDiscountArray removeAllObjects];
            [weakSelf.selectPriceArray removeAllObjects];
            [weakSelf.selectRangArray removeAllObjects];
            [weakSelf.selectDiscountArray addObjectsFromArray:discountArray];
            [weakSelf.selectPriceArray addObjectsFromArray:priceArray];
            [weakSelf.selectRangArray addObjectsFromArray:rangArray];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
}


#pragma mark -
- (void)dc_goodsItemClick:(NSIndexPath *)indexPath tag:(NSInteger)tag
{
    GLBStoreListModel *model = self.dataArray[indexPath.section];
    GLBStoreListGoodsModel *goodsModel = model.goodslist[tag - 1];
    
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
    vc.goodsId = goodsModel.goodsId;
    [self dc_pushNextController:vc];
}


#pragma mark - 请求 店铺列表数据
- (void)requestStoreList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSString *coupon = @"";
    NSString *promotion = @"";
    if (self.selectDiscountArray.count > 0) {
        if ([self.selectDiscountArray containsObject:@"有优惠券"]) {
            coupon = @"1";
        }
        if ([self.selectDiscountArray containsObject:@"有促销活动"]) {
            promotion = @"1";
        }
    }
    
    NSString *maxMoney = @"0";
    NSString *minMoney = @"0";
    if (self.selectPriceArray.count > 0) {
        NSString *title = self.selectPriceArray[0];
        if ([title containsString:@"~"]) {
            NSArray *array = [title componentsSeparatedByString:@"~"];
            minMoney = array[0];
            maxMoney = array[1];
        } else {
            minMoney = @"1000";
        }
    }
    
    NSString *scope = @"";
    if (self.selectRangArray.count > 0) {
        for (int i=0; i<self.selectRangArray.count; i++) {
            GLBRangModel *rangModel = self.selectRangArray[i];
            if (scope.length == 0) {
                scope = rangModel.key;
            } else {
                scope = [NSString stringWithFormat:@"%@,%@",scope,rangModel.key];
            }
        }
    }
    
    NSString *sortField = @"";
    NSString *sortMode = @"";
    if ([self.rankStr isEqualToString:@"按销量排序"]) {
        sortField = @"sales";
        sortMode = @"asc";
    } else if ([self.rankStr isEqualToString:@"按评论数从高到低"]) {
        sortField = @"evalCount";
        sortMode = @"asc";
    } else if ([self.rankStr isEqualToString:@"按起配金额从低到高"]) {
        sortField = @"deliveryMoney";
        sortMode = @"desc";
    } else if ([self.rankStr isEqualToString:@"按入住时间从新到旧"]) {
        sortField = @"createTime";
        sortMode = @"asc";
    }

    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSearchStoreListWithCurrentPage:_page coupon:coupon firmName:self.navBar.searchTF.text isShowGoods:@"" maxMoney:maxMoney minMoney:minMoney promotion:promotion scope:scope sortField:sortField sortMode:sortMode success:^(NSArray *array, BOOL hasNextPage) {
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
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (GLBGoodsNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLBGoodsNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        _navBar.searchTF.placeholder = @"输入店铺名称";
        WEAKSELF;
        _navBar.backBtnBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _navBar.searchTFBlock = ^{
            // 清空筛选条件
            [weakSelf.selectDiscountArray removeAllObjects];
            [weakSelf.selectPriceArray removeAllObjects];
            [weakSelf.selectRangArray removeAllObjects];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _navBar;
}

- (GLBStoreFiltrateView *)filtrateView{
    if (!_filtrateView) {
        _filtrateView = [[GLBStoreFiltrateView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 40)];
        WEAKSELF;
        _filtrateView.filtrateBtnBlock = ^(NSInteger tag) {
            [weakSelf dc_filtrateViewBtnClick:tag];
        };
    }
    return _filtrateView;
}

- (NSMutableArray<GLBStoreListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectRangArray{
    if (!_selectRangArray) {
        _selectRangArray = [NSMutableArray array];
    }
    return _selectRangArray;
}


- (NSMutableArray *)selectDiscountArray{
    if (!_selectDiscountArray) {
        _selectDiscountArray = [NSMutableArray array];
    }
    return _selectDiscountArray;
}

- (NSMutableArray *)selectPriceArray{
    if (!_selectPriceArray) {
        _selectPriceArray = [NSMutableArray array];
    }
    return _selectPriceArray;
}



@end
