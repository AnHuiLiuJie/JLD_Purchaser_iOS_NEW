//
//  DCPayTool.m
//  DCProject
//
//  Created by bigbing on 2019/5/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCPayTool.h"
#import <WechatOpenSDK/WXApi.h>//使用微信支付的界面
#import <AlipaySDK/AlipaySDK.h>

@implementation DCPayTool

+ (DCPayTool *) shareTool {
    static DCPayTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - 调起支付宝支付
- (void)dc_alipay:(NSString *)orderStr
{    
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:DCAlipay_AppScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"resultDic-->%@",resultDic);
    }];
}

#pragma mark - 调起微信支付
- (void)dc_wxpay:(NSDictionary *)dict
{
    if ([WXApi isWXAppInstalled]) {
        [self openWxPay:dict];
    }else {
        [self showNoWxTip];
    }
}


#pragma mark - 吊起微信支付
#pragma mark - 微信支付回调
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        //            SendAuthResp *authResp = (SendAuthResp *)resp;
        
    }else if ([resp isKindOfClass:[WXPayInsuranceResp class]]){
        
    }
    //    WXMediaMessage *msg = req.message;
    
}

- (void)openWxPay:(NSDictionary *)dict{
    
    PayReq *request = [[PayReq alloc] init];
    //微信支付分配的商户号
    request.partnerId = dict[@"partnerid"];
    //微信返回的支付交易会话ID
    request.prepayId = dict[@"prepayid"];
    //暂填写固定值Sign=WXPay
    request.package = @"Sign=WXPay";
    //随机字符串，不长于32位。推荐随机数生成算法
    request.nonceStr = dict[@"noncestr"];
    //时间戳，请见接口规则-参数规定
    request.timeStamp = [dict[@"timestamp"] intValue];
    //签名，详见签名生成算法
    request.sign = dict[@"sign"];
    [WXApi sendReq:request completion:^(BOOL success) {
        
    }];
    
}

#pragma mark - 提示
- (void)showNoWxTip{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未安装微信客户端，请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
        }
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

@end
