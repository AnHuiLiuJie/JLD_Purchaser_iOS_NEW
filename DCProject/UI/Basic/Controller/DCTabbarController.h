//
//  DCTabbarController.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HConversationsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCTabbarController : UITabBarController
{
    HConnectionState _connectionState;
}


#pragma mark - 环信
/*Add_HX_标识
 *集成方法
 */

- (void)_setupUnreadMessageCount;

- (void)networkChanged:(HConnectionState)connectionState;

- (void)didReceiveUserNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0));

- (void)_playSoundAndVibration;

- (void)_showNotificationWithMessage:(NSArray *)messages;
@end

NS_ASSUME_NONNULL_END
