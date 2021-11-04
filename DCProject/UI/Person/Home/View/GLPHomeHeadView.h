//
//  GLPHomeHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "GLPAdModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BannerViewBlock)(NSInteger selectindex);
@interface GLPHomeHeadView : UIView

// 轮播图
@property (nonatomic, strong) SDCycleScrollView *scrollView;

// banner数据
@property (nonatomic, strong) NSMutableArray<GLPAdModel *> *bannerArray;
@property(nonatomic,copy)BannerViewBlock bannerViewBlock;
@end

NS_ASSUME_NONNULL_END
