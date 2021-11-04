//
//  GLPPaymentPasswordVC.h
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import "DCBasicViewController.h"
#import "GLPVerifyPayPwdModel.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark - 密码页功能
typedef NS_OPTIONS(NSUInteger, PasswordFunctionType) {
    PasswordFunctionTypeSite    = 1,//设置支付密码
    PasswordFunctionTypeConfirmForSet  ,//确认支付密码用于修改密码
    PasswordFunctionTypeConfirmForVerify  ,//确认支付密码用于验证
    PasswordFunctionTypeConfirmForUntie  ,//确认支付密码用于解绑验证
};

@interface GLPPaymentPasswordVC : DCBasicViewController

@property (nonatomic, assign) PasswordFunctionType showType;

@property (nonatomic, copy) void(^GLPPaymentPasswordVC_block)(NSString *md5Pwd);

@end

NS_ASSUME_NONNULL_END
