//
//  GLBNotificationMsgController.h
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface GLBNotificationMsgController : DCTabViewController

// type = 0 系统消息 type =1 订单消息
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
