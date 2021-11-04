//
//  NSObject+Category.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

#pragma mark - 判断一个对象是否为空
- (BOOL)dc_isNull
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
        
    }else if ([self isEqual:[NSNull class]]){
        return YES;
    }else{
        if (self == nil) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([((NSString *)self) isEqualToString:@"(null)"]) {
            return YES;
        } else if ([((NSString *)self) isEqualToString:@"<null>"]) {
            return YES;
        }
    }
    
    return NO;
}

@end
