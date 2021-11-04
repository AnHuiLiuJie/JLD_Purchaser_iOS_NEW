//
//  DCCheckRegular.m
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCCheckRegular.h"

@implementation DCCheckRegular


#pragma 正则校验邮箱号
+ (BOOL)dc_checkMailInput:(NSString *)mail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}


#pragma 正则校验手机号 - 简单
+ (BOOL)dc_checkTelNumber:(NSString *)telNumber{
    NSString *mobile = @"^1[23456789][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    return [phoneTest evaluateWithObject:telNumber];
}

#pragma 正则校验用户密码6-18位数字和字母组合
+ (BOOL)dc_checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}


#pragma 正则校验用户名6-20位数字、字母或下划线组合
+ (BOOL)dc_checkUserName:(NSString *) name
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9_]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
    
}


#pragma 正则校验用户身份证号15或18位
+ (BOOL)dc_checkUserIdCard: (NSString *) idCard
{
    BOOL flag;
    if (idCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)dc_checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

#pragma 正则校验URL
+ (BOOL)dc_checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

#pragma 正则校验昵称
+ (BOOL)dc_checkNickname:(NSString *) nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [pred evaluateWithObject:nickname];
    return isMatch;
}

#pragma 正则校验以C开头的18位字符
+ (BOOL)dc_checkCtooNumberTo18:(NSString *) nickNumber
{
    NSString *nickNum=@"^C{1}[0-9]{18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}
#pragma 正则校验以C开头字符
+ (BOOL)dc_checkCtooNumber:(NSString *) nickNumber
{
    NSString *nickNum=@"^C{1}[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}
#pragma 正则校验银行卡号是否正确
+ (BOOL)dc_checkBankNumber:(NSString *) bankNumber{
    NSString *bankNum=@"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:bankNumber];
    return isMatch;
}

#pragma 正则只能输入数字和字母
+ (BOOL)dc_checkTeshuZifuNumber:(NSString *) CheJiaNumber{
    NSString *bankNum=@"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CheJiaNumber];
    return isMatch;
}

#pragma 正则只能输入数字
+ (BOOL)dc_checkNumber:(NSString *) number{
    NSString *bankNum=@"^[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

#pragma 车牌号验证
+ (BOOL)dc_checkCarNumber:(NSString *) CarNumber{
    NSString *bankNum = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CarNumber];
    return isMatch;
}

#pragma 正则判断是否有emoji
+ (BOOL)dc_checkContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar high = [substring characterAtIndex: 0];
        
        // Surrogate pair (U+1D000-1F9FF)
        if (0xD800 <= high && high <= 0xDBFF) {
            const unichar low = [substring characterAtIndex: 1];
            const int codepoint = ((high - 0xD800) *0x400) + (low - 0xDC00) + 0x10000;
            
            if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                returnValue = YES;
            }
            
            // Not surrogate pair (U+2100-27BF)
        } else {
            if (0x2100 <= high && high <= 0x27BF){
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}


#pragma 正则校验汉字、字母与数字
+ (BOOL)dc_checkEncoryCode:(NSString *) code
{
    NSString *nicknameRegex = @"[a-zA-Z0-9\u4e00-\u9fa5]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [pred evaluateWithObject:code];
    return isMatch;
}

/*
 *第二种方法，利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

@end
