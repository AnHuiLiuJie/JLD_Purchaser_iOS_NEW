//
//  CALayer+Category.m
//  DCProject
//
//  Created by bigbing on 2019/4/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "CALayer+Category.h"

@implementation CALayer (Category)

- (void)setBorderColorFromUIColor:(UIColor *)color{
    self.borderColor = color.CGColor;
}

- (void)testBorderColorAndBoundary:(UIColor *)color{
    self.borderColor = color.CGColor;
    self.borderWidth = 1;
}


@end
