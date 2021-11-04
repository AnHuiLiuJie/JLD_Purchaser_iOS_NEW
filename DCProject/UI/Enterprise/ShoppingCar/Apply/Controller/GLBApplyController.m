//
//  GLBApplyController.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBApplyController.h"

#import "GLBApplyStoreCell.h"
#import "GLBApplyTotalCell.h"
#import "GLBAddressListCell.h"
#import "GLBSelectAddressCell.h"
#import "GLBApplyBottomView.h"
#import "GLBRepayTimeView.h"

#import "DCAlterView.h"

#import "GLBAddressModel.h"
#import "GLBRepayInfoModel.h"

#import "GLBApplyGoodsController.h"
#import "GLBMineTicketController.h"
#import "GLBAddressListController.h"
#import "GLBApplySuccessController.h"

static NSString *const storeCellID = @"GLBApplyStoreCell";
static NSString *const totalCellID = @"GLBApplyTotalCell";
static NSString *const addressCellID = @"GLBAddressListCell";
static NSString *const noAddressCellID = @"GLBSelectAddressCell";

@interface GLBApplyController ()

@property (nonatomic, strong) GLBApplyBottomView *bottomView;

// 
@property (nonatomic, strong) NSMutableArray<GLBShoppingCarModel *> *dataArray;
// 地址模型
@property (nonatomic, strong) GLBAddressModel *addressModel;
// 选中的券模型
@property (nonatomic, strong) NSMutableArray *selectTicketArray;

@end


@implementation GLBApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认订单";
    
    [self setUpTableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    [self requestDefaultAddress];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count + 2;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        if (_addressModel) {
            GLBAddressListCell *addressCell = [tableView dequeueReusableCellWithIdentifier:addressCellID forIndexPath:indexPath];
            addressCell.orderAddressModel = self.addressModel;
            cell = addressCell;
        } else {
            GLBSelectAddressCell *selectCell = [tableView dequeueReusableCellWithIdentifier:noAddressCellID forIndexPath:indexPath];
            cell = selectCell;
        }
        
    } else if (indexPath.section == tableView.numberOfSections - 1) {
        
        GLBApplyTotalCell *totalCell = [tableView dequeueReusableCellWithIdentifier:totalCellID forIndexPath:indexPath];
        totalCell.dataArray = self.dataArray;
        cell = totalCell;
        
    } else {
        
        WEAKSELF;
        GLBApplyStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:storeCellID forIndexPath:indexPath];
        storeCell.carModel = self.dataArray[indexPath.section - 1];
        storeCell.yunfeiBlock = ^{
            NSLog(@"跳转 - h5");
        };
        storeCell.goodsBlock = ^{
            [weakSelf pushApplyGoodsController:indexPath];
        };
        storeCell.discountBlock = ^{
            [weakSelf pushMineTicketController:indexPath];
        };
        storeCell.typeBlock = ^{
            [weakSelf dc_pushWebController:@"/public/transact.html" params:nil];
        };
        storeCell.typeBtnBlock = ^(NSInteger tag) {
            
            if (tag == 2) {
                
                DCAlterView *alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"您是否确定向供应商申请账期支付交易申请,申请通过后，您将获得一定的信用额度，并且无利息的哟。可下次交易时，先货后款，大大提高您的资金周转"];
                [alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
                [alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
                    [weakSelf requestIsRepayInfo:indexPath];
                }];
                
                [DC_KeyWindow addSubview:alterView];
                [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(DC_KeyWindow);
                }];
                
                
            } else {
                GLBShoppingCarModel *model = weakSelf.dataArray[indexPath.section - 1];
                model.payType = tag;
                [weakSelf.dataArray replaceObjectAtIndex:indexPath.section - 1 withObject:model];
                [weakSelf.tableView reloadData];
            }
        };
        cell = storeCell;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WEAKSELF;
        GLBAddressListController *vc = [GLBAddressListController new];
        vc.selectedBlock = ^(GLBAddressModel *addressModel) {
            weakSelf.addressModel = addressModel;
            [weakSelf.tableView reloadData];
        };
        [self dc_pushNextController:vc];
    }
}


#pragma mark - action
- (void)dc_completeBtnClick
{
    if (!self.addressModel) {
        [SVProgressHUD showInfoWithStatus:@"请选择收货地址"];
        return;
    }
    
    NSString *cartIds = @"";
    NSString *couponsIds = @"";
    NSMutableArray *cartTradeInfoDTO = [NSMutableArray array];
    for (int i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarModel *carModel = self.dataArray[i];
        
        for (int j=0; j<carModel.cartGoodsList.count; j++) {
            GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[j];
            
            if (cartIds.length == 0) {
                cartIds = [NSString stringWithFormat:@"%ld",(long)goodsModel.cartId];
            } else {
                cartIds = [NSString stringWithFormat:@"%@,%ld",cartIds,(long)goodsModel.cartId];
            }
        }
        
        if (carModel.ticketModel) {
            if (couponsIds.length == 0) {
                couponsIds = [NSString stringWithFormat:@"%ld",carModel.ticketModel.cashCouponId];
            } else {
                couponsIds = [NSString stringWithFormat:@"%@,%ld",couponsIds,carModel.ticketModel.cashCouponId];
            }
        }
        
        GLBApplyStoreCell *cell = (GLBApplyStoreCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i+1]];
        NSString *leaveMsg = cell.textView.text;
        
        NSString *tradeType = @"";
        if (carModel.payType == 0) { // 担保支付
            tradeType = @"1";
        } else if (carModel.payType == 1) { // 预付款
            tradeType = @"3";
        } else if (carModel.payType == 2) { // 账期
            tradeType = @"2";
        }
        
        NSDictionary *dict = @{@"leaveMsg":leaveMsg ? leaveMsg : @"",
                                @"repatmentEndDate":carModel.payType == 2 ? @(carModel.repatmentEndDate) : @"",
                                @"supFirmId":carModel.suppierFirmId,
                                @"tradeType":tradeType
                                };
        
        [cartTradeInfoDTO addObject:dict];
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestShoppingCarSubmitWithAddressId:self.addressModel.addrId couponsIds:couponsIds cartIds:cartIds cartTradeInfoDTO:cartTradeInfoDTO success:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = response[@"data"];
            if (dict[@"payStatus"] && [dict[@"payStatus"] boolValue]) {

                GLBApplySuccessController *vc = [GLBApplySuccessController new];
                vc.order = dict[@"orderNos"] ? dict[@"orderNos"] : @"";
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
    
}


#pragma mark - 界面跳转
- (void)pushApplyGoodsController:(NSIndexPath *)indexPath
{
    GLBApplyGoodsController *vc = [GLBApplyGoodsController new];
    vc.carModel = self.dataArray[indexPath.section - 1];
    [self dc_pushNextController:vc];
}

- (void)pushMineTicketController:(NSIndexPath *)indexPath
{
    WEAKSELF;
    GLBMineTicketController *vc = [GLBMineTicketController new];
    vc.selectTicketArray = self.selectTicketArray;
    vc.carModel = self.dataArray[indexPath.section - 1];
    vc.ticketClickBlock = ^(GLBMineTicketCouponsModel *ticketModel) {
        GLBShoppingCarModel *carModel = weakSelf.dataArray[indexPath.section - 1];
        if (carModel.ticketModel) { //当前选择券了
            
            GLBMineTicketCouponsModel *selectTicketModel = nil;
            for (int i=0; i<weakSelf.selectTicketArray.count > 0;  i++) {
                GLBMineTicketCouponsModel *ticketModel = weakSelf.selectTicketArray[i];
                if (ticketModel.cashCouponId == carModel.ticketModel.cashCouponId) {
                    selectTicketModel = ticketModel;
                }
            }
            
            if (selectTicketModel) {
                [weakSelf.selectTicketArray removeObject:selectTicketModel];
            }
            
            if (carModel.ticketModel.cashCouponId == ticketModel.cashCouponId) {
                carModel.ticketModel = nil;
            } else {
                [weakSelf.selectTicketArray addObject:ticketModel];
                carModel.ticketModel = ticketModel;
            }
            
//            [weakSelf.selectTicketArray addObject:ticketModel];
//            carModel.ticketModel = ticketModel;
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section - 1 withObject:carModel];
            [weakSelf.tableView reloadData];
            weakSelf.bottomView.dataArray = weakSelf.dataArray;
            
        } else { // 未选择券
            
            [weakSelf.selectTicketArray addObject:ticketModel];
            carModel.ticketModel = ticketModel;
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section - 1 withObject:carModel];
            [weakSelf.tableView reloadData];
            weakSelf.bottomView.dataArray = weakSelf.dataArray;
        }
        
    };
    [self dc_pushNextController:vc];
}


#pragma mark - 请求 是否存在账期关系
- (void)requestIsRepayInfo:(NSIndexPath *)indexPath
{
    GLBShoppingCarModel *carModel = self.dataArray[indexPath.section - 1];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestIsRepayInfoWithSuppierFirmId:[carModel.suppierFirmId integerValue] success:^(id response) {
        if (response && [response isKindOfClass:[GLBRepayInfoModel class]]) {
            GLBRepayInfoModel *infoModel = response;
            
            if (infoModel.periodState == 0) {
                [weakSelf requestApplyRepay:[carModel.suppierFirmId integerValue]];
            } else if (infoModel.periodState == 1) {
                [SVProgressHUD showInfoWithStatus:@"您已申请账期支付交易授权，请耐心等待"];
            } else if (infoModel.periodState == 2) {
                [SVProgressHUD showInfoWithStatus:@"您账期支付交易授权已被供应商停用，请联系供应商"];
            } else if (infoModel.periodState == 3) {
                // 可以使用账期支付
                
                GLBShoppingCarModel *carModel = weakSelf.dataArray[indexPath.section - 1];
                CGFloat allMoney = 0;
                if (carModel.cartGoodsList && [carModel.cartGoodsList count] > 0) {
                    for (int i=0; i<carModel.cartGoodsList.count; i++) {
                        GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[i];
                        allMoney += (goodsModel.price *goodsModel.quantity);
                    }
                }
                
                if (allMoney > infoModel.accountPeriodLimit) { // 超出额度
                    [SVProgressHUD showInfoWithStatus:@"授信额度不足，请选择其他交易方式"];
                } else { // 正常使用
                    
                    GLBRepayTimeView *view = [[GLBRepayTimeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    view.maxCount = infoModel.paymentTerm;
                    view.successBlock = ^(NSInteger day) {
                        
                        GLBShoppingCarModel *carModel = weakSelf.dataArray[indexPath.section - 1];
                        carModel.payType = 2;
                        carModel.repatmentEndDate = day;
                        [weakSelf.dataArray replaceObjectAtIndex:indexPath.section - 1 withObject:carModel];
                        [weakSelf.tableView reloadData];
                        
                    };
                    [DC_KeyWindow addSubview:view];
                }
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 申请账期支付
- (void)requestApplyRepay:(NSInteger)suppierFirmId
{
    [[DCAPIManager shareManager] dc_requestApplyRepayWithSuppierFirmId:suppierFirmId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 默认收货地址
- (void)requestDefaultAddress
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDefautAddresssuccess:^(id response) {
        if (response && [response isKindOfClass:[GLBAddressModel class]]) {
            weakSelf.addressModel = response;
            
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(10, kNavBarHeight, kScreenW - 20, kScreenH - kNavBarHeight - 50 - 10);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(addressCellID) forCellReuseIdentifier:addressCellID];
    [self.tableView registerClass:NSClassFromString(totalCellID) forCellReuseIdentifier:totalCellID];
    [self.tableView registerClass:NSClassFromString(storeCellID) forCellReuseIdentifier:storeCellID];
    [self.tableView registerClass:NSClassFromString(noAddressCellID) forCellReuseIdentifier:noAddressCellID];
}


#pragma mark - lazy load
- (GLBApplyBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GLBApplyBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
        WEAKSELF;
        _bottomView.completeBlock = ^{
            [weakSelf dc_completeBtnClick];
        };
    }
    return _bottomView;
}

- (NSMutableArray<GLBShoppingCarModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)selectTicketArray{
    if (!_selectTicketArray) {
        _selectTicketArray = [NSMutableArray array];
    }
    return _selectTicketArray;
}


#pragma mark - setter
- (void)setListArray:(NSMutableArray<GLBShoppingCarModel *> *)listArray
{
    _listArray = listArray;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_listArray];
    
    self.bottomView.dataArray = self.dataArray;
}


@end
