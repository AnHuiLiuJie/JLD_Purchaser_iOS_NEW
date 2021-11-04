//
//  DCH5ViewController.h
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol DCH5ViewControllerActivity <JSExport>

// 传递token
- (NSString *_Nullable)appGetUserToken;
// 传递userId
- (NSString *_Nullable)appGetUserId;
// 传递版本号
- (NSString *_Nullable)appVersionName;
// 返回上一级
- (void)appGoBack;
// 返回根视图
- (void)appGoMain;
// 联系卖家
- (void)contactMerchant:(NSDictionary *_Nullable)string;
// 上传图片
- (void)uploadImage;
// 去使用优惠券
- (void)toUseCoupon:(NSString *_Nullable)string;
// 去我的账期还款
- (void)toMinePayment;
// 去资质认证
- (void)toCertification;
// 跳转到我的订单
- (void)toMineOrder;
// 打电话
- (void)callContacts:(NSString *_Nullable)string;
// 订单支付
- (void)payOrder:(NSString *_Nullable)string;
// 需要登录
- (void)appToLogin;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DCH5ViewController : DCBasicViewController<DCH5ViewControllerActivity>

@property (nonatomic, copy) NSString *path;

@end

NS_ASSUME_NONNULL_END
