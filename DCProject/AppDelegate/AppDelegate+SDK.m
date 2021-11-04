//
//  AppDelegate+SDK.m
//  DCProject
//
//  Created by bigbing on 2019/3/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "AppDelegate+SDK.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "AFNetworkActivityIndicatorManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GLPGoodsDetailsController.h"
#import "TRStorePageVC.h"
#import "GLBStorePageController.h"
#import "DCNavigationController.h"
#import "GLBGoodsDetailController.h"
#import "GLBOpenTypeController.h"
#import "GLBGuideController.h"


@implementation AppDelegate (SDK)

#pragma mark - 初始化三方SDK
- (void)initSDKWithOptions:(NSDictionary *)launchOptions{
    [self configUconfigure];
    [self confitUShareSettings];
    [self initWXSDK];
    [self configUSharePlatfcorms];
    [self initBugly];
    [self initJPushWithOptions:launchOptions];
    [self addActivity];
    [self setSVProgressHUDInfo];
    
    // 注册通知  监听自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

#pragma mark - 设置SVProgressHUD参数
- (void)setSVProgressHUDInfo{
    [SVProgressHUD setBackgroundColor:[UIColor dc_colorWithHexString:DC_BGColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setFont:[UIFont fontWithName:PFR size:14]];
    [SVProgressHUD setForegroundColor:[UIColor dc_colorWithHexString:@"#333333"]];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
}

#pragma mark - 显示网络请求时顶部小圆圈
- (void)addActivity
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

#pragma mark - 初始化微信sdk
- (void)initWXSDK{
    
    //在register之前打开log, 后续可以根据log排查问题
//    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
//        NSLog(@"WeChatSDK: %@", log);
//    }];

    //务必在调用自检函数前注册
    [WXApi registerApp:DCWX_AppKey universalLink:WX_APP_UniversalLink];

//    //调用自检函数
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//        NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//    }];
}



#pragma mark - Bugly初始化
- (void)initBugly{
    BuglyConfig *config = [[BuglyConfig alloc] init];
    //#if DEBUG
    config.debugMode = YES;
    //#endif
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    config.channel = @"AppStore";
    config.version = APP_VERSION;
    config.deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    config.delegate = self;
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    config.reportLogLevel = BuglyLogLevelWarn;
    
    [Bugly startWithAppId:DCBugly_AppiD config:config];
}

#pragma mark - 友盟
- (void)confitUShareSettings
{
    /*
     *打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = NO;
    /*
     *关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败

    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):WX_APP_UniversalLink,
    @(UMSocialPlatformType_QQ):DCQQ_APP_UniversalLink
    };
}

#pragma mark - 初始化友盟所有组件产品
- (void)configUconfigure
{
    /** 初始化友盟所有组件产品
     @param appKey 开发者在友盟官网申请的appkey.
     @param channel 渠道标识，可设置nil表示"App Store".
     */
    
    NSString *deviceID = [UMConfigure deviceIDForIntegration];
    NSLog(@"集成测试的deviceID:%@", deviceID);
    /* 设置友盟appkey */
    [UMConfigure setEncryptEnabled:YES];//打开加密传输 YES 表示加密
    //#warning 打包的h时候要打开 NO
    [UMConfigure setLogEnabled:NO];//发布的时候必须设置成NO
    
    //开发者需要显式的调用此函数，日志系统才能工作
    //[UMCommonLogManager setUpUMCommonLogManager];
    
    [UMConfigure initWithAppkey:DCUM_AppKey channel:@"App Store"];


    //设置为自动采集页面
    [MobClick setAutoPageEnabled:YES];

}


#pragma mark - 初始化友盟分享
- (void)configUSharePlatfcorms
{

    [[UMSocialManager defaultManager] openLog:YES];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession|UMSocialPlatformType_WechatTimeLine appKey:DCWX_AppKey appSecret:DCWX_AppSecret redirectURL:@"http://mobile.umeng.com/social"];
    /*
     *移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:DCQQ_AppKey /*设置QQ平台的appID*/  appSecret:DCQQ_AppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:DCSina_AppKey  appSecret:DCSina_AppSecret redirectURL:@"http://mobile.umeng.com/social"];
}

#pragma mark - 初始化极光推送
- (void)initJPushWithOptions:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL apsForProduction = NO;
#ifdef DEBUG
    apsForProduction = NO;
#else
    apsForProduction = YES;
#endif
    
    [JPUSHService setupWithOption:launchOptions appKey:DCJPush_AppKey
                          channel:@"App Store"
                 apsForProduction:apsForProduction
            advertisingIdentifier:nil];
    
    // 获取 registrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
    }];
}


#pragma mark - <JPUSHRegisterDelegate>
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    /*Add_HX_标识
     *将得到的deviceToken传给环信SDK
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDClient sharedClient] bindDeviceToken:deviceToken];
    });
}


#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *)) {
        if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    } else {
        // Fallback on earlier versions
    }
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // 获取到通知 ，根据具体内容操作通知
    //    if (userInfo && userInfo[@"type"]) {
    //        if ([userInfo[@"type"] integerValue] == 1) {
    //            // 掉线通知
    //            [[QYLoginTool shareTool] dc_showOfflineView];
    //        }
    //    }
    NSLog(@">>>>>>>>%@",notification);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    } else {
        // 本地通知
    }
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //NSDictionary *apsDic = [userInfo objectForKey:@"aps"];
        NSString *fstr = [userInfo objectForKey:@"f"];
        if (fstr.length > 0) {
            [DCObjectManager dc_removeFileByFileName:DC_HX_Notification_Key];
            [DCObjectManager dc_saveObject:userInfo byFileName:DC_HX_Notification_Key];
        }
        //[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"服务器通知%@",@"A"]];
        [JPUSHService handleRemoteNotification:userInfo];
        // 点击了通知。要处理通知
        [self responseEventNotiction:userInfo];
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DC_HXMessageCheck_NotificationName2 object:userInfo];
        //[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"本地通知%@",@"A"]];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 监听到通知
- (void)networkDidReceiveMessage:(NSNotification *)sender
{
//    NSDictionary *dictionary = sender.userInfo;
//    NSLog(@"获取到通知 - %@",dictionary);
}


#pragma mark - 通知处理
- (void)responseEventNotiction:(NSDictionary *)dict
{
    
    //    NSString *url = [DCObjectManager dc_readUserDataForKey:DC_H5_Key];
    //    NSString *url1 = [DCObjectManager dc_readUserDataForKey:DC_PersonH5_Key];
    
    NSString *url = DC_H5BaseUrl;
    NSString *url1 = Person_H5BaseUrl;
    
    NSString *pageType=dict[@"msgType"];//11:采购商订单 12:个人订单
    NSString *pkid=dict[@"pkid"];
    if ([pageType isEqualToString:@"12"])
    {
        GLPH5ViewController *vc = [GLPH5ViewController new];
        UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.path = [NSString stringWithFormat:@"%@/geren/detail.html?id=%@",url1,pkid];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }
    else if ([pageType isEqualToString:@"11"])
    {
        DCH5ViewController *vc = [DCH5ViewController new];
        UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.path = [NSString stringWithFormat:@"%@/qiye/order_detail.html?id=%@",url,pkid];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - <BuglyDelegate>
- (NSString *BLY_NULLABLE)attachmentForException:(NSException *BLY_NULLABLE)exception{
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    return @"This is an attachment";
}

#pragma mark - 支付宝支付处理逻辑 ios9.0之后版本
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if ([MobClick handleUrl:url]) {
        return YES;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@",url.absoluteString];
    if ([urlStr containsString:@"jldpurchase://gotoapp.com"])
    {
        [self dc_openAppWithUrl:urlStr];
    }

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        //其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"支付宝支付结果 = %@",resultDic);
                [[NSNotificationCenter defaultCenter]postNotificationName:DC_AlipayResulkt_NotificationName object:self userInfo:resultDic];
            }];
        }else if ([url.host isEqualToString:@"oauth"] || [url.host isEqualToString:@"pay"] || [url.host isEqualToString:@"wapoauth"]){
            //微信登录/支付
            return [WXApi handleOpenURL:url delegate:self];
        }
        
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
            
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    return result;
}

#pragma mark - UniversalLink 必须实现的方法处理
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))restorationHandler{
    if(![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]){
        // 其他SDK的回调
        if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]){
            NSURL *webpageURL = userActivity.webpageURL;
            NSString *host = [webpageURL absoluteString];
            if ([host containsString:WX_APP_UniversalLink]) {
                return [WXApi handleOpenUniversalLink:userActivity delegate:self];
            }else if([host containsString:DCQQ_APP_UniversalLink]){

            }else{
                [[UIApplication sharedApplication]openURL:webpageURL];
             }
        }
    }
    return YES;
}

#pragma mark - 微信支付回调
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;

        NSDictionary *dict = [response mj_JSONObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:DC_WxPayResulkt_NotificationName object:self userInfo:dict];
        NSLog(@"微信支付结果 - %@",dict);
    }

    // 向微信请求授权后,得到响应结果
    //    if ([resp isKindOfClass:[SendAuthResp class]]) {
    //        SendAuthResp *temp = (SendAuthResp *)resp;
    //
    //        if([temp.state isEqualToString:@"wx_oauth_authorization_state"]){//微信授权成功
    //            NSString *code = temp.code; //获得code
    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXLoginCode" object:self userInfo:@{@"code":code}];
    //        }
    //    }
}



#pragma mark - 唤起App操作
- (void)dc_openAppWithUrl:(NSString *)url
{
    //    jldpurchase://gotoapp.com/?type=1&batchId&id=1
    
    if ([url containsString:@"?"]) {
        NSString *paramStr = [url componentsSeparatedByString:@"?"][1];
        if ([paramStr containsString:@"&"]) {
            
            NSString *type = @"";
            NSString *iD = @"";
            NSString *batchId = @"";
            NSString *utmUserId;
            NSString *goodsId = @"";
            NSString *pioneerUserId = @"";
            NSString *stm;
            NSArray *array = [paramStr componentsSeparatedByString:@"&"];
            for (NSInteger i = 0; i<array.count; i++) {
                NSString *subStr = array[i];
                
                // type
                if ([subStr containsString:@"type"]) {
                    if ([subStr containsString:@"="]) {
                        type = [subStr componentsSeparatedByString:@"="][1];
                    } else {
                        type = subStr;
                    }
                }
                
                // iD
                if ([subStr containsString:@"id"]) {
                    if ([subStr containsString:@"="]) {
                        iD = [subStr componentsSeparatedByString:@"="][1];
                    } else {
                        iD = subStr;
                    }
                }
                
                // batchId
                if ([subStr containsString:@"batchId"]) {
                    if ([subStr containsString:@"="]) {
                        batchId = [subStr componentsSeparatedByString:@"="][1];
                    } else {
                        batchId = subStr;
                    }
                }
                
                
                // utmUserId
                if ([subStr containsString:@"utmUserId"]) {
                    if ([subStr containsString:@"="]) {
                        utmUserId = [subStr componentsSeparatedByString:@"="][1];
                    } else {
                        utmUserId = subStr;
                    }
                    [DCObjectManager dc_saveUserData:utmUserId forKey:@"utmUserId"];
                    [DCObjectManager dc_saveUserData:[DCSpeedy getCurrentTimes] forKey:@"rtime"];
                }
                
                if ([subStr containsString:@"goodsId"]) {
                    if ([subStr containsString:@"="]) {
                        goodsId = [subStr componentsSeparatedByString:@"="][1];
                    } else {
                        goodsId = subStr;
                    }
                    [DCObjectManager dc_saveUserData:goodsId forKey:@"goodsId"];
                }
                [DCObjectManager dc_saveUserData:goodsId forKey:@"goodsId"];
                if ([subStr containsString:@"stm"]) {
                    if ([subStr containsString:@"="]) {
                        stm = [subStr componentsSeparatedByString:@"="][1];
                    } else {
                        stm = subStr;
                    }
                    [DCObjectManager dc_saveUserData:stm forKey:@"stm"];
                }
                
                // pioneerUserId
                if ([subStr containsString:@"pioneerUserId"]) {
                    if ([subStr containsString:@"="]) {
                        pioneerUserId = [subStr componentsSeparatedByString:@"="][1];
                    } else {
                        pioneerUserId = subStr;
                    }
                    [DCObjectManager dc_saveUserData:pioneerUserId forKey:@"pioneerUserId"];
                }
                
                
            }
            
            if ([type isEqualToString:@"1"]) { // 个人版 - 店铺详情
                
                [self dc_pushPersonStoreController:iD];
                
            } else if ([type isEqualToString:@"2"]) { // 个人版 - 商品详情
                
                if (stm.length >1) {
                    [DCObjectManager dc_saveUserData:iD forKey:@"goodsId"];
                    [self dc_pushPersonGoodsController2:iD];
                }else{
                    [self dc_pushPersonGoodsController:iD];
                }
                
            } else if ([type isEqualToString:@"3"]) { // 企业版 - 店铺详情
                
                [self dc_pushCompanyStoreController:iD];
                
            } else if ([type isEqualToString:@"4"]) { // 企业版 - 商品详情
                
                [self dc_pushCompanyGoodsController:iD];
            }
            
            [DCObjectManager dc_saveUserData:@"1" forKey:@"Share"];
        }
    }
}


#pragma mark - 跳转 个人店铺详情
- (void)dc_pushPersonStoreController:(NSString *)iD
{
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
            
            TRStorePageVC *vc = [[TRStorePageVC alloc] init];
            vc.firmId=iD;
            UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
            DCNavigationController *nav = tabber.selectedViewController;
            [nav pushViewController:vc animated:YES];
            
            
        } else { // 未登录个人
            
            if ([DCObjectManager dc_readUserDataForKey:DC_Token_Key]) { // 已登录企业
                
                [self dc_showExchangePerson];
                
            } else { // 未登录企业
                
                [[DCLoginTool shareTool] dc_logoutWithPerson];
            }
        }
        
    } else {
        
        [self dc_addTimerWithType:@"1" iD:iD];
    }
    
}
#pragma mark - 跳转 个人商品详情
- (void)dc_pushPersonGoodsController2:(NSString *)iD
{
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
            
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId=iD;
            UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
            DCNavigationController *nav = tabber.selectedViewController;
            [nav pushViewController:vc animated:YES];
            NSString *stm = [DCObjectManager dc_readUserDataForKey:@"stm"];
            NSString *usei = [DCObjectManager dc_readUserDataForKey:@"utmUserId"];
            [[DCAPIManager shareManager] dc_promote:iD Stm:stm utmUserId:usei success:^(id response) {
                if (response) {
                    
                }
            } failture:^(NSError *error) {
                if (error) {
                    
                }
            }];
            [DCObjectManager dc_removeUserDataForkey:@"goodsId"];
            [DCObjectManager dc_removeUserDataForkey:@"stm"];
            [DCObjectManager dc_removeUserDataForkey:@"utmUserId"];
            [DCObjectManager dc_removeUserDataForkey:@"rtime"];
        } else { // 未登录个人
            
            if ([DCObjectManager dc_readUserDataForKey:DC_Token_Key]) { // 已登录企业
                
                [self dc_showExchangePerson];
                
            } else { // 未登录企业
                
                [[DCLoginTool shareTool] dc_logoutWithPerson];
            }
            
        }
        
    } else {
        
        //        [self dc_addTimerWithType:@"2" iD:iD];
    }
}

#pragma mark - 跳转 个人商品详情
- (void)dc_pushPersonGoodsController:(NSString *)iD
{
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
            
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId=iD;
            UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
            DCNavigationController *nav = tabber.selectedViewController;
            [nav pushViewController:vc animated:YES];
            //            NSString *stm = [DCObjectManager dc_readUserDataForKey:@"stm"];
            //            NSString *usei = [DCObjectManager dc_readUserDataForKey:@"utmUserId"];
            //            [[DCAPIManager shareManager] dc_promote:iD Stm:stm utmUserId:usei success:^(id response) {
            //                if (response) {
            //
            //                }
            //            } failture:^(NSError *error) {
            //                if (error) {
            //
            //                }
            //            }];
            //            [DCObjectManager dc_removeUserDataForkey:@"goodsId"];
            //            [DCObjectManager dc_removeUserDataForkey:@"stm"];
            //            [DCObjectManager dc_removeUserDataForkey:@"utmUserId"];
            //            [DCObjectManager dc_removeUserDataForkey:@"rtime"];
        } else { // 未登录个人
            
            if ([DCObjectManager dc_readUserDataForKey:DC_Token_Key]) { // 已登录企业
                
                [self dc_showExchangePerson];
                
            } else { // 未登录企业
                
                [[DCLoginTool shareTool] dc_logoutWithPerson];
            }
            
        }
        
    } else {
        
        [self dc_addTimerWithType:@"2" iD:iD];
    }
}


#pragma mark - 跳转 企业店铺详情
- (void)dc_pushCompanyStoreController:(NSString *)iD
{
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
            
            [self dc_showExchangeCompany];
            
        } else { // 未登录个人
            
            GLBStorePageController *vc = [[GLBStorePageController alloc] init];
            vc.firmId = iD;
            UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
            DCNavigationController *nav = tabber.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
        
    } else {
        
        [self dc_addTimerWithType:@"3" iD:iD];
    }
    
}


#pragma mark - 跳转 企业商品详情
- (void)dc_pushCompanyGoodsController:(NSString *)iD
{
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
            
            [self dc_showExchangeCompany];
            
        } else { // 未登录个人
            
            GLBGoodsDetailController *vc = [[GLBGoodsDetailController alloc] init];
            vc.goodsId=iD;
            UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
            DCNavigationController *nav = tabber.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
        
    } else {
        
        [self dc_addTimerWithType:@"4" iD:iD];
    }
}



#pragma mark - showAlter
- (void)dc_showExchangePerson
{
    if ([DCObjectManager dc_readUserDataForKey:DC_Token_Key]) { // 已登录企业
        
        BOOL hasShow = NO;
        for (id class in DC_KeyWindow.subviews) {
            if ([class isKindOfClass:[DCAlterView class]]) {
                hasShow = YES;
            }
        }
        
        if (hasShow == YES) {
            return;
        }
        
        DCAlterView *alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"切换个人版需要退出当前账号重新登录,是否切换？"];
        [alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            
            [[DCAPIManager shareManager] dc_requestLogoutWithSuccess:^(id response) {
                
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                } seq:0];
                [JPUSHService deleteTags:[NSSet setWithObject:@"jld_enterprise"] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    
                } seq:0];
                [[DCLoginTool shareTool] dc_logoutWithCompany];
                
            } failture:^(NSError *_Nullable error) {
    }];
        }];
        [DC_KeyWindow addSubview:alterView];
        [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
        
    }
    
    //    else { // 未登录企业
    //
    //        [[DCLoginTool shareTool] dc_logoutWithCompany];
    //    }
}


#pragma mark - showAlter
- (void)dc_showExchangeCompany
{
    BOOL hasShow = NO;
    for (id class in DC_KeyWindow.subviews) {
        if ([class isKindOfClass:[DCAlterView class]]) {
            hasShow = YES;
        }
    }
    
    if (hasShow == YES) {
        return;
    }
    
    DCAlterView *alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"切换企业版需要退出当前账号重新登录,是否切换？"];
    [alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
    [alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
        
        [[DCAPIManager shareManager] person_requestLogoutWithSuccess:^(id response) {
            [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:0];
            [JPUSHService deleteTags:[NSSet setWithObject:@"jld_person"] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                
            } seq:0];
            [[DCLoginTool shareTool] dc_logoutWithPerson];
        } failture:^(NSError *_Nullable error) {
    }];
        
    }];
    [DC_KeyWindow addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(DC_KeyWindow);
    }];
}


#pragma mark - 添加倒计时
- (void)dc_addTimerWithType:(NSString *)type iD:(NSString *)iD
{
    self.index = 0;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo:) userInfo:@{@"type":type,@"iD":iD} repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}


#pragma mark - 倒计时
- (void)timeGo:(NSTimer *)sender
{
    self.index ++;
    if (self.index > 30) {
        self.index = 0;
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSDictionary *params = sender.userInfo;
    NSLog(@" - %@",params);
    
    NSString *iD = @"";
    if (params && params[@"iD"]) {
        iD = params[@"iD"];
    }
    
    NSString *type = @"";
    if (params && params[@"type"]) {
        type = params[@"type"];
    }
    
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        [self.timer invalidate];
        self.timer = nil;
        self.index = 0;
        
        if ([type isEqualToString:@"1"]) { // 个人版 - 店铺详情
            
            if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
                
                TRStorePageVC *vc = [[TRStorePageVC alloc] init];
                vc.firmId=iD;
                UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
                DCNavigationController *nav = tabber.selectedViewController;
                [nav pushViewController:vc animated:YES];
                
            } else { // 未登录个人
                
                if ([DCObjectManager dc_readUserDataForKey:DC_Token_Key]) { // 已登录企业
                    
                    [self dc_showExchangePerson];
                    
                } else { // 未登录企业
                    
                    [[DCLoginTool shareTool] dc_logoutWithPerson];
                }
            }
            
        } else if ([type isEqualToString:@"2"]) { // 个人版 - 商品详情
            
            if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
                
                GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
                vc.goodsId=iD;
                UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
                DCNavigationController *nav = tabber.selectedViewController;
                [nav pushViewController:vc animated:YES];
                
            } else { // 未登录个人
                
                if ([DCObjectManager dc_readUserDataForKey:DC_Token_Key]) { // 已登录企业
                    [self dc_showExchangePerson];
                } else { // 未登录企业
                    [[DCLoginTool shareTool] dc_logoutWithPerson];
                }
            }
            
        } else if ([type isEqualToString:@"3"]) { // 企业版 - 店铺详情
            
            if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
                
                [self dc_showExchangeCompany];
                
            } else { // 未登录个人
                
                GLBStorePageController *vc = [[GLBStorePageController alloc] init];
                vc.firmId = iD;
                UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
                DCNavigationController *nav = tabber.selectedViewController;
                [nav pushViewController:vc animated:YES];
            }
            
        } else if ([type isEqualToString:@"4"]) { // 企业版 - 商品详情
            
            if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) { // 已登录个人
                
                [self dc_showExchangeCompany];
                
            } else { // 未登录个人
                
                GLBGoodsDetailController *vc = [[GLBGoodsDetailController alloc] init];
                vc.goodsId=iD;
                UITabBarController *tabber = (UITabBarController *)self.window.rootViewController;
                DCNavigationController *nav = tabber.selectedViewController;
                [nav pushViewController:vc animated:YES];
            }
        }
        
    } else if ([self.window.rootViewController isKindOfClass:[DCNavigationController class]]){
        
        DCNavigationController *nav = (DCNavigationController *)self.window.rootViewController;
        UIViewController *vc = nav.childViewControllers.firstObject;
        if ([vc isKindOfClass:[GLBOpenTypeController class]] || [vc isKindOfClass:[GLBGuideController class]]) {
            
            self.index = 0;
            [self.timer invalidate];
            self.timer = nil;
            
            if ([type isEqualToString:@"3"]) {
                
                GLBStorePageController *vc = [[GLBStorePageController alloc] init];
                vc.firmId = iD;
                [nav pushViewController:vc animated:YES];
                
            } else if ([type isEqualToString:@"4"]) {
                
                GLBGoodsDetailController *vc = [[GLBGoodsDetailController alloc] init];
                vc.goodsId=iD;
                [nav pushViewController:vc animated:YES];
            }
        }
    }
}



@end
