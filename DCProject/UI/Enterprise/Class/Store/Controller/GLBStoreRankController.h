//
//  GLBStoreRankController.h
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBRankFiltrateBlock)(NSString *rankStr);

@interface GLBStoreRankController : DCTabViewController

@property (nonatomic, copy) NSString *rankStr;

@property (nonatomic, copy) GLBRankFiltrateBlock cancelBlock;

@end

NS_ASSUME_NONNULL_END
