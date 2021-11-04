//
//  GLPTicketSelectModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPTicketSelectModel : NSObject

@property (nonatomic, strong) NSArray *coupons; // 店铺券/平台券集合
@property (nonatomic, copy) NSString *couponsClass;
@property (nonatomic, strong) NSArray *couponsGoods; // 商品券集合
@property (nonatomic, copy) NSString *firmId; // 供应商标识
@property (nonatomic, copy) NSString *firmName; // 供应商名称
@property (nonatomic, copy) NSString *isConsume; // 是否已消费，0：已过期，1：未消费，2：已消费
@property (nonatomic, copy) NSString *logo; // 供应商店铺logo
@property (nonatomic, copy) NSString *storeName; // 供应商店铺

@end


#pragma mark - 券
@interface GLPTicketSelectTicketModel : NSObject

@property (nonatomic, assign) NSInteger couponsId; // 优惠券ID
@property (nonatomic, assign) NSInteger couponsType; // 优惠券类型，1：现金券，2：折扣券，3：包邮券
@property (nonatomic, copy) NSString *discountAmount; // 优惠金额
@property (nonatomic, copy) NSString *firmId; // 发行企业
@property (nonatomic, copy) NSString *goodsId; // 商品id
@property (nonatomic, copy) NSString *isReceive; // 是否领取 0：未领取，1：已领取

@property (nonatomic, copy) NSString *isconsume; // 是否消费1：未消费 2：已消费 3：已绑定4：已过期
@property (nonatomic, copy) NSString *requireAmount; // 金额要求
@property (nonatomic, copy) NSString *useEndDate; // 使用结束日期
@property (nonatomic, copy) NSString *useStartDate; // 使用开始日期
@property (nonatomic, copy) NSString *goodsImg1;// 商品图片
@property (nonatomic, copy) NSString *goodsName; // 商品名称

@property (nonatomic, strong) NSArray *goodsList; // 购物车中所适用的商品 无用，不做解析


@end

NS_ASSUME_NONNULL_END
