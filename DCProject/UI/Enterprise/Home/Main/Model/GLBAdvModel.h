//
//  GLBAdvModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBAdvModel : NSObject

@property (nonatomic, copy) NSString *adTitle; // 标题
@property (nonatomic, copy) NSString *adLinkUrl; // 广告链接
@property (nonatomic, copy) NSString *adContent; // 图片-上传后的展示地址；文字广告-写入文字
@property (nonatomic, copy) NSString *adInfoId; // 广告信息ID，如商品广告存商品ID，企业广告存企业ID;
@property (nonatomic, copy) NSString *adType; // 广告类型，1-商品广告，2-企业广告，3-资讯广告，4-展会广告


@end

NS_ASSUME_NONNULL_END
