//
//  DCTabbarController.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabbarController.h"

#import "DCNavigationController.h"
#import "GLBHomeController.h"
#import "GLBClassController.h"
#import "GLBShoppingCarController.h"
#import "GLBMineController.h"
#import "TRStorePageVC.h"

#define ControllerClassKey @"controllerClassKey"
#define TitleNameKey @"titleNameKey"
#define ImgNormalKey @"imgNormalKey"
#define ImgSelectKey @"imgSelectKey"


#import <UserNotifications/UserNotifications.h>
#import "CSDemoAccountManager.h"//lj_will_change_end

#import "HDCDDeviceManager.h"
#if DEMO_CALL == 1
#import <Hyphenate/Hyphenate.h>
#import "DemoConfManager.h"
#import "UIViewController+HDHUD.h"
#endif

@interface DCTabbarController () <UITabBarControllerDelegate,HDChatManagerDelegate>

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation DCTabbarController
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUserNotification:) name:DC_HXMessageCheck_NotificationName2 object:nil];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    //#warning 把self注册为SDK的delegate
    [self registerNotifications];

    self.delegate = self;
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    NSArray *array = @[@{
                            ControllerClassKey:NSStringFromClass([GLBHomeController class]),
                            TitleNameKey:@"首页",
                            ImgNormalKey:@"sy",
                            ImgSelectKey:@"syxz"},
                        
                        @{
                            ControllerClassKey:NSStringFromClass([GLBClassController class]),
                            TitleNameKey:@"分类",
                            ImgNormalKey:@"fl",
                            ImgSelectKey:@"flxz"},
                        
                        @{
                            ControllerClassKey:NSStringFromClass([GLBShoppingCarController class]),
                            TitleNameKey:@"购物车",
                            ImgNormalKey:@"gwc",
                            ImgSelectKey:@"gwcxz"},
                        
                        @{
                            ControllerClassKey:NSStringFromClass([GLBMineController class]),
                            TitleNameKey:@"个人中心",
                            ImgNormalKey:@"wd",
                            ImgSelectKey:@"wodexz"}
                        
                        ];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(obj[ControllerClassKey]) new];
        DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.image = [UIImage imageNamed:obj[ImgNormalKey]];
        item.selectedImage = [[UIImage imageNamed:obj[ImgSelectKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setImageInsets:UIEdgeInsetsMake(-1, 0, 1, 0)];
        item.title = obj[TitleNameKey];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#A2A6B0"],NSFontAttributeName:[UIFont fontWithName:PFRMedium size:10]} forState:0];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"],NSFontAttributeName:[UIFont fontWithName:PFRMedium size:10]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    
    NSDictionary *infoDic = [DCObjectManager dc_getObjectByFileName:DC_HX_Notification_Key];
    if (infoDic != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 *NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self receiveUserNotification:infoDic];
            [DCObjectManager dc_removeFileByFileName:DC_HX_Notification_Key];
        });
    }
   
}

#pragma mark - <UITabBarControllerDelegate>
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    // 控制器跳转拦截
    //    if(viewController == [tabBarController.viewControllers objectAtIndex:3]){
    //
    //
    //        return YES;
    //    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self tabBarButtonClick:[self getTabBarButton]];
}


- (UIControl *)getTabBarButton
{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

- (void)dc_pushPersonStoreController:(NSString *)iD
{
    
        
        if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
            
            TRStorePageVC *vc = [[TRStorePageVC alloc] init];
            vc.firmId=iD;
//            UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
            DCNavigationController *nav = self.selectedViewController;
            [nav pushViewController:vc animated:YES];
            [DCObjectManager dc_removeUserDataForkey:@"goodsId"];
             [DCObjectManager dc_removeUserDataForkey:@"stm"];
             [DCObjectManager dc_removeUserDataForkey:@"utmUserId"];
            
        }
    }
#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

#pragma mark - 环信
// 统计未读消息数
- (void)_setupUnreadMessageCount
{
    NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
    long unreadCount = 0;
    for (HDConversation *conv in hConversations) {
        unreadCount += conv.unreadMessagesCount;
    }
    NSLog(@"环信服务器=====未读消息数量：%ld",unreadCount);
//    if (self.bottonView) {
//        [self.bottonView reloadMessageUnRead:unreadCount];
//    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)networkChanged:(HConnectionState)connectionState
{
    _connectionState = connectionState;
}

#pragma mark - private

- (void)registerNotifications
{
    [self unregisterNotifications];
    
    [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications
{
    [[HDClient sharedClient].chatManager removeDelegate:self];
}

- (void)_playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < DC_kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[HDCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[HDCDDeviceManager sharedInstance] playVibration];
}

- (void)_showNotificationWithMessage:(NSArray *)messages
{
    HDPushOptions *options = [[HDClient sharedClient] hdPushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    id<HDIMessageModel> messageModel = messages.firstObject;

    if (options.displayStyle == HDPushDisplayStyleMessageSummary) {
        NSString *messageStr = nil;
        switch (messageModel.body.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageModel.body).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = @"图片";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = @"位置";
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = @"音频";
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = @"视频";
            }
                break;
            default:
                break;
        }
        
        NSString *title = messageModel.from;
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= DC_kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:messageModel.body.type] forKey:DC_kMessageType];
    [userInfo setObject:messageModel.messageId forKey:DC_kConversationChatter];

    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        
        if (@available(iOS 10.0, *)) {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            if (playSound) {
                content.sound = [UNNotificationSound defaultSound];
            }
            content.body =notification.alertBody;
            content.userInfo = userInfo;
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:messageModel.messageId content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        } else {
            // Fallback on earlier versions
        }

    }
    else {
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = notification.alertBody;
        notification.alertAction = @"打开";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;

        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        [UIApplication sharedApplication].applicationIconBadgeNumber = ++badge;
    }
}

// 收到消息回调
- (void)messagesDidReceive:(NSArray *)aMessages {
    if ([self isNotificationMessage:aMessages.firstObject]) {
        return;
    }
#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self _showNotificationWithMessage:aMessages];
    }else {
        [self _playSoundAndVibration];
    }
#endif
}

- (BOOL)isNotificationMessage:(HDMessage *)message {
    if (message.ext == nil) { //没有扩展
        return NO;
    }
    NSDictionary *weichat = [message.ext objectForKey:kMessageExtWeChat];
    if (weichat == nil || weichat.count == 0 ) {
        return NO;
    }
    if ([weichat objectForKey:@"notification"] != nil && ![[weichat objectForKey:@"notification"] isKindOfClass:[NSNull class]]) {
        BOOL isNotification = [[weichat objectForKey:@"notification"] boolValue];
        if (isNotification) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"正在重连中..."];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showInfoWithStatus:@"重连失败，稍候将继续重连"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"重连成功！"];
        }
    }
}

#pragma mark - public



- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveUserNotification:(NSNotification *)notification {
//    //NSDictionary *infoDic = [notification userInfo];
//    if (![[self currentViewController] isKindOfClass:[HDChatViewController class]]) { // 这个判断防止两次执行里面代码
//        //lj_will_change_end
//        WEAKSELF;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
//            if ([lgM loginKefuSDK]) {
//                NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
//                NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
//                NSString *chatTitle = @"启源大药房";
//                HDQueueIdentityInfo *queueIdentityInfo = nil;
//                HDAgentIdentityInfo *agentIdentityInfo = nil;
//                queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
//                agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
//                chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
//                hd_dispatch_main_async_safe(^(){
//                    [weakSelf hideHud];
//                    HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
//                    chat.hidesBottomBarWhenPushed = YES; // 隐藏你的 tabBar
//                    queue ? (chat.queueInfo = queueIdentityInfo) : nil;
//                    agent ? (chat.agent = agentIdentityInfo) : nil;
//                    chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
//                    chat.title = chatTitle;
//                    [[weakSelf currentViewController].navigationController pushViewController:chat animated:YES];
//                    //[self.navigationController pushViewController:chat animated:YES];
//                });
//               
//            } else {
//                hd_dispatch_main_async_safe(^(){
//                    [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
//                });
//                NSLog(@"登录失败");
//            }
//        });//完整
//
//    }
}

// MARK: - 跳转到客服页面
- (void)receiveUserNotification:(NSDictionary *)infoDic {
//    //NSDictionary *apsDic = [infoDic objectForKey:@"aps"];
//    //NSString *f = [infoDic objectForKey:@"f"];
//    if (![[self currentViewController] isKindOfClass:[HDChatViewController class]]) { // 这个判断防止两次执行里面代码
//        //lj_will_change_end
//        WEAKSELF;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
//            if ([lgM loginKefuSDK]) {
//                NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
//                NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
//                NSString *chatTitle = @"启源大药房";
//                HDQueueIdentityInfo *queueIdentityInfo = nil;
//                HDAgentIdentityInfo *agentIdentityInfo = nil;
//                queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
//                agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
//                chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
//                hd_dispatch_main_async_safe(^(){
//                    [weakSelf hideHud];
//                    HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
//                    chat.hidesBottomBarWhenPushed = YES; // 隐藏你的 tabBar
//                    queue ? (chat.queueInfo = queueIdentityInfo) : nil;
//                    agent ? (chat.agent = agentIdentityInfo) : nil;
//                    chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
//                    chat.title = chatTitle;
//                    [[weakSelf currentViewController].navigationController pushViewController:chat animated:YES];
//                    //[self.navigationController pushViewController:chat animated:YES];
//                });
//
//            } else {
//                hd_dispatch_main_async_safe(^(){
//                    [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
//                });
//                NSLog(@"登录失败");
//            }
//        });//完整
//
////        // 如果不想隐藏导航栏返回按钮文字就去掉这个判断
////        if (![[self currentViewController] isKindOfClass:[GLPHomeViewController class]]) {// 如果不是父控制器就进入,应领导要求,不是从父控制器(指的是正常进入目标控制器的父控制器) 就隐藏导航栏返回按钮的文字
////
////            // 隐藏导航栏返回按钮的文字
////            [self currentViewController].navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
////        }else { // 这个判断是走完上面方法之后,所有返回按钮文字都隐藏了, 下面这方法可以解决这个问题
////            [self currentViewController].navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self currentViewController].title style:UIBarButtonItemStylePlain target:self action:nil];
////        }
//        // 正角来了,这个方法可以让你在任何页面都可以跳转到目标控制器, 当然返回也是进入之前的页面(爱奇艺也是这效果)
////        [[self currentViewController].navigationController pushViewController:announceVC animated:YES];
//
//    }
}

#pragma mark - 获取当前最外层VC
- (UIViewController*)currentViewController{
    UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return[self findBestViewController:viewController];
}

//递归方法
- (UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    }else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    }else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    }else{
        return vc;
    }
}



@end
