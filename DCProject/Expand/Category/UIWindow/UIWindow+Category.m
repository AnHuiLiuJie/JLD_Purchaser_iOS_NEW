//
//  UIWindow+Category.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "UIWindow+Category.h"

@implementation UIWindow (Category)

- (void)dc_disable
{
    DC_KeyWindow.userInteractionEnabled = NO;
}


- (void)dc_enable
{
    DC_KeyWindow.userInteractionEnabled = YES;
}


@end
