//
//  GLBTCMFiltrateView.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBTCMFiltrateBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBTCMFiltrateView : UIView

// 点击按钮
@property (nonatomic, copy) GLBTCMFiltrateBlock filtrateBlock;

// 恢复初始话设置
- (void)dc_recoverInit;

@end

NS_ASSUME_NONNULL_END
