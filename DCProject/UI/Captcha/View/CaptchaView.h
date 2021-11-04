//
//  CaptchaView.h
//  captcha_oc
//
//  Created by kean_qi on 2020/5/23.
//  Copyright © 2020 kean_qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DH_EncryptAndDecrypt.h"
#import "CaptchaRepModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,CaptchaType){
    puzzle = 0,//滑动拼图
    clickword = 1//字符校验
};
typedef NS_ENUM(NSUInteger,CaptchaResult){
    normalState,
    progressState,
    successState,
    failureState
};

@interface CaptchaView : UIView
@property (nonatomic,copy) void(^completeBlock)(NSString *result);
@property (nonatomic,assign) CaptchaType currentType;
@property (nonatomic,assign) CaptchaResult capchaResult;

+ (void)showWithType:(CaptchaType)type CompleteBlock:(void(^)(NSString *result))completeBlock;
@end

NS_ASSUME_NONNULL_END
