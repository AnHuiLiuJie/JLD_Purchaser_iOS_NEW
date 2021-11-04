//
//  GLBZizhiListController.h
//  DCProject
//
//  Created by bigbing on 2019/8/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"

typedef NS_ENUM(NSInteger , GLBZizhiType) {
    GLBZizhiTypeCertified = 0, // 已认证
    GLBZizhiTypeUnverified // 未认证
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBZizhiListController : DCTabViewController


@property (nonatomic, assign) GLBZizhiType zizhiType;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
