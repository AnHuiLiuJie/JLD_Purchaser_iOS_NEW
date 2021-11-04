//
//  DCCacheTool.h
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCCacheTool : NSObject

/* 创建单列 */
+ (DCCacheTool*)shareTool;

/* 获取缓存大小 */
- (float)dc_readCacheSize;

/* 获取缓存大小 **M */
- (NSString *)dc_readCacheString;

/* 清除缓存 */
- (void)dc_cleanCache;

@end

NS_ASSUME_NONNULL_END
