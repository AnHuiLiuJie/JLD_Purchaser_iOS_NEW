//
//  GLPGoodsDetailsHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "GLPGoodsDetailModel.h"
#import <YBImageBrowser/YBImageBrowser.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsHeadView : UIView<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic,strong) YBImageBrowser *brow;
// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;

// 商品详情图
@property (nonatomic, copy) NSArray *imageArray;

@end

NS_ASSUME_NONNULL_END
