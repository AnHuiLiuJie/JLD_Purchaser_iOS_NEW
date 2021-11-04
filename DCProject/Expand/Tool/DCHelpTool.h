//
//  DCHelpTool.h
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHttpClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCHelpTool : NSObject

+ (DCHelpTool *)shareClient;

#pragma mark - 打电话
- (void)dc_callMobile:(NSString *)mobile;


#pragma mark - 获取设备号 截取20位
- (NSString *)dc_uuidFitLength;


#pragma mark - 绑定推送别名
- (void)dc_bindAlies;


#pragma mark - 移除推送别名
- (void)dc_deleteAlies;


#pragma mark - 默认 “/”
- (NSString *)dc_setValue:(NSString *)str;


//#pragma mark - 默认 “/”
//- (NSString *)dc_encrypt:(NSString *)time url:(NSString *)url parmas:(NSDictionary *)params type:(DCHttpRequestType)type;
//
//
//- (NSString *)dc_nowTime;


#pragma mark - 网络地址图片
- (NSString *)dc_imageUrl:(NSString *)str;


#pragma mark - HTML适配图片文字
- (NSString *)dc_adaptWebViewForHtml:(NSString *) htmlStr;


#pragma mark - 确保字符里具备富文本标签
- (NSString *)dc_newAttributeStr:(NSString *)string;

//根据Dictionary字符串返回Json
+(NSString *)dictionaryTransformationJsonStringByDictionary:(NSDictionary *)dic;
//根据Json字符串返回Dictionary
+(NSDictionary *)stringTransformationDictionaryByJsonString:(NSString *)jsonString ;

@end

NS_ASSUME_NONNULL_END
