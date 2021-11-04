//
//  TRStoreGoodsModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLPGoodsActivitiesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRStoreGoodsModel : NSObject
@property(nonatomic,copy)NSString *brandName;//品牌名称
@property(nonatomic,copy)NSString *catId;//商品分类
@property(nonatomic,copy)NSString *batchId;//
@property(nonatomic,copy)NSString *chargeUnit;//计价单位
@property(nonatomic,copy)NSString *dosageForm;//剂型
@property(nonatomic,copy)NSString *goodsImg;//商品图片
@property(nonatomic,copy)NSString *goodsTitle;//商品名
@property(nonatomic,copy)NSString *id;//商品ID
@property(nonatomic,copy)NSString *isPromotion;//是否促销：1-有促销；2-无促销
@property(nonatomic,copy)NSString *manufactory;//生产单位
@property(nonatomic,copy)NSString *marketPrice;//市场单价：单位元
@property(nonatomic,copy)NSString *packingSpec;//包装规格
@property(nonatomic,copy)NSString *sellPrice;//商城销售单价：单位元
@property(nonatomic,copy)NSString *sellerFirmName;//卖家企业名称
@property(nonatomic,copy)NSString *sellerFirmId;//卖家企业ID
@property(nonatomic,copy)NSString *totalSales;//总销量
@property(nonatomic,copy)NSString *totalStock;//总库存
@property(nonatomic,strong)NSDictionary *goodsCouponsBean;//商品优惠券信息
@property(nonatomic,copy)NSString *goodsTagNameList;//标签
@property(nonatomic,copy)NSString *frontClassState;
@property(nonatomic,copy)NSString *frontClassIcon;//标记icon
@property(nonatomic,copy)NSString *frontClassName; //标记名称
@property(nonatomic,copy)NSString *spreadAmount; //返利价格
@property(nonatomic,copy)NSString *purchased; //标记该商品是否购买过
@property(nonatomic,copy) NSArray *activities;//各个活动信息  GLPGoodsActivitiesModel
@property(nonatomic,copy)NSString *isMixGoods;//是否为疗程优惠，1-是；2-否查询产品列表判断是否有组合医疗装
- (instancetype)initWithDic:(NSDictionary *)dic;
@end




NS_ASSUME_NONNULL_END
