//
//  DCCacheTool.m
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCCacheTool.h"

@implementation DCCacheTool


+ (DCCacheTool*)shareTool{
    static DCCacheTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - 获取缓存文件的大小
- (float)dc_readCacheSize{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath:cachePath];
}


#pragma mark -  获取缓存大小 **M
- (NSString *)dc_readCacheString
{
    float size = [self dc_readCacheSize];
    if (size > 1024) {
        return [NSString stringWithFormat:@"%.2fM",(float)size/1024];
    }
    return [NSString stringWithFormat:@"%.2fKB",size];
}


//由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
// 遍历文件夹获得文件夹大小，返回多少 M
- (float)folderSizeAtPath:(NSString *)folderPath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 *1024.0);
    
}

// 计算 单个文件的大小
- (long long)fileSizeAtPath:(NSString *) filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

#pragma mark - 清除缓存
- (void)dc_cleanCache{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray *files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString *p in files) {
        
        NSError *error = nil ;
        //获取文件全路径
        NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
}

@end
