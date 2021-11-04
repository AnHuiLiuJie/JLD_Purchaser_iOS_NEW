//
//  GLBGoodsFiltrateView.h
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBFiltrateViewBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsFiltrateView : UIView


@property (nonatomic, copy) GLBFiltrateViewBlock filtrateBtnBlock;


@property (nonatomic, assign) NSInteger count;


// 恢复初始状态
- (void)dc_recoverInit;


@end

NS_ASSUME_NONNULL_END
