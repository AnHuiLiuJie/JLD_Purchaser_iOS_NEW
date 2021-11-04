//
//  DCPhoneTextField.m
//  LieShou
//
//  Created by Apple on 2018/8/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "DCTextField.h"
#import "NSString+Emoji.h"

@interface DCTextField ()<UITextFieldDelegate>

@end

@implementation DCTextField

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

#pragma mark - 添加监听方式
- (void)addTargetWithType:(DCTextFieldType)type{
    
    self.delegate = self;
    
    switch (type) {
        case DCTextFieldTypeDefault:
            
            [self addTarget:self action:@selector(defalutEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            break;
        case DCTextFieldTypeTelePhone:
            
            [self addTarget:self action:@selector(telePhoneEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            self.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
        case DCTextFieldTypePassWord:
            
//            [self addTarget:self action:@selector(passWordEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            self.secureTextEntry = YES;
            
            break;
        case DCTextFieldTypeSMSCode:
            
            [self addTarget:self action:@selector(smsCodeEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            break;
        case DCTextFieldTypeMoney:
            
            [self addTarget:self action:@selector(moneyEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            self.keyboardType = UIKeyboardTypeDecimalPad;
            
            break;
        case DCTextFieldTypeIDCard:
            
            [self addTarget:self action:@selector(idCardEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            break;
        case DCTextFieldTypeImageCode:
            
            [self addTarget:self action:@selector(imageCodeEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            break;
        case DCTextFieldTypeZimu:
            
            [self addTarget:self action:@selector(zimuEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            break;
        case DCTextFieldTypeUserName:
            
            [self addTarget:self action:@selector(usernameEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            break;
        case DCTextFieldTypeCount:
            
            [self addTarget:self action:@selector(countEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            self.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 监听 默认输入框
- (void)defalutEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        // 过滤emoji
        if (textfield.text.length > 0) {
            textfield.text = [textfield.text dc_noEmoji];
        }
        
    }else { //有高亮文字
        //do nothing
    }
}

#pragma mark - 监听 电话号码输入框
- (void)telePhoneEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        //过滤非数字
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^0-9]"];
        
        if (textfield.text.length >= 11) {
            textfield.text = [textfield.text substringToIndex:11];
        }
        
    }else { //有高亮文字
        //do nothing
    }
}

#pragma mark - 监听 密码输入框
- (void)passWordEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        //过滤
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^A-Za-z0-9-()（）—”“$&@%^*?+?=|{}?【】？??￥!！.<>/:;：；、,，。]"];
        
        if (textfield.text.length >= 18) {
            textfield.text = [textfield.text substringToIndex:18];
        }
        
    }else { //有高亮文字
        //do nothing
    }
}

#pragma mark - 监听 短信验证码输入框
- (void)smsCodeEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        //过滤
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^0-9]"];
        
        if (textfield.text.length >= 6) {
            textfield.text = [textfield.text substringToIndex:6];
        }
        
    }else { //有高亮文字
        //do nothing
    }
}

#pragma mark - 监听 人民币输入框
- (void)moneyEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        // 过滤非法字符
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^0-9.]"];
        
        
        if ([textfield.text containsString:@"."]) {
            
            // 过滤多个小数点
            NSArray *array = [textfield.text componentsSeparatedByString:@"."];
            if (array.count > 2) {
                textfield.text = [NSString stringWithFormat:@"%@.%@",array[0],array[1]];
            }
            
            // 过滤小数点后超过两位数
            NSArray *otherArray = [textfield.text componentsSeparatedByString:@"."];
            NSString *lastStr = otherArray[1];
            if (lastStr.length > 2) {
                lastStr = [lastStr substringToIndex:2];
                textfield.text = [NSString stringWithFormat:@"%@.%@",otherArray[0],lastStr];
            }
        }
        
        // 过滤第一位为小数点的情况
        if (textfield.text.length > 0) {
            NSString *str = [textfield.text substringToIndex:1];
            if ([str isEqualToString:@"."]) {
                textfield.text = [textfield.text substringFromIndex:1];
            }
        }
        
        
    }else { //有高亮文字
        //do nothing
    }
}


#pragma mark - 监听 身份证输入框
- (void)idCardEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        // 过滤非法字符
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^0-9xX]"];
        
        // 过滤长度
        if (textfield.text.length >= 18) {
            textfield.text = [textfield.text substringToIndex:18];
        }
        
    }else { //有高亮文字
        //do nothing
    }
}


#pragma mark - 监听 图形验证码输入框
- (void)imageCodeEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        //过滤
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^A-Za-z0-9+-]"];
        
    }else { //有高亮文字
        //do nothing
    }
}


#pragma mark - 监听 字母 + 数组输入框
- (void)zimuEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        //过滤
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^A-Za-z0-9]"];
        
    }else { //有高亮文字
        //do nothing
    }
}


#pragma mark - 监听 用户名输入框
- (void)usernameEditingChanged:(UITextField *)textfield
{
//    UITextRange *selectedRange = textfield.markedTextRange;
//    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
//
//    if (!position) { // 没有高亮选择的字
//
//        //过滤
//        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^A-Za-z0-9+_]"];
//
//        // 过滤长度
//        if (textfield.text.length >= 20) {
//            textfield.text = [textfield.text substringToIndex:20];
//        }
//
//    }else { //有高亮文字
//        //do nothing
//    }
}


#pragma mark - 监听 数量输入框
- (void)countEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = textfield.markedTextRange;
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        //过滤非数字
        textfield.text = [self filterCharactor:textfield.text withRegex:@"[^0-9]"];
        
    }else { //有高亮文字
        //do nothing
    }
}


#pragma mark - 根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr
{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}



#pragma mark - setter
- (void)setType:(DCTextFieldType)type
{
    _type = type;
    
    [self addTargetWithType:_type];
    
    if (_type == DCTextFieldTypePassWord) {
        self.clearButtonMode = UITextFieldViewModeUnlessEditing;
    }
}

@end
