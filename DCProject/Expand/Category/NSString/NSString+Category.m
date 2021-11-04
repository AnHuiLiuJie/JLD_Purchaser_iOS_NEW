//
//  NSString+Category.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>

// 定义宏
#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C000) << 18) | (c & 0x3F) << 24)

@implementation NSString (Category)

//md5加密
+ ( NSString *)md5String:( NSString *)str {
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
}


#pragma mark - 中文转拼音
+ (NSString *)transform:(NSString *)chinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    
    //返回最近结果
    return pinyin;
}


#pragma mark - 返回一个带行间距的富文本
+ (NSMutableAttributedString *)dc_attributeWithString:(NSString *)string lineSpacing:(CGFloat)spacing{
    
    if (!string || string.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = spacing;
    style.alignment = NSTextAlignmentLeft;
    [attStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attStr.length)];
    return attStr;
}



+ (NSMutableAttributedString *)dc_placeholderWithString:(NSString *)string
{
    UIColor *color = [UIColor dc_colorWithHexString:@"#cccccc"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, attrStr.length)];
    return  attrStr;
}

+ (NSMutableAttributedString *)dc_placeholderWithString:(NSString *)string color:(UIColor *)color
{
    if (color == nil) {
        color = [UIColor dc_colorWithHexString:@"#cccccc"];
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, attrStr.length)];
    return  attrStr;
}


#pragma mark - 返回一个富文本的行高
+ (CGFloat)dc_heightWithAttributeStr:(NSMutableAttributedString *)attributeStr maxWidth:(CGFloat)maxWidth
{
    return [attributeStr boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.height;
}

#pragma mark - 返回一个富文本的行高
+ (CGFloat)dc_WidthWithAttributeStr:(NSMutableAttributedString *)attributeStr maxHeight:(CGFloat)maxHeight
{
    return [attributeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.width;
}


#pragma mark - 返回一个富文本的size
+ (CGSize)dc_sizeWithAttributeStr:(NSMutableAttributedString *)attributeStr maxWidth:(CGFloat)maxWidth
{
    return [attributeStr boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
}


#pragma mark - 返回一个中间带横线的富文本
+ (NSMutableAttributedString *)dc_strikethroughWithString:(NSString *)string{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    [attrStr addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrStr.length)];
    return  attrStr;
}


#pragma mark - 返回一个带下划线的富文本
+ (NSMutableAttributedString *)dc_underlineWithString:(NSString *)string{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    [attrStr addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrStr.length)];
    return  attrStr;
}

#pragma mark - 10进制 - 转16进制
+ (NSString *)dc_getHexByDecimal:(NSDecimalNumber *)decimal {
    
    //10进制转换16进制（支持无穷大数）
    NSString *hex =@"";
    NSString *letter;
    NSDecimalNumber *lastNumber = decimal;
    for (int i = 0; i<999; i++) {
        NSDecimalNumber *tempShang = [lastNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"16"]];
        NSString *tempShangString = [tempShang stringValue];
        if ([tempShangString containsString:@"."]) {
            // 有小数
            tempShangString = [tempShangString substringToIndex:[tempShangString rangeOfString:@"."].location];
            //            DLog(@"%@", tempShangString);
            NSDecimalNumber *number = [[NSDecimalNumber decimalNumberWithString:tempShangString] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"16"]];
            NSDecimalNumber *yushu = [lastNumber decimalNumberBySubtracting:number];
            int yushuInt = [[yushu stringValue] intValue];
            switch (yushuInt) {
                case 10:
                    letter =@"A"; break;
                case 11:
                    letter =@"B"; break;
                case 12:
                    letter =@"C"; break;
                case 13:
                    letter =@"D"; break;
                case 14:
                    letter =@"E"; break;
                case 15:
                    letter =@"F"; break;
                default:
                    letter = [NSString stringWithFormat:@"%d", yushuInt];
            }
            lastNumber = [NSDecimalNumber decimalNumberWithString:tempShangString];
        } else {
            // 没有小数
            if (tempShangString.length <= 2 && [tempShangString intValue] < 16) {
                
                //                if(i == 0 && [lastNumber compare:[NSDecimalNumber one]] == NSOrderedDescending){
                //                    [hex appendString:@"0"];
                //                }
                
                int num = [tempShangString intValue];
                if (num == 0) {
                    break;
                }
                switch (num) {
                    case 10:
                        letter =@"A"; break;
                    case 11:
                        letter =@"B"; break;
                    case 12:
                        letter =@"C"; break;
                    case 13:
                        letter =@"D"; break;
                    case 14:
                        letter =@"E"; break;
                    case 15:
                        letter =@"F"; break;
                    default:
                        letter = [NSString stringWithFormat:@"%d", num];
                }
                hex = [letter stringByAppendingString:hex];
                break;
            } else {
                letter = @"0";
            }
            lastNumber = tempShang;
        }
        
        hex = [letter stringByAppendingString:hex];
    }
    //    return hex;
    return hex.length > 0 ? hex : @"0";
}


#pragma mark - < emoji 表情 >

/**
 将十六进制的编码转为 emoji 字符串
 
 @param intCode 无符号 32 位整数
 @return 字符串
 */
+ (NSString *)emojiWithIntCode:(unsigned int)intCode
{
    unsigned int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    
    if (string == nil) {
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

/**
 将十六进制的编码转为 emoji 字符串
 
 @param stringCode 十六进制格式的字符串, 例如`0x1f633`
 @return 字符串
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:stringCode];
    
    unsigned int intCode = 0;
    
    [scanner scanHexInt:&intCode];
    
    return [NSString emojiWithIntCode:intCode];
}


#pragma mark - 返回一特定大小的图片（200x200 / 340x200 / 750x420 ）
+ (NSString *)dc_imageSizeWith:(NSString *)string size:(CGSize)size{
    if (!string || [string dc_isNull]) {
        return @"";
    }
    
    NSString *sizeString = nil;
    if (CGSizeEqualToSize(size, CGSizeMake(200, 200))) {
        sizeString = @"imageView2/1/w/200/h/200/q/75|imageslim";
    } else if (CGSizeEqualToSize(size, CGSizeMake(340, 200))) {
        sizeString = @"imageView2/1/w/340/h/200/q/75|imageslim";
    } else if (CGSizeEqualToSize(size, CGSizeMake(750, 420))) {
        sizeString = @"imageView2/1/w/750/h/419/q/75|imageslim";
    }
    
    if (sizeString) {
        string = [NSString stringWithFormat:@"%@?%@",string,sizeString];
    }
    NSString *imgUrl = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return imgUrl;
}


#pragma mark -   UTF - 8 编码
+ (NSString *)dc_encodingByUTF8WithUrl:(NSString *)url
{
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *videoUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return videoUrl;
}

#pragma mark -  UTF - 8 解码
+ (NSString *)dc_dencodingByUTF8WithUrl:(NSString *)url
{
    NSString *path = [url stringByRemovingPercentEncoding];
    return path;
}

#pragma mark -  去掉首位为零的字符串
+ (NSString *)getFirstNoZoneStr:(NSString *)str
{
    NSString *newStr = str;
    if ([newStr characterAtIndex:0] == '0') {
        newStr = [newStr substringFromIndex:1];
    }
    return newStr;
}

#pragma mark - 富文本设置部分字体颜色
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color font:(UIFont*)font{
    NSRange hightlightTextRange = [text rangeOfString:rangeText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:font range:hightlightTextRange];
        return attributeStr;
    }else {
        return [rangeText copy];
    }
}

@end
