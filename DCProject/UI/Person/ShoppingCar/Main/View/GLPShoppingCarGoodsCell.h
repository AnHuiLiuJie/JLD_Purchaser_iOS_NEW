//
//  GLPShoppingCarGoodsCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPEditCountView.h"
#import "GLPNewShoppingCarModel.h"

typedef void(^GLPShoppingCarGoodsCellBlock)(BOOL isSelcted);

NS_ASSUME_NONNULL_BEGIN

@interface GLPShoppingCarGoodsCell : UITableViewCell

// 数量
@property (nonatomic, strong) GLPEditCountView *countView;


// 活动商品详情
@property (nonatomic, strong) GLPNewShopCarGoodsModel *actGoodsModel;


// 非活动商品详情
@property (nonatomic, strong) GLPNewShopCarGoodsModel *noActGoodsModel;


// 点击选择按钮
@property (nonatomic, copy) GLPShoppingCarGoodsCellBlock goodsCellBlock;

@end

NS_ASSUME_NONNULL_END
