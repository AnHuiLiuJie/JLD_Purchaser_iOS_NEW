//
//  AppDelegate+EaseMob.h
//  EasMobSample
//
//  Created by dujiepeng on 12/5/14.
//  Copyright (c) 2014 dujiepeng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HelpDesk)<UIAlertViewDelegate,HDClientDelegate>
- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)resetCustomerServiceSDK;
- (void)userAccountDidRemoveFromServer ;
- (void)userAccountDidLoginFromOtherDevice;

//环信登录
- (void)huanxinLogin:(id)tabbar successBlock:(dispatch_block_t)successBlock failBlock:(dispatch_block_t)failBlock;

//环信退出
- (void)huanxinLogOut;

@end
