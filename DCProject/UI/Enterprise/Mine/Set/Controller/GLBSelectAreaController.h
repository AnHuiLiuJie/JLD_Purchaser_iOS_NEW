//
//  GLBSelectAreaController.h
//  DCProject
//
//  Created by bigbing on 2019/8/6.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

typedef void(^GLBSelectAreaBlock)(NSString *_Nullable areaFullName,NSInteger areaId);

NS_ASSUME_NONNULL_BEGIN

@interface GLBSelectAreaController : DCBasicViewController

+ (GLBSelectAreaController *)shareInstance;


- (void)dc_getAllAreaData;


@property (nonatomic, copy) GLBSelectAreaBlock areaBlock;

@property(nonatomic,copy) NSString *isPerson;//0:采购版 1:个人版
@end

NS_ASSUME_NONNULL_END
