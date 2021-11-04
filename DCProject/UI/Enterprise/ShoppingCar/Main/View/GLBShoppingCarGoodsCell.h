//
//  GLBShoppingCarGoodsCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBEditCountView.h"
#import "GLBShoppingCarModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^GLBCarGoodsCellBlock)(GLBShoppingCarGoodsModel *_Nullable goodsModel);

@interface GLBShoppingCarGoodsCell : UITableViewCell

// 商品模型
@property (nonatomic, strong) GLBShoppingCarGoodsModel *goodsModel;

// 数量
@property (nonatomic, strong) GLBEditCountView *countView;


// 选择商品回调
@property (nonatomic, copy) GLBCarGoodsCellBlock goodsCellBlock;

@end

NS_ASSUME_NONNULL_END
