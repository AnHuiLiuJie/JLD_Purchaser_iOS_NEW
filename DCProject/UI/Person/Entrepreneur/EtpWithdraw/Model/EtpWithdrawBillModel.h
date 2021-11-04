//
//  EtpWithdrawBillModel.h
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "DCBaseModel.h"
#import "PioneerServiceFeeModel.h"
NS_ASSUME_NONNULL_BEGIN



#pragma EtpWithdrawBillListModel

@interface EtpBillListModel : DCBaseModel


@property (nonatomic, copy) NSString *billId;//账单ID
@property (nonatomic, copy) NSString *billMonth;//账单月份，显示年月格式，如：2020-02
@property (nonatomic, copy) NSString *extendAmount;//推广金额
@property (nonatomic, copy) NSString *incomeAmount;//收入金额
@property (nonatomic, copy) NSString *month;//月份，只显示月份，如：2月
@property (nonatomic, copy) NSString *taxAmount;//个税金额
@property (nonatomic, copy) NSString *userId;//用户ID

@end


#pragma EtpOrderListModel

@interface EtpOrderListModel : DCBaseModel

@property (nonatomic, copy) NSArray *orderList;//订单列表
@property (nonatomic, copy) NSString *settleDate;//结算日期
@property (nonatomic, copy) NSString *settleDateId;//结算日期ID
@property (nonatomic, copy) NSString *totalExtendAmount;//推广总金额

@end

#pragma EtpOrderPageListModel

@interface EtpOrderPageListModel : DCBaseModel


@property (nonatomic, copy) NSString *custType;//客源类型
@property (nonatomic, copy) NSString *extendAmount;//推广金额
@property (nonatomic, copy) NSString *extendLevel;//推广级别，客源类型
@property (nonatomic, copy) NSString *goodsCount;//商品数量
@property (nonatomic, copy) NSArray *goodsList;//商品列表 === PioneerServiceFeeModel
@property (nonatomic, copy) NSString *orderAmount;//订单金额
@property (nonatomic, copy) NSString *orderNo;//订单编号
@property (nonatomic, copy) NSString *orderState;//订单状态
@property (nonatomic, copy) NSString *orderStateStr;//订单状态字符串
@property (nonatomic, copy) NSString *orderTime;//下单时间
@property (nonatomic, copy) NSString *settleDate;//结算日期
@property (nonatomic, copy) NSString *settleState;//结算状态 6成功 7 失败 其他
@property (nonatomic, copy) NSString *settleStateStr;//结算状态字符串

@end


#pragma make EtpWithdrawBillModel
@interface EtpWithdrawBillModel : DCBaseModel

@property (nonatomic, strong) CommonListModel *orderDateList;
@property (nonatomic, strong) EtpBillListModel *billVo;//账单VO
@property (nonatomic, copy) NSArray *dateList;//结算日期列表


@end



NS_ASSUME_NONNULL_END
