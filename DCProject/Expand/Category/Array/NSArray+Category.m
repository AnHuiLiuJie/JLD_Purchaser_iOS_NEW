//
//  NSArray+Category.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//CO2FLOXAQO5N
#import "NSArray+Category.h"
#import <ImageIO/ImageIO.h>

@implementation NSArray (Category)

#pragma mark -  将一个gif转换为一帧一帧的数组
+ (NSArray *)dc_imageWithGIF:(NSString *)gifBoundle
{
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:gifBoundle withExtension:@"gif"];
    
    // 获取到GIF图的源数据 CGImageSourceRef
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (size_t i = 0; i< gifCount; i++) {
        // 由源数据 SourceRef生成一张CGImageRef类型图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        // 用CGImageRef生成UIImage
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        
        // 等比压缩图片
        UIImage *newImage = [UIImage dc_scaleToImage:image size:CGSizeMake(50, 50)];
        
        [frames addObject:newImage];
        CGImageRelease(imageRef);
    }
    return frames;
}

@end
