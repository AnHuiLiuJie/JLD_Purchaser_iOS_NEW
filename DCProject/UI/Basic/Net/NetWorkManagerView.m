//
//  NetWorkManagerView.m
//  Pole
//
//  Created by 赤道 on 2020/1/14.
//  Copyright © 2020 刘伟. All rights reserved.
//

#import "NetWorkManagerView.h"
#import "LookOverNetViewController.h"

@interface NetWorkManagerView()
@property (weak, nonatomic) IBOutlet UILabel *tishiLab1;
@property (weak, nonatomic) IBOutlet UILabel *tishiLab2;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *refresh_btn;
@property (weak, nonatomic) IBOutlet UIButton *leave_btn;
@property (weak, nonatomic) IBOutlet UIButton *lookOver_btn;


@end

@implementation NetWorkManagerView

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self awakeFromNib];
        
        self.contentView.backgroundColor = [RGB_COLOR(0, 0, 0) colorWithAlphaComponent:0.5f];
        self.bgView.backgroundColor = [UIColor whiteColor];
        //圆角
        [DCSpeedy dc_changeControlCircularWith:_refresh_btn AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:RGBA_COLOR(97, 127, 244, 0.7) canMasksToBounds:NO];
        
        [DCSpeedy dc_changeControlCircularWith:_leave_btn AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:RGBA_COLOR(97, 127, 244, 0.7) canMasksToBounds:NO];
        
        [self.refresh_btn addTarget:self action:@selector(update_AppAction:) forControlEvents:UIControlEventTouchUpInside];
        _refresh_btn.hidden = YES;
        self.refresh_btn.tag = 1;
        
        [self.leave_btn addTarget:self action:@selector(update_AppAction:) forControlEvents:UIControlEventTouchUpInside];
        self.leave_btn.tag = 2;
        
        [self.lookOver_btn addTarget:self action:@selector(update_AppAction:) forControlEvents:UIControlEventTouchUpInside];
        _lookOver_btn.hidden = YES;
        self.lookOver_btn.tag = 3;
    }
    return self;
}

#pragma mark - set
-(void)setIsFristLoad:(NSInteger)isFristLoad{
    _isFristLoad = isFristLoad;
    
    if (_isFristLoad != 1) {
        _refresh_btn.hidden = NO;
        _lookOver_btn.hidden = NO;
        _tishiLab2.text = @"尝试一下重新加载!";
    }else
        _tishiLab2.text = @"请前往设置开启网络权限";
}

#pragma mark - 按钮
- (void)update_AppAction:(UIButton *)button{
    if (button.tag == 1) {
        !_clickNewWorkBtnAction_Block ? : _clickNewWorkBtnAction_Block(1);
    }else if (button.tag == 2){
        [self jumpToAPPSetting];
        //[self showStatusDeniedMeg:@"请检查当前网络环境是否正确,是否前往\n设置方法:打开手机设置->Wifi或蜂窝移动网络"];
        //!_clickNewWorkBtnAction_Block ? : _clickNewWorkBtnAction_Block(2);
    }else if (button.tag == 3){
        !_clickNewWorkBtnAction_Block ? : _clickNewWorkBtnAction_Block(3);
        
        
//        id object = [self nextResponder];
//        while (![object isKindOfClass:[UIViewController class]] && object != nil) {
//            object = [object nextResponder];
//        }
//        if (object == nil) {
//            UINavigationController *nav = [self navigationViewController];
//            LookOverNetViewController *Mycontroller = [[LookOverNetViewController alloc] init];
//            [nav.navigationController pushViewController:Mycontroller animated:YES];
//        }else{
//            UIViewController *superController = (UIViewController*)object;
//            LookOverNetViewController *Mycontroller = [[LookOverNetViewController alloc] init];
//            [superController.navigationController pushViewController:Mycontroller animated:YES];
//        }
    }
}


- (UINavigationController *)navigationViewController {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        return (UINavigationController *)window.rootViewController;
        
    } else if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *selectVc = [((UITabBarController *)window.rootViewController)selectedViewController];
        
        if ([selectVc isKindOfClass:[UINavigationController class]]) {
            
            return (UINavigationController *)selectVc;
            
        }
        
    }
    
    return nil;
    
}

#pragma mark - 手势点击事件
- (void)templateSingleTapAction1:(id)sender
{
    [self dismissWithAnimation:YES];
}


- (void)awakeFromNib{
    [super awakeFromNib];
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"NetWorkManagerView" owner:self options:nil] lastObject];
    _contentView.frame = self.bounds;
    [self addSubview:_contentView];
    
    [self setUpViewUI];
}


- (void)setUpViewUI{
//    [self showWithAnimation:YES];
}

#pragma mark - 跳转到设置APP页面
/**
 跳转到设置APP页面
 */
- (void)jumpToAPPSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

/**
 用户拒绝访问权限,我们需要提醒用户打开访问开关
 
 @param meg 提示文字
 */
- (void)showStatusDeniedMeg:(NSString *)meg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:meg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self jumpToAPPSetting];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        //
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.bgView.frame;
        rect.origin.y = kScreenH;
        self.bgView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.bgView.frame;
            rect.origin.y -= kScreenH + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
            self.bgView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y += kScreenH + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
        self.bgView.frame = rect;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
