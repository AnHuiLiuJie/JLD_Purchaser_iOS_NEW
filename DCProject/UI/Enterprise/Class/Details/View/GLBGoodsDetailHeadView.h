//
//  GLBGoodsDetailHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "GLBGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsDetailHeadView : UIView


// banner图
@property (nonatomic, strong) SDCycleScrollView *scrollView;

//  赋值
@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
