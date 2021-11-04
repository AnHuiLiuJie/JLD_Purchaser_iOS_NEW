//
//  GLBMineTicketController.h
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBShoppingCarModel.h"
#import "GLBMineTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBTicketClickBlock)(GLBMineTicketCouponsModel *ticketModel);


@interface GLBMineTicketController : DCTabViewController

// 已选中的券
@property (nonatomic, strong) NSMutableArray *selectTicketArray;

// 购物车模型
@property (nonatomic, strong) GLBShoppingCarModel *carModel;

// 券点击
@property (nonatomic, copy) GLBTicketClickBlock ticketClickBlock;

@end

NS_ASSUME_NONNULL_END
