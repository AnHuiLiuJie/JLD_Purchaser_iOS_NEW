//
//  DCPhoneTextField.h
//  LieShou
//
//  Created by Apple on 2018/8/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DCTextFieldType){
    DCTextFieldTypeDefault = 0,  // 默认输入框
    DCTextFieldTypeTelePhone,    // 手机号码输入框
    DCTextFieldTypePassWord,     // 密码输入框
    DCTextFieldTypeSMSCode,      // 短信验证码输入框
    DCTextFieldTypeMoney,        // 人民币输入框
    DCTextFieldTypeIDCard,       // 身份证输入框
    DCTextFieldTypeImageCode,    // 图形验证码
    DCTextFieldTypeZimu,         // 字母+数字
    DCTextFieldTypeUserName,     // 用户名 6-20位数字、字母或下划线组合
    DCTextFieldTypeCount         // 数量
};

NS_ASSUME_NONNULL_BEGIN

@interface DCTextField : UITextField

// 输入框类型
@property (nonatomic, assign) DCTextFieldType type;

@end

NS_ASSUME_NONNULL_END
