//
//  GLPBindController.h
//  DCProject
//
//  Created by bigbing on 2019/8/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPBindController : DCBasicViewController

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *thirdLoginId;

@property (nonatomic, assign) NSInteger thirdType; // 第三方登录类型：1-QQ，2-微信，3-微博

@end

NS_ASSUME_NONNULL_END
