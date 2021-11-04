//
//  GLPApplyController.m
//  DCProject
//
//  Created by bigbing on 2019/9/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPApplyController.h"

#import "GLPApplyStoreCell.h"
#import "GLPApplyTotalCell.h"
#import "GLPApplyAddressCell.h"
#import "GLBSelectAddressCell.h"
#import "GLPApplyBottomView.h"

#import "GLPAddressListVC.h"
#import "GLPApplyGoodsListController.h"
#import "PayAndDistributionVC.h"
#import "GLPTicketSelectController.h"
#import "TRStorePageVC.h"

#import "GLPGoodsAddressModel.h"
#import "PersonOrderPageController.h"
#import "GLPApplyOTCInfoCell.h"
#import "GLPH5ViewController.h"
#import "NSMutableArray+WeakReferences.h"

#import "GLPMedicalInformationVC.h"

static NSString *const storeCellID = @"GLPApplyStoreCell";
static NSString *const totalCellID = @"GLPApplyTotalCell";
static NSString *const addressCellID = @"GLPApplyAddressCell";
static NSString *const noAddressCellID = @"GLBSelectAddressCell";
static NSString *const GLPApplyOTCInfoCellID = @"GLPApplyOTCInfoCell";


@interface GLPApplyController ()

@property (nonatomic, strong) PatientDisplayInformationModel *infoModel;
@property (nonatomic, strong) MedicalPersListModel *userModel;


@property (nonatomic, strong) GLPApplyBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray<GLPShoppingCarModel *> *dataArray;
@property (nonatomic, strong) GLPGoodsAddressModel *addressModel; // 地址模型
//@property (nonatomic, strong) NSMutableArray *selectTicketArray;

@property (nonatomic, assign) BOOL isOtc; //药品中是否包含otc药品，otc需要选择用药人


@end

@implementation GLPApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"确认订单";

    [self.view addSubview:self.bottomView];
    [self setUpTableView];
    
    [self requestDefaultAddress];
    
    
    if (self.shoppingcarArray) {
        [self.dataArray removeAllObjects];
        NSMutableArray *indexArr = [NSMutableArray mutableArrayUsingWeakReferences];//解决强引用造成的问题
        indexArr = [self.shoppingcarArray  mutableCopy];
        self.dataArray = [indexArr mutableCopy];
        //        [self.dataArray addObjectsFromArray:self.shoppingcarArray];//造成指针地址一样
        //循环判断是否有OTC
        for (GLPShoppingCarModel *carModel in self.dataArray) {
            if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
                for (int i=0; i<carModel.validActInfoList.count; i++) {
                    GLPShoppingCarActivityModel *activityModel = carModel.validActInfoList[i];
                    if (activityModel.actCartGoodsList && activityModel.actCartGoodsList.count > 0) {
                        for (int j = 0; j<activityModel.actCartGoodsList.count; j++) {
                            GLPShoppingCarActivityGoodsModel *goodsModel = activityModel.actCartGoodsList[j];
                            if (goodsModel.isSelected && goodsModel.isOtc == 2) {
                                self.isOtc = YES;
                                //                                break;
                                //记录药品ID
                                NSArray *arr = [goodsModel.goodsId componentsSeparatedByString:@"_"];
                                [self.infoModel.drugInfo setObject:@"" forKey:[NSString stringWithFormat:@"%@",arr[0]]];
                            }
                        }
                    }
                    //                    if (self.isOtc) {
                    //                        break;
                    //                    }
                }
            }
            if (carModel.validNoActGoodsList && [carModel.validNoActGoodsList count] > 0) {
                for (int i=0; i<carModel.validNoActGoodsList.count; i++) {
                    GLPShoppingCarNoActivityModel *noActivityModel = carModel.validNoActGoodsList[i];
                    if (noActivityModel.isOtc == 2 && noActivityModel.isSelected) {
                        self.isOtc = YES;
                        //                        break;
                        //记录药品ID
                        NSArray *arr = [noActivityModel.goodsId componentsSeparatedByString:@"_"];
                        [self.infoModel.drugInfo setObject:@"" forKey:[NSString stringWithFormat:@"%@",arr[0]]];
                    }
                }
            }
            //            if (self.isOtc) {
            //                break;
            //            }
        }
    }
    NSLog(@"===self.drugInfo:%@",self.infoModel.drugInfo);
    [self.tableView reloadData];
    self.bottomView.dataArray = self.dataArray;
    
    if (!self.goodsId) {
        [self requestApplyOrderTicket];
    }
    
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
    WEAKSELF;
    if (indexPath.section == 0) {
        
        if (self.addressModel && self.addressModel.addrId) {
            GLPApplyAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:addressCellID forIndexPath:indexPath];
            addressCell.addressModel = self.addressModel;
            cell = addressCell;
            
        } else {
            
            GLBSelectAddressCell *noAaddressCell = [tableView dequeueReusableCellWithIdentifier:noAddressCellID forIndexPath:indexPath];
            cell = noAaddressCell;
            
        }
        
        
    } else if (self.isOtc && indexPath.section == 1) {
        
        GLPApplyOTCInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:GLPApplyOTCInfoCellID forIndexPath:indexPath];
        //infoCell.hasInfo = self.drugId.length > 0;
        infoCell.model = self.userModel;
        cell = infoCell;
        
    } else if ((self.isOtc && indexPath.section == self.dataArray.count + 2) || (!self.isOtc && indexPath.section == self.dataArray.count + 1)) {
        
        GLPApplyTotalCell *totalCell = [tableView dequeueReusableCellWithIdentifier:totalCellID forIndexPath:indexPath];
        if (self.dataArray.count > 0) {
            totalCell.dataArray = self.dataArray;
        }
        cell = totalCell;
        
    } else {
        NSInteger section = self.isOtc ? indexPath.section - 2 : indexPath.section - 1;
        GLPApplyStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:storeCellID forIndexPath:indexPath];
        storeCell.carModel = self.dataArray[section];
        storeCell.goodsViewBlock = ^{
            [weakSelf dc_pushApplyGoodsListController:indexPath];
        };
        storeCell.ticketBlock = ^{
            [weakSelf pushMineTicketController:indexPath];
        };
        storeCell.storeTFBlock = ^(NSString *text) {
            GLPShoppingCarModel *carModel = weakSelf.dataArray[section];
            carModel.remark = text;
            [weakSelf.dataArray replaceObjectAtIndex:section withObject:carModel];
        };
        storeCell.shopBtnBlock = ^{
            [weakSelf dc_pushTRStorePageVC:indexPath];
        };
        MJWeakSelf
        storeCell.payAndDistrBlock = ^{
            
            weakSelf.bottomView.dataArray = weakSelf.dataArray;
            [weakSelf.tableView reloadData];
            
            //            PayAndDistributionVC *vc = [[PayAndDistributionVC alloc] init];
            //            vc.payWay = @"2";
            //            vc.distributionWay = @"1";
            //            vc.goodsArray = @[@"",@"",@"",@""];
            //            vc.distributionwayBlock = ^(NSString *_Nonnull distributionway) {
            //
            //            };
            //            vc.paywayBlock = ^(NSString *_Nonnull payway) {
            //
            //            };
            //            [self.navigationController pushViewController:vc animated:YES];
        };
        cell = storeCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return 0.01f;
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
            
            [weakSelf uploadYunfeiInfo];
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


#pragma mark - action
- (void)dc_payBtnClick
{
    NSString *areaId = @"";
    if (self.addressModel && self.addressModel.addrId) {
        areaId = self.addressModel.addrId;
    }
    
    if (areaId.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择收货地址"];
        return;
    }
    if (self.isOtc && self.infoModel.drugId.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写就诊信息"];
        return;
    }
    
    // 购物车id
    NSString *cardIds = @"";
    NSMutableArray *sellerFirmList = [NSMutableArray array];
    
    
    
    for (int i=0; i<self.dataArray.count; i++) {
        GLPShoppingCarModel *carModel = self.dataArray[i];
        NSMutableArray *orderGoodsList = [[NSMutableArray alloc] init];
        
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            for (int j = 0; j<carModel.validActInfoList.count; j++) {
                GLPShoppingCarActivityModel *activityModel = carModel.validActInfoList[j];
                if (activityModel.actCartGoodsList && activityModel.actCartGoodsList.count > 0) {
                    for (int k = 0; k<activityModel.actCartGoodsList.count; k++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = activityModel.actCartGoodsList[k];
                        
                        if (goodsModel.isSelected) {
                            
                            if (cardIds.length == 0) {
                                cardIds = [NSString stringWithFormat:@"%ld",goodsModel.cartId];
                            } else {
                                cardIds = [NSString stringWithFormat:@"%@,%ld",cardIds,goodsModel.cartId];
                            }
                            
                            //如果是otc
                            if (goodsModel.isOtc == 2) {
                                NSString *gid = [[goodsModel.goodsId componentsSeparatedByString:@"_"] firstObject];
                                NSString *symptom = [NSString stringWithFormat:@"%@",self.infoModel.drugInfo[gid]];
                                [orderGoodsList addObject:@{@"goodsId":gid,@"symptom":symptom}];
                            }
                        }
                        
                    }
                }
            }
        }
        
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            for (int z =0; z<carModel.validNoActGoodsList.count; z++) {
                GLPShoppingCarNoActivityModel *noActModel = carModel.validNoActGoodsList[z];
                if (noActModel.isSelected) {
                    
                    if (cardIds.length == 0) {
                        cardIds = [NSString stringWithFormat:@"%ld",noActModel.cartId];
                    } else {
                        cardIds = [NSString stringWithFormat:@"%@,%ld",cardIds,noActModel.cartId];
                    }
                    
                    //如果是otc
                    if (noActModel.isOtc == 2) {
                        NSString *gid = [[noActModel.goodsId componentsSeparatedByString:@"_"] firstObject];
                        NSString *symptom = [NSString stringWithFormat:@"%@",self.infoModel.drugInfo[gid]];
                        [orderGoodsList addObject:@{@"goodsId":gid,@"symptom":symptom}];
                    }
                }
                
            }
        }
        
        NSString *couponsId = @"";
        if (carModel.ticketArray && carModel.ticketArray.count > 0) {
            for (int qqq=0; qqq<carModel.ticketArray.count; qqq++) {
                GLPNewTicketModel *ticketModel = carModel.ticketArray[qqq];
                if (couponsId.length == 0) {
                    couponsId = [NSString stringWithFormat:@"%ld",ticketModel.couponsId];
                } else {
                    couponsId = [NSString stringWithFormat:@"%@,%ld",couponsId,ticketModel.couponsId];
                }
            }
        }
        
        NSDictionary *dictionary = @{@"couponIds":couponsId,
                                     @"leaveMsg":carModel.remark ? carModel.remark : @"",
                                     @"firmId":@(carModel.sellerFirmId),
                                     @"buyType":[carModel.sendType integerValue]==1?@"12":@"11",
                                     @"orderGoodsList":orderGoodsList
        };
        
        [sellerFirmList addObject:dictionary];
    }
    NSString *prescriptionImg = @"";
    NSString *supUrl = @"";
    if ([self.infoModel.onlineStatus isEqualToString:@"1"]) {
        prescriptionImg = self.infoModel.drugImg;
    }else{
        supUrl = self.infoModel.drugImg;
    }

    WEAKSELF;
    if ([self.ispay isEqualToString:@"1"])
    {
        //商品详情点击立即购买
        
        NSString *leaveMsg = @"";
        NSString *couponsId = @"";
        NSString *buy = @"";
        NSString *symptom = @"";
        if (sellerFirmList.count > 0) {
            NSDictionary *dictttt = sellerFirmList[0];
            leaveMsg = dictttt[@"leaveMsg"];
            couponsId = dictttt[@"couponIds"];
            buy = dictttt[@"buyType"];
            NSArray *arr = [NSArray arrayWithArray:dictttt[@"orderGoodsList"]];
            if (arr.count > 0) {
                symptom = [NSString stringWithFormat:@"%@",[arr firstObject][@"symptom"]];
            }
        }
        [[DCAPIManager shareManager] person_buyNowWidthGoodsId:self.goodsId quantity:self.quanlity addrId:areaId leaveMsg:leaveMsg couponId:couponsId buytype:buy drugId:self.infoModel.drugId symptom:symptom prescriptionImg:prescriptionImg billDesc:self.infoModel.billDesc supUrl:supUrl success:^(id response) {
            
            NSDictionary *dict = response;
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"orderNo"]) {
                    NSString *orderNo = dict[@"data"][@"orderNo"];
                    [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSString *paramStr = [NSString stringWithFormat:@"orderNo=%@",orderNo];
                        //[weakSelf dc_pushPersonWebController:@"/geren/pay.html" params:paramStr];
                        [weakSelf dc_pushPersonWebToPayController:@"/geren/pay.html" params:paramStr targetIndex:1];

                    });
                }
            }
            
        } failture:^(NSError *error) {
            
        }];
        
    }
    else{
        //购物车提
        [[DCAPIManager shareManager] person_requestShoppingCarCommintWithAaddrId:areaId cartIds:cardIds sellerFirmList:sellerFirmList drugId:self.infoModel.drugId prescriptionImg:prescriptionImg billDesc:self.infoModel.billDesc supUrl:supUrl success:^(id response) {
            if (response) {
                [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
                
                NSDictionary *dict = response;
                if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    if (dict[@"data"][@"orderNo"]) {
                        NSString *orderNo = dict[@"data"][@"orderNo"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            NSString *paramStr = [NSString stringWithFormat:@"orderNo=%@",orderNo];
                            //[weakSelf dc_pushPersonWebController:@"/geren/pay.html" params:paramStr];
                            [weakSelf dc_pushPersonWebToPayController:@"/geren/pay.html" params:paramStr targetIndex:1];
                        });
                        
                        return ;
                    }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
                    vc.index = 1;
                    [weakSelf dc_pushNextController:vc];
                    
                    //                       [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
            
        } failture:^(NSError *_Nullable error) {
        }];
    }
}


#pragma mark - 页面跳转
- (void)dc_pushApplyGoodsListController:(NSIndexPath *)indexPath
{
    GLPApplyGoodsListController *vc = [GLPApplyGoodsListController new];
    vc.carModel = self.dataArray[(self.isOtc ? indexPath.section-2 : indexPath.section-1)];
    [self dc_pushNextController:vc];
}

#pragma mark - 跳转到店铺详情
- (void)dc_pushTRStorePageVC:(NSIndexPath *)indexPath
{
    GLPShoppingCarModel *carModel = self.dataArray[(self.isOtc ? indexPath.section-2 : indexPath.section-1)];
    
    TRStorePageVC *vc = [TRStorePageVC new];
    vc.firmId = [NSString stringWithFormat:@"%ld",carModel.sellerFirmId];
    [self dc_pushNextController:vc];
}


- (void)pushMineTicketController:(NSIndexPath *)indexPath
{
    NSInteger section = (self.isOtc ? indexPath.section-2 : indexPath.section-1);
    // 已选中的券id
    NSMutableArray *selectTicketArray = [NSMutableArray array];
    for (int i=0; i<self.dataArray.count; i++) {
        GLPShoppingCarModel *carModel = self.dataArray[i];
        
        if (carModel.ticketArray && carModel.ticketArray.count > 0) {
            [selectTicketArray addObjectsFromArray:carModel.ticketArray];
        }
    }
    
    WEAKSELF;
    GLPTicketSelectController *vc = [GLPTicketSelectController new];
    vc.selectTicketArray = selectTicketArray;
    vc.carModel = self.dataArray[section];
    vc.ispay = self.ispay;
    vc.goodsId = self.goodsId;
    vc.quanlity = self.quanlity;
    vc.ticketClickBlock = ^(NSMutableArray *ticketArray) {
        
        GLPShoppingCarModel *carModel = weakSelf.dataArray[section];
        carModel.ticketArray = ticketArray;
        
        [weakSelf.dataArray replaceObjectAtIndex:section withObject:carModel];
        [weakSelf.tableView reloadData];
        weakSelf.bottomView.dataArray = weakSelf.dataArray;
    };
    [self dc_pushNextController:vc];
}



#pragma mark - 刷新运费信息
- (void)uploadYunfeiInfo
{
    // 先将运费归0
    for (int i=0; i<self.dataArray.count; i++) {
        GLPShoppingCarModel *carModel = self.dataArray[i];
        carModel.yufei = 0;
        [self.dataArray replaceObjectAtIndex:i withObject:carModel];
    }
    
    WEAKSELF;
    dispatch_group_t group = dispatch_group_create();
    
    
    for (int i=0; i<self.dataArray.count; i++) {
        
        NSString *cardIds = @"";
        NSString *goodsId = @"";
        NSString *quanlity = @"";
        NSString *logisticsTplId = @"";
        GLPShoppingCarModel *carModel = self.dataArray[i];
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            for (int j = 0; j<carModel.validActInfoList.count; j++) {
                GLPShoppingCarActivityModel *activityModel = carModel.validActInfoList[j];
                if (activityModel.actCartGoodsList && activityModel.actCartGoodsList.count > 0) {
                    for (int k = 0; k<activityModel.actCartGoodsList.count; k++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = activityModel.actCartGoodsList[k];
                        
                        if (goodsModel.isSelected && goodsModel.logisticsTplId != 0) {
                            
                            if (cardIds.length == 0) {
                                cardIds = [NSString stringWithFormat:@"%ld",goodsModel.cartId];
                                goodsId = [NSString stringWithFormat:@"%@",goodsModel.goodsId];
                                quanlity = [NSString stringWithFormat:@"%ld",(long)goodsModel.quantity];
                                logisticsTplId = [NSString stringWithFormat:@"%ld",(long)goodsModel.logisticsTplId];
                            } else {
                                cardIds = [NSString stringWithFormat:@"%@,%ld",cardIds,goodsModel.cartId];
                                goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
                                quanlity = [NSString stringWithFormat:@"%@,%ld",quanlity,goodsModel.quantity];
                                logisticsTplId = [NSString stringWithFormat:@"%@,%ld",logisticsTplId,goodsModel.logisticsTplId];
                            }
                        }
                    }
                }
            }
        }
        
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            for (int z =0; z<carModel.validNoActGoodsList.count; z++) {
                GLPShoppingCarNoActivityModel *noActModel = carModel.validNoActGoodsList[z];
                if (noActModel.isSelected && noActModel.logisticsTplId != 0) {
                    
                    if (cardIds.length == 0) {
                        cardIds = [NSString stringWithFormat:@"%ld",noActModel.cartId];
                        goodsId = [NSString stringWithFormat:@"%@",noActModel.goodsId];
                        quanlity = [NSString stringWithFormat:@"%ld",(long)noActModel.quantity];
                        logisticsTplId = [NSString stringWithFormat:@"%ld",(long)noActModel.logisticsTplId];
                    } else {
                        cardIds = [NSString stringWithFormat:@"%@,%ld",cardIds,noActModel.cartId];
                        goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,noActModel.goodsId];
                        quanlity = [NSString stringWithFormat:@"%@,%ld",quanlity,noActModel.quantity];
                        logisticsTplId = [NSString stringWithFormat:@"%@,%ld",logisticsTplId,noActModel.logisticsTplId];
                    }
                }
            }
        }
        if ([self.ispay isEqualToString:@"1"])
        {
            if (goodsId.length>0&&quanlity.length>0&&quanlity.length>0&&logisticsTplId.length>0&&self.addressModel.areaId.length>0)
            {
                dispatch_group_enter(group);
                [[DCAPIManager shareManager]person_getAddressMoenywithgoodsId:goodsId quantity:quanlity areaId:self.addressModel.areaId logisticsTplId:logisticsTplId success:^(id response) {
                    dispatch_group_leave(group);
                    NSDictionary *dict = response;
                    if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
                        if (dict[@"data"]) {
                            GLPShoppingCarModel *carModel = weakSelf.dataArray[i];
                            carModel.yufei = [dict[@"data"][@"express"][@"value"] floatValue];
                            [weakSelf.dataArray replaceObjectAtIndex:i withObject:carModel];
                        }
                    }
                } failture:^(NSError *error) {
                    
                }];
            }
        }
        else{
            if (cardIds.length > 0) {
                dispatch_group_enter(group);
                NSString *sellerFirmId = [NSString stringWithFormat:@"%ld",carModel.sellerFirmId];
                [self requestYunfeiInfoWidthCartIds:cardIds sellerFirmId:sellerFirmId index:i block:^{
                    dispatch_group_leave(group);
                }];
            }
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
        weakSelf.bottomView.dataArray = weakSelf.dataArray;
    });
}


#pragma mark - 请求 获取默认收货地址
- (void)requestDefaultAddress
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_GetDefautAddresssuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = response;
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                GLPGoodsAddressModel *addressModel = [GLPGoodsAddressModel mj_objectWithKeyValues:dict[@"data"]];
                if (addressModel) {
                    weakSelf.addressModel = addressModel;
                    [weakSelf.tableView reloadData];
                    weakSelf.bottomView.dataArray = weakSelf.dataArray;
                    
                    if (weakSelf.addressModel && weakSelf.addressModel.areaId) {
                        [weakSelf uploadYunfeiInfo];
                    }
                }
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


//#pragma mark - 请求 获取运费
//- (void)requestYunfeiInfoWidthGoodsId:(NSString *)goodsId logisticsTplId:(NSInteger)logisticsTplId quantity:(NSInteger)quantity index:(NSInteger)index block:(dispatch_block_t)block
//{
//    NSString *areaId = @"";
//    if (self.addressModel && self.addressModel.areaId) {
//        areaId = self.addressModel.areaId;
//    }
//
//    person_requestShoppingCarYunfeiWithAreaId
//    WEAKSELF;
//    [[DCAPIManager shareManager] person_requestGoodsDetailsDefaultAddressWithAreaId:areaId goodsId:goodsId logisticsTplId:logisticsTplId quantity:quantity success:^(id response) {
//        if (response && [response isKindOfClass:[GLPGoodsAddressModel class]]) {
//            GLPGoodsAddressModel *model = response;
//
//            GLPShoppingCarModel *carModel = weakSelf.dataArray[index];
//            carModel.yufei += [model.express.value floatValue];
//            [weakSelf.dataArray replaceObjectAtIndex:index withObject:carModel];
//        }
//        block();
//
//    } failture:^(NSError *error) {
//        block();
//    }];
//}


#pragma mark - 请求 获取运费
- (void)requestYunfeiInfoWidthCartIds:(NSString *)cartIds sellerFirmId:(NSString *)sellerFirmId index:(NSInteger)index block:(dispatch_block_t)block
{
    NSString *areaId = @"";
    if (self.addressModel && self.addressModel.areaId) {
        areaId = self.addressModel.areaId;
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestShoppingCarYunfeiWithAreaId:areaId cartIds:cartIds sellerFirmId:sellerFirmId success:^(id response) {
        
        NSDictionary *dict = response;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"]) {
                GLPShoppingCarModel *carModel = weakSelf.dataArray[index];
                carModel.yufei = [dict[@"data"] floatValue];
                [weakSelf.dataArray replaceObjectAtIndex:index withObject:carModel];
            }
        }
        block();
    } failture:^(NSError *error) {
        block();
    }];
}


#pragma mark - 请求 获取默认券信息
- (void)requestApplyOrderTicket
{
    // 购物车id
    NSString *cardIds = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        GLPShoppingCarModel *carModel = self.dataArray[i];
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            for (int j = 0; j<carModel.validActInfoList.count; j++) {
                GLPShoppingCarActivityModel *activityModel = carModel.validActInfoList[j];
                if (activityModel.actCartGoodsList && activityModel.actCartGoodsList.count > 0) {
                    for (int k = 0; k<activityModel.actCartGoodsList.count; k++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = activityModel.actCartGoodsList[k];
                        
                        if (goodsModel.isSelected) {
                            
                            if (cardIds.length == 0) {
                                cardIds = [NSString stringWithFormat:@"%ld",goodsModel.cartId];
                            } else {
                                cardIds = [NSString stringWithFormat:@"%@,%ld",cardIds,goodsModel.cartId];
                            }
                        }
                    }
                }
            }
        }
        
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            for (int z =0; z<carModel.validNoActGoodsList.count; z++) {
                GLPShoppingCarNoActivityModel *noActModel = carModel.validNoActGoodsList[z];
                if (noActModel.isSelected) {
                    
                    if (cardIds.length == 0) {
                        cardIds = [NSString stringWithFormat:@"%ld",noActModel.cartId];
                    } else {
                        cardIds = [NSString stringWithFormat:@"%@,%ld",cardIds,noActModel.cartId];
                    }
                }
            }
        }
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestCartNotarizeWithCartIds:cardIds success:^(id response) {
        if (response[@"data"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = response[@"data"];
            if (dataDict[@"sellerFirmList"] && [dataDict[@"sellerFirmList"] isKindOfClass:[NSArray class]]) {
                NSArray *array = dataDict[@"sellerFirmList"];
                
                // 乱七八糟
                for (int i= 0; i<weakSelf.dataArray.count; i++) {
                    GLPShoppingCarModel *carModel = weakSelf.dataArray[i];
                    for (int j = 0; j<array.count; j++) {
                        NSDictionary *shopModel = array[j];
                        
                        if (shopModel && shopModel[@"sellerFirmId"] && [shopModel[@"sellerFirmId"] integerValue] == carModel.sellerFirmId) {
                            // 神秘操作
                            carModel.couponsDiscount = [shopModel[@"couponsDiscount"] floatValue];
                            carModel.couponsId = shopModel[@"couponsId"];
                            carModel.couponsClass = [shopModel[@"couponsClass"] floatValue];
                            
                            NSMutableArray *couponArray = [NSMutableArray array];
                            NSString *couponsId = shopModel[@"couponsId"];
                            if (couponsId && couponsId.length > 0) {
                                if ([couponsId containsString:@","]) {
                                    NSArray *coupons = [couponsId componentsSeparatedByString:@","];
                                    for (int kkk = 0; kkk < coupons.count; kkk++) {
                                        GLPNewTicketModel *ticketModel = [[GLPNewTicketModel alloc] init];
                                        ticketModel.couponsId = [coupons[kkk] integerValue];
                                        [couponArray addObject:ticketModel];
                                    }
                                } else {
                                    GLPNewTicketModel *ticketModel = [[GLPNewTicketModel alloc] init];
                                    ticketModel.couponsId = [couponsId integerValue];
                                    [couponArray addObject:ticketModel];
                                }
                            }
                            if ([couponArray count] > 0) {
                                carModel.ticketArray = couponArray;
                            }
                            
                            //                            [weakSelf.selectTicketArray addObjectsFromArray:couponArray];
                            
                            [weakSelf.dataArray replaceObjectAtIndex:i withObject:carModel];
                        }
                    }
                }
            }
        }
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        
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
    
    [self.tableView registerClass:NSClassFromString(noAddressCellID) forCellReuseIdentifier:noAddressCellID];
    [self.tableView registerClass:NSClassFromString(addressCellID) forCellReuseIdentifier:addressCellID];
    [self.tableView registerClass:NSClassFromString(storeCellID) forCellReuseIdentifier:storeCellID];
    [self.tableView registerClass:NSClassFromString(totalCellID) forCellReuseIdentifier:totalCellID];
    [self.tableView registerClass:NSClassFromString(GLPApplyOTCInfoCellID) forCellReuseIdentifier:GLPApplyOTCInfoCellID];
}


#pragma mark - lazy load
- (GLPApplyBottomView *)bottomView{
    if (!_bottomView) {
        
        CGFloat height = kStatusBarHeight > 20 ? 90 : 56;
        
        _bottomView = [[GLPApplyBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - height, kScreenW, height)];
        WEAKSELF;
        _bottomView.payBtnBlock = ^{
            [weakSelf dc_payBtnClick];
        };
    }
    return _bottomView;
}


- (NSMutableArray<GLPShoppingCarModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    }
    return _infoModel;
}

#pragma mark - setter
- (void)setShoppingcarArray:(NSMutableArray<GLPShoppingCarModel *> *)shoppingcarArray{
    _shoppingcarArray = shoppingcarArray;
    
}

@end
