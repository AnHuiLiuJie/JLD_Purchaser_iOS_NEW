//
//  GLPGoodsDetailsSimilarCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsSimilarModel.h"

typedef void(^GLPSimilarCellBlock)(GLPGoodsSimilarModel *_Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsSimilarCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray<GLPGoodsSimilarModel *> *similarArray;


@property (nonatomic, copy) GLPSimilarCellBlock similarCellBlock;


@end


#pragma mark - 商品
@interface GLPGoodsDetailsSimilarGoodsView : UIView

@property (nonatomic, strong) GLPGoodsSimilarModel *similarModel;

@end

NS_ASSUME_NONNULL_END
