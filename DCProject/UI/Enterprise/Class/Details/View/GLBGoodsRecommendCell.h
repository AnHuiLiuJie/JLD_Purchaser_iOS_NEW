//
//  GLBGoodsRecommendCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBRecommendCellBlock)(GLBGoodsDetailGoodsModel *goodsModel);


@interface GLBGoodsRecommendCell : UITableViewCell


// 推荐商品
@property (nonatomic, strong) NSMutableArray<GLBGoodsDetailGoodsModel *> *recommendArray;

// 关联商品
@property (nonatomic, strong) NSMutableArray<GLBGoodsDetailGoodsModel *> *similarArray;


// 回调
@property (nonatomic, copy) GLBRecommendCellBlock recommendCellBlock;


@end

NS_ASSUME_NONNULL_END
