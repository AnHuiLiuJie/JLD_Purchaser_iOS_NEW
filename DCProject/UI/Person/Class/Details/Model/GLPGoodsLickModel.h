//
//  GLPGoodsLickModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLPGoodsLickFacetsModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsLickModel : NSObject

@property (nonatomic, strong) NSArray *goodsList; // 商品列表
@property (nonatomic, strong) NSArray *facets; // 查询字段列表
@property (nonatomic, copy) NSString *hotGoodsTitle; // 名称

@end


#pragma mark -
@interface GLPGoodsLickFacetsModel : NSObject

@property (nonatomic, assign) NSInteger count; // 数量
@property (nonatomic, copy) NSString *name; // 名称
@property (nonatomic, strong) GLPGoodsLickFacetsModel *valueList; // 筛选条件列表

@end


#pragma mark -
@interface GLPGoodsLickGoodsModel : NSObject

@property (nonatomic, copy) NSString *brandName; // 品牌名称
@property (nonatomic, copy) NSString *catId; // 商品分类
@property (nonatomic, copy) NSString *batchId; // 商品批号
@property (nonatomic, copy) NSString *chargeUnit; // 计价单位
@property (nonatomic, copy) NSString *defaultImg; // 默认图片
@property (nonatomic, copy) NSString *dosageForm; // 剂型
@property (nonatomic, strong) NSDictionary *goodsCouponsBean; // 这里不需要这个信息，不做解析
@property (nonatomic, copy) NSString *goodsImg; // 商品图片1
@property (nonatomic, copy) NSString *goodsIntro; // 默认图片
@property (nonatomic, copy) NSString *goodsTagIdList; // 商品标签id列表
@property (nonatomic, copy) NSString *goodsTagNameList; // 商品标签名称列表
@property (nonatomic, copy) NSString *goodsTitle; // 商品名
@property (nonatomic, copy) NSString *iD; // 商品ID
@property (nonatomic, copy) NSString *isPromotion; // 是否促销：1-有促销；2-无促销
@property (nonatomic, copy) NSString *manufactory; // 生产单位
@property (nonatomic, copy) NSString *marketPrice; // 市场单价：单位元
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, copy) NSString *sellPrice; // 商城销售单价：单位元
@property (nonatomic, copy) NSString *sellerFirmId; // 卖家企业ID
@property (nonatomic, copy) NSString *sellerFirmName; // 卖家企业名称
@property (nonatomic, copy) NSString *totalSales; // 总销量
@property (nonatomic, copy) NSString *totalStock; // 总库存

@end

NS_ASSUME_NONNULL_END
