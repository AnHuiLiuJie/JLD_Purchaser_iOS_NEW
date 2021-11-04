//
//  DCUpdateTool.h
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLBUserInfoModel.h"
#import "GLPUserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCUpdateTool : NSObject

extern NSString *const XYLoginMangerDidLoginNotification;


//环信用户信息
@property (nonatomic,strong) NSMutableDictionary *easeUserDict;
//用户数据
@property (nonatomic,strong) GLBUserInfoModel *currentUser;
//用户数据
@property (nonatomic,strong) GLPUserInfoModel *currentUserB2C;
///  单列
+ (DCUpdateTool *) shareClient;


///  检测是否需要更新
- (BOOL)dc_isUpdateWithVersion:(NSString *)version onlineVer:(NSString *)onlineVer;


///  必须强制更新提示
- (void)dc_showMustUpdateTipWithUrl:(NSString *)url;


///  非强制更新提示，可取消
- (void)dc_showUpdateTipWithUrl:(NSString *)url;


#pragma mark - 检测更新
- (void)requestIsUpdate;
///每天进行一次版本判断
- (BOOL)judgeNeedVersionUpdate;

/*Add_HX_标识
 *更新环信用户信息
 */
- (void)updateEaseUser:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
