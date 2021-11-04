//
//  GLBOrderPageController.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonOrderPageController : WMPageController


@property (nonatomic, assign) int index;


@property (nonatomic, assign) BOOL isPopView;


@property (nonatomic, copy) NSString *orderNo_str; // 订单号


@property (nonatomic, assign) BOOL isRefund;//YES 退款售后  NO我的订单

- (instancetype)initWithIsRefund:(BOOL)isRefund;

@end

NS_ASSUME_NONNULL_END
