//
//  GLBStoreListModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLBStoreListInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreListModel : NSObject

@property (nonatomic, copy) NSString *deliveryExplain; // 配送说明
@property (nonatomic, copy) NSString *firmId; // 企业ID
@property (nonatomic, copy) NSString *firmName; // 企业名称
@property (nonatomic, strong) NSArray *freight; // 运费
@property (nonatomic, strong) NSArray *goodslist; // 企业所属产品(若当前有在售药品，则返回10条数据)
@property (nonatomic, copy) NSString *isCoupon; // 是否有优惠券
@property (nonatomic, copy) NSString *isPromotion; // 是否有促销商品
@property (nonatomic, copy) NSString *logoImg; // logo
@property (nonatomic, copy) NSString *produceArea; // 生产/经营范围名称
@property (nonatomic, strong) NSArray *scopeList; // 经营范围列表，key为经营范围ID，value为经营范围名称
@property (nonatomic, copy) NSString *shopName; // 店铺名称
@property (nonatomic, strong) GLBStoreListInfoModel *statistics; // 店铺统计信息(上架、发货、评价)
@property (nonatomic, strong) NSArray *supplierScopeList; // 供应商经营范围
@property (nonatomic, copy) NSString *notice; // 商家公告
@property (nonatomic, copy) NSString *arrivalEate; // 到货速度
@property (nonatomic, copy) NSString *createTime; // 注册时间
@property (nonatomic, assign) NSInteger deliveryMoney; // 最小起定量
@property (nonatomic, copy) NSString *domainName; // 店铺域名

@end



@interface GLBStoreListGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsCode; // 商品编码
@property (nonatomic, copy) NSString *goodsId; // 产品ID
@property (nonatomic, copy) NSString *goodsImg; // 产品图片
@property (nonatomic, copy) NSString *goodsName; // 产品名称
@property (nonatomic, copy) NSString *wholeNotaxPrice; // 整件价
@property (nonatomic, copy) NSString *zeroNotaxPrice; // 拆零价

@end


@interface GLBStoreListInfoModel : NSObject

@property (nonatomic, assign) NSInteger evalCount; // 评论数量
@property (nonatomic, copy) NSString *firmId; // 企业编码
@property (nonatomic, assign) NSInteger goodsCount; // 产品上架数量
@property (nonatomic, assign) NSInteger sendCount; // 发货数量

@end

NS_ASSUME_NONNULL_END
