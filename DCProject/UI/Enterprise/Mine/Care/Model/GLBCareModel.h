//
//  GLBCareModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLBCareInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLBCareModel : NSObject

@property (nonatomic, assign) NSInteger collectionId; // 收藏id
@property (nonatomic, copy) NSString *firmName; // 企业名称
@property (nonatomic, copy) NSString *logoImg; // 企业logo图片
@property (nonatomic, copy) NSString *objectId; // 收藏的企业ID
@property (nonatomic, strong) NSArray *goods;
@property (nonatomic, strong) GLBCareInfoModel *statistics;

@end


#pragma mark - 商品
@interface GLBCareGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsId; // 商品ID
@property (nonatomic, copy) NSString *goodsImg; // 商品图片
@property (nonatomic, copy) NSString *goodsName; // 商品名称
@property (nonatomic, assign) CGFloat price; // 单价

@end


#pragma mark - 详情
@interface GLBCareInfoModel : NSObject

@property (nonatomic, copy) NSString *coupon; // 优惠卷满减信息
@property (nonatomic, assign) NSInteger evalCount; // 评论数量
@property (nonatomic, copy) NSString *firmId; // 企业编码
@property (nonatomic, assign) NSInteger goodsCount; // 产品上架数量
@property (nonatomic, assign) NSInteger sendCount; // 发货数量

@end

NS_ASSUME_NONNULL_END
