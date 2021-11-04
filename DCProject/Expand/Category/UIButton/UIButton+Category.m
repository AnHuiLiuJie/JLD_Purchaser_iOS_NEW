//
//  UIButton+Category.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)


#pragma mark -  图片在左  文字在右  spacing间隔
- (void)dc_buttonIconLeftWithSpacing:(CGFloat)spacing
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2)];
}


#pragma mark -  图片在右  文字在左  spacing间隔
- (void)dc_buttonIconRightWithSpacing:(CGFloat)spacing
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width + spacing, 0, -self.titleLabel.bounds.size.width - spacing)];
}


#pragma mark -  图片在上  文字在下  spacing间隔
- (void)dc_buttonIconTopWithSpacing:(CGFloat)spacing
{
    [self setImageEdgeInsets:UIEdgeInsetsMake(-spacing, (self.frame.size.width - self.imageView.frame.size.width)/2, 0, (self.frame.size.width - self.imageView.frame.size.width)/2)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height + spacing, -self.imageView.frame.size.width, 0, 0)];
}


#pragma mark -  图片在下  文字在上  spacing间隔
- (void)dc_buttonIconBottomWithSpacing:(CGFloat)spacing
{
    
}


#pragma mark - 边框  切角
- (void)dc_layerBorderWith:(CGFloat)width color:(UIColor *)color radius:(CGFloat)radius
{
    if (width && width > 0) {
        self.layer.borderWidth = width;
        self.layer.borderColor = color.CGColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = radius;
    }else{
        self.clipsToBounds = YES;
        self.layer.cornerRadius = radius;
    }
}


@end
