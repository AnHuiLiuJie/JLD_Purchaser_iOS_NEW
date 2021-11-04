//
//  DCBasicViewController.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface DCBasicViewController ()

@end

@implementation DCBasicViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    BOOL keyBoard = NO;
    for (UIView* view in self.view.window.subviews)
    {
        keyBoard = keyBoard ? keyBoard : [self dc_dismissAllKeyBoardInView:view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResign)];
    //设置点击多少次退出键盘，一般设置为1次
    tapGestureRecognizer.numberOfTapsRequired = 1.0;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
}

- (void)tapResign{
    [DC_KeyWindow endEditing:YES];//关闭键盘
}

- (void)useMethodToFindBlackLineAndHindWithHidden:(BOOL)hidden{
//    //隐藏黑线
//    [self useMethodToFindBlackLineAndHindWithHidden:NO];
//    ///显示黑线
//    [self useMethodToFindBlackLineAndHindWithHidden:YES];
    UIImageView *blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //隐藏黑线（在viewWillAppear时隐藏，在viewWillDisappear时显示）
    blackLineImageView.hidden = hidden;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


#pragma mark - 界面跳转 不需要判断是否登陆
- (void)dc_pushNextController:(id)controller
{
    [DC_KeyWindow endEditing:YES];//关闭键盘
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - 界面跳转 需要判断是否登陆
- (void)dc_pushLoginNextController:(id)controller
{
//    if (![[QYLoginTool shareTool] dc_isLogin]) {
//        [[QYLoginTool shareTool] dc_pushLoginController];
//        return;
//    }
    
    [self dc_pushNextController:controller];
}


#pragma mark - 界面跳转h5界面
- (void)dc_pushWebController:(NSString *)path params:(NSString *_Nullable)params
{
//    NSString *url = [DCObjectManager dc_readUserDataForKey:DC_H5_Key];;
    
    NSString *url = DC_H5BaseUrl;
    if (path && [path length] > 0) {
        url = [url stringByAppendingString:path];
    }

    if (params && [params length] > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }

    DCH5ViewController *vc = [DCH5ViewController new];
    vc.path = url;
    [self dc_pushNextController:vc];
}

#pragma mark - 界面跳转h5界面
- (void)dc_pushLoginWebController:(NSString *)path params:(NSString *_Nullable)params
{
//    if (![[QYLoginTool shareTool] dc_isLogin]) {
//        [[QYLoginTool shareTool] dc_pushLoginController];
//        return;
//    }
    
    [self dc_pushWebController:path params:params];
}


#pragma mark - 界面跳转h5界面 - 个人 付款
- (void)dc_pushPersonWebToPayController:(NSString *)path params:(NSString *_Nullable)params targetIndex:(NSInteger)targetIndex{
    [DC_KeyWindow endEditing:YES];//关闭键盘
    NSString *url = Person_H5BaseUrl;
    if (path && [path length] > 0) {
        url = [url stringByAppendingString:path];
    }
    
    if (params && [params length] > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }
    
    GLPH5ViewController *vc = [GLPH5ViewController new];
    vc.path = url;
    vc.currentIndex = targetIndex;
    [self dc_pushNextController:vc];
}

#pragma mark - 界面跳转h5界面 - 个人
- (void)dc_pushPersonWebController:(NSString *)path params:(NSString *_Nullable)params
{
    [DC_KeyWindow endEditing:YES];//关闭键盘
    NSString *url = Person_H5BaseUrl;
    if (path && [path length] > 0) {
        url = [url stringByAppendingString:path];
    }
    
    if (params && [params length] > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }
    
    GLPH5ViewController *vc = [GLPH5ViewController new];
    vc.path = url;
    [self dc_pushNextController:vc];
}

- (void)sp_popViewController{
    
    if (self.backOperStandBy != nil) {
        __weak typeof(self) ws = self;
        self.backOperStandBy(^(BOOL back, NSInteger targetIndex) {
                if (back) {
                    ws.targetIndex = targetIndex;
                    [ws handlePopAction];
                }
        }, self.navigationController.viewControllers.count-1);
    } else {
        [self handlePopAction];
    }
}

- (void)handlePopAction
{
    if (self.targetIndex == 5) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    if (self.targetIndex != 0 && self.targetIndex > 0) {
        UIViewController *target = self.navigationController.viewControllers[self.targetIndex];
        self.targetIndex = 0;
        if (target) {
            [self.navigationController popToViewController:target animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    // 普通情况
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 添加自定义的返回事件
- (void)dc_addCustomBackEvent:(SEL)sel
{
    [DC_KeyWindow endEditing:YES];//关闭键盘
    self.navigationItem.leftBarButtonItem = nil;
    
    //返回按钮自定义
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"dc_fanhui_hei"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"dc_fanhui_hei"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 38, 38);
    
    if (@available(ios 11.0,*)) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10,0, 0);
    }
    
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
}


#pragma mark - 设置导航栏是否透明
- (void)dc_navBarLucency:(BOOL)isLucency
{
    UIImage *image = isLucency ? [[UIImage alloc] init] : nil;
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    //[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //设置导航栏背景图片为一个空的image，这样就透明了
    //[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - 设置导航栏标题字体 颜色
- (void)dc_navBarTitleWithFont:(UIFont *)font color:(UIColor *)color
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color,NSFontAttributeName:font};
}

/// 设置导航栏标背景颜色
- (void)dc_navBarBackGroundcolor:(UIColor *)color
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage dc_initImageWithColor:color size:CGSizeMake(kScreenW, kNavBarHeight)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 设置消息栏样式
- (void)dc_statusBarStyle:(UIStatusBarStyle)style
{
    [UIApplication sharedApplication].statusBarStyle = style;
}

#pragma mark - 设置导航栏是否隐藏
- (void)dc_navBarHidden:(BOOL)isHidden
{
    [self.navigationController setNavigationBarHidden:isHidden animated:NO];
}

- (void)dc_navBarHidden:(BOOL)isHidden animated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:isHidden animated:animated];
}

/// 设置侧滑是否禁用
- (void)dc_popBackDisabled:(BOOL)disabled
{
    self.fd_interactivePopDisabled = disabled;
}

#pragma mark - 关闭window上所有view的键盘
-(BOOL)dc_dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dc_dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Toast
//在系统键盘上显示提示信息
- (void)showTextOnKeyboard:(NSString *)str
{
        [[UIApplication sharedApplication].windows.lastObject makeToast:str duration:Toast_During position:CSToastPositionBottom];
}

@end
