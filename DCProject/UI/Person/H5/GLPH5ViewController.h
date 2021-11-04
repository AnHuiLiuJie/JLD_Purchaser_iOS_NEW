//
//  GLPH5ViewController.h
//  DCProject
//
//  Created by bigbing on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GLPBaseWebViewControllerActivity <JSExport>

@optional
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
- (void)contactMerchant;
// 上传图片
- (void)uploadImage:(NSString *_Nullable)index;
// 跳转到我的订单
- (void)toMineOrder;
// 打电话
- (void)callContacts:(NSString *_Nullable)string;
// 去付款
- (void)toPay:(NSString *_Nullable)string;
// 去商品明细
- (void)toGoodsDetail:(NSString *_Nullable)goodsId;
// 订单支付
- (void)payOrder:(NSString *_Nullable)string;
// 个人版企业分享
- (void)personFirmShare:(NSDictionary *_Nullable)firmdic;
// 个人版订单详情联系客服
- (void)personOrderKeFu:(NSDictionary *_Nullable)kefudic;
// 保存图片到本地
- (void)tosaveImage:(NSString *_Nullable)image;
// 需要登录
- (void)appToLogin;

@end

NS_ASSUME_NONNULL_BEGIN

//用于返回就诊信息
typedef void(^GLPH5ViewControllerDrugBlock)(NSDictionary *dict);

@interface GLPH5ViewController : DCBasicViewController<GLPBaseWebViewControllerActivity>

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) GLPH5ViewControllerDrugBlock drugBlock;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
