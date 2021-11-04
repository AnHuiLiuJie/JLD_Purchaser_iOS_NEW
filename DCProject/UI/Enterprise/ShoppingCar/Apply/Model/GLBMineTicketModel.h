//
//  GLBMineTicketModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBMineTicketModel : NSObject

@property (nonatomic, assign) NSInteger firmId; // 供应商标识
@property (nonatomic, copy) NSString *firmName; // 供应商名称
@property (nonatomic, copy) NSString *logo; // 供应商店铺logo
@property (nonatomic, copy) NSString *storeName; // 供应商店铺
@property (nonatomic, strong) NSArray *coupons; // 优惠券列表

@end


@interface GLBMineTicketCouponsModel : NSObject

@property (nonatomic, assign) NSInteger cashCouponId; // 现金劵ID
@property (nonatomic, copy) NSString *couponType; // 优惠卷类型，1.单品优惠券；2.全场优惠券 3.平台券
@property (nonatomic, assign) CGFloat discountAmount; // 优惠金额
@property (nonatomic, copy) NSString *endTime; // 使用结束时间
@property (nonatomic, assign) NSInteger receive; // 是否被领取，1-已领取；2-未领取
@property (nonatomic, assign) CGFloat requireAmount; // 金额要求
@property (nonatomic, copy) NSString *startTime; // 使用开始时间
@property (nonatomic, assign) CGFloat suppierFirmId; // 归属供应商
@property (nonatomic, assign) NSInteger firmId; // 供应商标识
@property (nonatomic, copy) NSString *firmName; // 供应商名称
@property (nonatomic, copy) NSString *logo; // 供应商店铺logo
@property (nonatomic, copy) NSString *storeName; // 供应商店铺

@property (nonatomic, copy) NSString *batchId; // 1.单品优惠券-对应的产品批次编码
@property (nonatomic, copy) NSString *goodsId; // 1.单品优惠券-对应的产品编码

@end

NS_ASSUME_NONNULL_END
