//
//  DCPermitTool.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCPermitTool.h"
#import <UserNotifications/UserNotifications.h>

@implementation DCPermitTool

+ (DCPermitTool *) shareTool {
    static DCPermitTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


#pragma mark - 获取是否具有通知权限
- (BOOL)dc_isCanNotification{
    __block BOOL enabled = NO;
    if (@available(iOS 10.0, *)) {
        dispatch_semaphore_t sem;
        sem = dispatch_semaphore_create(0);
        UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        [notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *_Nonnull settings) {
            switch (settings.authorizationStatus) {
                case UNAuthorizationStatusAuthorized:
                    enabled = YES;
                    break;
                default:
                    break;
            }
            dispatch_semaphore_signal(sem);
        }];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER); //获取通知设置的过程是异步的，这里需要等待
    } else {
        UIApplication *application = [UIApplication sharedApplication];
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
            UIUserNotificationSettings *settings = [application currentUserNotificationSettings];
            if (settings.types != UIUserNotificationTypeNone) {
                enabled = YES;
            }
        }
    }
    return enabled;
}


#pragma mark - 跳转到通知设置界面
- (void)dc_openSetController
{
    if (UIApplicationOpenSettingsURLString != NULL) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:URL options:@{} completionHandler:nil];
            } else {
                [application openURL:URL];
            }
        } else {
            [application openURL:URL];
        }
    }
}

@end
