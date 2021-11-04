//
//  GLPOldShoppingCarCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPShoppingCarModel.h"
#import "GLPEditCountView.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLPShoppingCarCountViewBlock)(GLPEditCountView *_Nullable countView,NSInteger type,NSIndexPath *subIndexPath);

typedef void(^GLPShoppingCarEditBtnBlock)(GLPShoppingCarModel *newShoppingCarModel);

typedef void(^GLPShoppingCarGoodsBlock)(GLPShoppingCarNoActivityModel *_Nullable noActivityModel,GLPShoppingCarActivityGoodsModel *_Nullable activityGoodsModel);


@interface GLPOldShoppingCarCell : UITableViewCell

// 购物车模型
@property (nonatomic, strong) GLPShoppingCarModel *shoppingCarModel;

// 数量改变回调
@property (nonatomic, copy) GLPShoppingCarCountViewBlock countViewBlock;

// 点击编辑按钮回调
@property (nonatomic, copy) GLPShoppingCarEditBtnBlock editBtnBlock;

// 点击领券按钮回调
@property (nonatomic, copy) dispatch_block_t ticketBtnBlock;

// 点击店铺回调
@property (nonatomic, copy) dispatch_block_t shopNameClickBlock;

// 点击商品回调
@property (nonatomic, copy) GLPShoppingCarGoodsBlock goodsBlock;

@end

NS_ASSUME_NONNULL_END
