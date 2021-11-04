//
//  DCBasicViewController.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UINavigationController+FDFullscreenPopGesture.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCBasicViewController : UIViewController

/// 界面跳转 不需要判断是否登陆
- (void)dc_pushNextController:(id)controller;

/// 界面跳转 需要判断是否登陆
- (void)dc_pushLoginNextController:(id)controller;

/// 界面跳转h5界面
- (void)dc_pushWebController:(NSString *)path params:(NSString *_Nullable)params;

/// 界面跳转h5界面 - 个人付款
- (void)dc_pushPersonWebToPayController:(NSString *)path params:(NSString *_Nullable)params targetIndex:(NSInteger)targetIndex;
/// 界面跳转h5界面 - 个人
- (void)dc_pushPersonWebController:(NSString *)path params:(NSString *_Nullable)params;

/// 界面跳转h5界面 需要判断是否登录
- (void)dc_pushLoginWebController:(NSString *)path params:(NSString *_Nullable)params;

/// 添加自定义的返回事件
- (void)dc_addCustomBackEvent:(SEL)sel;


/// 设置导航栏是否透明
- (void)dc_navBarLucency:(BOOL)isLucency;

/// 设置导航栏标题字体 颜色
- (void)dc_navBarTitleWithFont:(UIFont *)font color:(UIColor *)color;

/// 设置导航栏标背景颜色
- (void)dc_navBarBackGroundcolor:(UIColor *)color;

/// 设置消息栏样式
- (void)dc_statusBarStyle:(UIStatusBarStyle)style;

/// 设置导航栏是否隐藏
- (void)dc_navBarHidden:(BOOL)isHidden;
- (void)dc_navBarHidden:(BOOL)isHidden animated:(BOOL)animated;
/// 设置侧滑是否禁用
- (void)dc_popBackDisabled:(BOOL)disabled;

#pragma mark -关闭window上所有view的键盘
- (BOOL)dc_dismissAllKeyBoardInView:(UIView *)view;

#pragma mark - Toast
//在系统键盘上显示提示信息
- (void)showTextOnKeyboard:(NSString *)str;

@property (nonatomic, assign) NSInteger targetIndex;
@property (nonatomic, copy) void(^backOperStandBy)(void(^handleBack)(BOOL back,NSInteger targetIndex),NSInteger operIndex);

@end

NS_ASSUME_NONNULL_END
