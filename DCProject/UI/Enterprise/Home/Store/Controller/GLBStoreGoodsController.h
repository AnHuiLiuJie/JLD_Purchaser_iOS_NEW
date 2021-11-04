//
//  GLBStoreGoodsController.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreGoodsController : DCTabViewController

@property (nonatomic, strong) GLBStoreModel *storeModel;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
