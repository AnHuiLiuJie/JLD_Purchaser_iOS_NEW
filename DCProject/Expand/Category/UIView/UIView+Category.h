//
//  UIView+Category.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UIBorderSideType) {
    UIBorderSideTypeAll = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
};

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 分类 关于view.frame
@interface UIView (Category)

@property (nonatomic , assign) CGFloat dc_width;
@property (nonatomic , assign) CGFloat dc_height;
@property (nonatomic , assign) CGSize  dc_size;
@property (nonatomic , assign) CGFloat dc_x;
@property (nonatomic , assign) CGFloat dc_y;
@property (nonatomic , assign) CGPoint dc_origin;
@property (nonatomic , assign) CGFloat dc_centerX;
@property (nonatomic , assign) CGFloat dc_centerY;
@property (nonatomic , assign) CGFloat dc_right;
@property (nonatomic , assign) CGFloat dc_bottom;

- (BOOL)intersectWithView:(UIView *)view;

+ (instancetype)dc_viewFromXib;
- (BOOL)isShowingOnKeyWindow;


@end


#pragma mark - 分类 关于view的边框 切角
@interface UIView (BorderLine)


- (UIView *)dc_borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;


#pragma mark - 任意切角
- (void)dc_cornerRadius:(CGFloat)readius rectCorner:(UIRectCorner)rectCorner;

#pragma mark - 切角
- (void)dc_cornerRadius:(CGFloat)readius;


#pragma mark - 边框  切角
- (void)dc_layerBorderWith:(CGFloat)width color:(UIColor *)color radius:(CGFloat)radius;


@end



#pragma mark - 渐变色
@interface UIView (Color)

- (CAGradientLayer *)dc_changeColorWithStart:(CGPoint)start end:(CGPoint)end locations:(NSArray *)locations colors:(NSArray *)colors;

@end


@interface UIView (AZGradient)

/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */

@property(nullable, copy) NSArray *az_colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. Animatable. */

@property(nullable, copy) NSArray<NSNumber *> *az_locations;

/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */

@property CGPoint az_startPoint;
@property CGPoint az_endPoint;

+ (UIView *_Nullable)az_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)az_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
