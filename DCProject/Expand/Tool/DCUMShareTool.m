//
//  DCUMShareTool.m
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCUMShareTool.h"
#import <UMShare/WXApi.h>
#import "CSXImageCompressTool.h"
//#import <UMShare/WXApiObject.h>

@implementation DCUMShareTool


#pragma mark - 单列
+ (DCUMShareTool *) shareClient{
    static DCUMShareTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


#pragma mark - 分享
- (void)shareInfoWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url image:(UIImage *)image pathUrl:(NSString *)pathUrl
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSDictionary *dict = @{@"type":@"app分享",@"shareNumber":@"分享次数"};//UM统计 自定义搜索关键词事件
        [MobClick event:UMEventCollection_2 attributes:dict];
        
        if (platformType == UMSocialPlatformType_WechatSession) {
            [[DCUMShareTool shareClient] dc_shareWeChatPlatformType:UMSocialPlatformType_WechatSession orderNo:@"" joinId:@"" goodsId:@"" title:@"" imageUrl:@"https://img0.123ypw.com/sys/share.png" pathUrl:pathUrl image:image];
        }else{
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageNamed:@"logo"]];
            shareObject.webpageUrl = url;
            
            messageObject.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(id result, NSError *error) {
                
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = result;
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    }else{
                        UMSocialLogInfo(@"response data is %@",result);
                    }
                }
            }];
        }
    }];
}


#pragma mark -  分享 含回调
- (void)shareInfoWithImage:(NSString *)imageUrl WithTitle:(NSString *)title orderNo:(NSString *)orderNo joinId:(NSString *)joinId goodsId:(NSString *)goodsId content:(NSString *)content url:(NSString *)url completion:(UMSocialRequestCompletionHandler)completion
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSDictionary *dict = @{@"type":@"商品分享",@"shareNumber":@"分享次数"};//UM统计 自定义搜索关键词事件
        [MobClick event:UMEventCollection_2 attributes:dict];
        if (platformType == UMSocialPlatformType_WechatSession) {
            [[DCUMShareTool shareClient] dc_shareWeChatPlatformType:UMSocialPlatformType_WechatSession orderNo:orderNo joinId:joinId goodsId:goodsId title:title imageUrl:imageUrl pathUrl:@"" image:nil];
        }else{
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            UIImage *shareimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:shareimage];
            shareObject.webpageUrl = url;
            
            messageObject.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[UIApplication sharedApplication].keyWindow.rootViewController completion:completion];
        }
    }];
}


#pragma mark -  分享 微信小程序
- (void)dc_shareWeChatPlatformType:(UMSocialPlatformType)platformType orderNo:(NSString *_Nullable)orderNo joinId:(NSString *_Nullable)joinId goodsId:(NSString *_Nullable)goodsId title:(NSString *_Nullable)title imageUrl:(NSString *_Nullable)imageUrl  pathUrl:(NSString *_Nullable)pathUrl image:(UIImage * _Nullable)image
{
    NSString *appTitle = @"金利达健康商城，致力健康生活";
    UIImage *thumImage = nil;
    if (title.length != 0) {
        appTitle = title;
        if (joinId.length != 0) {
            appTitle = [NSString stringWithFormat:@"参团购买%@",title];
        }
    }
    
    if (image != nil) {
        thumImage = image;
    }else{
        if (imageUrl.length != 0) {
            thumImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        }else
            thumImage = [UIImage imageNamed:@"logo"];
    }

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:appTitle descr:@"金利达医药商城正品便捷" thumImage:nil];

    shareObject.webpageUrl = @"https://www.123ypw.com";
    shareObject.userName = @"gh_2917910ac23c";
    
    if (pathUrl.length > 0) {
        shareObject.path = pathUrl;
    }else{
        if (goodsId.length != 0) {
            shareObject.path = [NSString stringWithFormat:@"/pages/cates/goods/good-detail?id=%@",goodsId];
        }else
            shareObject.path = @"/pages/index/index";
        
        if (joinId.length != 0) {
            shareObject.path = [NSString stringWithFormat:@"/pages/drug/collage_detail?orderNo=%@&joinId=%@",orderNo,joinId];
        }
    }
    
    messageObject.shareObject = shareObject;

    UIImage *newImage = [UIImage dc_scaleToImage:thumImage size:CGSizeMake(500, 400)];
    
    [CSXImageCompressTool compressedImageFiles:newImage imageKB:120 imageBlock:^(NSData *imageData) {
        shareObject.hdImageData = imageData;
    }];
//    NSData *imageData = UIImageJPEGRepresentation(newImage,0.5);
//    shareObject.hdImageData = imageData;
    
//#warning 上架的话要改成 UShareWXMiniProgramTypeRelease
    if (versionFlag == 0) {
        shareObject.miniProgramType = UShareWXMiniProgramTypePreview; // 可选体验版和开发板
    }else{
        shareObject.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板
    }

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"error - %@",error);
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
            NSLog(@"data - %@",data);
        }
    }];
}


#pragma mark - 微信登录 
- (void)dc_umWechatLogin:(void(^)(UMSocialUserInfoResponse *resp))successBlcok
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        
        if (error) {
            
            NSLog(@"error - %@",error);
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            successBlcok(resp);
        }
    }];
}


#pragma mark -  微信登录 原生
- (void)dc_weixinAuthReq
{
    //    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
    //
    //        SendAuthReq *req = [[SendAuthReq alloc] init];
    //        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
    //        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
    //
    //        [WXApi sendReq:req];//发起微信授权请求
    //
    //    }else{
    //
    //        //提示：未安装微信应用或版本过低
    //        [self showNoWxTip];
    //    }
}


///  登录第三方授权登录 友盟
- (void)dc_umThirdLoginWidthType:(UMSocialPlatformType)type successBlock:(void(^)(UMSocialUserInfoResponse *resp))successBlcok
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:nil completion:^(id result, NSError *error) {
        
        if (error) {
            
            NSLog(@"error - %@",error);
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@" uid: %@", resp.uid);
            NSLog(@" openid: %@", resp.openid);
            NSLog(@" unionid: %@", resp.unionId);
            NSLog(@" accessToken: %@", resp.accessToken);
            NSLog(@" refreshToken: %@", resp.refreshToken);
            NSLog(@" expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@" name: %@", resp.name);
            NSLog(@" iconurl: %@", resp.iconurl);
            NSLog(@" gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
            
            successBlcok(resp);
        }
    }];
}

@end
