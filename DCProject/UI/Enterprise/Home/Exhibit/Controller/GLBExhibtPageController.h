//
//  GLBExhibtPageController.h
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBExhibtPageController : WMPageController

// 展会id 从广告页进来才有
@property (nonatomic, copy) NSString *iD;

@end

NS_ASSUME_NONNULL_END
