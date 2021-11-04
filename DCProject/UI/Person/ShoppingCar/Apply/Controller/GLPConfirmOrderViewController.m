//
//  GLPConfirmOrderViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/7/12.
//

#import "GLPConfirmOrderViewController.h"

#import "GLPConfirmOrderStoreCell.h"
#import "GLPConfirmOrderTotalCell.h"
#import "GLPApplyAddressCell.h"
#import "GLBSelectAddressCell.h"
#import "GLPConfirmOrderBottomView.h"

#import "GLPAddressListVC.h"
#import "GLPConfirmOrderListVC.h"
#import "PayAndDistributionVC.h"
#import "GLPNewTicketSelectVC.h"
#import "TRStorePageVC.h"

#import "GLPGoodsAddressModel.h"
#import "PersonOrderPageController.h"
#import "GLPApplyOTCInfoCell.h"
#import "GLPH5ViewController.h"
#import "NSMutableArray+WeakReferences.h"
#import "GLPMedicalInformationVC.h"
#import "GLPToPayViewController.h"
static NSString *const GLPConfirmOrderStoreCellID = @"GLPConfirmOrderStoreCell";
static NSString *const GLPConfirmOrderTotalCellID = @"GLPConfirmOrderTotalCell";
static NSString *const GLPApplyAddressCellID = @"GLPApplyAddressCell";
static NSString *const GLBSelectAddressCellID = @"GLBSelectAddressCell";
static NSString *const GLPApplyOTCInfoCellID = @"GLPApplyOTCInfoCell";

@interface GLPConfirmOrderViewController ()

@property (nonatomic, strong) GLPConfirmOrderBottomView *bottomView;

@property (nonatomic, strong) PatientDisplayInformationModel *infoModel;
@property (nonatomic, strong) MedicalPersListModel *userModel;
@property (nonatomic, strong) GLPGoodsAddressModel *addressModel; // 地址模型
@property (nonatomic, strong) NSMutableArray<GLPFirmListModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GLPNewShopCarGoodsModel *> *goodsArray;
@property (nonatomic, assign) BOOL isOtc; //药品中是否包含otc药品，otc需要选择用药人

@end

@implementation GLPConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"确认订单";
    self.isOtc = NO;
    WEAKSELF;
    [self.mainModel.firmList enumerateObjectsUsingBlock:^(GLPFirmListModel *firmModel, NSUInteger idx1, BOOL * _Nonnull stop1) {
        if (firmModel.isPrescription) {
            weakSelf.isOtc = YES;
        }
        
        [firmModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *actModel, NSUInteger idx21, BOOL * _Nonnull stop21) {
            
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx3, BOOL * _Nonnull stop3) {
                [weakSelf.goodsArray addObject:goodsModel];
                if ([goodsModel.isOtc intValue] == 2) {
                    //记录药品ID
                    weakSelf.isOtc = YES;
                    NSArray *arr = [goodsModel.goodsId componentsSeparatedByString:@"_"];
                    [self.infoModel.drugInfo setObject:@"" forKey:[NSString stringWithFormat:@"%@",arr[0]]];
                    [self.infoModel.goodsOtcArray addObject:goodsModel];
                }
            }];
        }];
        
        [firmModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx22, BOOL * _Nonnull stop22) {
            [weakSelf.goodsArray addObject:goodsModel];
            if ([goodsModel.isOtc intValue] == 2) {
                //记录药品ID
                weakSelf.isOtc = YES;
                NSArray *arr = [goodsModel.goodsId componentsSeparatedByString:@"_"];
                [self.infoModel.drugInfo setObject:@"" forKey:[NSString stringWithFormat:@"%@",arr[0]]];
                [self.infoModel.goodsOtcArray addObject:goodsModel];
            }
        }];
    }];
    
    //    [self.dataArray removeAllObjects];
    //    NSMutableArray *indexArr = [NSMutableArray mutableArrayUsingWeakReferences];//解决强引用造成的问题
    //    indexArr = [self.mainModel.firmList  mutableCopy];
    //    self.dataArray = [indexArr mutableCopy];
    self.dataArray = [self.mainModel.firmList  mutableCopy];
    
    [self requestDefaultAddress];
    
    //    if (self.shoppingCarArray.count == 0) {
    //    }else{
    //    }
    
    [self.view addSubview:self.bottomView];
    [self setUpTableView];
    
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isOtc ? self.dataArray.count + 3 : self.dataArray.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WEAKSELF;//0x12171c2b0 0x103654630
    if (indexPath.section == 0) {
        //地址
        if (self.addressModel && self.addressModel.addrId) {
            GLPApplyAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:GLPApplyAddressCellID forIndexPath:indexPath];
            addressCell.addressModel = self.addressModel;
            cell = addressCell;
        } else {
            GLBSelectAddressCell *noAaddressCell = [tableView dequeueReusableCellWithIdentifier:GLBSelectAddressCellID forIndexPath:indexPath];
            cell = noAaddressCell;
        }
    } else if (self.isOtc && indexPath.section == 1) {
        GLPApplyOTCInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:GLPApplyOTCInfoCellID forIndexPath:indexPath];
        infoCell.model = self.userModel;
        cell = infoCell;
    } else if ((self.isOtc && indexPath.section == self.dataArray.count + 2) || (!self.isOtc && indexPath.section == self.dataArray.count + 1)) {
        
        GLPConfirmOrderTotalCell *totalCell = [tableView dequeueReusableCellWithIdentifier:GLPConfirmOrderTotalCellID forIndexPath:indexPath];
        if (self.dataArray.count > 0) {
            totalCell.model = self.mainModel;
        }
        cell = totalCell;
    } else {
        NSInteger section = self.isOtc ? indexPath.section - 2 : indexPath.section - 1;
        GLPConfirmOrderStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:GLPConfirmOrderStoreCellID forIndexPath:indexPath];
        storeCell.firmModel = self.dataArray[section];
        storeCell.clickGoodsView_Block = ^{
            [weakSelf dc_pushApplyGoodsListController:indexPath];
        };
        storeCell.clickMoreTicketView_Block = ^{
            [weakSelf pushMineTicketController:indexPath];
        };
        storeCell.GLPConfirmOrderStoreCell_block = ^(NSString * _Nonnull text) {
            GLPFirmListModel *carModel = weakSelf.dataArray[section];
            carModel.remark = text;
            [weakSelf.dataArray replaceObjectAtIndex:section withObject:carModel];
        };
        storeCell.clickShopBtnBlock_Block = ^{
            [weakSelf dc_pushTRStorePageVC:indexPath];
        };
        cell = storeCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section<2) {
        return 5.01f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    if (indexPath.section == 0) {
        GLPAddressListVC *vc = [GLPAddressListVC new];
        vc.isChose = @"1";
        vc.addressblock = ^(GLPGoodsAddressModel *_Nonnull model) {
            weakSelf.addressModel = model;
            [weakSelf.tableView reloadData];
            
            [weakSelf requestTradeInfoFreight];
        };
        [self dc_pushNextController:vc];
    }else if (self.isOtc && indexPath.section == 1){
        
        GLPMedicalInformationVC *vc = [[GLPMedicalInformationVC alloc] init];
        NSArray *allKeys = [self.infoModel.drugInfo allKeys];
        NSString *goodsIds = @"";
        for (NSString *key in allKeys) {
            if (goodsIds.length == 0) {
                goodsIds = key;
            }else
                goodsIds = [NSString stringWithFormat:@"%@,%@",goodsIds,key];
        }
        vc.goodsIds = goodsIds;
        vc.infoModel = [self.infoModel mutableCopy];
        WEAKSELF;
        vc.GLPMedicalInformationVC_block = ^(PatientDisplayInformationModel * _Nonnull infoModel, MedicalPersListModel * _Nonnull userModel) {
            weakSelf.userModel = userModel;
            weakSelf.infoModel = [infoModel mutableCopy];
            weakSelf.infoModel.drugId = [NSString stringWithFormat:@"%@",weakSelf.infoModel.drugId];
            weakSelf.infoModel.onlineStatus = [NSString stringWithFormat:@"%@",weakSelf.infoModel.onlineStatus];
            weakSelf.infoModel.drugImg = [NSString stringWithFormat:@"%@",weakSelf.infoModel.drugImg];
            weakSelf.infoModel.billDesc = [NSString stringWithFormat:@"%@",weakSelf.infoModel.billDesc];
            NSMutableDictionary *drugInfo = [NSMutableDictionary dictionaryWithDictionary:weakSelf.infoModel.drugInfo];
            [weakSelf.infoModel.drugInfo addEntriesFromDictionary:drugInfo];
            NSLog(@"====drugInfo:%@",weakSelf.infoModel.drugInfo);
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        [self dc_pushNextController:vc];
    }
    
}

#pragma mark - 商品详情列表
- (void)dc_pushApplyGoodsListController:(NSIndexPath *)indexPath
{
    GLPConfirmOrderListVC *vc = [GLPConfirmOrderListVC new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.firmModel = self.dataArray[(self.isOtc ? indexPath.section-2 : indexPath.section-1)];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

#pragma mark - 跳转到店铺详情
- (void)dc_pushTRStorePageVC:(NSIndexPath *)indexPath
{
    GLPFirmListModel *carModel = self.dataArray[(self.isOtc ? indexPath.section-2 : indexPath.section-1)];
    TRStorePageVC *vc = [TRStorePageVC new];
    vc.firmId = [NSString stringWithFormat:@"%@",carModel.sellerFirmId];
    [self dc_pushNextController:vc];
}

#pragma mark -  选择优惠券
- (void)pushMineTicketController:(NSIndexPath *)indexPath
{
    __block GLPFirmListModel *firmModel = self.dataArray[(self.isOtc ? indexPath.section-2 : indexPath.section-1)];
    if (firmModel.couponList.count == 0) {
        //[self.view makeToast:@"暂无可用优惠券"];
        return;
    }
    GLPNewTicketSelectVC *vc = [GLPNewTicketSelectVC new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.firmModel = firmModel;
    WEAKSELF;//
    vc.GLPNewTicketSelectVC_block = ^(NSArray * _Nonnull ticketArray) {
        [weakSelf getNewOrderCouponsDiscountWithOldDefaultCoupon:firmModel.defaultCoupon andNewTicketArray:ticketArray];
        firmModel.defaultCoupon = ticketArray;
        [weakSelf changePriceInformation];
    };
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)getNewOrderCouponsDiscountWithOldDefaultCoupon:(NSArray *)defaultCoupon andNewTicketArray:(NSArray *)ticketArray{
    __block CGFloat oldNum = 0;
    [defaultCoupon enumerateObjectsUsingBlock:^(GLPCouponListModel *couponModel, NSUInteger idx22, BOOL * _Nonnull stop22) {
        oldNum += [couponModel.discountAmount floatValue];
    }];
    
    __block CGFloat newNum = 0;
    [ticketArray enumerateObjectsUsingBlock:^(GLPCouponListModel *couponModel, NSUInteger idx22, BOOL * _Nonnull stop22) {
        newNum += [couponModel.discountAmount floatValue];
    }];
    
    CGFloat spreadNum = oldNum - newNum;
    CGFloat oldAll = [self.mainModel.orderCouponsDiscount floatValue];
    self.mainModel.orderCouponsDiscount = [NSString stringWithFormat:@"%.2f",oldAll-spreadNum];
}

#pragma mark - action
- (void)dc_payBtnClick
{
    NSString *addrId = @"";
    if (self.addressModel && self.addressModel.addrId) {
        addrId = self.addressModel.addrId;
    }
    
    if (addrId.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择收货地址"];
        return;
    }
    
    if (self.isOtc && self.infoModel.drugId.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写就诊信息"];
        return;
    }
    
    __block NSString *batchId = @"";
    __block NSMutableArray *cartArr = [[NSMutableArray alloc] init];
    __block NSString *goodsId = @"";
    __block NSString *quantity = @"";
    __block NSString *sellerFirmId = @"";
    
    WEAKSELF;
    [self.goodsArray enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        batchId = goodsModel.batchId.length > 0 ? goodsModel.batchId : @"";
        [cartArr addObject:goodsModel.cartId];
        if (idx == 0) {
            goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
        }else{
            goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
        }
        quantity = goodsModel.quantity;
        sellerFirmId = goodsModel.sellerFirmId;
    }];
    
    NSMutableArray *symptomList = [[NSMutableArray alloc] init];
    for (NSString *key in self.infoModel.drugInfo) {
        NSDictionary *dic = @{@"goodsId":key,@"symptom":[self.infoModel.drugInfo objectForKey:key]};
        [symptomList addObject:dic];
    }
    
    if ([self.ispay isEqualToString:@"1"]) {
        //直接购
        cartArr = [NSMutableArray arrayWithArray:@[]];
    }else{
        //购物车
        batchId = @"";
        quantity = @"";
        sellerFirmId = @"";
    }
    
    NSString *billDesc = self.infoModel.billDesc;
    NSString *tradeType = @"5";
    
    NSString *prescriptionImg = @"";
    NSString *supUrl = @"";
    if ([self.infoModel.onlineStatus isEqualToString:@"1"]) {
        prescriptionImg = self.infoModel.drugImg;
    }else{
        supUrl = self.infoModel.drugImg;
    }
    __block NSString *payFirmId = @"";
    NSMutableArray *shopList = [[NSMutableArray alloc] init];
    [self.mainModel.firmList enumerateObjectsUsingBlock:^(GLPFirmListModel *firmModel, NSUInteger idx1, BOOL * _Nonnull stop1) {
        NSMutableArray *couponsId = [[NSMutableArray alloc] init];
        [firmModel.defaultCoupon enumerateObjectsUsingBlock:^(GLPCouponListModel *couponModel, NSUInteger idx22, BOOL * _Nonnull stop22) {
            [couponsId addObject:couponModel.couponsId];
        }];
        NSDictionary *firmDic = @{@"couponsId":couponsId,@"firmId":firmModel.sellerFirmId,@"leaveMsg":firmModel.remark ? firmModel.remark : @""};
        [shopList addObject:firmDic];
        payFirmId = firmModel.sellerFirmId;
    }];
    
    
    NSString *actType = [self.actDic objectForKey:@"actType"];//1-秒杀；2-拼团；
    NSString *actId = [self.actDic objectForKey:@"actId"];//秒杀或者拼团的Id
    NSString *joinId = [self.actDic objectForKey:@"joinId"];//参与时存发起拼团ID（拼团购买使用）
    NSString *mixId = [self.actDic objectForKey:@"mixId"];//组合装Id
    if ([self.ispay isEqualToString:@"1"]) {
        //
    }
    
    
    
    NSDictionary *paramDic = @{@"addrId":addrId,
                               @"batchId":batchId,
                               @"billDesc":billDesc,
                               @"cart":cartArr,
                               @"goodsId":goodsId,
                               @"drugId":self.infoModel.drugId,
                               @"prescriptionImg":prescriptionImg,
                               @"quantity":quantity,
                               @"sellerFirmId":sellerFirmId,
                               @"shopList":shopList,
                               @"supUrl":supUrl,
                               @"symptomList":symptomList,
                               @"tradeType":tradeType,
                               @"actType":actType,
                               @"actId":actId,
                               @"joinId":joinId,
                               @"mixId":mixId,
    };
    
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_submit_newWithPrameDic:paramDic success:^(id  _Nullable response) {
        NSString *typeStr = @"订单成功详情页";
        if ([weakSelf.ispay isEqualToString:@"2"]) {
            typeStr = @"订单成功购物车";
        }
        
        NSDictionary *dict = @{@"type":typeStr,@"goodsId":[NSString stringWithFormat:@"提交%@",goodsId]};//UM统计 自定义搜索关键词事件
        [MobClick event:UMEventCollection_32 attributes:dict];
        
        [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
        NSDictionary *dic = response;
        
        NSArray *orderNo = dic[@"data"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (orderNo.count>1) {
                PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
                vc.index = 1;
                [weakSelf dc_pushNextController:vc];
            }else{
                GLPToPayViewController *vc = [[GLPToPayViewController alloc] init];
                vc.firmIdStr = payFirmId;
                vc.isNeedBackOrder = YES;
                vc.orderNoStr = orderNo[0];
                [weakSelf dc_pushNextController:vc];
                //                NSString *paramStr = [NSString stringWithFormat:@"orderNo=%@",orderNo[0]];
                //                [weakSelf dc_pushPersonWebToPayController:@"/geren/pay.html" params:paramStr targetIndex:1];
            }
        });
        
    } failture:^(NSError * _Nullable error) {
        
    }];
    
}


#pragma mark - 刷新运费信息
- (void)uploadYunfeiInfo
{
    // 先将运费归0
    [self.dataArray enumerateObjectsUsingBlock:^(GLPFirmListModel * _Nonnull firmModel, NSUInteger idx, BOOL * _Nonnull stop) {
        firmModel.yufei = 0;
        [self.dataArray replaceObjectAtIndex:idx withObject:firmModel];
        
        [self.addressModel.expressList enumerateObjectsUsingBlock:^(GLPGoodsAddressExpressModel *  _Nonnull expressModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([expressModel.sellerFirmId isEqualToString:firmModel.sellerFirmId]) {
                firmModel.yufei = [expressModel.freight floatValue];
            }
        }];
    }];
    
    self.mainModel.firmList = self.dataArray;//运费变化 重新赋值
    [self changePriceInformation];
}

- (void)changePriceInformation{
    self.bottomView.model = self.mainModel;
    [self.tableView reloadData];
}

#pragma mark - 请求 获取默认收货地址
- (void)requestDefaultAddress
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_GetDefautAddresssuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            
            GLPGoodsAddressModel *addressModel = [GLPGoodsAddressModel mj_objectWithKeyValues:response[@"data"]];
            weakSelf.addressModel = addressModel;
            [weakSelf changePriceInformation];
            if (weakSelf.addressModel && weakSelf.addressModel.areaId) {
                [weakSelf requestTradeInfoFreight];
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 请求 运费
- (void)requestTradeInfoFreight{
    
    NSString *areaId = self.addressModel.areaId ? self.addressModel.areaId : @"";
    
    NSMutableArray *listArr = [[NSMutableArray alloc] init];
    
    [self.goodsArray enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *goodsId = goodsModel.goodsId ? goodsModel.goodsId : @"";
        NSString *logisticsTplId = goodsModel.logisticsTplId  ? goodsModel.logisticsTplId : @"";
        NSString *goodsWeight = goodsModel.goodsWeight ? goodsModel.goodsWeight : @"";
        NSString *quantity = goodsModel.quantity ? goodsModel.quantity : @"";
        NSString *sellerFirmId = goodsModel.sellerFirmId ? goodsModel.sellerFirmId : @"";
        NSString *goodsSubtotal = goodsModel.goodsSubtotal;//（商品小计，明细页面传入单价、订单确认页面传入后台给的goodsSubtotal）
        NSString *freeShippingId = goodsModel.freeShippingId;//freeShippingId（包邮活动的Id，若存在）
        
        NSDictionary *dic = @{@"goodsId":goodsId,@"logisticsTplId":logisticsTplId,@"goodsWeight":goodsWeight,@"quantity":quantity,@"sellerFirmId":sellerFirmId,@"goodsSubtotal":goodsSubtotal,@"freeShippingId":freeShippingId};
        [listArr addObject:dic];
    }];
    
    
    WEAKSELF;//因为详情页只有一种商品所以
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_freightWithAreaId:areaId goodsList:listArr success:^(id  _Nullable response) {
        NSArray *listArr = [GLPGoodsAddressExpressModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        weakSelf.addressModel.expressList = listArr;
        [weakSelf uploadYunfeiInfo];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - UI
- (void)setUpTableView{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - CGRectGetHeight(self.bottomView.frame));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    [self.tableView registerClass:NSClassFromString(GLBSelectAddressCellID) forCellReuseIdentifier:GLBSelectAddressCellID];
    [self.tableView registerClass:NSClassFromString(GLPApplyAddressCellID) forCellReuseIdentifier:GLPApplyAddressCellID];
    [self.tableView registerClass:NSClassFromString(GLPConfirmOrderStoreCellID) forCellReuseIdentifier:GLPConfirmOrderStoreCellID];
    [self.tableView registerClass:NSClassFromString(GLPConfirmOrderTotalCellID) forCellReuseIdentifier:GLPConfirmOrderTotalCellID];
    [self.tableView registerClass:NSClassFromString(GLPApplyOTCInfoCellID) forCellReuseIdentifier:GLPApplyOTCInfoCellID];
}


#pragma mark - lazy load
- (GLPConfirmOrderBottomView *)bottomView{
    if (!_bottomView) {
        CGFloat height = kStatusBarHeight > 20 ? 90 : 56;
        _bottomView = [[GLPConfirmOrderBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - height, kScreenW, height)];
        WEAKSELF;
        _bottomView.GLPConfirmOrderBottomView_block = ^{
            [weakSelf dc_payBtnClick];
        };
    }
    return _bottomView;
}


- (NSMutableArray<GLPFirmListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLPNewShopCarGoodsModel *> *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}

- (PatientDisplayInformationModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [[PatientDisplayInformationModel alloc] init];
        _infoModel.drugId = @"";
        _infoModel.onlineStatus = @"0";
        _infoModel.drugImg = @"";
        _infoModel.billDesc = @"";
        _infoModel.isConfirm = @"0";
        _infoModel.drugImgList = [[NSMutableArray alloc] init];
        _infoModel.drugInfo = [NSMutableDictionary dictionary];
        _infoModel.goodsOtcArray = [[NSMutableArray alloc] init];
        
    }
    return _infoModel;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
