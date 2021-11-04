//
//  UILabel+Category.m
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

#pragma mark - 创建UILabel
+ (UILabel*)lableFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor*)color font:(UIFont*)font textColor:(UIColor*)textColor
{
    UILabel *lable = [[UILabel alloc]initWithFrame:frame];
    lable.text = title;
    lable.font = font;
    [lable setBackgroundColor:color];
    lable.textColor = textColor;
    return lable;
}

+ (UILabel *)setupAttributeReplaceText:(NSString *)replaceText textColor:(UIColor *_Nullable)color font:(UIFont *_Nullable)font label:(UILabel *)myLable
{
    UIColor *MinColor = color;
    if (color == nil) {
        MinColor = myLable.textColor;
    }
    
    UIFont *minFont = font;
    if (font == nil) {
        CGFloat fontSize = myLable.font.pointSize;
        minFont = [UIFont fontWithName:PFR size:fontSize-2];
    }
    NSString *text = myLable.text;
//    NSString *floStr;
//    NSString *intStr;
//    if ([text containsString:replaceText]) {
//        NSRange range = [text rangeOfString:replaceText];
//        intStr = [text substringToIndex:range.location];//前
//        floStr = [text substringFromIndex:range.location];//后(包括)
//    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:replaceText];
    [AttributedStr setAttributes:@{NSForegroundColorAttributeName:MinColor,NSFontAttributeName:minFont} range:range];
    myLable.attributedText = AttributedStr;
    return myLable;
}

#pragma mark -价格 ¥小 小数点后面也小 只针对价格  如 ¥288.97
+ (UILabel *)setupAttributeLabel:(UILabel *)myLable textColor:(UIColor *_Nullable)color minFont:(UIFont *_Nullable)minFont maxFont:(UIFont *_Nullable)maxFont forReplace:(NSString *)replaceStr
{
    UIColor *MinColor = color;
    if (color == nil) {
        MinColor = myLable.textColor;
    }
    
    NSString *text = myLable.text;
    
    UIFont *MinFont = minFont;
    UIFont *MinFont1 = minFont;
    if (minFont == nil) {
        CGFloat fontSize = myLable.font.pointSize - 3;
        fontSize = fontSize > 8 ? fontSize : 9;
        MinFont = [UIFont fontWithName:PFR size:fontSize];
        MinFont1 = [UIFont fontWithName:PFR size:fontSize-1];
    }
    
    //UIFont *MaxFont = myLable.font;
    UIFont *MaxFont = maxFont;
    if (maxFont == nil) {
        CGFloat fontSize = myLable.font.pointSize;
        MaxFont = [UIFont fontWithName:PFRMedium size:fontSize];
    }
    
    NSString *qianStr;
    NSString *floStr;
    NSString *intStr;
    
    if ([text containsString:replaceStr]) {
        qianStr = replaceStr;
    }
    
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        intStr = [text substringToIndex:range.location];//前
        floStr = [text substringFromIndex:range.location];//后(包括.)
        intStr = [intStr stringByReplacingOccurrencesOfString:replaceStr withString:@""];//去掉¥
    }
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:text];
    
    
    if ([text containsString:replaceStr]) {
        NSRange range1 = [text rangeOfString:qianStr];
        [AttributedStr1 setAttributes:@{NSForegroundColorAttributeName:MinColor,NSFontAttributeName:MinFont1} range:range1];
    }
    
    NSRange range = [text rangeOfString:intStr];
    [AttributedStr1 setAttributes:@{NSForegroundColorAttributeName:MinColor,NSFontAttributeName:MaxFont} range:range];
    
    NSRange range2 = [text rangeOfString:floStr];
    [AttributedStr1 setAttributes:@{NSForegroundColorAttributeName:MinColor,NSFontAttributeName:MinFont} range:range2];
    
    myLable.attributedText = AttributedStr1;
    return myLable;
}


#pragma mark - ChangeLineSpaceAndWordSpace.h

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}


@end
