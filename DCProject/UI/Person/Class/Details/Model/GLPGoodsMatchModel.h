//
//  GLPGoodsMatchModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLPGoodsMatchGoodsModel;
@class GLPGoodsMatchProductModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsMatchModel : NSObject

@property (nonatomic, assign) NSInteger count; // 处方集商品数量
@property (nonatomic, copy) NSString *preDesc; // 处方集描述
@property (nonatomic, copy) NSString *preName; // 处方集名称
@property (nonatomic, strong) NSArray *prodList;
@property (nonatomic, copy) NSString *tagIds; // 标签ID列表，多标签用逗号隔开
@property (nonatomic, copy) NSString *tagNames; // 标签名称列表，多标签用逗号隔开
@property (nonatomic, strong) NSArray *goodsList;

@end


#pragma mark - 处方集商品
@interface GLPGoodsMatchGoodsModel : NSObject

@property (nonatomic, copy) NSString *brandName; // 品牌名称
@property (nonatomic, copy) NSString *catId; // 商品分类
@property (nonatomic, copy) NSString *batchId; // 商品批号
@property (nonatomic, copy) NSString *chargeUnit; // 计价单位
@property (nonatomic, copy) NSString *defaultImg; // 默认图片
@property (nonatomic, copy) NSString *dosageForm; // 剂型
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


#pragma mark - 后台数据转存使用，忽略
@interface GLPGoodsMatchProductModel : NSObject

@property (nonatomic, copy) NSString *certifiNum;//批准文号
@property (nonatomic, copy) NSString *manufacturer;//生产单位
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *prodName;//产品名

@end

NS_ASSUME_NONNULL_END
