//
//  UIBarButtonItem+Extension.m
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype) itemWithImage:(NSString *) imageName hightlightedImage:(NSString *) highlightedImageName target:(id)target selector:(SEL)selector {
    UIBarButtonItem *item = [[self alloc] init];
    
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    
    // 一定要设置frame，才能显示
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // 设置不自动调整按钮
    button.adjustsImageWhenHighlighted = NO;
    button.adjustsImageWhenDisabled = NO;
    
    // 设置事件
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    item.customView = button;
    return item;
}

@end
