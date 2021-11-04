//
//  NSString+Category.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)


#pragma mark -md5加密
+ ( NSString *)md5String:( NSString *)str;
#pragma mark - 中文转拼音
+ (NSString *)transform:(NSString *)chinese;

#pragma mark - 返回一个带行间距的富文本
+ (NSMutableAttributedString *)dc_attributeWithString:(NSString *)string lineSpacing:(CGFloat)spacing;

#pragma mark - 返回一个富文本的行高
+ (CGFloat)dc_heightWithAttributeStr:(NSMutableAttributedString *)attributeStr maxWidth:(CGFloat)maxWidth;
#pragma mark - 返回一个富文本的行高
+ (CGFloat)dc_WidthWithAttributeStr:(NSMutableAttributedString *)attributeStr maxHeight:(CGFloat)maxHeight;

#pragma mark - 返回一个富文本的size
+ (CGSize)dc_sizeWithAttributeStr:(NSMutableAttributedString *)attributeStr maxWidth:(CGFloat)maxWidth;

#pragma mark - 返回一个中间带横线的富文本
+ (NSMutableAttributedString *)dc_strikethroughWithString:(NSString *)string;

#pragma mark - 返回一个带下划线的富文本
+ (NSMutableAttributedString *)dc_underlineWithString:(NSString *)string;


+ (NSMutableAttributedString *)dc_placeholderWithString:(NSString *)string;

+ (NSMutableAttributedString *)dc_placeholderWithString:(NSString *)string color:(UIColor *)color;

#pragma mark - 10进制 - 转16进制
+ (NSString *)dc_getHexByDecimal:(NSDecimalNumber *)decimal;


#pragma mark - 加载emoji表情
+ (NSString *)emojiWithIntCode:(unsigned int)intCode;

+ (NSString *)emojiWithStringCode:(NSString *)stringCode;

#pragma mark - 返回一特定大小的图片（200x200 / 340x200 / 750x420 ）
+ (NSString *)dc_imageSizeWith:(NSString *)string size:(CGSize)size;

#pragma mark -   UTF - 8 编码
+ (NSString *)dc_encodingByUTF8WithUrl:(NSString *)url;

#pragma mark -  UTF - 8 解码
+ (NSString *)dc_dencodingByUTF8WithUrl:(NSString *)url;

#pragma mark -  去掉首位为零的字符串
+ (NSString *)getFirstNoZoneStr:(NSString *)str;

#pragma mark - 富文本设置部分字体颜色
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color font:(UIFont*)font;
@end

NS_ASSUME_NONNULL_END
