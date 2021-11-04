//
//  GLBUserInfoController.h
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBUserInfoController : DCTabViewController

@property (nonatomic, strong) GLBUserInfoModel *userInfo;

@property (nonatomic, copy) dispatch_block_t successBlock;

@end

NS_ASSUME_NONNULL_END
