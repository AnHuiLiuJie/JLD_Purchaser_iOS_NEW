////
////  DCQiniuTool.m
////  DCProject
////
////  Created by bigbing on 2019/3/31.
////  Copyright © 2019 bigbing. All rights reserved.
////
//
//#import "DCQiniuTool.h"
//
//@interface DCQiniuTool ()
//
//@property (nonatomic, strong) QNUploadManager *uploadManager;
//
//@end
//
//@implementation DCQiniuTool
//
//// 创建单列
//+ (DCQiniuTool *)shareTool
//{
//    static DCQiniuTool *_instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[[self class] alloc] init];
//    });
//    return _instance;
//}
//
//
//#pragma mark - 上传图片到七牛云服务器
//- (void)dc_uploadImage:(UIImage *)image
//          successBlock:(DCUploadSuccessBlock)successBlock
//          failureBlock:(DCUploadFailureBlock)failureBlock
//
//{
//    NSData *data = UIImageJPEGRepresentation(image, 1);
//    NSInteger length = [data length]; // 为了多张上传做一个区分
//    // 如果图片大于1M  将图片压缩到200kb左右
//    if ([data length] > 1024000) {
//        CGFloat compress = 200 / [data length];
//        data = UIImageJPEGRepresentation(image, compress);
//    }
//    
//    // 汉字转拼音
//    NSString *appName = [NSString transform:APP_NAME];
//    // 去掉空格
//    appName = [appName stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSInteger index = arc4random()%10000; // 随机数 防止重复
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *name = [NSString stringWithFormat:@"%@/ios/image/%ld%ld/%@.jpg",appName,(long)length,index,[formatter stringFromDate:[NSDate date]]];
//    //    NSString *name = [NSString stringWithFormat:@"ios/image/%ld%ld/%@.jpg",(long)length,index,[formatter stringFromDate:[NSDate date]]];
//    NSString *qiniutoken = [DCObjectManager dc_readUserDataForKey:DC_QiniuToken_Key];
//    
//    [SVProgressHUD show];
//    [self.uploadManager putData:data key:name token:qiniutoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        
//        if (info.ok) {
//            NSLog(@"===resp1:%@,%@",resp,[resp objectForKey:@"key"]);
//            
//            //            NSString *url = [DCObjectManager dc_readUserDataForKey:DC_QiniuImgUrl_Key];
//            //            NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",url,resp[@"key"]];
//            
//            NSString *imageUrl = [NSString stringWithFormat:@"%@",resp[@"key"]];
//            if (successBlock) {
//                successBlock(imageUrl);
//            }
//            
//        }else{
//            NSLog(@"===resp:%@",resp);
//            
//            [SVProgressHUD showErrorWithStatus:@"图片上传失败，请重新提交"];
//            if (failureBlock) {
//                failureBlock(@"图片上传失败，请重新提交");
//            }
//            
//        }
//        
//    } option:nil];
//}
//
//
//#pragma mark - 上传图片到七牛云服务器 多张
//- (void)dc_uploadImageArray:(NSArray *)images
//               successBlock:(DCUploadImagesBlock)successBlock
//{
//    if (!images || [images count] == 0) {
//        return;
//    }
//    
//    NSMutableArray *imageArray = [NSMutableArray array];
//    
//    dispatch_group_t group = dispatch_group_create();
//    for (int i=0; i<images.count; i++) {
//        
//        dispatch_group_enter(group);
//        
//        [[DCQiniuTool shareTool] dc_uploadImage:images[i] successBlock:^(NSString *imageUrl) {
//            
//            [imageArray addObject:imageUrl];
//            dispatch_group_leave(group);
//            
//        } failureBlock:^(NSString *error) {
//            
//            dispatch_group_leave(group);
//        }];
//    }
//    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        
//        if (imageArray.count == images.count) {
//            if (successBlock) {
//                successBlock(imageArray);
//            }
//        }
//    });
//}
//
//
//#pragma mark - 上传文件到七牛云服务器
//- (void)dc_uploadfilePath:(NSString *)filePath
//             successBlock:(DCUploadDataSuccessBlock)successBlock
//             failureBlock:(DCUploadFailureBlock)failureBlock
//{
//    // 汉字转拼音
//    NSString *appName = [NSString transform:APP_NAME];
//    // 去掉空格
//    appName = [appName stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSInteger index = arc4random()%10000; // 随机数 防止重复
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *name = [NSString stringWithFormat:@"%@/ios/image/%ld%ld/%@.%@",appName,(long)[filePath length],index,[formatter stringFromDate:[NSDate date]],[filePath componentsSeparatedByString:@"."].lastObject];
//    NSString *qiniutoken = [DCObjectManager dc_readUserDataForKey:DC_QiniuToken_Key];
//    
//    [SVProgressHUD show];
//    [self.uploadManager putFile:filePath key:name token:qiniutoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        
//        if (info.ok) {
//            NSLog(@"===resp1:%@,%@",resp,[resp objectForKey:@"key"]);
//            
//            //            NSString *url = [DCObjectManager dc_readUserDataForKey:DC_QiniuImgUrl_Key];
//            //            NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",url,resp[@"key"]];
//            
//            NSString *imageUrl = [NSString stringWithFormat:@"%@",resp[@"key"]];
//            if (successBlock) {
//                successBlock(imageUrl);
//            }
//            
//        }else{
//            NSLog(@"===resp:%@",resp);
//            
//            [SVProgressHUD showErrorWithStatus:@"文件上传失败，请重新提交"];
//            if (failureBlock) {
//                failureBlock(@"文件上传失败，请重新提交");
//            }
//            
//        }
//        
//    } option:nil];
//}
//
//
//#pragma mark -
//- (QNUploadManager *)uploadManager{
//    if (!_uploadManager) {
//        _uploadManager = [[QNUploadManager alloc] init];
//    }
//    return _uploadManager;
//}
//
//@end
