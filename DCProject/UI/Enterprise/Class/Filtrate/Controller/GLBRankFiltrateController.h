//
//  GLBRankFiltrateController.h
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBRankFiltrateBlock)(NSString *_Nullable rankStr);


@interface GLBRankFiltrateController : DCTabViewController

@property (nonatomic, copy) NSString *rankStr;

@property (nonatomic, copy) GLBRankFiltrateBlock cancelBlock;

@property(nonatomic,strong)NSString *frameType;
@end

NS_ASSUME_NONNULL_END
