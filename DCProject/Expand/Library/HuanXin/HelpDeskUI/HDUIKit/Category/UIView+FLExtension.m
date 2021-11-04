//
//  UIView+FLExtension.m
//  FLPictureBrowser
//
//  Created by ease
//

#import "UIView+FLExtension.h"

@implementation UIView (FLExtension)


- (void)setFl_originX:(CGFloat)fl_originX {
    CGRect frame = self.frame;
    frame.origin.x = fl_originX;
    self.frame =frame;
}

- (void)setFl_originY:(CGFloat)fl_originY {
    CGRect frame = self.frame;
    frame.origin.y= fl_originY;
    self.frame =frame;
}

- (CGFloat)fl_originX {
    return self.frame.origin.x;
}


- (CGFloat)fl_originY {
    return self.frame.origin.y;
}

- (void)setFl_width:(CGFloat)fl_width
{
    CGRect frame = self.frame;
    
    frame.size.width = fl_width;
    self.frame =frame;
    
}

- (void)setFl_height:(CGFloat)fl_height
{
    CGRect frame = self.frame;
    frame.size.height = fl_height;
    self.frame =frame;
}

- (CGFloat)fl_width
{
    return self.frame.size.width;
    
}

- (CGFloat)fl_height
{
    return self.frame.size.height;
    
}

- (void)setFl_size:(CGSize)fl_size
{
    CGRect frame = self.frame;
    
    frame.size = fl_size;
    self.frame =frame;
    
    
}

-(CGSize)fl_size
{
    
    return self.frame.size;
    
}

- (void)setFl_origin:(CGPoint)fl_origin
{
    
    CGRect frame =self.frame;
    frame.origin =fl_origin;
    self.frame = frame;
}


-(CGPoint)fl_origin
{
    return self.frame.origin;
    
}

- (CGFloat)fl_left {
    return self.frame.origin.x;
}

- (void)setFl_left:(CGFloat)fl_x {
    CGRect frame = self.frame;
    frame.origin.x = fl_x;
    self.frame = frame;
}

- (CGFloat)fl_top {
    return self.frame.origin.y;
}

- (void)setFl_top:(CGFloat)fl_y {
    CGRect frame = self.frame;
    frame.origin.y = fl_y;
    self.frame = frame;
}

- (CGFloat)fl_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFl_right:(CGFloat)fl_right {
    CGRect frame = self.frame;
    frame.origin.x = fl_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)fl_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFl_bottom:(CGFloat)fl_bottom {
    CGRect frame = self.frame;
    frame.origin.y = fl_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)fl_centerX {
    return self.center.x;
}

- (void)setFl_centerX:(CGFloat)fl_centerX {
    self.center = CGPointMake(fl_centerX, self.center.y);
}

- (CGFloat)fl_centerY {
    return self.center.y;
}

- (void)setFl_centerY:(CGFloat)fl_centerY {
    self.center = CGPointMake(self.center.x, fl_centerY);
}
@end
