//
//  DCPermitTool.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCPermitTool : NSObject


+ (DCPermitTool *) shareTool;


#pragma mark - 获取是否具有通知权限
- (BOOL)dc_isCanNotification;


#pragma mark - 跳转到通知设置界面
- (void)dc_openSetController;

@end

NS_ASSUME_NONNULL_END
