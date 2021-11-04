//
//  DCSignTool.h
//  DCProject
//
//  Created by bigbing on 2019/9/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCSignTool : NSObject

+ (DCSignTool *)shareClient;


#pragma mark - 加密
- (NSString *)dc_encrypt:(NSString *)time url:(NSString *)url parmas:(NSDictionary *)params type:(DCHttpRequestType)type;


#pragma mark - 获取当前时间
- (NSString *)dc_nowTime;

#pragma mark - 参数操作：去掉非字母、数字、汉字等特殊字符
- (NSString *)dc_newParamStr:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
