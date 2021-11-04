//
//  AppDelegate+EaseMob.m
//  EasMobSample
//
//  Created by dujiepeng on 12/5/14.
//  Copyright (c) 2014 dujiepeng. All rights reserved.
//

#import "AppDelegate+HelpDesk.h"
#import "CSDemoAccountManager.h"

/**
 *本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (HelpDesk)
- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //ios8注册apns
    [self registerRemoteNotification];
    //初始化环信客服sdk
    [self initializeCustomerServiceSdk];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    /*
     注册IM用户【注意:注册建议在服务端创建，而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器。】
     */
    // 注册环信监听
    [self setupNotifiers];
    
    //添加自定义小表情
#pragma mark smallpngface
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,3}\\]"];
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[HDConvertToCommonEmoticonsHelper emotionsDictionary]];
}


//初始化客服sdk
- (void)initializeCustomerServiceSdk {
    //#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = DCEMApnsCertName;
    
    //注册kefu_sdk
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    HDOptions *option = [[HDOptions alloc] init];

    option.appkey = lgM.appkey;
    option.tenantId = lgM.tenantId;
    option.kefuRestServer = @"http://kefu.easemob.com";
    option.enableConsoleLog = YES; // 是否打开日志信息
    option.apnsCertName = apnsCertName;
    option.visitorWaitCount = YES; // 打开待接入访客排队人数功能
    option.showAgentInputState = YES; // 是否显示坐席输入状态
    HDClient *client = [HDClient sharedClient];
    HDError *initError = [client initializeSDKWithOptions:option];
    
    
    
    if (initError) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"initialization_error", @"Initialization error!") message:initError.errorDescription preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
        return;
    }
    [self registerEaseMobNotification];
    
    [lgM setPushOptions];

}

//修改关联app后需要重新初始化
- (void)resetCustomerServiceSDK {
    //如果在登录状态,账号要退出
    HDClient *client = [HDClient sharedClient];
    HDError *error = [client logout:NO];
    if (error != nil) {
            NSLog(@"登出出错:%@",error.errorDescription);
    }
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    //#warning "changeAppKey 为内部方法，不建议使用"//lj_change_focus ⚠️
    HDError *er = [client changeAppKey:lgM.appkey];
    if (er == nil) {
        NSLog(@"appkey 已更新");
    } else {
        NSLog(@"appkey 更新失败,请手动重启");
    }
}

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[HDClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[HDClient sharedClient] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
//    [[HDClient sharedClient] applicationdidfinishLounching];
 //   [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
  //  [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
 //   [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeRecording" object:nil];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
 //   [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
//    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns) message:error.description preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    [application registerForRemoteNotifications];
#endif
}

#pragma mark - registerEaseMobNotification

- (void)registerEaseMobNotification
{
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[HDClient sharedClient] addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[HDClient sharedClient] removeDelegate:self];
}


#pragma mark - IChatManagerDelegate
- (void)connectionStateDidChange:(HConnectionState)aConnectionState {
    switch (aConnectionState) {
        case HConnectionConnected: {
            break;
        }
        case HConnectionDisconnected: {
            break;
        }
        default:
            break;
    }
}

- (void)userAccountDidRemoveFromServer {
    [self userAccountLogout];
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your login account has been remove from server") preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[DCLoginTool shareTool] dc_aaaaaaLoginController];
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

- (void)userAccountDidLoginFromOtherDevice {
    //[self userAccountLogout];
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[DCLoginTool shareTool] dc_aaaaaaLoginController];
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}


- (void)userDidForbidByServer {
    [self userAccountLogout];
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"userDidForbidByServer", @"your login account has been forbid by server") preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[DCLoginTool shareTool] dc_aaaaaaLoginController];
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

- (void)userAccountDidForcedToLogout:(HDError *)aError {
    [self userAccountLogout];
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"userAccountDidForcedToLogout", @"your login account has been forced logout") preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[DCLoginTool shareTool] dc_aaaaaaLoginController];
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

//退出当前
- (void)userAccountLogout {
    [[HDClient sharedClient] logout:YES];
    HDChatViewController *chat = [CSDemoAccountManager shareLoginManager].curChat;
    if (chat) {
        [chat backItemClicked];
    }
}

//环信退出
- (void)huanxinLogOut{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HDError *error = [HDClient.sharedClient logout:YES];
        if (error == nil) {
            NSLog(@"===环信退出成功");
            //[[EMClient sharedClient].options setIsAutoLogin:NO];
        } else {
            NSLog(@"失败:%@",error.errorDescription);
        }
    });
}

//环信登录
- (void)huanxinLogin:(id)tabbar successBlock:(dispatch_block_t)successBlock failBlock:(dispatch_block_t)failBlock{
    
    BOOL isLogin = [[CSDemoAccountManager shareLoginManager] login];
    [[CSDemoAccountManager shareLoginManager] setPushOptions];
    if (isLogin) {
        //设置是否自动登录
        //[[EMClient sharedClient].options setIsAutoLogin:YES];
        NSLog(@"===环信登录成功");
        if (successBlock) {
            successBlock();
        }
    }else{//登录失败
        if (failBlock) {
            failBlock();
        }
    }
}




@end
