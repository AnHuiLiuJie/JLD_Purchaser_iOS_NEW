//
//  GLBStoreTicketModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreTicketModel : NSObject

@property (nonatomic, assign) NSInteger cashCouponId;//现金劵ID
@property (nonatomic, assign) CGFloat discountAmount;//优惠金额
@property (nonatomic, copy) NSString *endTime;//使用结束时间
@property (nonatomic, assign) NSInteger receive; // 是否被领取，1-已领取；2-未领取
@property (nonatomic, assign) CGFloat requireAmount;//金额要求
@property (nonatomic, copy) NSString *startTime;//使用开始时间
@property (nonatomic, assign) NSInteger suppierFirmId;//归属供应商

@end

NS_ASSUME_NONNULL_END
