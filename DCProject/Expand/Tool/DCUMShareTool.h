//
//  DCUMShareTool.h
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>


NS_ASSUME_NONNULL_BEGIN

@interface DCUMShareTool : NSObject


///  单列
+ (DCUMShareTool *) shareClient;

///  分享
- (void)shareInfoWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url image:(UIImage *_Nullable)image pathUrl:(NSString *)pathUr;

///  分享 含回调
- (void)shareInfoWithImage:(NSString *)image WithTitle:(NSString *)title orderNo:(NSString *)orderNo joinId:(NSString *)joinId goodsId:(NSString *)goodsId content:(NSString *)content url:(NSString *)url completion:(UMSocialRequestCompletionHandler)completion;

///  分享 微信小程序
//- (void)dc_shareWeChatPlatformType:(UMSocialPlatformType)platformType orderNo:(NSString *_Nullable)orderNo joinId:(NSString *_Nullable)joinId goodsId:(NSString *_Nullable)goodsId title:(NSString *_Nullable)title pathUrl:(NSString *_Nullable)imageUrl image:(UIImage *_Nullable)image;

///  微信登录 友盟
- (void)dc_umWechatLogin:(void(^)(UMSocialUserInfoResponse *resp))successBlcok;

///  微信登录 原生
- (void)dc_weixinAuthReq;


///  登录第三方授权登录 友盟
- (void)dc_umThirdLoginWidthType:(UMSocialPlatformType)type successBlock:(void(^)(UMSocialUserInfoResponse *resp))successBlcok;


@end

NS_ASSUME_NONNULL_END
