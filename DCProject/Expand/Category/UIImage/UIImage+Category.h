//
//  UIImage+Category.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

#pragma mark -  等比压缩图片 解决iOS上直接缩小UIImageView的大小会产生锯齿,可以先将其缩放后再使用. 类似于CALayer 属性minificationFilter、magnificationFilter
+ (UIImage *)dc_scaleToImage:(UIImage *)img size:(CGSize)size;

#pragma mark - 生成特定颜色得图片
+ (UIImage *)dc_initImageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 获取启动图图片
+ (UIImage *)dc_getLaunchImage;

#pragma mark - 图片旋转
+ (UIImage *)dc_image:(UIImage *)image rotation:(UIImageOrientation)orientation;

#pragma mark - 图片缩小
+ (UIImage *)dc_scaleImage:(UIImage *)image toScale:(float)scaleSize;

#pragma mark - 自定义裁剪算法
+ (UIImage *)dealImage:(UIImage *)img cornerRadius:(CGFloat)c;

/** 保护性拉伸图片，通常用来使用小图做背景 */
+ (UIImage *) resizedImage:(NSString *) imageName;


#pragma mark - 返回渐变的image
+ (UIImage *)gradientImageFromColors:(NSArray*)colors ByGradientType:(NSInteger)gradientType inSize:(CGSize)size;

@end


typedef void (^GIFimageBlock)(UIImage *GIFImage);

#pragma mark - gif图
@interface UIImage (GIFImage)

/** 根据本地GIF图片名 获得GIF image对象 */
+ (UIImage *)imageWithGIFNamed:(NSString *)name;

/** 根据一个GIF图片的data数据 获得GIF image对象 */
+ (UIImage *)imageWithGIFData:(NSData *)data;

/** 根据一个GIF图片的URL 获得GIF image对象 */
+ (void)imageWithGIFUrl:(NSString *)url and:(GIFimageBlock)gifImageBlock;


@end

NS_ASSUME_NONNULL_END
