//
//  CouponsListModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponsListModel : NSObject
@property (nonatomic, copy) NSString *firmId; // 供应商标识
@property (nonatomic, copy) NSString *firmName; //供应商名称
@property (nonatomic, copy) NSString *storeName; // 供应商店铺
@property (nonatomic, copy) NSString *logo; //供应商店铺logo
@property (nonatomic, strong) NSArray *couponsGoods; // 商品券集合
@property (nonatomic, strong) NSArray *coupons; // 店铺券/平台券集合
@property (nonatomic, copy) NSString *couponsClass; //优惠券类型1：平台通用券 2：店铺通用券 3：商品通用券 0:全部
@property (nonatomic, copy) NSString *isConsume; // 是否已消费，0：已过期，1：未消费，2：已消费
@property (nonatomic, copy) NSString *isconsume; // 是否已消费，0：已过期，1：未消费，2：已消费

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
