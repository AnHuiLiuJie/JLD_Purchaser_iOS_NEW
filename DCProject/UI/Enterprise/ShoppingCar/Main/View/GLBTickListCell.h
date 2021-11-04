//
//  GLBTickListCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsTicketModel.h"
#import "GLBStoreTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBTickListCell : UITableViewCell

// 商品专享券
@property (nonatomic, strong) GLBGoodsTicketModel *goodsTicketModel;

// 店铺优惠券
@property (nonatomic, strong) GLBStoreTicketModel *storeTicketModel;

@end

NS_ASSUME_NONNULL_END
