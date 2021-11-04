//
//  UIBarButtonItem+Category.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "UIBarButtonItem+Category.h"

#define PFSC [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"

@implementation UIBarButtonItem (Category)

+ (UIBarButtonItem *)dc_leftItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 38, 38);
    
    if (@available(ios 11.0,*)) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)dc_rightItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 38, 38);
    
    if (@available(ios 11.0,*)) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (UIBarButtonItem *)dc_itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 38, 38);
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(ios 11.0,*)) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10,0, 0);
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (UIBarButtonItem *)dc_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:PFSC size:14];
    [button sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (UIBarButtonItem *)dc_rightItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:PFSC size:14];
    [button sizeToFit];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    CGFloat width = [title boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFSC size:14]} context:nil].size.width + 20;
    button.frame = CGRectMake(0, 0, 44, width);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


#pragma - title color font
+ (UIBarButtonItem *)dc_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitleColor:color forState:0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = font;
    [button sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
