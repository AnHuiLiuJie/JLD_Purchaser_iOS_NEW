//
//  DCHttpClient.m
//  DCProject
//
//  Created by bigbing on 2019/4/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCHttpClient.h"
#import "DCMD5Tool.h"
#import "DCSignTool.h"

static NSString *BASIC_URL;

@interface DCHttpClient ()
{
    AFHTTPSessionManager *_manager;
}
@end

@implementation DCHttpClient


+ (DCHttpClient *) shareClient {
    static DCHttpClient *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


+ (void)setBaseUrl:(NSString *)baseUrl{
    BASIC_URL = baseUrl;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Disposition"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        [_manager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"appVersion"];
        [_manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"appType"];
        
        _manager.securityPolicy.allowInvalidCertificates = NO;
        
        if (!BASIC_URL) {
            //            NSString *ipStr = [DCObjectManager dc_readUserDataForKey:DC_IP_Key];
            //            BASIC_URL = ipStr;
            BASIC_URL = DC_RequestUrl;
        }
    }
    return self;
}




- (void)requestWithPath:(NSString *)path
                 params:(NSDictionary *__nullable)params
             httpMethod:(DCHttpRequestType)method
                 sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture{
    
    NSString *url = DC_RequestUrl;
    
    if (path && ([path containsString:@"https"] || [path containsString:@"http"])) {
        url = path;
    } else if (path && [path length] > 0){
        url = [url stringByAppendingString:path];
    }
    
    
    NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
    NSString *userId = [DCObjectManager dc_readUserDataForKey:DC_UserID_Key];
    NSInteger iD = [userId integerValue];
    userId = [NSString stringWithFormat:@"%ld",(long)iD];
    if (token) {
        [_manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        [_manager.requestSerializer setValue:userId forHTTPHeaderField:@"userId"];
    } else {
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
    }
    NSString *time = [[DCSignTool shareClient] dc_nowTime];
    
    NSString *string = [[DCSignTool shareClient] dc_encrypt:time url:path parmas:params type:method];
    
    if (string) {
        [_manager.requestSerializer setValue:string forHTTPHeaderField:@"sign"];
    }
    [_manager.requestSerializer setValue:time forHTTPHeaderField:@"timestamp"];
    
    [self requestWithURLString:url params:params httpMethod:method sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [responseObject mj_JSONObject];
        
        if (method != DCHttpRequestJsonPost) {
            
        }
        
        if (dict && dict[DC_ResultCode_Key] && ([dict[DC_ResultCode_Key] integerValue] == DC_Result_TokenOut || [dict[DC_ResultCode_Key] integerValue] == DC_Result_UnLogin || [dict[DC_ResultCode_Key] integerValue] == DC_Result_Unallow || [dict[DC_ResultCode_Key] integerValue] == DC_Result_Unexist)) {
            [[DCLoginTool shareTool] dc_aaaaaaLoginController];
        }
        
        if (success) {
            success(task,responseObject);
        }
        
    } failture:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (method != DCHttpRequestJsonPost) {
            
        }
        
        [[DCAlterTool shareTool] showCancelWithTitle:@"请求失败" message:error.localizedDescription cancelTitle:@"确定"];
        [SVProgressHUD dismiss];
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(task,error);
        }
    }];
}




- (void)requestWithBaseUrl:(NSString *)baseUrl
                      path:(NSString *)path
                    params:(NSDictionary *__nullable)params
                httpMethod:(DCHttpRequestType)method
                    sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture
{
    //lj_change_focus ⚠️
    //NSString *url = baseUrl;
    NSString *url = Person_RequestUrl;
    
    if (path && [path length] > 0){
        url = [url stringByAppendingString:path];
    }
    
    
    NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
    NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    NSInteger iD = [userId integerValue];
    userId = [NSString stringWithFormat:@"%ld",(long)iD];
    if (token) {
        [_manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        [_manager.requestSerializer setValue:userId forHTTPHeaderField:@"userId"];
    } else {
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
    }
    NSString *time = [[DCSignTool shareClient] dc_nowTime];
    
    NSString *string = [[DCSignTool shareClient] dc_encrypt:time url:path parmas:params type:method];
    if (string) {
        [_manager.requestSerializer setValue:string forHTTPHeaderField:@"sign"];
    }
    [_manager.requestSerializer setValue:time forHTTPHeaderField:@"timestamp"];
    
    NSLog(@"==url:%@",url);
    [self requestWithURLString:url params:params httpMethod:method sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [responseObject mj_JSONObject];
        
        if (method != DCHttpRequestJsonPost) {
            
        }
        
        if (dict && dict[DC_ResultCode_Key] && ([dict[DC_ResultCode_Key] integerValue] == DC_Result_TokenOut || [dict[DC_ResultCode_Key] integerValue] == DC_Result_UnLogin || [dict[DC_ResultCode_Key] integerValue] == DC_Result_Unallow || [dict[DC_ResultCode_Key] integerValue] == DC_Result_Unexist)) {
            
            [[DCLoginTool shareTool] dc_aaaaaaLoginController];
        }
        
        if (success) {
            success(task,responseObject);
        }
        
    } failture:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (method != DCHttpRequestJsonPost) {
            
        }
        
        [[DCAlterTool shareTool] showCancelWithTitle:@"请求失败" message:error.localizedDescription cancelTitle:@"确定"];
        [SVProgressHUD dismiss];
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(task,error);
        }
    }];
}




- (void)requestWithURLString:(NSString *)URLString
                      params:(NSDictionary *__nullable)params
                  httpMethod:(DCHttpRequestType)method
                      sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture{
    
    switch (method) {
        case DCHttpRequestGet:
        {
            
            [_manager GET:URLString parameters:params headers:nil progress:^(NSProgress *_Nonnull downloadProgress) {
                
            } success:success failure:failture];
            
        }
            break;
        case DCHttpRequestPost:
        {
            
            [_manager POST:URLString parameters:params headers:nil progress:^(NSProgress *_Nonnull uploadProgress) {
                
            } success:success failure:failture];
            
        }
            break;
        case DCHttpRequestJsonPost:
        {
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.securityPolicy.allowInvalidCertificates = NO;
            
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:params error:nil];
            request.timeoutInterval = 10.f;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:APP_VERSION forHTTPHeaderField:@"appVersion"];
            [request setValue:@"1" forHTTPHeaderField:@"appType"];
            
            
            NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
            NSString *userId = [DCObjectManager dc_readUserDataForKey:DC_UserID_Key];
            NSInteger iD = [userId integerValue];
            userId = [NSString stringWithFormat:@"%ld",(long)iD];
            if (token) {
                [request setValue:token forHTTPHeaderField:@"token"];
                [request setValue:userId forHTTPHeaderField:@"userId"];
                
            } else {
                
                NSString *token1 = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
                NSString *userId1 = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
                if (token1) {
                    [request setValue:token1 forHTTPHeaderField:@"token"];
                    [request setValue:userId1 forHTTPHeaderField:@"userId"];
                }
                else{
                    [request setValue:@"" forHTTPHeaderField:@"token"];
                    [request setValue:@"" forHTTPHeaderField:@"userId"];
                }
                
            }
            
            NSString *url = URLString;
            
            NSString *urllll = Person_RequestUrl;
            
            if ([url containsString:urllll]) {
                url = [url stringByReplacingOccurrencesOfString:urllll withString:@""];
            }
            
            NSString *ipStr = DC_RequestUrl;
            if ([url containsString:ipStr]) {
                url = [url stringByReplacingOccurrencesOfString:ipStr withString:@""];
            }
            
            NSString *time = [[DCSignTool shareClient] dc_nowTime];
            
            NSString *string = [[DCSignTool shareClient] dc_encrypt:time url:url parmas:params type:DCHttpRequestJsonPost];
            if (string) {
                [request setValue:string forHTTPHeaderField:@"sign"];
            }
            [request setValue:time forHTTPHeaderField:@"timestamp"];
            
            __block NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress *_Nonnull uploadProgress) {
                
            } downloadProgress:^(NSProgress *_Nonnull downloadProgress) {
                
            } completionHandler:^(NSURLResponse *_Nonnull response, id  _Nullable responseObject, NSError *_Nullable error) {
                
                if (!error) {
                    
                    //NSDictionary *dict = [responseObject mj_JSONObject];
                    
                    if (success) {
                        success(task,responseObject);
                    }
                    
                } else {
                    
                    if (failture) {
                        failture(task,error);
                    }
                }
                
            }];
            [task resume];
            
        }
            break;
        default:
            break;
    }
    
}



- (void)requestUploadWithPath:(NSString *)path
                       images:(NSArray *)images
                       params:(NSDictionary *__nullable)params
                     progress:(void(^)(NSProgress *uploadProgress))progress
                       sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture{
    
    //    NSString *ipStr = [DCObjectManager dc_readUserDataForKey:DC_IP_Key];
    
    NSString *url = DC_RequestUrl;
    
    NSString *URLString = [NSString stringWithFormat:@"%@",url];
    if (path && [path length]>0) {
        URLString = [URLString stringByAppendingString:path];
    }
    
    [_manager POST:URLString parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmsss";
        
        for (int i = 0; i < [images count]; i++) {
            
            NSInteger index = arc4random()%100;
            
            NSString *imageName = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%ld%@.jpg",(long)index,imageName];
            
            UIImage *image = images[i];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            
            if ([data length] > 1024000) {
                CGFloat compress = 200 / [data length];
                data = UIImageJPEGRepresentation(image, compress);
            }
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
        }
        
    } progress:progress success:success failure:failture];
}



- (void)requestFileDownloadWithPath:(NSString *)path
                           progress:(void(^)(NSProgress *uploadProgress))progress
                           complete:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))complete
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.securityPolicy.allowInvalidCertificates = NO;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    NSURLSessionDownloadTask *loadTask = [manger downloadTaskWithRequest:request progress:^(NSProgress *_Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress);
        }
        
        
    } destination:^NSURL *_Nonnull(NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
        
        complete(response,filePath,error);
        
        NSString *path = [filePath.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        if (error) {
            [[DCAlterTool shareTool] showCancelWithTitle:error.localizedDescription message:nil cancelTitle:@"确定"];
        } else {
            
            
            NSFileManager *file = [NSFileManager defaultManager];
            NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *mpaccPath = [document stringByAppendingPathComponent:@"QYMPAccFile"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:mpaccPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:mpaccPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSString *filepathssss = [path componentsSeparatedByString:@"file://"][1];
            NSString *newPath = [mpaccPath stringByAppendingPathComponent:[path componentsSeparatedByString:@"/Library/Caches/"][1]];
            
            NSError *errrrrr = nil;
            if ([file moveItemAtPath:filepathssss toPath:newPath error:&errrrrr]) {
                
            } else {
            }
        }
    }];
    [loadTask resume];
}



- (void)requestFileDownloadWithPath:(NSString *)path
                           fileName:(NSString *)fileName
                           progress:(void(^)(NSProgress *uploadProgress))progress
                           complete:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))complete
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.securityPolicy.allowInvalidCertificates = NO;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    NSURLSessionDownloadTask *loadTask = [manger downloadTaskWithRequest:request progress:^(NSProgress *_Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL *_Nonnull(NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
        
        complete(response,filePath,error);
        
        NSString *path = [filePath.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        if (error) {
            [[DCAlterTool shareTool] showCancelWithTitle:error.localizedDescription message:nil cancelTitle:@"确定"];
        } else {
            
            
            NSFileManager *file = [NSFileManager defaultManager];
            NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *mpaccPath = [document stringByAppendingPathComponent:@"QYMPAccFile"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:mpaccPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:mpaccPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSString *filepathssss = [path componentsSeparatedByString:@"file://"][1];
            NSString *newPath = [mpaccPath stringByAppendingPathComponent:[path componentsSeparatedByString:@"/Library/Caches/"][1]];
            
            NSError *errrrrr = nil;
            if ([file moveItemAtPath:filepathssss toPath:newPath error:&errrrrr]) {
                
            } else {
            }
        }
    }];
    [loadTask resume];
}


- (void)personRequestUploadWithPath:(NSString *)path
                             images:(NSArray *)images
                             params:(NSDictionary *__nullable)params
                           progress:(void(^)(NSProgress *uploadProgress))progress
                             sucess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failture:(void (^)(NSURLSessionDataTask *task, NSError *error))failture
{
    //     NSString *url = [DCObjectManager dc_readUserDataForKey:DC_PersonIP_Key];
    
    NSString *url = Person_RequestUrl;
    
    NSString *URLString = [NSString stringWithFormat:@"%@",url];
    if (path && [path length]>0) {
        URLString = [URLString stringByAppendingString:path];
    }
    
    [_manager POST:URLString parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 利用时间戳当做图片名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        for (int i = 0; i < [images count]; i++) {
            
            NSInteger index = arc4random()%100;
            
            NSString *imageName = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%ld%@.jpg",(long)index,imageName];
            
            UIImage *image = images[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            
            // 如果图片大于1M  将图片压缩到200kb左右
            if ([data length] > 1024000) {
                CGFloat compress = 200 / [data length];
                data = UIImageJPEGRepresentation(image, compress);
            }
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
        }
        
    } progress:progress success:success failure:failture];
}


@end
