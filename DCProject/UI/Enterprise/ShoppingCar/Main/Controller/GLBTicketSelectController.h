//
//  GLBTicketSelectController.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

typedef NS_ENUM(NSInteger ,GLBTicketType) {
    GLBTicketTypeGoods = 0, // 商品专享券
    GLBTicketTypeStore,     // 店铺券
    GLBTicketTypeComment,   // 平台券、通用券
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBTicketSelectController : DCBasicViewController

// 券类型
@property (nonatomic, assign) GLBTicketType ticketType;

// 商品id
@property (nonatomic, copy) NSString *goodsId;

// 店铺id
@property (nonatomic, copy) NSString *storeId;


@end

NS_ASSUME_NONNULL_END
