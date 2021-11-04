//
//  GLBGoodsDetailBottomView.h
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsDetailModel.h"

typedef void(^GLBDetailBottomViewBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsDetailBottomView : UIView

// 购物车数量
@property (nonatomic, assign) NSInteger count;


@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;

// 点击
@property (nonatomic, copy) GLBDetailBottomViewBlock bottomViewBlock;

@end

NS_ASSUME_NONNULL_END
