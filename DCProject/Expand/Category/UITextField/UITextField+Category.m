//
//  UITextField+Category.m
//  DCProject
//
//  Created by bigbing on 2020/4/28.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "UITextField+Category.h"

@implementation UITextField (Category)

- (void)setPlaceholder:(NSString *)placeholder
{
    self.attributedPlaceholder = [NSString dc_placeholderWithString:placeholder];
}

@end
