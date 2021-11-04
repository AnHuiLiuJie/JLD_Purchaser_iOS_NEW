//
//  CaptchaRepModel.h
//  captcha_oc
//
//  Created by kean_qi on 2020/5/23.
//  Copyright © 2020 kean_qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaptchaRepModel : DCBaseModel

@property (nonatomic, copy) NSString *originalImageBase64;
@property (nonatomic, copy) NSString *jigsawImageBase64;
@property (nonatomic, copy) NSString *captchaToken;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSArray *wordList;
@property (nonatomic, copy) NSString *point;

@end


@interface CaptchaCheckModel : DCBaseModel
@property (nonatomic, copy) NSString *repCode;
@property (nonatomic, copy) NSString *repData;
@property (nonatomic, copy) NSString *repMsg;
@property (nonatomic, copy) NSString *success;
@end

NS_ASSUME_NONNULL_END
