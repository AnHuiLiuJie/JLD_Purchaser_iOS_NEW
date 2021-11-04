//
//  CALayer+Category.h
//  DCProject
//
//  Created by bigbing on 2019/4/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Category)

- (void)setBorderColorFromUIColor:(UIColor *)color;

- (void)testBorderColorAndBoundary:(UIColor *)color;



@end

NS_ASSUME_NONNULL_END
