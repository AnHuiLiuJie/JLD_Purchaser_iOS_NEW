//
//  DCSignTool.m
//  DCProject
//
//  Created by bigbing on 2019/9/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCSignTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DCSignTool

+ (DCSignTool *)shareClient {
    static DCSignTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - 加密
- (NSString *)dc_encrypt:(NSString *)time url:(NSString *)url parmas:(NSDictionary *)params type:(DCHttpRequestType)type
{
    // 1、key
    NSString *key = DC_Encrypt_Key;
    NSString *string = key;
    
    // 2、+ time
    string = [string stringByAppendingString:time];
    
    // 3、+ url
    string = [string stringByAppendingString:url];
    
    // 4、+ 请求参数
    NSString *paramStr = @"";
    if (type == DCHttpRequestPost) { // 该类型下需要排序
        
        paramStr = [self dc_rankWithDic:params];
        
    } else { // 不需要排序
        
        if (params) {
            paramStr = [params mj_JSONString];
        }
    }
    
    if (paramStr && paramStr.length > 0) {
        NSString *newParamStr = [self dc_newParamStr:paramStr]; // 参数特殊处理
        string = [string stringByAppendingString:newParamStr];
    }
    // 5、+ token + userId
    if ([[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue] == DCUserTypeWithCompany) { // 企业
        
        // 5-1-1 、token
        NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
        if (token) {
            string = [string stringByAppendingString:token];
        }
        // 5-1-2 、userId
        NSString *userId = [DCObjectManager dc_readUserDataForKey:DC_UserID_Key];
        if (userId) {
            string = [string stringByAppendingString:userId];
        }
        
    } else if ([[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue] == DCUserTypeWithPerson) { // 个人
        
        // 5-2-1 、token
        NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
        if (token) {
            string = [string stringByAppendingString:token];
        }
        
        // 5-2-2 、userId
        NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
        if (userId) {
            string = [string stringByAppendingString:userId];
        }

    }
    // 7、+ key
    string = [string stringByAppendingString:key];
    NSLog(@"加密前参数 -- %@",string);
    
    // 8、md5加密
    NSString *sign = [self md5:string];
    
    // 9、+ key
    NSString *newString = [sign stringByAppendingString:key];
    
    // 10、md5加密
    NSString *doubeSign = [self md5:newString];
    NSLog(@"加密后 --- %@",doubeSign);
    return doubeSign;
}


#pragma mark - 获取当前时间
- (NSString *)dc_nowTime
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*60*60];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSDate*datenow = [NSDate date];
    NSString *time = [formatter stringFromDate:datenow];
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    //    NSDate *now = [NSDate mylocalDate];
    //    NSString *time = [formatter stringFromDate:now];
    
    return time;
}


#pragma mark - 参数操作：去掉非字母、数字、汉字等特殊字符
- (NSString *)dc_newParamStr:(NSString *)string
{
    NSString *newString = @"";
    if (string && string.length > 0) {
        for (int i=0; i<string.length; i++) {
            NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
            
            if (![self dc_checkEncoryCode:subString]) {
                subString = @"";
            }
            
            if (newString.length == 0) {
                newString = subString;
            } else {
                newString = [NSString stringWithFormat:@"%@%@",newString,subString];
            }
        }
    }
    return newString;
}


#pragma mark - 字段按key值排序
- (NSString *)dc_rankWithDic:(NSDictionary *)params {
    
    NSArray *keyArray = [params allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *paramStr = [NSString string];
    for (NSInteger i=0; i<sortArray.count; i++) {
        NSString *key = sortArray[i];
        NSString *value = params[key];
        if (i == 0) {
            
            paramStr = key;
            if ([value isKindOfClass:[NSNumber class]]) {
                paramStr = [paramStr stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[value integerValue]]];
            } else {
                paramStr = [paramStr stringByAppendingString:value];
            }
            
        } else {
            paramStr = [paramStr stringByAppendingString:key];
            if ([value isKindOfClass:[NSNumber class]]) {
                paramStr = [paramStr stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[value integerValue]]];
            } else {
                paramStr = [paramStr stringByAppendingString:value];
            }
            
        }
    }
    return paramStr;
}



#pragma mark -  32位md5加密算法
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma 正则校验汉字、字母与数字
- (BOOL)dc_checkEncoryCode:(NSString *) code
{
    NSString *nicknameRegex = @"[a-zA-Z0-9\u4e00-\u9fa5]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [pred evaluateWithObject:code];
    return isMatch;
}

@end
