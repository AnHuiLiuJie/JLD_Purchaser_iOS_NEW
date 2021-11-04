//
//  CouponsModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponsModel : NSObject
@property (nonatomic, copy) NSString *couponsId; // 优惠券ID
@property (nonatomic, copy) NSString *couponsType; //优惠券类型1：平台通用券 2：店铺通用券 3：商品通用券 0:全部
@property (nonatomic, copy) NSString *discountAmount; // 优惠金额
@property (nonatomic, copy) NSString *isReceive; //是否领取 0：未领取，1：已领取
@property (nonatomic, copy) NSString *isconsume; // 是否已消费，0：已过期，1：未消费，2：已消费
@property (nonatomic, copy) NSString *requireAmount; // 金额要求
@property (nonatomic, copy) NSString *useEndDate; // 使用结束日期
@property (nonatomic, copy) NSString *useStartDate; // 使用开始日期
@property (nonatomic, copy) NSString *goodsImg1; // 商品图片
@property (nonatomic, copy) NSString *firmId; // 店铺id
@property (nonatomic, copy) NSString *goodsId; // 商品id
@property (nonatomic, copy) NSString *orderId; // 订单id
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
