//
//  GLPShoppingCarController.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPShoppingCarController.h"

#import "GLPShoppingCarCell.h"
#import "GLPShoppingCarBottomView.h"
#import "DCNoDataView.h"
#import "GLBCountTFView.h"

#import "GLPTicketSgnController.h"
#import "GLPConfirmOrderViewController.h"
#import "TRStorePageVC.h"
#import "GLPGoodsDetailsController.h"
#import "GLPInvalidGoodsListCell.h"


static NSString *const GLPShoppingCarCellID = @"GLPShoppingCarCell";
static NSString *const GLPInvalidGoodsListCellID = @"GLPInvalidGoodsListCell";

@interface GLPShoppingCarController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLPShoppingCarBottomView *bottomView;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic, strong) GLBCountTFView *countTFView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *invalidGoodsList;
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) BOOL isNoReload; // 是否不刷新
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation GLPShoppingCarController

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
     
    CGFloat bottomViewH = 50;
    if (self.isPush) {
        bottomViewH = 50+LJ_TabbarSafeBottomMargin;
    }
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(bottomViewH);
        make.bottom.equalTo(self.view.bottom).offset(0);
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.top).offset(0);
        make.top.equalTo(self.view.top).offset(kNavBarHeight);
    }];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.invalidGoodsList.count == 0) {
        return self.dataArray.count;
    }else{
        return self.dataArray.count+1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    if (indexPath.section == self.dataArray.count) {
        GLPInvalidGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPInvalidGoodsListCellID forIndexPath:indexPath];
        cell.dataArray = [self.invalidGoodsList mutableCopy];
        WEAKSELF;
        cell.GLPInvalidGoodsListCell_Block = ^{
            [weakSelf dc_removeInvalidGoodsListBtnClick];
        };
        return cell;
    }else{
        GLPShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPShoppingCarCellID forIndexPath:indexPath];
        cell.shoppingCarModel = self.dataArray[indexPath.section];
        
        cell.GLPShoppingCarCell_countViewBlock = ^(GLPEditCountView *countView, NSInteger type, NSIndexPath *subIndexPath) {
            [weakSelf dc_responseEventCellCountChangeWithCountView:countView type:type indexPath:indexPath subIndexPath:subIndexPath];
        };
        
        cell.GLPShoppingCarCell_editBtnBlock = ^(GLPFirmListModel *newShoppingCarModel) {
            if (weakSelf.dataArray.count>0) {
                [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:newShoppingCarModel];
                [weakSelf dc_reloadView:NO];
            }
        };
        
        cell.GLPShoppingCarCell_goodsBlock = ^(GLPNewShopCarGoodsModel *noActivityModel, GLPNewShopCarGoodsModel *activityGoodsModel) {
            [weakSelf dc_pushGLPGoodsDetailsController:noActivityModel goodsModel:activityGoodsModel indexPath:indexPath];
        };
        
        cell.ticketBtnBlock = ^{
            [weakSelf dc_pushTicketSgnController:indexPath];
        };
        
        cell.shopNameClickBlock = ^{
            [weakSelf dc_pushTRStorePageVC:indexPath];
        };
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < self.dataArray.count) {
        return 0.01f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   return [[UIView alloc] init];
}

#pragma mark 获取失效商品列表
- (BOOL)isHaveInvalidGoodsList_and_getAll_InvalidGoodsList{
    
    NSMutableArray *listArr = [[NSMutableArray alloc] init];
    for (int i=0; i<self.dataArray.count; i++) {
        GLPFirmListModel *carModel = _dataArray[i];
        [listArr addObjectsFromArray:carModel.invalidGoodsList];
    }
    
    self.invalidGoodsList = listArr;
    if (listArr.count != 0) {
        return YES;
    }else
        return NO;
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
        GLPFirmListModel *carModel = _dataArray[i];
        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                goodsModel.isSelected = isSelect;
            }];
        }];
        
        // 非活动
        [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            goodsModel.isSelected = isSelect;
        }];
    }
    
    [self dc_reloadView:YES];
}


#pragma mark - 加入收藏
- (void)dc_collectBtnClick
{
    __block NSString *goodsIds = @"";
    
    for (int i=0; i<self.dataArray.count; i++) {
        GLPFirmListModel *carModel = self.dataArray[i];
        
        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (goodsModel.isSelected) {
                    if (goodsIds.length == 0) {
                        goodsIds = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
                    } else {
                        goodsIds = [NSString stringWithFormat:@"%@,%@",goodsIds,goodsModel.goodsId];
                    }
                }
            }];
        }];
        
        // 非活动
        [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (goodsModel.isSelected) {
                if (goodsIds.length == 0) {
                    goodsIds = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
                } else {
                    goodsIds = [NSString stringWithFormat:@"%@,%@",goodsIds,goodsModel.goodsId];
                }
            }
        }];
    }
    
    if (goodsIds.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择商品"];
        return;
    }
    
    [self requestAddCollect:goodsIds];
}


#pragma mark - 删除
- (void)dc_removeBtnClick
{
    NSArray *carIdArr = [self dc_getCarIdArray];
    
    if (carIdArr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择商品"];
        return;
    }
    
    WEAKSELF;
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除该商品吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakSelf requestRemoveShoppingCar:carIdArr type:1];
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
}

- (void)dc_removeInvalidGoodsListBtnClick
{
    NSMutableArray *carIdArr = [[NSMutableArray alloc] init];
    [self.invalidGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [carIdArr addObject:goodsModel.cartId];
    }];
    WEAKSELF;
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认清空失效商品？" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakSelf requestRemoveShoppingCar:carIdArr type:2];
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
}


#pragma mark - 结算
- (void)dc_payBtnClick
{
    //NSMutableArray *selectedGoods = [self getselectgoods];
    NSString *batchId = @"";
    NSArray *cart = [self dc_getCarIdArray];
    if (cart.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择商品"];
        return;
    }
    NSString *goodsId = @"";
    NSString *quantity = @"";
    NSString *sellerFirmId = @"";
    NSString *tradeType = @"2";
    WEAKSELF;
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_confirmOrderWithBatchId:batchId cart:cart goodsId:goodsId quantity:quantity sellerFirmId:sellerFirmId tradeType:tradeType success:^(id  _Nullable response) {
        GLPNewShoppingCarModel *model = [GLPNewShoppingCarModel mj_objectWithKeyValues:response[@"data"]];
        NSArray *firmList = [GLPFirmListModel mj_objectArrayWithKeyValuesArray:model.firmList];
        for (GLPFirmListModel *firmModel in firmList) {
            NSArray *actInfoList = [ActInfoListModel mj_objectArrayWithKeyValuesArray:firmModel.actInfoList];
            NSArray *cartGoodsList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:firmModel.cartGoodsList];
            NSArray *couponList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.couponList];
            NSArray *defaultCoupon = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.defaultCoupon];
            for (ActInfoListModel *actModel in actInfoList) {
                NSArray *actInfoList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:actModel.actGoodsList];
                actModel.actGoodsList = [actInfoList mutableCopy];
            }
            firmModel.actInfoList = [actInfoList mutableCopy];
            firmModel.cartGoodsList = [cartGoodsList mutableCopy];
            firmModel.couponList = couponList;
            firmModel.defaultCoupon = defaultCoupon;
        }
        model.firmList = firmList;
        GLPConfirmOrderViewController *vc = [GLPConfirmOrderViewController new];
        vc.ispay = @"2";
        vc.mainModel = model;
        [weakSelf dc_pushNextController:vc];
        NSDictionary *dict = @{@"type":@"创建订单购物车"};//UM统计 自定义搜索关键词事件
        [MobClick event:UMEventCollection_31 attributes:dict];
        
    } failture:^(NSError * _Nullable error) {
    }];
}

#pragma 筛选购物车勾选的商品企业
- (NSMutableArray *)getselectgoods
{
    NSMutableArray *selcetArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<self.dataArray.count; i++) {
        GLPFirmListModel *carModel = _dataArray[i];
        __block BOOL have = NO;
        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (goodsModel.isSelected) {
                    have = YES;
                }
            }];
        }];
        
        // 非活动
        [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (goodsModel.isSelected) {
                have = YES;
            }
        }];
        
        if (have == YES){
            [selcetArray addObject:carModel];
        }
    }
    return selcetArray;
}

#pragma mark - 获取选中的购物车id
- (NSString *)dc_getCarIds
{
    __block NSString *carIds = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        GLPFirmListModel *carModel = self.dataArray[i];
        
        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (goodsModel.isSelected) {
                    if (carIds.length == 0) {
                        carIds = [NSString stringWithFormat:@"%@",goodsModel.cartId];
                    } else {
                        carIds = [NSString stringWithFormat:@"%@,%@",carIds,goodsModel.cartId];
                    }
                }
            }];
        }];
        
        // 非活动
        [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (goodsModel.isSelected) {
                if (carIds.length == 0) {
                    carIds = [NSString stringWithFormat:@"%@",goodsModel.cartId];
                } else {
                    carIds = [NSString stringWithFormat:@"%@,%@",carIds,goodsModel.cartId];
                }
            }
        }];
    }
    
    return carIds;
}

- (NSArray *)dc_getCarIdArray
{
    NSMutableArray *carIdArr = [[NSMutableArray alloc] init];
    for (int i=0; i<self.dataArray.count; i++) {
        GLPFirmListModel *carModel = self.dataArray[i];
        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (goodsModel.isSelected) {
                    [carIdArr addObject:goodsModel.cartId];
                }
            }];
        }];
        
        // 非活动
        [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (goodsModel.isSelected) {
                [carIdArr addObject:goodsModel.cartId];
            }
        }];
    }
    
    return carIdArr;
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
    GLPFirmListModel *carModel = self.dataArray[indexPath.section];
    
    // 获取大数据数组
    NSMutableArray *dataArray = [NSMutableArray array];
    // 活动
    [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [dataArray addObject:@[actModel]];
    }];
    
    // 非活动
    [dataArray addObject:carModel.cartGoodsList];
    
    // 获取小数据数组 、section
    NSArray *subArray = dataArray[subIndexPath.section];
    
    // 判读类型 找到 row
    if ([subArray count] > 0) {
        id class = subArray[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
            __block ActInfoListModel *carActivityModel = class;
            
            NSArray *goodsList = carActivityModel.actGoodsList;
            __block GLPNewShopCarGoodsModel *goodsModel = goodsList[subIndexPath.row];
            
            NSString *cartId = [NSString stringWithFormat:@"%@",goodsModel.cartId];
            
            GLPMarketingMixListModel *marketingMix = goodsModel.marketingMix;
            if (marketingMix.mixId.length > 0) {//组合装
                count = count * [marketingMix.mixNum integerValue];
            }
            
            NSString *quantity = [NSString stringWithFormat:@"%ld",(long)count];
            
            if ([goodsModel.stock integerValue] < count) {//这里要注意万一库存 不是 组合装的倍数 就会出现问题
                NSMutableArray *newGoodsList = [goodsList mutableCopy];
                [newGoodsList replaceObjectAtIndex:subIndexPath.row withObject:goodsModel];
                carActivityModel.actGoodsList = newGoodsList;
                
                NSMutableArray *actInfoList = [carModel.actInfoList mutableCopy];
                [actInfoList replaceObjectAtIndex:subIndexPath.section withObject:carActivityModel];
                carModel.actInfoList = actInfoList;
                [dataArray replaceObjectAtIndex:indexPath.section withObject:carModel];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                
                [self dc_reloadView:NO];
                
                [self.view makeToast:@"库存不足！" duration:Toast_During position:CSToastPositionBottom];
                return;
            }
            
            WEAKSELF;
            // 请求 改变数量
            [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_cart_editWithAct:@"change" cart:@[cartId] value:quantity success:^(id  _Nullable response) {
                if (response) {// 成功 改变数据源
                    goodsModel.quantity = [NSString stringWithFormat:@"%ld",(long)count];
                    NSMutableArray *newGoodsList = [goodsList mutableCopy];
                    [newGoodsList replaceObjectAtIndex:subIndexPath.row withObject:goodsModel];
                    carActivityModel.actGoodsList = newGoodsList;
                    
                    NSMutableArray *actInfoList = [carModel.actInfoList mutableCopy];
                    [actInfoList replaceObjectAtIndex:subIndexPath.section withObject:carActivityModel];
                    carModel.actInfoList = actInfoList;
                    [dataArray replaceObjectAtIndex:indexPath.section withObject:carModel];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [weakSelf dc_reloadView:NO];
                }
            } failture:^(NSError * _Nullable error) {
            }];
        } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]){ // 无活动
            
            GLPNewShopCarGoodsModel *noActModel = subArray[subIndexPath.row];
            
            NSString *cartID = [NSString stringWithFormat:@"%@",noActModel.cartId];
            
            GLPMarketingMixListModel *marketingMix = noActModel.marketingMix;
            if (marketingMix.mixId.length > 0) {//组合装
                count = count * [marketingMix.mixNum integerValue];
            }
            
            NSString *quantity = [NSString stringWithFormat:@"%ld",(long)count];
            if ([noActModel.stock integerValue] < count) {//这里要注意万一库存 不是 组合装的倍数 就会出现问题
                noActModel.quantity = noActModel.stock;
                
                NSMutableArray *newSubArray = [subArray mutableCopy];
                [newSubArray replaceObjectAtIndex:subIndexPath.row withObject:noActModel];
                
                carModel.cartGoodsList = newSubArray;
                [dataArray replaceObjectAtIndex:dataArray.count-1 withObject:carModel];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                [self dc_reloadView:NO];
                
                [self.view makeToast:@"库存不足！" duration:Toast_During position:CSToastPositionBottom];
                return;
            }
            
            // 请求 改变数量
            [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_cart_editWithAct:@"change" cart:@[cartID] value:quantity success:^(id  _Nullable response) {
                if (response) {// 成功 改变数据源
                    noActModel.quantity = [NSString stringWithFormat:@"%ld",(long)count];

                    NSMutableArray *newSubArray = [subArray mutableCopy];
                    [newSubArray replaceObjectAtIndex:subIndexPath.row withObject:noActModel];
                    
                    carModel.cartGoodsList = newSubArray;
                    [dataArray replaceObjectAtIndex:dataArray.count-1 withObject:carModel];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf dc_reloadView:NO];
                }
            } failture:^(NSError * _Nullable error) {
            }];
        }
    }
}

#pragma mark - 选择券
- (void)dc_pushTicketSgnController:(NSIndexPath *)indexpath
{
    GLPFirmListModel *carModel = self.dataArray[indexpath.section];
    
    __block NSString *goodsId = @"";
    
    // 活动
    [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (goodsModel.isSelected) {
                if (goodsId.length == 0) {
                    goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
                } else {
                    goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
                }
            }
        }];
    }];
    
    // 非活动
    [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (goodsModel.isSelected) {
            if (goodsId.length == 0) {
                goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
            } else {
                goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
            }
        }
    }];
    
    if (goodsId.length == 0) { // 未有选中的商品 - 该购物车下的所有商品id拼接
        
        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (goodsId.length == 0) {
                    goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
                } else {
                    goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
                }
            }];
        }];
        
        // 非活动
        [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (goodsId.length == 0) {
                goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
            } else {
                goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
            }
        }];
    }
    
    WEAKSELF;
    GLPTicketSgnController *vc = [GLPTicketSgnController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.storeId = [NSString stringWithFormat:@"%@",carModel.sellerFirmId];
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
    GLPFirmListModel *carModel = self.dataArray[indexPath.section];
    
    TRStorePageVC *vc = [TRStorePageVC new];
    vc.firmId = [NSString stringWithFormat:@"%@",carModel.sellerFirmId];
    [self dc_pushNextController:vc];
}

#pragma mark - 跳转商品详情
- (void)dc_pushGLPGoodsDetailsController:(GLPNewShopCarGoodsModel *)noActicityModel goodsModel:(GLPNewShopCarGoodsModel *)goodsModel indexPath:(NSIndexPath *)indexPath
{
    GLPFirmListModel *carModel = self.dataArray[indexPath.section];
    
    NSString *firmId = @"";
    NSString *goodsId = @"";
    NSString *batchId = @"";

    if (noActicityModel) {
        goodsId = noActicityModel.goodsId;
        batchId = noActicityModel.batchId;
    }
    
    if (goodsModel) {
        goodsId = goodsModel.goodsId;
        batchId = goodsModel.batchId;
    }
    
    if (carModel) {
        firmId = [NSString stringWithFormat:@"%@",carModel.sellerFirmId];
    }
    
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.firmId = firmId;
    vc.goodsId = goodsId;
    vc.batchId = batchId;
    vc.detailType = GLPGoodsDetailTypeNormal;
    [self dc_pushNextController:vc];
}


#pragma mark - 刷新
- (void)dc_reloadView:(BOOL)isReload
{
    if (self.dataArray.count == 0 && self.invalidGoodsList.count == 0) {
        self.noDataView.hidden = NO;
        self.bottomView.hidden = YES;
    } else {
        self.noDataView.hidden = YES;
        self.bottomView.hidden = NO;
    }
    
    self.bottomView.dataArray = _dataArray;
    
    if (isReload) {
        [self.tableView reloadData];
    }
    
} 

#pragma mark - 请求 购物车商品列表
- (void)requestShoppingCarList
{
    [self.dataArray removeAllObjects];
    [self.invalidGoodsList removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_cartWithSuccess:^(id  _Nullable response) {
        //GLPNewShoppingCarModel *model = [GLPFirmListModel mj_objectWithKeyValues:response[@"data"]];
        if ([response[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *firmList = [GLPFirmListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            for (GLPFirmListModel *firmModel in firmList) {
                NSArray *actInfoList = [ActInfoListModel mj_objectArrayWithKeyValuesArray:firmModel.actInfoList];
                NSArray *cartGoodsList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:firmModel.cartGoodsList];
                NSArray *couponList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.couponList];
                NSArray *defaultCoupon = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.defaultCoupon];
                NSArray *invalidGoodsList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:firmModel.invalidGoodsList];
                for (ActInfoListModel *actModel in actInfoList) {
                    NSArray *actInfoList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:actModel.actGoodsList];
                    actModel.actGoodsList = [actInfoList mutableCopy];
                }
                firmModel.actInfoList = [actInfoList mutableCopy];
                firmModel.cartGoodsList = [cartGoodsList mutableCopy];
                firmModel.couponList = couponList;
                firmModel.defaultCoupon = defaultCoupon;
                firmModel.invalidGoodsList = invalidGoodsList;
            }
            
            
            [weakSelf.dataArray addObjectsFromArray:firmList];
            [weakSelf isHaveInvalidGoodsList_and_getAll_InvalidGoodsList];
        }else{
            
        }
        [weakSelf removeEmptyObjectList];

        [weakSelf dc_reloadView:YES];
        

        
    } failture:^(NSError *error) {
        [weakSelf dc_reloadView:YES];
    }];
    
}

#pragma mark - 请求 加入收藏
- (void)requestAddCollect:(NSString *)collectIds
{
    [[DCAPIManager shareManager] person_CollectionGoodswithobjectIds:collectIds success:^(id response){
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"添加收藏成功"];
        }
    } failture:^(NSError *_Nullable error) {
    }];
    
    [self managerAction:self.navigationItem.rightBarButtonItem];
}


#pragma mark - 请求 删除购物车
- (void)requestRemoveShoppingCar:(NSArray *)carIdArr type:(NSInteger)type
{
    if (type == 1) {//
        WEAKSELF;
        [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_cart_editWithAct:@"remove" cart:carIdArr value:@"" success:^(id  _Nullable response) {
            if (response) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [weakSelf cahngeDataArray:carIdArr];
            }
        } failture:^(NSError * _Nullable error) {
            
        }];
    }else{
        WEAKSELF;
        [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_cart_editWithAct:@"remove" cart:carIdArr value:@"" success:^(id  _Nullable response) {
            if (response) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [weakSelf requestShoppingCarList];
            }
        } failture:^(NSError * _Nullable error) {
            
        }];
    }
    
    [self managerAction:self.navigationItem.rightBarButtonItem];
}

- (void)cahngeDataArray:(NSArray *)carIdArr{
    
    [carIdArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull carId, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.dataArray enumerateObjectsUsingBlock:^(GLPFirmListModel *  _Nonnull carModel, NSUInteger idx11, BOOL * _Nonnull stop11) {
            
            // 活动
            [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx12, BOOL * _Nonnull stop12) {
                [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx13, BOOL * _Nonnull stop13) {
                    if ([carId isEqualToString:goodsModel.cartId]) {
                        [actModel.actGoodsList removeObject:goodsModel];
                    }
                }];
            }];
            
            // 非活动
            [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx21, BOOL * _Nonnull stop21) {
                if ([carId isEqualToString:goodsModel.cartId]) {
                    [carModel.cartGoodsList removeObject:goodsModel];
                }
            }];
        
        }];
        
    }];
    
    [self removeEmptyObjectList];
    
    [self dc_reloadView:YES];
}

- (void)removeEmptyObjectList{
    
    [self.dataArray enumerateObjectsUsingBlock:^(GLPFirmListModel *  _Nonnull carModel, NSUInteger idx11, BOOL * _Nonnull stop11) {
        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx12, BOOL * _Nonnull stop12) {
            if (actModel.actGoodsList.count == 0) {
                [carModel.actInfoList removeObject:actModel];
            }
        }];

        if (carModel.cartGoodsList.count == 0 && carModel.actInfoList.count ==0) {
            [self.dataArray removeObject:carModel];
        }
    }];
}

#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 10.0f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:NSClassFromString(GLPShoppingCarCellID) forCellReuseIdentifier:GLPShoppingCarCellID];
        [_tableView registerClass:NSClassFromString(GLPInvalidGoodsListCellID) forCellReuseIdentifier:GLPInvalidGoodsListCellID];
    }
    return _tableView;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 10;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }else{
//        scrollView.contentInset = UIEdgeInsetsMake(0.01, 0, 0, 0);
//    }
//}

- (GLPShoppingCarBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GLPShoppingCarBottomView alloc] initWithFrame:CGRectZero];
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

- (NSMutableArray *)invalidGoodsList{
    if (!_invalidGoodsList) {
        _invalidGoodsList = [[NSMutableArray alloc] init];
    }
    return _invalidGoodsList;
}


@end
