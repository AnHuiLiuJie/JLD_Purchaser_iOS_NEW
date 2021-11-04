//
//  GLBOrderSuccessModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBOrderSuccessModel : NSObject

@property (nonatomic, assign) NSInteger orderNo; // 订单编码
@property (nonatomic, assign) CGFloat paymentAmount; // 实付金额
@property (nonatomic, copy) NSString *repayment; // 账期信息
@property (nonatomic, copy) NSString *tradeType; // 交易方式

@end

NS_ASSUME_NONNULL_END
