//
//  GLBEditCountView.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"
@class GLBEditCountView;

@protocol GLBEditCountViewDelegate <NSObject>

// 加
- (void)dc_countAddWithCountView:(GLBEditCountView *_Nullable)countView;

// 减
- (void)dc_countSubWithCountView:(GLBEditCountView *_Nullable)countView;

// 改变
- (void)dc_countChangeWithCountView:(GLBEditCountView *_Nullable)countView;


@end

NS_ASSUME_NONNULL_BEGIN

@interface GLBEditCountView : UIView


// 数量框
@property (nonatomic, strong) DCTextField *countTF;

// 代理
@property (nonatomic, assign) id<GLBEditCountViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
