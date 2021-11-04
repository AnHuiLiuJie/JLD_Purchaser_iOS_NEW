//
//  UIButton+Category.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Category)

//  图片在左  文字在右  spacing间隔
- (void)dc_buttonIconLeftWithSpacing:(CGFloat)spacing;

//  图片在右  文字在左  spacing间隔
- (void)dc_buttonIconRightWithSpacing:(CGFloat)spacing;

//  图片在上  文字在下  spacing间隔
- (void)dc_buttonIconTopWithSpacing:(CGFloat)spacing;

//  图片在下  文字在上  spacing间隔
- (void)dc_buttonIconBottomWithSpacing:(CGFloat)spacing;

//  设置button 边框  切角
- (void)dc_layerBorderWith:(CGFloat)width color:(UIColor *)color radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
