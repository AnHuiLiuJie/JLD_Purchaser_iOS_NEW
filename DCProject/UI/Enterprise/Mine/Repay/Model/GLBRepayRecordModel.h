//
//  GLBRepayRecordModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayRecordModel : NSObject

@property (nonatomic, assign) CGFloat accountPeriodAmount; // 账期金额
@property (nonatomic, assign) CGFloat hasPaymentAmount; // 已还金额
@property (nonatomic, copy) NSString *isEnd; // 是否完成还款；1-是；2-否
@property (nonatomic, assign) CGFloat paymentAmount; // 未还款金额
@property (nonatomic, strong) NSArray *payments; // 还款记录

@end


#pragma mark - 还款记录
@interface GLBRepayRecordPaymentsModel : NSObject

@property (nonatomic, assign) CGFloat paymentAmount; // 还款金额
@property (nonatomic, copy) NSString *paymentTime; // 还款时间

@end

NS_ASSUME_NONNULL_END
