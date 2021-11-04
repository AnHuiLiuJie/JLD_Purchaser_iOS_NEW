//
//  HDPushManager.h
//  helpdesk_sdk
//
//  Created by 杜洁鹏 on 2021/1/8.
//  Copyright © 2021 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDPushManager : NSObject

@property (nonatomic, strong, readonly) HDPushOptions *pushOptions;

/*!
 *  \~chinese
 *  开启离线推送
 *
 *  同步方法，会阻塞当前线程
 *
 *  @result 错误信息
 *
 *  \~english
 *  Enable Apns
 *
 *  Synchronization method will block the current thread
 *
 *  @result Error
 */
- (HDError *)enableOfflinePush;


/*!
 *  \~chinese
 *  关闭离线推送
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aStartHour    开始时间
 *  @param aEndHour      结束时间
 *
 *  @result              错误信息
 *
 *  \~english
 *  Disable Apns
 *
 *  Synchronization method will block the current thread
 *
 *  @param aStartHour    start time
 *  @param aEndHour      end time
 *
 *  @result Error
 */
- (HDError *)disableOfflinePushStart:(int)aStartHour end:(int)aEndHour;


/*!
 *  \~chinese
 *  设置推送消息显示的样式
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pushDisplayStyle  要设置的推送样式
 *
 *  @result 错误信息
 *
 *  \~english
 *  Set display style for Apple Push Notification message
 *
 *  Synchronization method will block the current thread
 *
 *  @param pushDisplayStyle  Display style
 *
 *  @result Error
 */
- (HDError *)updatePushDisplayStyle:(HDPushDisplayStyle)pushDisplayStyle;


/*!
 *  \~chinese
 *  设置推送的显示名
 *
 *  @param pushDisplayStyle     推送显示样式
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Set display style for the push notification
 *
 *  @param pushDisplayStyle     Display style of push
 *  @param aCompletionBlock     The callback block of completion
 */
- (void)updatePushDisplayStyle:(HDPushDisplayStyle)pushDisplayStyle
                    completion:(void (^)(HDError *error))aCompletionBlock;


/*!
 *  \~chinese
 *  设置推送消息显示的昵称
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aNickname  要设置的昵称
 *
 *  @result 错误信息
 *
 *  \~english
 *  Set display name for Apple Push Notification message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aNickname  Display name
 *
 *  @result Error
 */
- (HDError *)updatePushDisplayName:(NSString *)aDisplayName;

/*!
 *  \~chinese
 *  设置推送的显示名
 *
 *  @param aDisplayName     推送显示名
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Set display name for the push notification
 *
 *  @param aDisplayName     Display name of push
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updatePushDisplayName:(NSString *)aDisplayName
                   completion:(void (^)(NSString *aDisplayName, HDError *aError))aCompletionBlock;



/*!
 *  \~chinese
 *  从服务器获取推送属性
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError  错误信息
 *
 *  @result 推送属性
 *
 *  \~english
 *  Get Apple Push Notification Service options from the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError  Error
 *
 *  @result Apple Push Notification Service options
 */
- (HDPushOptions *)getPushOptionsFromServerWithError:(HDError *_Nullable *_Nullable)pError;

/*!
 *  \~chinese
 *  从服务器获取推送属性
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Get Apple Push Notification Service options from the server
 *
 *  @param aCompletionBlock The callback of completion block
 */
- (void)getPushNotificationOptionsFromServerWithCompletion:(void (^)(HDPushOptions *aOptions, HDError *aError))aCompletionBlock;


@end

NS_ASSUME_NONNULL_END
