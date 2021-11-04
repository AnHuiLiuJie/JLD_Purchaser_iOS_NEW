//
//  HConversationsViewController.h
//  CustomerSystem-ios
//
//  Created by afanda on 6/8/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HConversationsViewController : HDRefreshTableViewController

//刷新会话列表
- (void)refreshData;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(HConnectionState)connectionState;


@end
