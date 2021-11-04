//
//  NSArray+Category.h
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Category)

/// 将一个gif转换为一帧一帧的数组
+ (NSArray *)dc_imageWithGIF:(NSString *)gifBoundle;

@end

NS_ASSUME_NONNULL_END
