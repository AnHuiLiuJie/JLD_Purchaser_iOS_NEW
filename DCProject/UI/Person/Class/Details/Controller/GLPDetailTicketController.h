//
//  GLPDetailTicketController.h
//  DCProject
//
//  Created by bigbing on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLPGoodsDetailModel.h"

typedef NS_ENUM(NSInteger , GLPTicketType) {
    GLPTicketTypeWithGoods = 0, // 商品券
    GLPTicketTypeWithStore,     // 店铺券
};

NS_ASSUME_NONNULL_BEGIN

@interface GLPDetailTicketController : DCBasicViewController

// 详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;

// 券类型
@property (nonatomic, assign) GLPTicketType ticketType;

@end

NS_ASSUME_NONNULL_END
