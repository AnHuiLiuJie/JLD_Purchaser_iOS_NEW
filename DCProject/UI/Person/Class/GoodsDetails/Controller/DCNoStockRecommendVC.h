//
//  DCNoStockRecommendVC.h
//  DCProject
//
//  Created by LiuMac on 2021/9/27.
//

#import "DCBasicViewController.h"
#import "GLPGoodsLickModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCNoStockRecommendVC : DCBasicViewController

@property (nonatomic, copy) NSArray *dataArray;

@end

#pragma mark - 商品
@interface GLPNoStockRecommendrGoodsView : UIView

@property (nonatomic, strong) GLPGoodsLickGoodsModel *model;

@end

NS_ASSUME_NONNULL_END
