//
//  GLPShoppingCarController.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPOldShoppingCarController.h"

#import "GLPOldShoppingCarCell.h"
#import "GLPShoppingCarBottomView.h"
#import "DCNoDataView.h"
#import "GLBCountTFView.h"

#import "GLPTicketSgnController.h"
#import "GLPApplyController.h"
#import "GLPTicketSelectController.h"
#import "TRStorePageVC.h"
#import "GLPGoodsDetailsController.h"

static NSString *const listCellID = @"GLPOldShoppingCarCell";

@interface GLPOldShoppingCarController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLPShoppingCarBottomView *bottomView;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic, strong) GLBCountTFView *countTFView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) BOOL isNoReload; // 是否不刷新
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation GLPOldShoppingCarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    
    if (self.isNoReload == YES) {
        self.isNoReload = NO;
    } else {
        if (!_isFirstLoad) {
            [SVProgressHUD show];
            _isFirstLoad = YES;
        }
        [self requestShoppingCarList];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" color:[UIColor dc_colorWithHexString:@"#303D55"] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(managerAction:)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.noDataView];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight+49);
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.top).offset(-1);
        make.top.equalTo(self.view).offset(kNavBarHeight);
    }];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    GLPOldShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.shoppingCarModel = self.dataArray[indexPath.section];
    cell.countViewBlock = ^(GLPEditCountView *countView, NSInteger type, NSIndexPath *subIndexPath) {
        [weakSelf dc_responseEventCellCountChangeWithCountView:countView type:type indexPath:indexPath subIndexPath:subIndexPath];
    };
    cell.editBtnBlock = ^(GLPShoppingCarModel *newShoppingCarModel) {
        if (weakSelf.dataArray.count>0) {
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:newShoppingCarModel];
            [weakSelf dc_reloadView:NO];
        }
    };
    cell.ticketBtnBlock = ^{
        [weakSelf dc_pushTicketSgnController:indexPath];
    };
    cell.shopNameClickBlock = ^{
        [weakSelf dc_pushTRStorePageVC:indexPath];
    };
    cell.goodsBlock = ^(GLPShoppingCarNoActivityModel *noActivityModel, GLPShoppingCarActivityGoodsModel *activityGoodsModel) {
        [weakSelf dc_pushGLPGoodsDetailsController:noActivityModel goodsModel:activityGoodsModel indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


#pragma mark - 编辑
- (void)managerAction:(id)sender
{
    _isEdit =! _isEdit;
    
    if (_isEdit) {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"取消" color:[UIColor dc_colorWithHexString:@"#303D55"] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(managerAction:)];
        
    } else {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" color:[UIColor dc_colorWithHexString:@"#303D55"] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(managerAction:)];
    }
    
    self.bottomView.isEdit = _isEdit;
}


#pragma mark - 全选/非全选
- (void)dc_allSelectBtnClick:(BOOL)isSelect
{
    for (int i=0; i<self.dataArray.count; i++) {
        GLPShoppingCarModel *carModel = _dataArray[i];
        
        // 活动
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            
            NSArray *array = carModel.validActInfoList;
            NSMutableArray *newArray = [NSMutableArray array];
            for (int j=0; j<array.count; j++) {
                GLPShoppingCarActivityModel *actModel = array[j];
                
                if (actModel.actCartGoodsList && actModel.actCartGoodsList.count > 0) {
                    
                    NSArray *actGoodsArray = actModel.actCartGoodsList;
                    
                    NSMutableArray *newActGoodsArray = [NSMutableArray array];
                    for (int k = 0; k<actGoodsArray.count; k++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = actGoodsArray[k];
                        goodsModel.isSelected = isSelect;
                        
                        [newActGoodsArray addObject:goodsModel];
                    }
                    
                    actModel.actCartGoodsList = newActGoodsArray;
                }
                
                [newArray addObject:actModel];
            }
            
            carModel.validActInfoList = newArray;
        }
        
        // 非活动
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            
            NSArray *array = carModel.validNoActGoodsList;
            NSMutableArray *newArray = [NSMutableArray array];
            for (int z =0; z<array.count; z++) {
                GLPShoppingCarNoActivityModel *noActModel = array[z];
                noActModel.isSelected = isSelect;
                [newArray addObject:noActModel];
            }
            
            carModel.validNoActGoodsList = newArray;
        }
        
        // 数据源替换
        [self.dataArray replaceObjectAtIndex:i withObject:carModel];
    }
    
    [self dc_reloadView:YES];
}


#pragma mark - 加入收藏
- (void)dc_collectBtnClick
{
    NSString *collectIds = [self dc_getCarIds];
    
    if (collectIds.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择商品"];
        return;
    }
    
    [self requestAddCollect:collectIds];
}


#pragma mark - 删除
- (void)dc_removeBtnClick
{
    NSString *carIds = [self dc_getCarIds];
    
    if (carIds.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择商品"];
        return;
    }
    
    WEAKSELF;
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除该商品吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakSelf requestRemoveShoppingCar:carIds];
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
}


#pragma mark - 支付
- (void)dc_payBtnClick
{
    NSString *collectIds = [self dc_getCarIds];
    
    if (collectIds.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择商品"];
        return;
    }
    self.isNoReload = YES;
    GLPApplyController *vc = [GLPApplyController new];
    vc.shoppingcarArray = [self getselectgoods];
    [self dc_pushNextController:vc];
}
#pragma 筛选购物车勾选的商品企业
-(NSMutableArray *)getselectgoods
{
    NSMutableArray *selcetArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<self.dataArray.count; i++) {
        GLPShoppingCarModel *carModel = _dataArray[i];
        BOOL have=NO;
        // 活动
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            
            NSArray *array = carModel.validActInfoList;
            for (int j=0; j<array.count; j++) {
                GLPShoppingCarActivityModel *actModel = array[j];
                
                if (actModel.actCartGoodsList && actModel.actCartGoodsList.count > 0) {
                    
                    NSArray *actGoodsArray = actModel.actCartGoodsList;
                    for (int k = 0; k<actGoodsArray.count; k++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = actGoodsArray[k];
                        if (goodsModel.isSelected) {
                            have=YES;
                        }
                    }
                }
            }
        }
        
        // 非活动
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            
            NSArray *array = carModel.validNoActGoodsList;
            for (int z =0; z<array.count; z++) {
                GLPShoppingCarNoActivityModel *noActModel = array[z];
                if (noActModel.isSelected) {
                    have=YES;
                }
            }
        }
        if (have==YES)
        {
            [selcetArray addObject:carModel];
        }
    }
    return selcetArray;
}
#pragma mark - 获取选中的购物车id
- (NSString *)dc_getCarIds
{
    NSString *carIds = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        GLPShoppingCarModel *carModel = self.dataArray[i];
        
        // 活动
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            
            NSArray *array = carModel.validActInfoList;
            for (int j=0; j<array.count; j++) {
                GLPShoppingCarActivityModel *actModel = array[j];
                
                if (actModel.actCartGoodsList && actModel.actCartGoodsList.count > 0) {
                    
                    NSArray *actGoodsArray = actModel.actCartGoodsList;
                    for (int k = 0; k<actGoodsArray.count; k++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = actGoodsArray[k];
                        if (goodsModel.isSelected) {
                            if (carIds.length == 0) {
                                carIds = [NSString stringWithFormat:@"%ld",(long)goodsModel.cartId];
                            } else {
                                carIds = [NSString stringWithFormat:@"%@,%ld",carIds,(long)goodsModel.cartId];
                            }
                        }
                    }
                }
            }
        }
        
        // 非活动
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            
            NSArray *array = carModel.validNoActGoodsList;
            for (int z =0; z<array.count; z++) {
                GLPShoppingCarNoActivityModel *noActModel = array[z];
                if (noActModel.isSelected) {
                    if (carIds.length == 0) {
                        carIds = [NSString stringWithFormat:@"%ld",(long)noActModel.cartId];
                    } else {
                        carIds = [NSString stringWithFormat:@"%@,%ld",carIds,(long)noActModel.cartId];
                    }
                }
            }
        }
    }
    
    return carIds;
}


#pragma mark - 数量改变回调
- (void)dc_responseEventCellCountChangeWithCountView:(GLPEditCountView *)countView type:(NSInteger)type indexPath:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath
{
    // 计算出数量
    __block NSInteger count = [countView.countTF.text integerValue];
    if (type == 1) { // +
        count += 1;
    } else if (type == 2) { // -
        count -= 1;
    } else if (type == 3) { // 修改数量
        if (![DC_KeyWindow.subviews containsObject:self.countTFView]) {
            [DC_KeyWindow addSubview:self.countTFView];
            self.countTFView.textField.text = countView.countTF.text;
            WEAKSELF;
            self.countTFView.successBlock = ^{
                count = [weakSelf.countTFView.textField.text integerValue];
                [weakSelf dc_requestCarCountChangeWithCount:count indexPath:indexPath subIndexPath:subIndexPath];
            };
            
            [self.countTFView.textField becomeFirstResponder];
            [self.countTFView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(DC_KeyWindow);
            }];
        }
        return;
    }
    
    [self dc_requestCarCountChangeWithCount:count indexPath:indexPath subIndexPath:subIndexPath];
}


//#pragma mark - 请求 购物车数量加减
- (void)dc_requestCarCountChangeWithCount:(NSInteger)count indexPath:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath
{
    WEAKSELF;
    GLPShoppingCarModel *carModel = self.dataArray[indexPath.section];
    
    // 获取大数据数组
    NSMutableArray *dataArray = [NSMutableArray array];
    if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
        for (int i=0; i<carModel.validActInfoList.count; i++) {
            [dataArray addObject:@[carModel.validActInfoList[i]]];
        }
    }
    if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
        [dataArray addObject:carModel.validNoActGoodsList];
    }
    
    // 获取小数据数组 、section
    NSArray *subArray = dataArray[subIndexPath.section];
    
    // 判读类型 找到 row
    if ([subArray count] > 0) {
        id class = subArray[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
            __block GLPShoppingCarActivityModel *carActivityModel = class;
            
            NSArray *goodsList = carActivityModel.actCartGoodsList;
            __block GLPShoppingCarActivityGoodsModel *goodsModel = goodsList[subIndexPath.row];
            
            NSString *cartID = [NSString stringWithFormat:@"%ld",(long)goodsModel.cartId];
            NSString *quantity = [NSString stringWithFormat:@"%ld",(long)count];
            
            // 请求 改变数量
            [[DCAPIManager shareManager] person_requestChangeShoppingCarCountWithCartId:cartID quantity:quantity success:^(id response) {
                if (response) { // 成功 改变数据源
                    
                    goodsModel.quantity = count;
                    NSMutableArray *newGoodsList = [goodsList mutableCopy];
                    [newGoodsList replaceObjectAtIndex:subIndexPath.row withObject:goodsModel];
                    carActivityModel.actCartGoodsList = newGoodsList;
                    
                    NSMutableArray *validActInfoList = [carModel.validActInfoList mutableCopy];
                    [validActInfoList replaceObjectAtIndex:subIndexPath.section withObject:carActivityModel];
                    carModel.validActInfoList = validActInfoList;
                    [dataArray replaceObjectAtIndex:indexPath.section withObject:carModel];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [weakSelf dc_reloadView:NO];
                }
                
            } failture:^(NSError *_Nullable error) {
            }];
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]){ // 无活动
            
            GLPShoppingCarNoActivityModel *noActModel = subArray[subIndexPath.row];
            
            NSString *cartID = [NSString stringWithFormat:@"%ld",(long)noActModel.cartId];
            NSString *quantity = [NSString stringWithFormat:@"%ld",(long)count];
            
            // 请求 改变数量
            [[DCAPIManager shareManager] person_requestChangeShoppingCarCountWithCartId:cartID quantity:quantity success:^(id response) {
                if (response) { // 成功 改变数据源
                    
                    noActModel.quantity = count;
                    NSMutableArray *newSubArray = [subArray mutableCopy];
                    [newSubArray replaceObjectAtIndex:subIndexPath.row withObject:noActModel];
                    
                    carModel.validNoActGoodsList = newSubArray;
                    [dataArray replaceObjectAtIndex:dataArray.count-1 withObject:carModel];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf dc_reloadView:NO];
                }
            } failture:^(NSError *_Nullable error) {
            }];
        }
    }
}

#pragma mark - 选择券
- (void)dc_pushTicketSgnController:(NSIndexPath *)indexpath
{
    GLPShoppingCarModel *carModel = self.dataArray[indexpath.section];
    
    NSString *goodsId = @"";
    // 活动
    if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
        
        NSArray *array = carModel.validActInfoList;
        for (int j=0; j<array.count; j++) {
            GLPShoppingCarActivityModel *actModel = array[j];
            
            if (actModel.actCartGoodsList && actModel.actCartGoodsList.count > 0) {
                
                NSArray *actGoodsArray = actModel.actCartGoodsList;
                for (int k = 0; k<actGoodsArray.count; k++) {
                    GLPShoppingCarActivityGoodsModel *goodsModel = actGoodsArray[k];
                    if (goodsModel.isSelected) {
                        if (goodsId.length == 0) {
                            goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
                        } else {
                            goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
                        }
                    }
                }
            }
        }
    }
    
    // 非活动
    if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
        
        NSArray *array = carModel.validNoActGoodsList;
        for (int z =0; z<array.count; z++) {
            GLPShoppingCarNoActivityModel *noActModel = array[z];
            if (noActModel.isSelected) {
                if (goodsId.length == 0) {
                    goodsId = [NSString stringWithFormat:@"%@",noActModel.goodsId];
                } else {
                    goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,noActModel.goodsId];
                }
            }
        }
    }
    
    if (goodsId.length == 0) { // 未有选中的商品 - 该购物车下的所有商品id拼接
        
        // 活动
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            
            NSArray *array = carModel.validActInfoList;
            for (int j=0; j<array.count; j++) {
                GLPShoppingCarActivityModel *actModel = array[j];
                
                if (actModel.actCartGoodsList && actModel.actCartGoodsList.count > 0) {
                    
                    NSArray *actGoodsArray = actModel.actCartGoodsList;
                    for (int k = 0; k<actGoodsArray.count; k++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = actGoodsArray[k];
                        
                        if (goodsId.length == 0) {
                            goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
                        } else {
                            goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
                        }
                    }
                }
            }
        }
        
        // 非活动
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            
            NSArray *array = carModel.validNoActGoodsList;
            for (int z =0; z<array.count; z++) {
                GLPShoppingCarNoActivityModel *noActModel = array[z];
                
                if (goodsId.length == 0) {
                    goodsId = [NSString stringWithFormat:@"%@",noActModel.goodsId];
                } else {
                    goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,noActModel.goodsId];
                }
            }
        }
    }
    
    WEAKSELF;
    GLPTicketSgnController *vc = [GLPTicketSgnController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.storeId = [NSString stringWithFormat:@"%ld",(long)carModel.sellerFirmId];
    vc.goodsId = goodsId;
    vc.dissmissBlock = ^{
        weakSelf.isNoReload = YES;
    };
    
    [DC_KeyWindow.rootViewController addChildViewController:vc];
    [DC_KeyWindow.rootViewController.view addSubview:vc.view];
    
    //    [DC_KeyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 跳转店铺详情
- (void)dc_pushTRStorePageVC:(NSIndexPath *)indexPath
{
    GLPShoppingCarModel *carModel = self.dataArray[indexPath.section];
    
    TRStorePageVC *vc = [TRStorePageVC new];
    vc.firmId = [NSString stringWithFormat:@"%ld",carModel.sellerFirmId];
    [self dc_pushNextController:vc];
}


#pragma mark - 跳转商品详情
- (void)dc_pushGLPGoodsDetailsController:(GLPShoppingCarNoActivityModel *)noActicityModel goodsModel:(GLPShoppingCarActivityGoodsModel *)goodsModel indexPath:(NSIndexPath *)indexPath
{
    GLPShoppingCarModel *carModel = self.dataArray[indexPath.section];
    
    NSString *firmId = @"";
    NSString *goodsId = @"";
    
    if (noActicityModel) {
        goodsId = noActicityModel.goodsId;
    }
    
    if (goodsModel) {
        goodsId = goodsModel.goodsId;
    }
    
    if (carModel) {
        firmId = [NSString stringWithFormat:@"%ld",carModel.sellerFirmId];
    }
    
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.firmId = firmId;
    vc.goodsId = goodsId;
    vc.detailType = GLPGoodsDetailTypeNormal;
    [self dc_pushNextController:vc];
}


#pragma mark - 刷新
- (void)dc_reloadView:(BOOL)isReload
{
    if (self.dataArray.count == 0) {
        self.noDataView.hidden = NO;
        self.bottomView.hidden = YES;
    } else {
        self.noDataView.hidden = YES;
        self.bottomView.hidden = NO;
    }
    
    self.bottomView.dataArray = self.dataArray;
    
    if (isReload) {
        [self.tableView reloadData];
    }
    
} 

#pragma mark - 请求 购物车商品列表
- (void)requestShoppingCarList
{
    [self.dataArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestShoppingCarListWithSuccess:^(id response) {
        [SVProgressHUD dismiss];
        if (response && [response count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:response];
        }
        [weakSelf dc_reloadView:YES];
        
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        [weakSelf dc_reloadView:YES];
    }];
}


#pragma mark - 请求 加入收藏
- (void)requestAddCollect:(NSString *)collectIds
{
    [[DCAPIManager shareManager]person_CollectionGoodswithobjectIds:collectIds success:^(id response){
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"添加收藏成功"];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 删除购物车
- (void)requestRemoveShoppingCar:(NSString *)cartIds
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_DeleRequestGoodswithcartIds:cartIds success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakSelf requestShoppingCarList];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}



#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - kTabBarHeight - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 10.0f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    }
    return _tableView;
}

- (GLPShoppingCarBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GLPShoppingCarBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - kTabBarHeight - 50, kScreenW, 50)];
        WEAKSELF;
        _bottomView.payBtnClick = ^{
            [weakSelf dc_payBtnClick];
        };
        _bottomView.selectBtnClick = ^(BOOL isSelected) {
            [weakSelf dc_allSelectBtnClick:isSelected];
        };
        _bottomView.deleteBtnClick = ^{
            [weakSelf dc_removeBtnClick];
        };
        _bottomView.collectBtnClick = ^{
            [weakSelf dc_collectBtnClick];
        };
        
    }
    return _bottomView;
}

- (DCNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight) image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"购物车里什么都没有哦～"];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

#pragma mark - lazy load
- (GLBCountTFView *)countTFView{
    if (!_countTFView) {
        _countTFView = [[GLBCountTFView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _countTFView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


@end
