//
//  DCUpdateTool.m
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCUpdateTool.h"
#import <UIKit/UIKit.h>
#import "GLBUpdateModel.h"
#import "GLBUserInfoModel.h"
@implementation DCUpdateTool


#pragma mark - 单列
+ (DCUpdateTool *) shareClient{
    static DCUpdateTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - 初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        
        //userInfo
        id puserObj = [DCObjectManager dc_readUserDataForKey:P_UserInfo_Key];
        if (puserObj) {
            //self.currentUserB2C = [GLPUserInfoModel mj_setKeyValues:puserObj];
            self.currentUserB2C = [GLPUserInfoModel mj_objectWithKeyValues:puserObj];
        }
        id userObj = [DCObjectManager dc_readUserDataForKey:DC_UserInfo_Key];
        if (userObj) {
            //self.currentUser = [GLBUserInfoModel mj_setKeyValues:userObj];
            self.currentUser = [GLBUserInfoModel mj_objectWithKeyValues:userObj];
        }
        
        //easeUsers
        id easeUserObj = [DCObjectManager dc_getObjectByFileName:DC_UserInfo_EaseMobile_Key];
        if (easeUserObj) {
            self.easeUserDict = [NSMutableDictionary dictionaryWithDictionary:easeUserObj];
        }else{
            self.easeUserDict = [[NSMutableDictionary alloc] init];
        }
        
    }
    return self;
}


#pragma mark - 检测是否需要更新
- (BOOL)dc_isUpdateWithVersion:(NSString *)version onlineVer:(NSString *)onlineVer
{
    /* NSOrderedAscending = -1  升序
     *NSOrderedSame = 0        相等
     *NSOrderedDescending      降序
     */
    
    if (!version && !onlineVer) {
        return NO;
    }
    
    if (!version && onlineVer) {
        return YES;
    }
    
    if (version && !onlineVer) {
        return NO;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [version componentsSeparatedByString:@"."];
    NSArray *v2Array = [onlineVer componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return NO;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return YES;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return NO;
    } else if (v1Array.count < v2Array.count) {
        return YES;
    } else {
        return NO;
    }
    
    return NO;
}


#pragma mark - 必须强制更新提示
- (void)dc_showMustUpdateTipWithUrl:(NSString *)url
{
    if (!url)  return;
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发现新的版本，更新后才能继续使用" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        // 打开网页
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            if (@available(ios 10.0,*)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}


#pragma mark - 非强制更新提示，可取消
- (void)dc_showUpdateTipWithUrl:(NSString *)url
{
    if (!url)  return;
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发现新的版本，您可以更新后使用" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            if (@available(ios 10.0,*)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:DC_CurrentDate_key];
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}


#pragma mark - 检测更新
- (void)requestIsUpdate
{
    [[DCAPIManager shareManager] dc_requestCheckUpdateWithAppBusType:@"1" appType:@"1" versionNo:APP_VERSION success:^(id response) {
        if (response && [response isKindOfClass:[GLBUpdateModel class]]) {
            GLBUpdateModel *updateModel = response;
            if (updateModel.need2Update && [updateModel.need2Update isEqualToString:@"1"]) { // 需要更新
                
                if (updateModel.isForced && [updateModel.isForced isEqualToString:@"1"]) { // 强制更新
                    
                    [[DCUpdateTool shareClient] dc_showMustUpdateTipWithUrl:updateModel.uri];
                    //itms-apps://itunes.apple.com/cn/app/id1482534636?mt=8
                } else { // 非强制更新
                    BOOL isNeed = [[DCUpdateTool shareClient] judgeNeedVersionUpdate];
                    if (isNeed) {
                        [[DCUpdateTool shareClient] dc_showUpdateTipWithUrl:updateModel.uri];
                    }
                }
                
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


//每天进行一次版本判断
- (BOOL)judgeNeedVersionUpdate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取年-月-日
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *currentDate = [[NSUserDefaults standardUserDefaults] objectForKey:DC_CurrentDate_key];
    if ([currentDate isEqualToString:dateString]) {
        return NO;
    }
    //[[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"currentDate"];
    return YES;
}



/*Add_HX_标识
 *更新环信用户信息
 */
- (void)updateEaseUser:(NSDictionary *)dict{
    if (dict && ![dict[@"userId"] dc_isNull]) {
        [self.easeUserDict removeAllObjects];
        [self.easeUserDict setObject:dict forKey:[NSString stringWithString:dict[@"userId"]]];
        [DCObjectManager dc_saveObject:self.easeUserDict byFileName:DC_UserInfo_EaseMobile_Key];
    }
}
@end
