////
////  DCQiniuTool.h
////  DCProject
////
////  Created by bigbing on 2019/3/31.
////  Copyright © 2019 bigbing. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
//
//typedef void(^DCUploadImagesBlock)(NSArray *imageArray);
//typedef void(^DCUploadSuccessBlock)(NSString *imageUrl);
//typedef void(^DCUploadDataSuccessBlock)(NSString *fileUrl);
//typedef void(^DCUploadFailureBlock)(NSString *error);
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface DCQiniuTool : NSObject
//
//// 创建单列
//+ (DCQiniuTool *)shareTool;
//
//
//// 上传图片到七牛云服务器 单张
//- (void)dc_uploadImage:(UIImage *)image
//          successBlock:(DCUploadSuccessBlock)successBlock
//          failureBlock:(DCUploadFailureBlock)failureBlock;
//
//
//// 上传图片到七牛云服务器 多张
//- (void)dc_uploadImageArray:(NSArray *)images
//               successBlock:(DCUploadImagesBlock)successBlock;
//
//// 上传文件到七牛云服务器
//- (void)dc_uploadfilePath:(NSString *)filePath
//             successBlock:(DCUploadDataSuccessBlock)successBlock
//             failureBlock:(DCUploadFailureBlock)failureBlock;
//
//@end
//
//NS_ASSUME_NONNULL_END
