//
//  GLBStoreGoodsController.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreGoodsController.h"

#import "GLBStoreGoodsFiltrateView.h"
#import "GLBStoreGoodsCell.h"

#import "GLBTypeFiltrateController.h"
#import "GLBRankFiltrateController.h"
#import "GLBGoodsDetailController.h"

#import "GLBTypeModel.h"
#import "DCLoginController.h"
#import "DCNavigationController.h"
#import "GLBNotGoodsHeaderView.h"
static NSString *const goodsCellID = @"GLBStoreGoodsCell";

@interface GLBStoreGoodsController ()
@property(nonatomic,strong) GLBNotGoodsHeaderView *headerView;

@property (nonatomic, strong) GLBStoreGoodsFiltrateView *filtrateView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

// 选中的分类数据
@property (nonatomic, strong) NSMutableArray *selectClassArray;
// 排序方式
@property (nonatomic, copy) NSString *sort;
// 是否是招标
@property (nonatomic, copy) NSString *isPromotion;

@end

@implementation GLBStoreGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTableView];
    [self.view addSubview:self.filtrateView];
    [self.filtrateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestGoodsList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestGoodsList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBStoreGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID forIndexPath:indexPath];
    cell.goodsModel = self.dataArray[indexPath.row];
    cell.loginBlcok = ^{
//        [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:DC_LoginSucess_Notification object:nil];
//        }];
        // 清除本地字段
            [[DCLoginTool shareTool] dc_removeLoginDataWithCompany];

            DCLoginController *vc = [DCLoginController new];
                             vc.isPresent = YES;
                             vc.modalPresentationStyle =UIModalPresentationFullScreen;
                             DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:^{
                           [[NSNotificationCenter defaultCenter] postNotificationName:DC_LoginSucess_Notification object:nil];
                          }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
//    vc.batchId = [NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] batchId]];
    vc.goodsId = [self.dataArray[indexPath.row] goodsId];
//    vc.detailType = GLBGoodsDetailTypePromotione;
    [self dc_pushNextController:vc];
}


#pragma mark - action
- (void)dc_filtrateViewBtnClick:(NSInteger)tag
{
    WEAKSELF;
    if (tag == 1) { // 分类
        
        GLBTypeFiltrateController *vc = [GLBTypeFiltrateController new];
        vc.catIds = @"0";
        if (_height == 0) {
            _height = kNavBarHeight + 146 + 60 + 40 +10;
        }
        vc.frameType = [NSString stringWithFormat:@"%.2f",_height + 40];
        vc.userTypeArray = self.selectClassArray;
        vc.cancelBlock = ^{
            [weakSelf.filtrateView dc_recoverInit];
        };
        vc.successBlock = ^(NSMutableArray *selectArray) {
            [weakSelf.selectClassArray removeAllObjects];
            [weakSelf.selectClassArray addObjectsFromArray:selectArray];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if (tag == 2) { // 排序
        
        GLBRankFiltrateController *vc = [GLBRankFiltrateController new];
        vc.rankStr = self.sort;
        if (_height == 0) {
            _height = kNavBarHeight + 146 + 60 +10;
        }
        vc.frameType = [NSString stringWithFormat:@"%.2f",_height + 40];
        vc.cancelBlock = ^(NSString *rankStr) {
            [weakSelf.filtrateView dc_recoverInit];
            
            if (!weakSelf.sort || ![weakSelf.sort isEqualToString:rankStr]) {
                weakSelf.sort = rankStr;
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if (tag == 3) { // 促销
        
        if (self.filtrateView.promotionBtn.isSelected) {
            _isPromotion = @"1";
        } else {
            _isPromotion = @"2";
        }
        [self.tableView.mj_header beginRefreshing];
    }
}


#pragma mark - 请求 获取商品
- (void)requestGoodsList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSString *goodsName = @"";
    NSString *entrance = @"";
    NSString *isPromotion = _isPromotion ? _isPromotion : @"";
    NSString *prodType = @"";
    NSString *manufactory = @"";
    NSString *packingSpec = @"";
    NSString *isCoupon = @"";
    
    NSString *catIds = @"";
    for (int i=0; i<self.selectClassArray.count; i++) {
        GLBTypeModel *typeModel = self.selectClassArray[i];
        if (i == 0) {
            catIds = [NSString stringWithFormat:@"%@",typeModel.catId];
        } else {
            catIds = [NSString stringWithFormat:@"%@,%@",catIds,typeModel.catId];
        }
    }
    
    NSString *sort = @"";
    if (self.sort && [self.sort isEqualToString:@"销量"]) {
        sort = @"1";
    } else if (self.sort && [self.sort isEqualToString:@"价格从高到低"]) {
        sort = @"2";
    } else if (self.sort && [self.sort isEqualToString:@"价格从低到高"]) {
        sort = @"3";
    }
    
    NSString *suppierFirmId = self.storeModel.storeInfoVO.firmId;;
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSearchGoodsListWithCatIds:catIds currentPage:_page entrance:entrance goodsName:goodsName isCoupon:isCoupon isPromotion:isPromotion manufactory:manufactory packingSpec:packingSpec prodType:prodType sort:sort suppierFirmId:suppierFirmId success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
    
}

// 自定义刷新方法  待完善
- (void)reloadTableViewWithDatas:(NSArray *)datas hasNextPage:(BOOL)hasNextPage {
    
    [self endRefresh];
    
    if (datas && [datas count]>0) {
        
        self.noDataView.hidden = YES;
        
        if (hasNextPage == NO) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.tableView.mj_footer.hidden = NO;
        
    }else {
        self.tableView.tableHeaderView = self.headerView;
        self.headerView.backgroundColor = [UIColor redColor];
        WEAKSELF;
        [SVProgressHUD show];
        [[DCAPIManager shareManager] dc_requestSearchGoodsListWithCatIds:@"" currentPage:1 entrance:@"3" goodsName:@"" isCoupon:@"" isPromotion:@"" manufactory:@"" packingSpec:@"" prodType:@"" sort:@"" suppierFirmId:@"" success:^(NSArray *array, BOOL hasNextPage) {
            if (array && [array count] > 0) {
                [weakSelf.dataArray addObjectsFromArray:array];
            }
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
            [SVProgressHUD dismiss];
        } failture:^(NSError *error) {
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
            [SVProgressHUD dismiss];
        }];
        //self.tableView.mj_footer.hidden = YES;
    }
    
    [self.tableView reloadData];
}

- (GLBNotGoodsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[GLBNotGoodsHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenW, 110);
    }
    return _headerView;
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, 41, kScreenW, kScreenH - kNavBarHeight - 61 - 40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = YES;
    
    [self.tableView registerClass:NSClassFromString(goodsCellID) forCellReuseIdentifier:goodsCellID];
}


#pragma mark - lazy load
- (GLBStoreGoodsFiltrateView *)filtrateView{
    if (!_filtrateView) {
        _filtrateView = [[GLBStoreGoodsFiltrateView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        WEAKSELF;
        _filtrateView.filtrateBlock = ^(NSInteger tag) {
            [weakSelf dc_filtrateViewBtnClick:tag];
        };
    }
    return _filtrateView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectClassArray{
    if (!_selectClassArray) {
        _selectClassArray = [NSMutableArray array];
    }
    return _selectClassArray;
}

@end
