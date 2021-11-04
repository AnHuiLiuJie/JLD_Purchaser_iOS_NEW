//
//  AppDelegate+SDK.h
//  DCProject
//
//  Created by bigbing on 2019/3/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//#import "WXApi.h"//至于要引用友盟的微信头文件
#import <WechatOpenSDK/WXApi.h>//使用微信支付的界面


NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (SDK)<BuglyDelegate,UNUserNotificationCenterDelegate,JPUSHRegisterDelegate,WXApiDelegate>

// 初始化三方SDK
- (void)initSDKWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
