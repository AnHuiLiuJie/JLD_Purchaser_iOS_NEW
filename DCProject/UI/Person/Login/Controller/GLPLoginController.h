//
//  GLPLoginController.h
//  DCProject
//
//  Created by bigbing on 2019/8/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPLoginController : DCBasicViewController

@property (nonatomic, copy) void(^GLPLoginController_block)(NSString *phoneStr);
@property (nonatomic, copy) NSString *phoneStr;

@end

NS_ASSUME_NONNULL_END
