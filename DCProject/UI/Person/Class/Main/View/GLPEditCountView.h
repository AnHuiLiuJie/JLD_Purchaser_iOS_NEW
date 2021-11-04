//
//  GLPEditCountView.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"
@class GLPEditCountView;

@protocol GLPEditCountViewDelegate <NSObject>

@optional

// 加
- (void)dc_personCountAddWithCountView:(GLPEditCountView *_Nullable)countView;

// 减
- (void)dc_personCountSubWithCountView:(GLPEditCountView *_Nullable)countView;

// 改变
- (void)dc_personCountChangeWithCountView:(GLPEditCountView *_Nullable)countView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GLPEditCountView : UIView


// 数量框
@property (nonatomic, strong) DCTextField *countTF;

// 代理
@property (nonatomic, assign) id<GLPEditCountViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
