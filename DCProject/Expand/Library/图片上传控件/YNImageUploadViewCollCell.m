//
//  YNImageUploadViewCollCell.m
//  上传图片控件
//
//  Created by 贾亚宁 on 2019/5/17.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import "YNImageUploadViewCollCell.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>

@interface YNImageTool ()
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation YNImageTool

- (instancetype)init {
    self = [super init];
    if (self) {
        self.models = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)saveUploadFinishImageAsset:(YNImageModel *)imageModel {
    if (![self.models containsObject:imageModel]) {
        [self.models addObject:imageModel];
    }
}

- (NSArray<YNImageModel *> *)imageModels {
    return self.models;
}

@end

@implementation YNImageModel

@end



static NSString *BASIC_URL;

@interface YNHTTPSessionManager : AFHTTPSessionManager
//{
//    AFHTTPSessionManager *_manager;
//}


@end

@implementation YNHTTPSessionManager
+ (YNHTTPSessionManager *)share {
    static YNHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [YNHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        manager.requestSerializer.timeoutInterval = 10.0;
    });
    return manager;
}

+ (void)setBaseUrl:(NSString *)baseUrl{
    BASIC_URL = baseUrl;
}

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        _manager = [AFHTTPSessionManager manager];
//        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _manager.requestSerializer.timeoutInterval = 30;
//        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
////        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Disposition"];
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
//
//        [_manager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"appVersion"];
//        [_manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"appType"];
//
//        _manager.securityPolicy.allowInvalidCertificates = NO;
//
//        if (!BASIC_URL) {
////            NSString *ipStr = [DCObjectManager dc_readUserDataForKey:DC_IP_Key];
////            BASIC_URL = ipStr;
//            BASIC_URL = DC_RequestUrl;
//        }
//    }
//    return self;
//}

@end










@interface YNImageUploadViewCollCell ()
/** 图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** view1 */
@property (nonatomic, strong) UIView *animationView1;
/** 层 */
@property (nonatomic, strong) CAShapeLayer *circleLayer;
/** 线层 */
@property (nonatomic, strong) CAShapeLayer *circleLayer2;
/** 展示 */
@property (nonatomic, strong) UIImageView *stateImg;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation YNImageUploadViewCollCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width-10, frame.size.height-10)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        // 1、添加第一种加载方式
        self.animationView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width-10, frame.size.height-10)];
        self.animationView1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        self.animationView1.hidden = YES;
        [self.contentView addSubview:self.animationView1];
        
        self.circleLayer.frame = CGRectMake(CGRectGetWidth(self.animationView1.frame)*0.5-20, CGRectGetHeight(self.animationView1.frame)*0.5-20, 40, 40);
        [self.animationView1.layer addSublayer:self.circleLayer];
        
        self.circleLayer2.frame = CGRectMake(CGRectGetWidth(self.animationView1.frame)*0.5-24, CGRectGetHeight(self.animationView1.frame)*0.5-24, 48, 48);
        [self.animationView1.layer addSublayer:self.circleLayer2];
        
        self.stateImg = [[UIImageView alloc] init];
        self.stateImg.frame = CGRectMake(0, 0, 26, 26);
        self.stateImg.center = CGPointMake(CGRectGetWidth(self.imageView.frame)*0.5, CGRectGetHeight(self.imageView.frame)*0.5);
        [self.imageView addSubview:self.stateImg];
        self.stateImg.hidden = YES;
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"image_upload_delete"] forState:normal];
        self.deleteBtn.frame = CGRectMake(frame.size.width-20, 0, 20, 20);
        [self.deleteBtn addTarget:self action:@selector(deleteBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteBtn];
        self.deleteBtn.hidden = NO;/*lj change*/
    }
    return self;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20)
                                                                  radius:7
                                                              startAngle:-M_PI*0.5
                                                                endAngle:M_PI*1.5
                                                               clockwise:YES];
        _circleLayer.path = bezierPath.CGPath;
        _circleLayer.strokeColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 14;
        _circleLayer.strokeStart = 0;
        _circleLayer.strokeEnd = 0;
        _circleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _circleLayer;
}

- (CAShapeLayer *)circleLayer2 {
    if (!_circleLayer2) {
        _circleLayer2 = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(24, 24)
                                                                  radius:16
                                                              startAngle:-M_PI*0.5
                                                                endAngle:M_PI*1.5
                                                               clockwise:YES];
        _circleLayer2.path = bezierPath.CGPath;
        _circleLayer2.strokeColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        _circleLayer2.fillColor = [UIColor clearColor].CGColor;
        _circleLayer2.lineWidth = 1.5;
        _circleLayer2.strokeStart = 0;
        _circleLayer2.strokeEnd = 1;
        _circleLayer2.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _circleLayer2;
}

- (void)setModel:(YNImageModel *)model {
    if (model.imageType == 3) {
        self.imageView.frame = CGRectMake(0, 10, CGRectGetWidth(self.contentView.frame)-10, CGRectGetHeight(self.contentView.frame)-10);
    }else {
        self.imageView.frame = self.contentView.bounds;
    }
    
    if (model.imageType == 0) {
        self.imageView.image = model.image;
    }else if (model.imageType == 1) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    }else if (model.imageType == 2) {
        self.imageView.image = [UIImage imageNamed:model.imageName];
    }else if (model.imageType == 3) {
        self.imageView.image = model.image;
        // 删除按钮的展示
        self.deleteBtn.hidden = model.isLast;
        // 不是最后一个，并且需要上传图片
        if (!model.isLast && self.isNeedUpload) {
            // 检查上传Url参数配置
            if (self.uploadUrl == nil || self.uploadUrl.length == 0 || ![self.uploadUrl containsString:@"http"]) {
                NSLog(@"请配置有效的上传Url");
                return;
            }
            // 判断上传状态
            if (model.state == YNImageUploadStateNormal) {
                [self show];
                model.state = YNImageUploadStateUploading;
                __weak typeof(self)weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    AFHTTPSessionManager *_manager = [YNHTTPSessionManager share];
                    [_manager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"appVersion"];
                    [_manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"appType"];
                    
//                    model.task = [_manager POST:self.uploadUrl parameters:self.parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                        // 利用时间戳当做图片名字
//                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                        formatter.dateFormat = @"yyyyMMddHHmmss";
//
//                        NSInteger index = arc4random()%100;
//
//                        NSString *imageName = [formatter stringFromDate:[NSDate date]];
//                        NSString *fileName = [NSString stringWithFormat:@"%ld%@.jpg",(long)index,imageName];
//
//                        UIImage *image = model.image;
//                        NSData *data = UIImageJPEGRepresentation(image, 0.1);
//
//                        // 如果图片大于1M  将图片压缩到200kb左右
//                        if ([data length] > 1024000) {
//                            CGFloat compress = 200 / [data length];
//                            data = UIImageJPEGRepresentation(image, compress);
//                        }
//
//                        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
//
//                        //                        [formData appendPartWithFileData:UIImageJPEGRepresentation(model.image, 1)
//                        //                                                    name:@"file"
//                        //                                                fileName:model.imageName
//                        //                                                mimeType:@"image/jpg"];
//                    } progress:^(NSProgress * _Nonnull uploadProgress) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            weakSelf.circleLayer.strokeEnd = (double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
//                        });
//                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            model.state = YNImageUploadStateFinish;
//                            [weakSelf hiddenToSuccess:YES];
//                            if ([[responseObject objectForKey:@"code"] intValue] == 200) {
//                                NSDictionary *dictionary = responseObject[@"data"];
//                                NSString *imageUrl = dictionary[@"uri"];
//                                if (!imageUrl || [imageUrl dc_isNull]) {
//                                    imageUrl = @"";
//                                }
//                                model.imageName = dictionary[@"fileName"];
//                                model.imageUrl = imageUrl;
//                                [weakSelf.tool saveUploadFinishImageAsset:model];
//                                !weakSelf.YNImageUploadViewCollCell_FinishBlock ? : weakSelf.YNImageUploadViewCollCell_FinishBlock(weakSelf.tool.models);
//                            }/*lj change*/
//                        });
//                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            model.state = YNImageUploadStateFailed;
//                            [weakSelf hiddenToFailed];
//                        });
//                    }];
                    
                    model.task = [_manager POST:self.uploadUrl parameters:self.parameter headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        // 利用时间戳当做图片名字
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmss";

                        NSInteger index = arc4random()%100;

                        NSString *imageName = [formatter stringFromDate:[NSDate date]];
                        NSString *fileName = [NSString stringWithFormat:@"%ld%@.jpg",(long)index,imageName];

                        UIImage *image = model.image;
                        NSData *data = UIImageJPEGRepresentation(image, 0.1);

                        // 如果图片大于1M  将图片压缩到200kb左右
                        if ([data length] > 1024000) {
                            CGFloat compress = 200 / [data length];
                            data = UIImageJPEGRepresentation(image, compress);
                        }

                        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];

                        //                        [formData appendPartWithFileData:UIImageJPEGRepresentation(model.image, 1)
                        //                                                    name:@"file"
                        //                                                fileName:model.imageName
                        //                                                mimeType:@"image/jpg"];
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.circleLayer.strokeEnd = (double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
                        });
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        dispatch_async(dispatch_get_main_queue(), ^{

                            model.state = YNImageUploadStateFinish;
                            [weakSelf hiddenToSuccess:YES];
                            if ([[responseObject objectForKey:@"code"] intValue] == 200) {
                                NSDictionary *dictionary = responseObject[@"data"];
                                NSString *imageUrl = dictionary[@"uri"];
                                if (!imageUrl || [imageUrl dc_isNull]) {
                                    imageUrl = @"";
                                }
                                model.imageName = dictionary[@"fileName"];
                                model.imageUrl = imageUrl;
                                [weakSelf.tool saveUploadFinishImageAsset:model];
                                !weakSelf.YNImageUploadViewCollCell_FinishBlock ? : weakSelf.YNImageUploadViewCollCell_FinishBlock(weakSelf.tool.models);
                            }/*lj change*/
                        });
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.state = YNImageUploadStateFailed;
                            [weakSelf hiddenToFailed];
                        });
                    }];
                });
            }else if (model.state == YNImageUploadStateUploading) {
                NSLog(@"正在上传图片，请稍后");
            }else if (model.state == YNImageUploadStateFinish) {
                [self hiddenToSuccess:NO];
            }else if (model.state == YNImageUploadStateFailed) {
                [self hiddenToFailed];
            }
        }
    }
}

- (void)deleteBtnTap:(UIButton *)sender {
    if (self.deleteBtnTapBlock) {
        self.deleteBtnTapBlock(self);
    }
}

- (void)show {
    self.animationView1.hidden = NO;
    self.stateImg.hidden = YES;
}

- (void)hiddenToSuccess:(BOOL)load {
    if (load) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.stateImg.hidden = NO;
            self.stateImg.image = [UIImage imageNamed:@"image_upload_finish"];
            self.animationView1.hidden = YES;
        });
    }else {
        self.stateImg.hidden = NO;
        self.stateImg.image = [UIImage imageNamed:@"image_upload_finish"];
        self.animationView1.hidden = YES;
    }
}

- (void)hiddenToFailed {
    self.stateImg.hidden = NO;
    self.stateImg.image = [UIImage imageNamed:@"image_upload_failed"];
    self.animationView1.hidden = YES;
}

@end
