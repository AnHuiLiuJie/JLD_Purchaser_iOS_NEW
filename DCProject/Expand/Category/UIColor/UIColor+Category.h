//
//  UIColor+Category.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Category)

#pragma mark - 十六进制颜色
+ (UIColor *)dc_colorWithHexString:(NSString *)color;
#pragma mark - 十六进制颜色
+ (UIColor *)dc_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
