//
//  DCLoginTool.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCLoginTool.h"

#import "DCNavigationController.h"
#import "DCLoginController.h"
#import "GLBGuideController.h"

#import "UINavigationController+WXSTransition.h"
#import "JPUSHService.h"

/*Add_环信_标识
 *
 */
#import "AppDelegate+HelpDesk.h"
#import "GLBOpenTypeController.h"

@implementation DCLoginTool


#pragma mark - 单列
+ (DCLoginTool *) shareTool {
    static DCLoginTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


#pragma mark - 判断用户是否登陆
- (BOOL)dc_isLogin {
    if ([DCObjectManager dc_readUserDataForKey:DC_UserID_Key]) {
        return YES;
    }
    if ([DCObjectManager dc_readUserDataForKey:P_UserID_Key]) {
        return YES;
    }
    return NO;
}


#pragma mark - 弹出登陆页
- (void)dc_pushLoginController {
    
    if ([[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue] == DCUserTypeWithPerson) {
        [self dc_logoutWithPerson];
        return;
    }
    
    /*Add_HX_标识
     *退出环信
     */
    [DC_Appdelegate huanxinLogOut];
    // 清除本地字段
    [self dc_removeLoginDataWithCompany];
    [self dc_deleteAliesWithCompany];
    
    DCLoginController *vc = [DCLoginController new];
    vc.isPresent = YES;
    
    DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
    [DC_KeyWindow.rootViewController wxs_presentViewController:nav makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType = WXSTransitionAnimationTypeSysPushFromRight;
        transition.animationTime = 0.25;
    } completion:nil];
}


#pragma mark -
- (void)dc_aaaaaaLoginController {
    
    if ([[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue] == DCUserTypeWithPerson) {
        [self dc_logoutWithPerson];
        return;
    }
    
    /*Add_HX_标识
     *退出环信
     */
    [DC_Appdelegate huanxinLogOut];
    // 清除本地字段
    [self dc_removeLoginDataWithCompany];
    [self dc_deleteAliesWithCompany];
    
    DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBGuideController new]];
    
//    DCLoginController *vc = [DCLoginController new];
//    vc.isPresent = YES;
//
//    DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
//    [DC_KeyWindow.rootViewController wxs_presentViewController:nav makeTransition:^(WXSTransitionProperty *transition) {
//        transition.animationType = WXSTransitionAnimationTypeSysPushFromRight;
//        transition.animationTime = 0.25;
//    } completion:nil];
}



#pragma mark - 弹出登陆页 带回调
- (void)dc_pushLoginControllerSuccessBlock:(dispatch_block_t)successBlock {
    
    if ([[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue] == DCUserTypeWithPerson) {
        [self dc_logoutWithPerson];
        return;
    }
    
    /*Add_HX_标识
     *退出环信
     */
    [DC_Appdelegate huanxinLogOut];
    // 清除本地字段
    [self dc_removeLoginDataWithCompany];
    [self dc_deleteAliesWithCompany];
    
    DCLoginController *vc = [DCLoginController new];
    vc.isPresent = YES;
    vc.successBlock = ^{
        if (successBlock) {
            successBlock();
        }
    };
    DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
    NSLog(@"===%@",[DC_KeyWindow.rootViewController class]);
    [DC_KeyWindow.rootViewController wxs_presentViewController:nav makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType = WXSTransitionAnimationTypeSysPushFromRight;
        transition.animationTime = 0.25;
    } completion:nil];
    
}


//#pragma mark - 弹出登陆页 个人
//- (void)dc_pushLoginControllerWithPerson
//{
//    // 清除本地字段
//    [[DCLoginTool shareTool] dc_removeLoginDataWithPerson];
//
//    GLPLoginController *vc = [GLPLoginController new];
//    vc.isPresent = YES;
//
//    DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
//    [DC_KeyWindow.rootViewController wxs_presentViewController:nav makeTransition:^(WXSTransitionProperty *transition) {
//        transition.animationType = WXSTransitionAnimationTypeSysPushFromRight;
//        transition.animationTime = 0.25;
//    } completion:nil];
//}
//
//
//#pragma mark - 弹出登陆页 带回调 个人
//- (void)dc_pushLoginControllerWidthPersonSuccessBlock:(dispatch_block_t)successBlock;


#pragma mark - 退出登录
- (void)dc_logoutWithCompany
{
    /*Add_HX_标识
     *退出环信
     */
    [DC_Appdelegate huanxinLogOut];
    
    [self dc_removeLoginDataWithCompany];
    [self dc_deleteAliesWithCompany];
    
    DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBOpenTypeController new]];
}


#pragma mark - 移除登陆本地保存的数据
- (void)dc_removeLoginDataWithCompany {
    [DCObjectManager dc_removeUserDataForkey:DC_Token_Key];
    [DCObjectManager dc_removeUserDataForkey:DC_UserID_Key];
    [DCObjectManager dc_removeUserDataForkey:DC_UserName_Key];
    [DCObjectManager dc_removeUserDataForkey:DC_UserImage_Key];
    
    [DCObjectManager dc_removeUserDataForkey:DC_UserInfo_Key];
    
    [DCObjectManager dc_removeFileByFileName:DC_UserInfo_EaseMobile_Key];
    [self dc_deleteAliesWithCompany];
}


#pragma mark - 绑定推送别名
- (void)dc_bindAliesWithCompany {
    NSString *uuid = [[DCHelpTool shareClient] dc_uuidFitLength];
    
    // 设置推送别名
    [JPUSHService setAlias:uuid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"设置推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
        
    } seq:0];
}


#pragma mark - 解除别名绑定
- (void)dc_deleteAliesWithCompany {
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"删除推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
        
    } seq:0];
}


#pragma mark - 显示掉线通知
- (void)dc_showOfflineView {
    
}





#pragma mark - 个人
#pragma mark - 退出登录个人版
- (void)dc_logoutWithPerson
{
    /*Add_HX_标识
     *退出环信
     */
    [DC_Appdelegate huanxinLogOut];
    
    [self dc_removeLoginDataWithPerson];
    [self dc_deleteAliesWithPerson];
    
    DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBOpenTypeController new]];
}

#pragma mark - 移除登陆本地保存的数据
- (void)dc_removeLoginDataWithPerson {
    
    [DCObjectManager dc_removeUserDataForkey:P_UserInfo_Key];
    
    [DCObjectManager dc_removeUserDataForkey:P_UserID_Key];
    [DCObjectManager dc_removeUserDataForkey:P_Token_Key];
    
    [DCObjectManager dc_removeUserDataForkey:DC_UserName_Key];
    [DCObjectManager dc_removeUserDataForkey:DC_UserImage_Key];
    
    [DCObjectManager dc_readUserDataForKey:DC_UserType_Key];
    [DCObjectManager dc_saveUserData:@(DCUserTypeWithPerson) forKey:DC_UserType_Key];
    
    [DCObjectManager dc_removeFileByFileName:DC_UserInfo_EaseMobile_Key];
    
    [self dc_deleteAliesWithCompany];
}

#pragma mark - 解除别名绑定
- (void)dc_deleteAliesWithPerson {
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"删除推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
        
    } seq:0];
}


@end
