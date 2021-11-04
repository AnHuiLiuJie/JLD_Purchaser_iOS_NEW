//
//  GLBTCMGoodsController.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTCMGoodsController.h"

#import "GLBTCMFiltrateView.h"
#import "GLBTypeGoodsSearchBar.h"
#import "GLBNormalGoodsCell.h"

#import "GLBTypeFiltrateController.h"
#import "GLBOtherFiltrateController.h"
#import "GLBGoodsDetailController.h"

#import "GLBFactoryModel.h"
#import "GLBPackageModel.h"

static NSString *const listCellID = @"GLBNormalGoodsCell";

@interface GLBTCMGoodsController ()

@property (nonatomic, strong) GLBTCMFiltrateView *filtrateView;
@property (nonatomic, strong) GLBTypeGoodsSearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray<GLBGoodsListModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

// 选择的商品分类
@property (nonatomic, strong) NSMutableArray *selectClassArray;
// 选择的包装规格
@property (nonatomic, strong) NSMutableArray *selectPackageArray;
// 选择的生产厂家
@property (nonatomic, strong) NSMutableArray *selectCompanyArray;
// 选择的类型
@property (nonatomic, strong) NSMutableArray *selectTypeArray;

@end

@implementation GLBTCMGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.definesPresentationContext = YES;

    if (self.goodsType == GLBTCMGoodsTypeJrth) {
        self.navigationItem.title = @"今日特惠";
    } else if (self.goodsType == GLBTCMGoodsTypeZshy) {
        self.navigationItem.title = @"最受欢迎";
    } else if (self.goodsType == GLBTCMGoodsTypeJptj) {
        self.navigationItem.title = @"精品推荐";
    }
    
    if (self.searchStr) {
        self.navigationItem.title = @"中药馆";
        self.searchBar.searchTF.text = self.searchStr;
    }
    
    [self setUpTableView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.filtrateView];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top).offset(kNavBarHeight);
        make.right.equalTo(self.view.right);
        make.height.equalTo(36);
    }];
    [self.filtrateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.searchBar.bottom);
        make.right.equalTo(self.view.right);
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
    GLBNormalGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.goodListModel = self.dataArray[indexPath.row];
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
    vc.goodsId = [self.dataArray[indexPath.section] goodsId];
    vc.detailType = GLBGoodsDetailTypeNormal;
    [self dc_pushNextController:vc];
}


#pragma mark - action
- (void)dc_filtrateViewBtnClick:(NSInteger)tag
{
    WEAKSELF;
    if (tag == 800) { // 分类
        
        GLBTypeFiltrateController *vc = [GLBTypeFiltrateController new];
        vc.catIds = @"13,23";
        vc.userTypeArray = self.selectClassArray;
        vc.cancelBlock = ^{
            [weakSelf.filtrateView dc_recoverInit];
        };
        vc.frameType = [NSString stringWithFormat:@"%ld",(long)(kNavBarHeight + 36 + 40)];
        vc.successBlock = ^(NSMutableArray *selectArray) {
            [weakSelf.selectClassArray removeAllObjects];
            [weakSelf.selectClassArray addObjectsFromArray:selectArray];
            
            // 清除筛选
            [weakSelf.selectCompanyArray removeAllObjects];
            [weakSelf.selectPackageArray removeAllObjects];
            [weakSelf.selectTypeArray removeAllObjects];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if (tag == 801) { // 筛选
        
        GLBOtherFiltrateController *vc = [GLBOtherFiltrateController new];
        vc.userTypeArray = self.selectTypeArray;
        vc.userPackageArray = self.selectPackageArray;
        vc.userCompanyArray = self.selectCompanyArray;
        vc.cancelBlock = ^{
            [weakSelf.filtrateView dc_recoverInit];
        };
        vc.frameType = [NSString stringWithFormat:@"%ld",(long)(kNavBarHeight + 36 + 40)];
        vc.successBlock = ^(NSArray *typeArray, NSArray *companyArray, NSArray *packageArray) {
            [weakSelf.selectTypeArray removeAllObjects];
            [weakSelf.selectPackageArray removeAllObjects];
            [weakSelf.selectCompanyArray removeAllObjects];
            [weakSelf.selectTypeArray addObjectsFromArray:typeArray];
            [weakSelf.selectPackageArray addObjectsFromArray:packageArray];
            [weakSelf.selectCompanyArray addObjectsFromArray:companyArray];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
        
    }
}


#pragma mark - 请求 商品列表数据
- (void)requestGoodsList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSString *goodsName = self.searchBar.searchTF.text;
    NSString *entrance = @"";
    NSString *isPromotion = @"";
    NSString *prodType = @"1";
    
    NSString *catIds = @"";
    for (int i=0; i<self.selectClassArray.count; i++) {
        GLBTypeModel *typeModel = self.selectClassArray[i];
        if (i == 0) {
            catIds = [NSString stringWithFormat:@"%@",typeModel.catId];
        } else {
            catIds = [NSString stringWithFormat:@"%@,%@",catIds,typeModel.catId];
        }
    }
    
    NSString *manufactory = @"";
    for (int i = 0; i<self.selectCompanyArray.count; i++) {
        GLBFactoryModel *companyModel = self.selectCompanyArray[i];
        if (i == 0) {
            manufactory = [NSString stringWithFormat:@"%@",companyModel.factoryName];
        } else {
            manufactory = [NSString stringWithFormat:@"%@,%@",manufactory,companyModel.factoryName];
        }
    }
    
    NSString *packingSpec = @"";
    for (int i=0; i<self.selectPackageArray.count; i++) {
        GLBPackageModel *packgeModel = self.selectPackageArray[i];
        if (i == 0) {
            packingSpec = [NSString stringWithFormat:@"%@",packgeModel.specs];
        } else {
            packingSpec = [NSString stringWithFormat:@"%@,%@",packingSpec,packgeModel.specs];
        }
    }
    
    NSString *sort = @"";
    
    NSString *suppierFirmId = @"";
    
    NSString *isCoupon = @"";
    for (int i=0; i<self.selectTypeArray.count; i++) {
        NSString *title = self.selectTypeArray[i];
        if ([title isEqualToString:@"有促销活动"]) {
            isCoupon = @"1";
        }
    }
    
    WEAKSELF;
    if (_searchStr.length > 0) { // 搜索
        
        [[DCAPIManager shareManager] dc_requestTCMSearchGoodsListWithCatIds:catIds currentPage:_page entrance:entrance goodsName:goodsName isCoupon:isCoupon isPromotion:isPromotion manufactory:manufactory packingSpec:packingSpec prodType:prodType sort:sort suppierFirmId:suppierFirmId success:^(NSArray *array, BOOL hasNextPage) {
            if (array && [array count] > 0) {
                [weakSelf.dataArray addObjectsFromArray:array];
            }
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
            
        } failture:^(NSError *error) {
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
        }];
        
    } else {
        
        if (_goodsType == GLBTCMGoodsTypeJrth) {
            
            [[DCAPIManager shareManager] dc_requestTCMSpecialGoodsListWithCatIds:catIds currentPage:_page entrance:entrance goodsName:goodsName isCoupon:isCoupon isPromotion:isPromotion manufactory:manufactory packingSpec:packingSpec prodType:prodType sort:sort suppierFirmId:suppierFirmId success:^(NSArray *array, BOOL hasNextPage) {
                if (array && [array count] > 0) {
                    [weakSelf.dataArray addObjectsFromArray:array];
                }
                [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
                
            } failture:^(NSError *error) {
                [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
            }];
            
        } else if (_goodsType == GLBTCMGoodsTypeZshy) {
            
            [[DCAPIManager shareManager] dc_requestTCMLickGoodsListWithCatIds:catIds currentPage:_page entrance:entrance goodsName:goodsName isCoupon:isCoupon isPromotion:isPromotion manufactory:manufactory packingSpec:packingSpec prodType:prodType sort:sort suppierFirmId:suppierFirmId success:^(NSArray *array, BOOL hasNextPage) {
                if (array && [array count] > 0) {
                    [weakSelf.dataArray addObjectsFromArray:array];
                }
                [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
                
            } failture:^(NSError *error) {
                [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
            }];
            
        } else if (_goodsType == GLBTCMGoodsTypeJptj) {
            
            [[DCAPIManager shareManager] dc_requestTCMRecommendGoodsListWithCatIds:catIds currentPage:_page entrance:entrance goodsName:goodsName isCoupon:isCoupon isPromotion:isPromotion manufactory:manufactory packingSpec:packingSpec prodType:prodType sort:sort suppierFirmId:suppierFirmId success:^(NSArray *array, BOOL hasNextPage) {
                if (array && [array count] > 0) {
                    [weakSelf.dataArray addObjectsFromArray:array];
                }
                [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
                
            } failture:^(NSError *error) {
                [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
            }];
        }
    }
    
    
    
    
}



#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 36 + 40, kScreenW, kScreenH - kNavBarHeight - 36 - 40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (GLBTypeGoodsSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[GLBTypeGoodsSearchBar alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 36)];
        WEAKSELF;
        _searchBar.searchTFBlock = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _searchBar;
}

- (GLBTCMFiltrateView *)filtrateView{
    if (!_filtrateView) {
        _filtrateView = [[GLBTCMFiltrateView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), kScreenW, 40)];
        WEAKSELF;
        _filtrateView.filtrateBlock = ^(NSInteger tag) {
            [weakSelf dc_filtrateViewBtnClick:tag];
        };
    }
    return _filtrateView;
}


- (NSMutableArray<GLBGoodsListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectCompanyArray{
    if (!_selectCompanyArray) {
        _selectCompanyArray = [NSMutableArray array];
    }
    return _selectCompanyArray;
}

- (NSMutableArray *)selectTypeArray{
    if (!_selectTypeArray) {
        _selectTypeArray = [NSMutableArray array];
    }
    return _selectTypeArray;
}

- (NSMutableArray *)selectPackageArray{
    if (!_selectPackageArray) {
        _selectPackageArray = [NSMutableArray array];
    }
    return _selectPackageArray;
}

- (NSMutableArray *)selectClassArray{
    if (!_selectClassArray) {
        _selectClassArray = [NSMutableArray array];
    }
    return _selectClassArray;
}

@end
