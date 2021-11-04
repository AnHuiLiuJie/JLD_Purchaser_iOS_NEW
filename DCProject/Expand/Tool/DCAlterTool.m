//
//  DCAlterTool.m
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCAlterTool.h"

@implementation DCAlterTool

+ (DCAlterTool *)shareTool{
    static DCAlterTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - 显示弹框：确定选项+取消选项
- (void)showDefaultWithTitle:(NSString *_Nullable)title
                     message:(NSString *_Nullable)message
                defaultTitle:(NSString *)defaultTitle
                     handler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:handler]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

#pragma mark - 显示弹框：仅取消选项
- (void)showCancelWithTitle:(NSString *_Nullable)title
                    message:(NSString *_Nullable)message
                cancelTitle:(NSString *)cancelTitle
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

#pragma mark - 显示弹框：仅确定选项
- (void)showDoneWithTitle:(NSString *_Nullable)title
                  message:(NSString *_Nullable)message
             defaultTitle:(NSString *)defaultTitle
                  handler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:handler]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

#pragma mark - 显示弹框：自定义选项 + 自定义选项
- (void)showCustomWithTitle:(NSString *_Nullable)title
                    message:(NSString *_Nullable)message
               customTitle1:(NSString *)customTitle1
                   handler1:(void (^)(UIAlertAction *action))handler1
               customTitle2:(NSString *)customTitle2
                   handler2:(void (^)(UIAlertAction *action))handler2
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:customTitle1 style:UIAlertActionStyleDefault handler:handler1]];
    [alter addAction:[UIAlertAction actionWithTitle:customTitle2 style:UIAlertActionStyleCancel handler:handler2]];
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
    [[DCSpeedy getKeyWindow].rootViewController presentViewController:alter animated:YES completion:nil];
    
}



@end
