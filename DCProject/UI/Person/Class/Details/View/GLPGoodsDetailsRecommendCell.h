//
//  GLPGoodsDetailsRecommendCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsLickModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLPDetailsRecommendCellBlock)(GLPGoodsLickGoodsModel *goodsModel);

@interface GLPGoodsDetailsRecommendCell : UITableViewCell

@property (nonatomic, strong) GLPGoodsLickModel *lickModel;

// 点击
@property (nonatomic, copy) GLPDetailsRecommendCellBlock recommendCellBlock;

@end


#pragma mark - 商品
@interface GLPGoodsDetailsRecommendGoodsCell : UICollectionViewCell

@property (nonatomic, strong) GLPGoodsLickGoodsModel *lickGoodsModel;

@end

NS_ASSUME_NONNULL_END
