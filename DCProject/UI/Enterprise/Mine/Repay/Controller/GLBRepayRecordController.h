//
//  GLBRepayRecordController.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLBRepayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayRecordController : DCBasicViewController


// 还款模型
@property (nonatomic, strong) GLBRepayListModel *repayListModel;

@end

NS_ASSUME_NONNULL_END
