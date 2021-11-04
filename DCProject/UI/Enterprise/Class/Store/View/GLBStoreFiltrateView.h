//
//  GLBStoreFiltrateView.h
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBFiltrateViewBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreFiltrateView : UIView


@property (nonatomic, copy) GLBFiltrateViewBlock filtrateBtnBlock;

// 恢复初始状态
- (void)dc_recoverInit;

@end

NS_ASSUME_NONNULL_END
