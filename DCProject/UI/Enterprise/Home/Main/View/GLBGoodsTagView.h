//
//  GLBGoodsTagView.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsModel.h"
#import "GLBStoreModel.h"
#import "GLBStoreGoodsModel.h"
#import "GLBGoodsListModel.h"
#import "GLBGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsTagView : UIView

// 商品
@property (nonatomic, strong) GLBGoodsModel *goodsModel;

// 店铺商品
@property (nonatomic, strong) GLBStoreGoodsModel *storeGoodsModel;

// 分类商品列表商品
@property (nonatomic, strong) GLBGoodsListModel *goodsListModel;

// 商品详情
@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
