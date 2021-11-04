//
//  GLBTCMGoodsController.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"

typedef NS_ENUM(NSInteger , GLBTCMGoodsType) {
    GLBTCMGoodsTypeJrth = 0, // 今日特惠
    GLBTCMGoodsTypeZshy,     // 最受欢迎
    GLBTCMGoodsTypeJptj,     // 精品推荐
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBTCMGoodsController : DCTabViewController

@property (nonatomic, assign) GLBTCMGoodsType goodsType;


@property (nonatomic, copy) NSString *searchStr;

@end

NS_ASSUME_NONNULL_END
