//
//  GLBGoodsListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsListController.h"

#import "GLBGoodsFiltrateView.h"
#import "GLBGoodsNavigationBar.h"
#import "GLBNormalGoodsCell.h"

#import "GLBRankFiltrateController.h"
#import "GLBStoreFiltrateController.h"
#import "GLBTypeFiltrateController.h"
#import "GLBOtherFiltrateController.h"
#import "GLBGoodsDetailController.h"
#import "GLBStorePageController.h"

#import "GLBFactoryModel.h"
#import "GLBPackageModel.h"
#import "GLBStoreFiltrateModel.h"
#import "DCLoginController.h"
#import "DCNavigationController.h"
#import "GLBNotGoodsHeaderView.h"
static NSString *const listCellID = @"GLBNormalGoodsCell";

@interface GLBGoodsListController ()
@property(nonatomic,strong) GLBNotGoodsHeaderView *headerView;

@property (nonatomic, strong) GLBGoodsNavigationBar *navBar;
@property (nonatomic, strong) GLBGoodsFiltrateView *filtrateView;
@property (nonatomic, strong) NSMutableArray<GLBGoodsListModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

// 选择的商品分类
@property (nonatomic, strong) NSMutableArray *selectClassArray;
// 选择的商家
@property (nonatomic, strong) NSMutableArray *selectStoreArray;
// 选择的包装规格
@property (nonatomic, strong) NSMutableArray *selectPackageArray;
// 选择的生产厂家
@property (nonatomic, strong) NSMutableArray *selectCompanyArray;
// 选择的类型
@property (nonatomic, strong) NSMutableArray *selectTypeArray;
// 排序  1:批次销量，2：价格从高到低，3：价格从低到高
@property (nonatomic, copy) NSString *sort;

@property (nonatomic, assign) BOOL isFristLoad;
@end

@implementation GLBGoodsListController

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
    
    if (_catIds && _catIds.length > 0) {
        
        if (!self.typeModel) { // 不是从点击分类进去的
            
            NSString *catIds = _catIds;
            
            [self.selectClassArray removeAllObjects];
            if ([catIds containsString:@","]) {
                NSArray *array = [catIds componentsSeparatedByString:@","];
                for (int i=0; i<array.count; i++) {
                    GLBTypeModel *typeModel = [GLBTypeModel new];
                    typeModel.catId = array[i];
                    typeModel.catName = @"";
                    [self.selectClassArray addObject:typeModel];
                }
                
            } else {
                
                GLBTypeModel *typeModel = [GLBTypeModel new];
                typeModel.catId = catIds;
                typeModel.catName = @"";
                [self.selectClassArray addObject:typeModel];
            }
        }
    }
    
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
    
    if (self.typeModel) {
        [self.selectClassArray addObject:self.typeModel];
    }
    if (self.goodsName) {
        self.navBar.searchTF.text = self.goodsName;
    }
    
    // 注册通知 接受登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:DC_LoginSucess_Notification object:nil];
}


#pragma mark - 登录成功
- (void)loginSuccess:(id)sender
{
    [self.tableView.mj_header beginRefreshing];
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBNormalGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.goodListModel = self.dataArray[indexPath.section];
    WEAKSELF;
    cell.shopNameBlock = ^{
        [weakSelf dc_pushStorePageController:indexPath];
    };
    cell.loginBlock = ^{
        //        [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
        //            [weakSelf.tableView.mj_header beginRefreshing];
        //        }];
        // 清除本地字段
        [[DCLoginTool shareTool] dc_removeLoginDataWithCompany];
        
        DCLoginController *vc = [DCLoginController new];
        vc.isPresent = YES;
        vc.modalPresentationStyle =UIModalPresentationFullScreen;
        DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
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
    
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
    vc.goodsId = [self.dataArray[indexPath.section] goodsId];
    vc.batchId = [self.dataArray[indexPath.section] batchId];
    vc.detailType = GLBGoodsDetailTypeNormal;
    [self dc_pushNextController:vc];
}


#pragma mark - 跳转
- (void)dc_pushStorePageController:(NSIndexPath *)indexPath
{
    GLBStorePageController *vc = [GLBStorePageController new];
    vc.firmId = [self.dataArray[indexPath.section] suppierFirmId];
    [self dc_pushNextController:vc];
}


#pragma mark - action
- (void)dc_filtrateViewBtnClick:(NSInteger)index
{
    
    NSString *catIds = @"";
    for (int i=0; i<self.selectClassArray.count; i++) {
        GLBTypeModel *typeModel = self.selectClassArray[i];
        if (i == 0) {
            catIds = [NSString stringWithFormat:@"%@",typeModel.catId];
        } else {
            catIds = [NSString stringWithFormat:@"%@,%@",catIds,typeModel.catId];
        }
    }
    
    WEAKSELF;
    if (index == 1) { // 分类
        
        GLBTypeFiltrateController *vc = [GLBTypeFiltrateController new];
        vc.catIds = self.catIds ? self.catIds : @"0";
        vc.userTypeArray = self.selectClassArray;
        vc.cancelBlock = ^{
            [weakSelf.filtrateView dc_recoverInit];
        };
        vc.successBlock = ^(NSMutableArray *selectArray) {
            
            [weakSelf.selectClassArray removeAllObjects];
            [weakSelf.selectClassArray addObjectsFromArray:selectArray];
            
            NSArray *classArray = [weakSelf.selectClassArray copy];
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (int i=0; i<classArray.count; i++) {
                GLBTypeModel *model = classArray[i];
                if (weakSelf.catIds && weakSelf.catIds.length > 0) {
                    if ([weakSelf.catIds containsString:@","]) {
                        
                        NSArray *array = [weakSelf.catIds componentsSeparatedByString:@","];
                        for (int j=0; j<array.count; j++) {
                            if ([model.catId isEqualToString:array[j]]) {
                                [deleteArray addObject:weakSelf.selectClassArray[i]];
                            }
                        }
                        
                    } else {
                        
                        if ([model.catId isEqualToString:weakSelf.catIds]) {
                            [deleteArray addObject:weakSelf.selectClassArray[i]];
                        }
                    }
                    
                    
                }
            }
            if ([deleteArray count] > 0) {
                [weakSelf.selectClassArray removeObjectsInArray:deleteArray];
            }
            
            // 清除筛选
            weakSelf.sort = nil;
            [weakSelf.selectCompanyArray removeAllObjects];
            [weakSelf.selectPackageArray removeAllObjects];
            [weakSelf.selectStoreArray removeAllObjects];
            [weakSelf.selectTypeArray removeAllObjects];
            weakSelf.filtrateView.count = weakSelf.selectStoreArray.count;
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
        //        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if (index == 2) { // 排序
        
        GLBRankFiltrateController *vc = [GLBRankFiltrateController new];
        vc.rankStr = self.sort;
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
    
    if (index == 3) { // 商家
        
        GLBStoreFiltrateController *vc = [GLBStoreFiltrateController new];
        vc.selectStoreArray = weakSelf.selectStoreArray;
        vc.searchName = self.navBar.searchTF.text;
        vc.catIds = catIds;
        vc.cancelBlock = ^{
            [weakSelf.filtrateView dc_recoverInit];
            weakSelf.filtrateView.count = weakSelf.selectStoreArray.count;
        };
        vc.filtrateBlock = ^(NSArray *selectedArray) {
            weakSelf.filtrateView.count = selectedArray.count;
        };
        vc.completeBlock = ^(NSArray *selectedArray) {
            [weakSelf.selectStoreArray removeAllObjects];
            [weakSelf.selectStoreArray addObjectsFromArray:selectedArray];
            
            [weakSelf.selectCompanyArray removeAllObjects];
            [weakSelf.selectPackageArray removeAllObjects];
            [weakSelf.selectTypeArray removeAllObjects];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
        //        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if (index == 4) { // 筛选
        
        GLBOtherFiltrateController *vc = [GLBOtherFiltrateController new];
        vc.userTypeArray = self.selectTypeArray;
        vc.userPackageArray = self.selectPackageArray;
        vc.userCompanyArray = self.selectCompanyArray;
        vc.userStoreArray = self.selectStoreArray;
        vc.searchName = self.navBar.searchTF.text;
        vc.catIds = catIds;
        vc.entrance = _entrance;
        vc.prodType = _prodType;
        vc.isPromotion = _isPromotion;
        vc.cancelBlock = ^{
            [weakSelf.filtrateView dc_recoverInit];
        };
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
    
    NSString *goodsName = self.navBar.searchTF.text;
    NSString *entrance = _entrance ? _entrance : @"";
    NSString *isPromotion = _isPromotion ? _isPromotion : @"";
    NSString *prodType = _prodType ? _prodType : @"";
    
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
    if (self.sort && [self.sort isEqualToString:@"销量"]) {
        sort = @"1";
    } else if (self.sort && [self.sort isEqualToString:@"价格从高到低"]) {
        sort = @"2";
    } else if (self.sort && [self.sort isEqualToString:@"价格从低到高"]) {
        sort = @"3";
    }
    
    NSString *suppierFirmId = @"";
    for (int i=0; i<self.selectStoreArray.count; i++) {
        GLBStoreFiltrateModel *storeModel = self.selectStoreArray[i];
        if (i == 0) {
            suppierFirmId = [NSString stringWithFormat:@"%@",storeModel.suppierFirmId];
        } else {
            suppierFirmId = [NSString stringWithFormat:@"%@,%@",suppierFirmId,storeModel.suppierFirmId];
        }
    }
    
    NSString *isCoupon = @"";
    for (int i=0; i<self.selectTypeArray.count; i++) {
        NSString *title = self.selectTypeArray[i];
        if ([title isEqualToString:@"有促销活动"]) {
            isPromotion = @"1";
        }
        if ([title isEqualToString:@"可领券"]) {
            isCoupon = @"1";
        }
    }
    
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
        WEAKSELF;
        _navBar.backBtnBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _navBar.searchTFBlock = ^{
            // 清除筛选
            weakSelf.sort = nil;
            [weakSelf.selectClassArray removeAllObjects];
            [weakSelf.selectTypeArray removeAllObjects];
            [weakSelf.selectCompanyArray removeAllObjects];
            [weakSelf.selectPackageArray removeAllObjects];
            [weakSelf.selectStoreArray removeAllObjects];
            weakSelf.filtrateView.count = weakSelf.selectStoreArray.count;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _navBar;
}

- (GLBGoodsFiltrateView *)filtrateView{
    if (!_filtrateView) {
        _filtrateView = [[GLBGoodsFiltrateView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 40)];
        WEAKSELF;
        _filtrateView.filtrateBtnBlock = ^(NSInteger tag) {
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


- (NSMutableArray *)selectStoreArray{
    if (!_selectStoreArray) {
        _selectStoreArray = [NSMutableArray array];
    }
    return _selectStoreArray;
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


#pragma mark -
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_LoginSucess_Notification object:nil];
}

@end
