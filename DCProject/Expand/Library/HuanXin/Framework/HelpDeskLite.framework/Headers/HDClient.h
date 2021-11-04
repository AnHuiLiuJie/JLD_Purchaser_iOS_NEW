//
//  ChatClient.h
//  helpdesk_sdk
//
//  Created by ZXG on 16/3/29.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "HDMessage.h"
#import "HDMessage+Content.h"
#import "HDMessage+Menu.h"
#import "HDChatManager.h"
#import "HDOptions.h"
#import "HDClientDelegate.h"
#import "HDLeaveMsgManager.h"
#import "HDConversation.h"
#import "HDError.h"
#import "HDPushOptions.h"
#import "HDjudgeTextMessageSubType.h"
#import "HDMessageHelper.h"
#import "HDPushManager.h"
// resued concept

@interface HDClient :NSObject<HDClientDelegate>
/*!
 *  \~chinese
 *  当前登录账号
 *
 *  \~english
 *  Current logined account
 */
@property (nonatomic, strong, readonly) NSString *currentUsername;

/**
 当前SDK 版本
 */
@property (nonatomic, copy) NSString *sdkVersion;

/**
 当前IM版本号
 */
@property (nonatomic, copy) NSString *imSdkVersion;

/**
 开启等待提示
 */
@property (nonatomic, assign) BOOL enableVisitorWaitCount;

/*!
 *  \~chinese
 *  推送设置
 *
 *  \~english
 *  Apple Push Notification Service setting
 */
@property (nonatomic, strong, readonly) HDPushOptions *hdPushOptions;

/*!
 *  \~chinese
 *  聊天消息管理模块
 *
 *  \~english
 *  Chat module
 */
@property (nonatomic, strong, readonly) HDChatManager *chatManager;

/*!
 *  \~chinese
 *  推送管理模块
 *
 *  \~english
 *  Chat module
 */
@property (nonatomic, strong, readonly) HDPushManager *pushManager;

/*!
 *  \~chinese
 *  用户是否已登录
 *
 *  \~english
 *  Whether user has logged in
 */
@property (nonatomic, readonly) BOOL isLoggedInBefore;


/*!
 *  \~chinese
 *  获取SDK实例
 *
 *  \~english
 *  Get SDK single instance
 */
+ (instancetype)sharedClient;

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<HDClientDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<HDClientDelegate>)aDelegate;

#pragma mark - Initialize SDK

/*!
 *  \~chinese
 *  初始化sdk
 *
 *  @param aOptions  SDK配置项
 *
 *  @result 错误信息
 *
 *  \~english
 *  Initialization sdk
 *
 *  @param aOptions  SDK setting options
 *
 *  @result Error
 */
- (HDError *)initializeSDKWithOptions:(HDOptions *)aOptions;

#pragma mark - Register

/*!
 *  \~chinese
 *  注册用户
 *
 *  同步方法，会阻塞当前线程. 不推荐使用，建议后台通过REST注册
 *
 *  @param aUsername  用户名
 *  @param aPassword  密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Register a new user
 *
 *  Synchronization method will block the current thread. It is not recommended, advise to register new user through REST API
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (HDError *)registerWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword;

#pragma mark - Login

/*!
 *  \~chinese
 *  登录
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername  用户名
 *  @param aPassword  密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Login
 *
 *  Synchronization method will block the current thread
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (HDError *)loginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword;

/*!
 *  \~chinese
 *  登录
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername  用户名
 *  @param aToken  token
 *
 *  @result 错误信息
 *
 *  \~english
 *  Login
 *
 *  Synchronization method will block the current thread
 *
 *  @param aUsername  Username
 *  @param aToken  token
 *
 *  @result Error
 */
- (HDError *)loginWithUsername:(NSString *)aUsername
                        token:(NSString *)aToken;

#pragma makr - Logout

/*!
 *  \~chinese
 *  退出
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param bIsUnbindDeviceToken 是否解除device token的绑定，解除绑定后设备不会再收到消息推送
 *         如果传入YES, 解除绑定失败，将返回error
 *
 *  @result 错误信息
 *
 *  \~english
 *  Logout
 *
 *  Synchronization method will block the current thread
 *
 *  @param bIsUnbindDeviceToken Whether unbind device token, device will don't receive message push after unbind token, if input YES, unbind failed will return error
 *
 *  @result Error
 */
- (HDError *)logout:(BOOL)bIsUnbindDeviceToken;

#pragma mark - Apns

/*!
 *  \~chinese
 *  绑定device token
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aDeviceToken  要绑定的token
 *
 *  @result 错误信息
 *
 *  \~english
 *  Bind device token
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDeviceToken  Device token to bind
 *
 *  @result Error
 */
- (HDError *)bindDeviceToken:(NSData *)aDeviceToken;




#pragma mark - iOS

/*!
 *  \~chinese
 *  iOS专用，程序进入后台时，需要调用此方法断开连接
 *
 *  @param aApplication  UIApplication
 *
 *  \~english
 *  iOS only, should call this method to disconnect from server when app enter backgroup
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationDidEnterBackground:(id)aApplication;

/*!
 *  \~chinese
 *  iOS专用，程序进入前台时，需要调用此方法进行重连
 *
 *  @param aApplication  UIApplication
 *
 *  \~english
 *  iOS only, should call this method to re-connect to server when app restore to foreground
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationWillEnterForeground:(id)aApplication;


#pragma mark - Change AppKey

/*!
 *  \~chinese
 *  修改appkey
 *
 *  @param aAppkey  appkey
 *
 *  @result 错误信息
 *
 *  \~english
 *  change appkey
 *
 *  @param aAppkey  appkey
 *
 *  @result Error
 */
- (HDError *)changeAppKey:(NSString *)appKey;

/**
 改变tenantId

 @param tenantId
 @return error
 */
- (void)changeTenantId:(NSString *)tenantId;

/**
 * 获取当前客服服务器地址 host
 *
 */
- (NSString *)kefuRestServer;


/**
 * 获取IM用户的token
 *
 */
- (NSString *) accessToken;


/*!
 *  \~chinese
 *  留言管理模块
 *
 *  \~english
 *  LeaveMsgManager module
 */
@property (nonatomic, strong, readonly) HDLeaveMsgManager *leaveMsgManager;




#pragma mark - deprecated
@property (nonatomic, readonly) BOOL isAutoLogin __attribute__((deprecated("已过期")));
@property (nonatomic, strong, readonly) HDChatManager *chat __attribute__((deprecated("已过期, 请使用chatManager")));
@property (nonatomic, readonly) BOOL isConnected __attribute__((deprecated("已过期")));
@property (nonatomic,copy) NSString *currentVersion __attribute__((deprecated("已过期, 请使用sdkVersion")));
@property (nonatomic,copy) NSString *imCurrentVersion __attribute__((deprecated("已过期, 请使用imSdkVersion")));

- (NSString *)getUserToken __attribute__((deprecated("已过期, 请使用accessToken")));
- (HDError *)setApnsNickname:(NSString *)aNickname __attribute__((deprecated("已过期, 请使用HDPushManager: updatePushDisplayName")));

- (HDPushOptions *)getPushOptionsFromServerWithError:(HDError **)pError __attribute__((deprecated("已过期, 请使用HDPushManager: getPushOptionsFromServerWithError:")));
- (HDError *)updatePushOptionsToServer:(HDPushOptions *)HDPushOptions  __attribute__((deprecated("已过期")));

@end
