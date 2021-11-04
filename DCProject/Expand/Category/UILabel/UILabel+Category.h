//
//  UILabel+Category.h
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Category)

#pragma mark - 创建UILabel
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor*)color font:(UIFont*)font textColor:(UIColor*)textColor;

#pragma mark - 替换字符 颜色 大小
+ (UILabel *)setupAttributeReplaceText:(NSString *)replaceText textColor:(UIColor *_Nullable)color font:(UIFont *__nullable)font label:(UILabel *)myLable;

#pragma mark -价格 ¥小 小数点后面也小 只针对价格  如 ¥288.97
+ (UILabel *)setupAttributeLabel:(UILabel *)myLable textColor:(UIColor *_Nullable)color minFont:(UIFont *_Nullable)minFont maxFont:(UIFont *_Nullable)maxFont forReplace:(NSString *)replaceStr;



#pragma mark - ChangeLineSpaceAndWordSpace.h
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end

NS_ASSUME_NONNULL_END
