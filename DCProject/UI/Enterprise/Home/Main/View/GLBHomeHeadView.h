//
//  GLBHomeHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "GLBAdvModel.h"
#import "GLBNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBHomeHeadViewBlock)(NSInteger index);
typedef void(^GLBBannerViewBlock)(GLBAdvModel *_Nullable model);
typedef void(^GLBNewsBlock)(GLBNewsModel *_Nullable model);



@interface GLBHomeHeadView : UIView

// 轮播图
@property (nonatomic, strong) SDCycleScrollView *scrollView;

// 轮播图数据
@property (nonatomic, strong) NSMutableArray<GLBAdvModel *> *bannerArray;

// 资讯数组
@property (nonatomic, strong) NSMutableArray<GLBNewsModel *> *newsArray;


// 点击类型回调
@property (nonatomic, copy) GLBHomeHeadViewBlock  homeHeadViewBlock;

// 轮播图回调
@property (nonatomic, copy) GLBBannerViewBlock bannerViewBlock;

// 点击更多
@property (nonatomic, copy) dispatch_block_t moreBtnBlock;

// 点击广告回调
@property (nonatomic, copy) GLBNewsBlock newsBlock;


@end

NS_ASSUME_NONNULL_END
