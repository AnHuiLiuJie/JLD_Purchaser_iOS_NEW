//
//  CaptchaRepModel.m
//  captcha_oc
//
//  Created by kean_qi on 2020/5/23.
//  Copyright © 2020 kean_qi. All rights reserved.
//

#import "CaptchaRepModel.h"
//#import <JSONModel/JSONModel.h>
@implementation CaptchaRepModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"originalImageBase64":@"original",@"jigsawImageBase64":@"jigsaw"};
}

//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    return YES;
//}
//
//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"id": @"ID",
//    @"description": @"desc"
//    }];
//}

@end


@implementation CaptchaCheckModel

@end
