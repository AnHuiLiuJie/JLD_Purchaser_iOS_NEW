//
//  GLBTypeGoodsListController.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBTypeModel.h"

typedef NS_ENUM(NSInteger , GLBGoodsType) {
    GLBGoodsTypeRmsx = 0,    // 热卖上新
    GLBGoodsTypeYhcx,        // 优惠促销
    GLBGoodsTypeYkx,         // 药控销
    GLBGoodsTypeYzb,         // 药招标
    GLBGoodsTypeYjk,         // 药健康
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBTypeGoodsListController : DCTabViewController


@property (nonatomic, assign) GLBGoodsType goodsType;

// 0：药健康；1：药控销;2：药招标；3：热卖上新；4：优惠促销
@property (nonatomic, copy) NSString *entrance;
// 是否是中药材：1.是；
@property (nonatomic, copy) NSString *prodType;
// 是否促销：1.是
@property (nonatomic, copy) NSString *isPromotion;
// 商品名称
@property (nonatomic, copy) NSString *goodsName;

// 选择的商品分类
@property (nonatomic, strong) GLBTypeModel *typeModel;

// 获取商品列表
@property (nonatomic, copy) NSString *catIds;

@end

NS_ASSUME_NONNULL_END
