//
//  GLBShoppingCarCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBShoppingCarModel.h"
#import "GLBShoppingCarGoodsCell.h"

typedef void(^GLBShoppingCarCountViewBlock)(GLBEditCountView *_Nullable countView,NSInteger type,NSInteger index);
typedef void(^GLBCarCellEditBlock)(GLBShoppingCarModel *_Nullable shoppingCarModel);
typedef void(^GLBCarGoodsBlock)(GLBShoppingCarGoodsModel *_Nullable goodsModel);

NS_ASSUME_NONNULL_BEGIN

@interface GLBShoppingCarCell : UITableViewCell

// 购物车模型
@property (nonatomic, strong) GLBShoppingCarModel *shoppingCarModel;

// 刷新
@property (nonatomic, copy) dispatch_block_t  reloadBlock;

// 点击领券
@property (nonatomic, copy) dispatch_block_t  ticketBtnBlock;

// 改变数量回调
@property (nonatomic, copy) GLBShoppingCarCountViewBlock countViewBlock;

// 选择按钮点击回调
@property (nonatomic, copy) GLBCarCellEditBlock cellEditBlock;

// 点击购物车商品
@property (nonatomic, copy) GLBCarGoodsBlock carGoodsBlock;

@end

NS_ASSUME_NONNULL_END
