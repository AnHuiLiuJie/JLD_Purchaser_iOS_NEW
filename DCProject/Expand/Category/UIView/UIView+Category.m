//
//  UIView+Category.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

#pragma mark - 分类 关于view.frame
@implementation UIView (Category)

- (CGFloat)dc_x {
    return self.frame.origin.x;
}


- (void)setDc_x:(CGFloat)dc_x {
    CGRect dcFrame = self.frame;
    dcFrame.origin.x = dc_x;
    self.frame = dcFrame;
}


- (CGFloat)dc_y {
    return self.frame.origin.y;
}

- (void)setDc_y:(CGFloat)dc_y {
    CGRect dcFrame = self.frame;
    dcFrame.origin.y = dc_y;
    self.frame = dcFrame;
}


- (CGPoint)dc_origin {
    return self.frame.origin;
}

- (void)setDc_origin:(CGPoint)dc_origin {
    CGRect dcFrame = self.frame;
    dcFrame.origin = dc_origin;
    self.frame = dcFrame;
}


- (CGFloat)dc_width {
    return self.frame.size.width;
}


- (void)setDc_width:(CGFloat)dc_width {
    CGRect dcFrame = self.frame;
    dcFrame.size.width = dc_width;
    self.frame = dcFrame;
}


- (CGFloat)dc_height {
    return self.frame.size.height;
}


- (void)setDc_height:(CGFloat)dc_height {
    CGRect dcFrame = self.frame;
    dcFrame.size.height = dc_height;
    self.frame = dcFrame;
}


- (CGSize)dc_size {
    return self.frame.size;
}


- (void)setDc_size:(CGSize)dc_size {
    CGRect dcFrame = self.frame;
    dcFrame.size = dc_size;
    self.frame = dcFrame;
}


- (CGFloat)dc_centerX {
    return self.center.x;
}


- (void)setDc_centerX:(CGFloat)dc_centerX {
    CGPoint dcFrmae = self.center;
    dcFrmae.x = dc_centerX;
    self.center = dcFrmae;
}

- (CGFloat)dc_centerY {
    return self.center.y;
}


- (void)setDc_centerY:(CGFloat)dc_centerY {
    CGPoint dcFrame = self.center;
    dcFrame.y = dc_centerY;
    self.center = dcFrame;
}


- (CGFloat)dc_right {
    return CGRectGetMaxX(self.frame);
}


- (CGFloat)dc_bottom {
    
    return CGRectGetMaxY(self.frame);
}


- (void)setDc_right:(CGFloat)dc_right {
    self.dc_x = dc_right - self.dc_width;
}


- (void)setDc_bottom:(CGFloat)dc_bottom {
    self.dc_y = dc_bottom - self.dc_height;
}


- (BOOL)intersectWithView:(UIView *)view {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}


- (BOOL)isShowingOnKeyWindow {
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

+ (instancetype)dc_viewFromXib {
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


@end



#pragma mark - 分类 关于view的边框 切角
@implementation UIView (BorderLine)

- (UIView *)dc_borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    
    if (borderType == UIBorderSideTypeAll) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.CGColor;
        return self;
    }
    
    
    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(self.frame.size.width, 0.0f) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(self.frame.size.width, 0.0f) color:color borderWidth:borderWidth]];
    }
    
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, self.frame.size.height) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    
    return self;
}

- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    
    /// 线的路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    return shapeLayer;
}


#pragma mark - 任意切角
- (void)dc_cornerRadius:(CGFloat)readius rectCorner:(UIRectCorner)rectCorner
{
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(readius, readius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
}

#pragma mark - 切角
- (void)dc_cornerRadius:(CGFloat)readius
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = readius;
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




#pragma mark - 渐变色
@implementation UIView (Color)

- (CAGradientLayer *)dc_changeColorWithStart:(CGPoint)start end:(CGPoint)end locations:(NSArray *)locations colors:(NSArray *)colors
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.startPoint = start; // CGPointMake(0, 0)
    gradient.endPoint = end; // CGPointMake(1, 1)
    gradient.locations = locations; // @[@0.3, @0.5, @0.6]
    gradient.colors = colors;
//      [NSArray arrayWithObjects:
//    (id)[UIColor redColor].CGColor,
//    (id)[UIColor greenColor].CGColor,
//    (id)[UIColor blueColor].CGColor,
//    nil]
    return gradient;
}

@end




@implementation UIView (AZGradient)


+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)az_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view az_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)az_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.az_colors = [colorsM copy];
    self.az_locations = locations;
    self.az_startPoint = startPoint;
    self.az_endPoint = endPoint;
}

#pragma mark- Getter&Setter

- (NSArray *)az_colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAz_colors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(az_colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.az_colors];
    }
}

- (NSArray<NSNumber *> *)az_locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAz_locations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(az_locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.az_locations];
    }
}

- (CGPoint)az_startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setAz_startPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(az_startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.az_startPoint];
    }
}

- (CGPoint)az_endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setAz_endPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(az_endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.az_endPoint];
    }
}


@end

@implementation UILabel (AZGradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end



