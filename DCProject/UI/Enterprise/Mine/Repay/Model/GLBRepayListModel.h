//
//  GLBRepayListModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayListModel : NSObject

@property (nonatomic, assign) CGFloat accountPeriodAmount; // 账期金额
@property (nonatomic, assign) NSInteger accountPeriodNo; // 账期编码
@property (nonatomic, copy) NSString *canApplyDelay; // 是否允许逾期申请：1-是；2-否（条件：1、状态处于代还款或者还款中，2、还款截止日期前一周可以申请延期付款；3、申请记录数未超过系统设定）
@property (nonatomic, strong) NSArray *delays; // 延期申请列表
@property (nonatomic, assign) CGFloat hasPaymentAmount; // 已还金额
@property (nonatomic, copy) NSString *orderFinishTime; // 订单完成时间
@property (nonatomic, assign) NSInteger orderNo; // 订单号
@property (nonatomic, assign) CGFloat paymentAmount; // 未还款金额
@property (nonatomic, assign) NSInteger paymentType; // 还款类型：0-未指定；1-按金额还款；2-按已购买商品还款
@property (nonatomic, assign) NSInteger periodState; // 账期状态：1-在途；2-待还款；3-还款中；4-已还款；5-逾期还款结束
@property (nonatomic, copy) NSString *repaymentEndDate; // 还款截止日期
@property (nonatomic, copy) NSString *suppierFirmName; // 供应商企业名称

@end


#pragma mark - 历史
@interface GLBRepayListDelayModel : NSObject

@property (nonatomic, copy) NSString *auditReason; // 审核结果说明
@property (nonatomic, copy) NSString *auditState; // 审核结果
@property (nonatomic, copy) NSString *days; // 延期天数
@property (nonatomic, copy) NSString *paymentEndDate; // 延期还款日期
@property (nonatomic, copy) NSString *reason; // 延期还款原因

@end

NS_ASSUME_NONNULL_END
