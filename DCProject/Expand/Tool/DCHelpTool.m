//
//  DCHelpTool.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCHelpTool.h"
#import "JPUSHService.h"
#import "DCMD5Tool.h"

@implementation DCHelpTool

+ (DCHelpTool *)shareClient {
    static DCHelpTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - 打电话
- (void)dc_callMobile:(NSString *)mobile {
    if (!mobile) {
        return;
    }
    
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel://%@",mobile];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
        
        if (@available(ios 10.0,*)) {
            
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                });
            }];
            
        } else {
            
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
            });
        }
    }
}


#pragma mark - 获取设备号 截取20位
- (NSString *)dc_uuidFitLength
{
    // 长度过长 截取后20位字符
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if ([uuid containsString:@"-"]) {
        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if (uuid.length > 20) {
        uuid = [uuid substringWithRange:NSMakeRange(uuid.length - 20, 20)];
    }
    return uuid;
}


#pragma mark - 绑定推送别名
- (void)dc_bindAlies
{
    NSString *uuidStr = [self dc_uuidFitLength];
    
    // 设置推送别名
    [JPUSHService setAlias:uuidStr completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"设置推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
        
    } seq:0];
}


#pragma mark - 移除推送别名
- (void)dc_deleteAlies
{
    // 移除推送别名
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"删除推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
        
    } seq:0];
}


#pragma mark - 默认 “/”
- (NSString *)dc_setValue:(NSString *)str
{
    if (str && ![str dc_isNull] && [str length] > 0) {
        return str;
    }
    return @"-";
}


#pragma mark - 网络地址图片
- (NSString *)dc_imageUrl:(NSString *)str
{
    if (!str || [str dc_isNull]) {
        str = @"";
    }
    return str;
}


//HTML适配图片文字
- (NSString *)dc_adaptWebViewForHtml:(NSString *) htmlStr
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}


// HTML适配图片文字 带文字颜色
- (NSString *)dc_adaptWebViewForHtml:(NSString *) htmlStr color:(NSString *)color
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    
    NSString *formatString = [NSString stringWithFormat:@"<span style=\"color:%@\">%@</span>",color,bodyHtml];
    return formatString;
    
}


#pragma mark - 确保字符里具备富文本标签
- (NSString *)dc_newAttributeStr:(NSString *)string{
    if (![string containsString:@"<"] && ![string containsString:@">"]) {
        string = [string stringByAppendingString:@"<span>"];
    }
    return string;
}


//根据Dictionary字符串返回Json
+(NSString *)dictionaryTransformationJsonStringByDictionary:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//根据Json字符串返回Dictionary
+(NSDictionary *)stringTransformationDictionaryByJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
