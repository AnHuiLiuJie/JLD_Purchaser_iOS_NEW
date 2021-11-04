//
//  DCHttpClient.h
//  DCProject
//
//  Created by bigbing on 2019/4/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , DCHttpRequestType) {
    DCHttpRequestGet = 0,
    DCHttpRequestPost,
    DCHttpRequestJsonPost,
};

NS_ASSUME_NONNULL_BEGIN

@interface DCHttpClient : NSObject


+ (DCHttpClient *) shareClient;



+ (void)setBaseUrl:(NSString *)baseUrl;



- (void)requestWithPath:(NSString *)path
                 params:(NSDictionary *__nullable)params
             httpMethod:(DCHttpRequestType)method
                 sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture;



- (void)requestWithBaseUrl:(NSString *)baseUrl
                      path:(NSString *)path
                    params:(NSDictionary *__nullable)params
                httpMethod:(DCHttpRequestType)method
                    sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture;



- (void)requestUploadWithPath:(NSString *)path
                       images:(NSArray *)images
                       params:(NSDictionary *__nullable)params
                     progress:(void(^)(NSProgress *uploadProgress))progress
                       sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture;



- (void)requestFileDownloadWithPath:(NSString *)path
                           progress:(void(^)(NSProgress *uploadProgress))progress
                           complete:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))complete;


- (void)personRequestUploadWithPath:(NSString *)path
                       images:(NSArray *)images
                       params:(NSDictionary *__nullable)params
                     progress:(void(^)(NSProgress *uploadProgress))progress
                       sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture;
@end

NS_ASSUME_NONNULL_END
