//
//  GLPAdModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPAdModel : NSObject

@property (nonatomic, copy) NSString *adBgcolor; // 广告背景色
@property (nonatomic, copy) NSString *adContent; // 图片-上传后的展示地址；文字广告-写入文字
@property (nonatomic, copy) NSString *adId; // 广告Id
@property (nonatomic, copy) NSString *adLinkUrl; // 广告链接
@property (nonatomic, copy) NSString *adTitle; // 广告标题
@property (nonatomic, copy) NSString *adspaceCode; // 广告位编码
@property (nonatomic, copy) NSString *infoId; // id
@property (nonatomic, copy) NSString *infoType; // 类型 1：商品 2:店铺 3:不跳转 4:活动 5:拼团 6:秒杀 7:优惠券 8:热销产品 9:活动产品
@end

NS_ASSUME_NONNULL_END
