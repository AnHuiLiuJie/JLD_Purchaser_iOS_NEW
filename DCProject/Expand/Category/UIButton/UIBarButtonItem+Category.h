//
//  UIBarButtonItem+Category.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Category)

#pragma -  左侧 image
+ (UIBarButtonItem *)dc_leftItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

#pragma -  右侧 image
+ (UIBarButtonItem *)dc_rightItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

#pragma - img + title
+ (UIBarButtonItem *)dc_itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

#pragma - title
+ (UIBarButtonItem *)dc_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

#pragma - title 右侧
+ (UIBarButtonItem *)dc_rightItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

#pragma - title color font
+ (UIBarButtonItem *)dc_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
