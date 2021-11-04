//
//  GLBEvaluateDetailModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBEvaluateDetailModel : NSObject

@property (nonatomic, assign) NSInteger allCount; // 评价总数
@property (nonatomic, assign) NSInteger bad; // 差评总数
@property (nonatomic, assign) CGFloat deliveryPercent; // 物流满意度
@property (nonatomic, assign) NSInteger favorite; // 好评总数
@property (nonatomic, assign) CGFloat goodsPercent; // 商品满意度
@property (nonatomic, assign) NSInteger kind; // 一般总数
@property (nonatomic, assign) CGFloat servicePercent; // 服务态度满意度

@end

NS_ASSUME_NONNULL_END
