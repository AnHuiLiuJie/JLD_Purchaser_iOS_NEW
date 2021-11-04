//
//  UIImage+Category.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "UIImage+Category.h"

#import <ImageIO/ImageIO.h>

@implementation UIImage (Category)

#pragma mark -  解决iOS上直接缩小UIImageView的大小会产生锯齿,可以先将其缩放后再使用. 类似于CALayer 属性minificationFilter、magnificationFilter
+ (UIImage *)dc_scaleToImage:(UIImage *)img size:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


#pragma mark - 生成特定颜色得图片
+ (UIImage *)dc_initImageWithColor:(UIColor *)color size:(CGSize)size
{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //绘制颜色区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [color setFill];
    [path fill];
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(ctx, color.CGColor);
    //    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 获取启动图图片
+ (UIImage *)dc_getLaunchImage {
    UIImage *launchImg = [[UIImage alloc] init];
    NSString *orientation = @"";
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft || statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        orientation = @"Landscape";
    } else {
        orientation = @"Portrait";
    }
    NSArray *imgsInfoArr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImages"];
    for (NSDictionary *info in imgsInfoArr) {
        CGSize imgSize = CGSizeFromString(info[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imgSize, screenSize) && [orientation isEqualToString:info[@"UILaunchImageOrientation"]] ) {
            launchImg = [UIImage imageNamed:info[@"UILaunchImageName"]];
        }
    }
    return launchImg;
}


#pragma mark - 图片旋转
+ (UIImage *)dc_image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 *M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

/** 保护性拉伸图片，通常用来使用小图做背景 */
+ (UIImage *) resizedImage:(NSString *) imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


#pragma mark - 图片缩小
+ (UIImage *)dc_scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width *scaleSize, image.size.height *scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width *scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark - 返回渐变的image
+ (UIImage *)gradientImageFromColors:(NSArray*)colors ByGradientType:(NSInteger)gradientType inSize:(CGSize)size{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(1.0, 1.0);
    
    switch (gradientType) {
        case 0:
        {
            //上下渐变
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
        }
            break;
        case 1:
        {
            //左右渐变
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
        }
            break;
        case 2:
        {
            //对角两侧渐变
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
        }
            break;
        case 3:
        {
            //对角两侧渐变
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
        }
            break;
        case 4:{
            //线性渐变
            start = CGPointMake(size.width/2, size.height/2);
            end = CGPointMake(size.width/2, size.height/2);
        }
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    if (gradientType == 4) {
        CGContextDrawRadialGradient(context, gradient, start, 10, end, size.width/3, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

// ------------------------------------------------------------------
// --------------------- 以下是自定义图像处理部分 -----------------------
// ------------------------------------------------------------------

// 自定义裁剪算法
+ (UIImage *)dealImage:(UIImage *)img cornerRadius:(CGFloat)c {
    // 1.CGDataProviderRef 把 CGImage 转 二进制流
    CGDataProviderRef provider = CGImageGetDataProvider(img.CGImage);
    void *imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
    int width = img.size.width *img.scale;
    int height = img.size.height *img.scale;
    
    // 2.处理 imgData
//    dealImage(imgData, width, height);
    cornerImage(imgData, width, height, c);
    
    // 3.CGDataProviderRef 把 二进制流 转 CGImage
    CGDataProviderRef pv = CGDataProviderCreateWithData(NULL, imgData, width *height *4, releaseData);
    CGImageRef content = CGImageCreate(width , height, 8, 32, 4 *width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, pv, NULL, true, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:content];
    CGDataProviderRelease(pv);      // 释放空间
    CGImageRelease(content);
    
    return result;
}

void releaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}

// 在 img 上处理图片, 测试用
void dealImage(UInt32 *img, int w, int h) {
    int num = w *h;
    UInt32 *cur = img;
    for (int i=0; i<num; i++, cur++) {
        UInt8 *p = (UInt8 *)cur;
        // RGBA 排列
        // f(x) = 255 - g(x) 求负片
        p[0] = 255 - p[0];
        p[1] = 255 - p[1];
        p[2] = 255 - p[2];
        p[3] = 255;
    }
}

// 裁剪圆角
void cornerImage(UInt32 *const img, int w, int h, CGFloat cornerRadius) {
    CGFloat c = cornerRadius;
    CGFloat min = w > h ? h : w;
    
    if (c < 0) { c = 0; }
    if (c > min *0.5) { c = min *0.5; }
    
    // 左上 y:[0, c), x:[x, c-y)
    for (int y=0; y<c; y++) {
        for (int x=0; x<c-y; x++) {
            UInt32 *p = img + y *w + x;    // p 32位指针，RGBA排列，各8位
            if (isCircle(c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右上 y:[0, c), x:[w-c+y, w)
    int tmp = w-c;
    for (int y=0; y<c; y++) {
        for (int x=tmp+y; x<w; x++) {
            UInt32 *p = img + y *w + x;
            if (isCircle(w-c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 左下 y:[h-c, h), x:[0, y-h+c)
    tmp = h-c;
    for (int y=h-c; y<h; y++) {
        for (int x=0; x<y-tmp; x++) {
            UInt32 *p = img + y *w + x;
            if (isCircle(c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右下 y~[h-c, h), x~[w-c+h-y, w)
    tmp = w-c+h;
    for (int y=h-c; y<h; y++) {
        for (int x=tmp-y; x<w; x++) {
            UInt32 *p = img + y *w + x;
            if (isCircle(w-c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
}

// 判断点 (px, py) 在不在圆心 (cx, cy) 半径 r 的圆内
static inline bool isCircle(float cx, float cy, float r, float px, float py) {
    if ((px-cx) *(px-cx) + (py-cy) *(py-cy) > r *r) {
        return false;
    }
    return true;
}

// 其他图像效果可以自己写函数，然后在 dealImage: 中调用 otherImage 即可
void otherImage(UInt32 *const img, int w, int h) {
    // 自定义处理
}


@end



@implementation UIImage (GIFImage)

+ (UIImage *)imageWithGIFData:(NSData *)data
{
    if (!data) return nil;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            // 拿出了Gif的每一帧图片
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            //Learning... 设置动画时长 算出每一帧显示的时长(帧时长)
            NSTimeInterval frameDuration = [UIImage sd_frameDurationAtIndex:i source:source];
            duration += frameDuration;
            // 将每帧图片添加到数组中
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            // 释放真图片对象
            CFRelease(image);
        }
        // 设置动画时长
        if (!duration) {
            duration = (1.0f / 10.0f) *count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    // 释放源Gif图片
    CFRelease(source);
    return animatedImage;
}


+ (UIImage *)imageWithGIFNamed:(NSString *)name
{
    NSUInteger scale = (NSUInteger)[UIScreen mainScreen].scale;
    
    return [self GIFName:name scale:scale];
    
}

+ (UIImage *)GIFName:(NSString *)name scale:(NSUInteger)scale
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    if (!imagePath) {
        (scale + 1 > 3) ? (scale -= 1) : (scale += 1);
        imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    }
    
    if (imagePath) {
        // 传入图片名(不包含@Nx)
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        return [UIImage imageWithGIFData:imageData];
    } else {
        imagePath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        if (imagePath) {
            // 传入的图片名已包含@Nx or 传入图片只有一张 不分@Nx
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            return [UIImage imageWithGIFData:imageData];
        } else {
            // 不是一张GIF图片(后缀不是gif)
            return [UIImage imageNamed:name];
        }
    }
    
}

+ (void)imageWithGIFUrl:(NSString *)url and:(GIFimageBlock)gifImageBlock
{
    NSURL *GIFUrl = [NSURL URLWithString:url];
    
    if (!GIFUrl) return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *CIFData = [NSData dataWithContentsOfURL:GIFUrl];
        
        // 刷新UI在主线程
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            gifImageBlock([UIImage imageWithGIFData:CIFData]);
            
        });
        
    });
    
}

#pragma mark - <关于GIF图片帧时长(Learning...)>

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    
    float frameDuration = 0.1f;
    
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    
    if (delayTimeUnclampedProp) {
        
        frameDuration = [delayTimeUnclampedProp floatValue];
        
    }
    
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        
        if (delayTimeProp) {
            
            frameDuration = [delayTimeProp floatValue];
            
        }
        
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    
    // a duration of <= 10 ms. See and
    
    // for more information.
    
    if (frameDuration < 0.011f) {
        
        frameDuration = 0.100f;
        
    }
    
    CFRelease(cfFrameProperties);
    
    return frameDuration;
    
}



@end
