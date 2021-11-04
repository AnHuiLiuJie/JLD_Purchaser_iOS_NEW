//
//  DCLoginController.h
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCLoginController : DCBasicViewController

// 是否是模态弹出
@property (nonatomic, assign) BOOL isPresent;

// 登录成功回调
@property (nonatomic, copy) dispatch_block_t successBlock;

@end

NS_ASSUME_NONNULL_END
