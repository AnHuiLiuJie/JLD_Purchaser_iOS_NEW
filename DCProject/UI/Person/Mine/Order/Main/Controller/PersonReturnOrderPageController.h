//
//  GLBOrderPageController.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonReturnOrderPageController : WMPageController


@property (nonatomic, assign) int index;

@property (nonatomic, copy) NSString *orderNo_str; // 订单号

@end

NS_ASSUME_NONNULL_END
