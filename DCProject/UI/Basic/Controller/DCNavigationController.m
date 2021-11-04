//
//  DCNavigationController.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCNavigationController.h"

@interface DCNavigationController ()

@end

@implementation DCNavigationController

#pragma mark - load初始化一次
+ (void)load
{
    [self setUpBase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化
+ (void)setUpBase
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setShadowImage:[UIImage new]];
    
    bar.barTintColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    [bar setTintColor:[UIColor darkGrayColor]];
    bar.translucent = YES;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置导航栏字体颜色
    UIColor *naiColor = [UIColor dc_colorWithHexString:@"#333333"];
    attributes[NSForegroundColorAttributeName] = naiColor;
    attributes[NSFontAttributeName] = DCWNavigationTitleFont;
    bar.titleTextAttributes = attributes;

}

#pragma mark - 返回
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count >= 1) {
        //返回按钮自定义
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -15;
        
        UIButton *button = [[UIButton alloc] init];
        NSString *viewControllerName = NSStringFromClass([viewController class]);
        
        if ([viewControllerName isEqualToString:@"GLPRefundDetailsVC"] || [viewControllerName isEqualToString:@"GLPRequestRefundVC"]){
            [button setImage:[UIImage imageNamed:@"dc_fanhui_bai"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"dc_fanhui_bai"] forState:UIControlStateHighlighted];
            button.frame = CGRectMake(0, 0, 44, 44);
        }else{
            [button setImage:[UIImage imageNamed:@"dc_fanhui_hei"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"dc_fanhui_hei"] forState:UIControlStateHighlighted];
            button.frame = CGRectMake(0, 0, 38, 38);
        }

        
        if (@available(ios 11.0,*)) {
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -10,0, 0);
        }
        
        [button addTarget:self action:@selector(backButtonTapClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    //跳转
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 点击
- (void)backButtonTapClick {
    
    [self popViewControllerAnimated:YES];
}


@end
