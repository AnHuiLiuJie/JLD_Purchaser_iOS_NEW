//
//  DCLoginTool.h
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCLoginTool : NSObject


#pragma mark - 单列
+ (DCLoginTool *) shareTool;


#pragma mark - 判断用户是否登陆
- (BOOL)dc_isLogin;


#pragma mark - 弹出登陆页
- (void)dc_pushLoginController;


#pragma mark -
- (void)dc_aaaaaaLoginController;


#pragma mark - 弹出登陆页 带回调
- (void)dc_pushLoginControllerSuccessBlock:(dispatch_block_t)successBlock;


//#pragma mark - 弹出登陆页 个人
//- (void)dc_pushLoginControllerWithPerson;
//
//
//#pragma mark - 弹出登陆页 带回调 个人
//- (void)dc_pushLoginControllerWidthPersonSuccessBlock:(dispatch_block_t)successBlock;


#pragma mark - 退出登录（企业版）
- (void)dc_logoutWithCompany;


#pragma mark - 移除登陆本地保存的数据（企业版）
- (void)dc_removeLoginDataWithCompany;


#pragma mark - 绑定推送别名 （企业版）
- (void)dc_bindAliesWithCompany;


#pragma mark - 解除别名绑定 （企业版）
- (void)dc_deleteAliesWithCompany;


#pragma mark - 显示掉线通知
- (void)dc_showOfflineView;



#pragma mark - 退出登录个人版
- (void)dc_logoutWithPerson;

@end

NS_ASSUME_NONNULL_END
