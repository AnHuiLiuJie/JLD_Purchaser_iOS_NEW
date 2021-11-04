//
//  UIViewController+BackButtonHandler.h
//  Pole
//
//  Created by 赤道 on 2018/12/28.
//  Copyright © 2018 刘伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>

@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
- (BOOL)navigationShouldPopOnBackButton;

@end


@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end
