//
//  GLBRepayStageController.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLBRepayListModel.h"

typedef void(^GLBRepayBlock)(CGFloat money);

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayStageController : DCBasicViewController

// 还款模型
@property (nonatomic, strong) GLBRepayListModel *repayListModel;


// 还款回调
@property (nonatomic, copy) GLBRepayBlock repayBlock;

@end

NS_ASSUME_NONNULL_END
