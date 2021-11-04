//
//  GLBGoodsDetailModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLBRecordModel.h"
#import "GLBGoodsTicketModel.h"
#import "GLBStoreTicketModel.h"
@class GLBGoodsDetailStoreModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsDetailModel : NSObject

@property (nonatomic, copy) NSString *actTitle; // 标签-活动标题
@property (nonatomic, copy) NSString *batchNum; // 商品批号
@property (nonatomic, copy) NSString *batchProduceTime; // 批文生产日期
@property (nonatomic, copy) NSString *certifiNum; // 批准文号
@property (nonatomic, copy) NSString *expireDate; // 批文有效期至
@property (nonatomic, copy) NSString *goodsName; // 商品名称（通用名）
@property (nonatomic, copy) NSString *isBasicMedc; //是否为基药：1.是，2：否
@property (nonatomic, copy) NSString *isPromotion; // 商品是否促销：1-是；2-否
@property (nonatomic, copy) NSString *isCtrlSale;//是否控销:1：非控销，2：控销
@property (nonatomic, copy) NSString *manufactory; //生产单位
@property (nonatomic, copy) NSString *manufactoryAbbr;//生产单位简称
@property (nonatomic, assign) NSInteger orderCount; // 采购记录(笔数)
@property (nonatomic, assign) NSInteger quantityCount; // 总销量(累计已采购)
@property (nonatomic, strong) NSArray *orderList; //采购记录
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, strong) NSArray *picUrl; // 商品图片地址
@property (nonatomic, copy) NSString *pkgPackingNum; //件装量
@property (nonatomic, copy) NSString *saleCtrl; // 标签-图标显示，0-无，1-控，2-标
@property (nonatomic, copy) NSString *suppierFirmId; // 供应商ID
@property (nonatomic, copy) NSString *suppierFirmName; // 供应商名称
@property (nonatomic, assign) NSInteger totalSales; // 总销量(累计已采购)
@property (nonatomic, copy) NSString *unitePrice; // 统一价(显示)
@property (nonatomic, copy) NSString *wholeMinBuyNum; // 整件最小起订量
@property (nonatomic, copy) NSString *wholePrice; // 整件价
@property (nonatomic, copy) NSString *zeroMinBuy; // 拆零最小起订数量
@property (nonatomic, copy) NSString *zeroMinType; // 拆零最小起订量类型：1.数量；2.金额 .
@property (nonatomic, copy) NSString *zeroPackNum; // 如果是拆零中包，中包装量
@property (nonatomic, copy) NSString *zeroPrice; // 拆零价
@property (nonatomic, copy) NSString *zeroSellType; // 如果存在拆零销售，拆零销售方式：0-不支持拆零；1.拆零中包；2.拆零小包 .

@property (nonatomic, copy) NSString *deliveryExplain; // 配送说明
@property (nonatomic, strong) NSArray *recommendGoods; // 推荐商品
@property (nonatomic, strong) NSArray *similarGoods; // 关联商品
@property (nonatomic, strong) GLBGoodsDetailStoreModel *storeInfo;
@property (nonatomic, assign) NSInteger sellType; // 产品销售方式： 2-整件、4-拆零、3-同时支持
@property (nonatomic, copy) NSString *suppierUserId;


#pragma mark - 自定义属性
@property (nonatomic, copy) NSString *goodsId; // 商品iD
@property (nonatomic, assign) BOOL isCollected; // 是否已收藏
@property (nonatomic, strong) NSArray *goodsTicketArray; // 商品专享券
@property (nonatomic, strong) NSArray *storeTicketArray; // 商户券
@property (nonatomic, strong) NSArray *commonTicketArray; // 平台券/通用券
@property (nonatomic, copy) NSString *batchId; // 批次id

@end



#pragma mark - 商品模型
@interface GLBGoodsDetailGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsCode; // 商品编码
@property (nonatomic, copy) NSString *goodsId; // 产品ID
@property (nonatomic, copy) NSString *goodsImg; // 产品图片
@property (nonatomic, copy) NSString *goodsName; // 产品名称
@property (nonatomic, copy) NSString *price; // 成交价格

@end


#pragma mark - 店铺模型
@interface GLBGoodsDetailStoreModel : NSObject

@property (nonatomic, assign) NSInteger evalCount; // 评论数量
@property (nonatomic, copy) NSString *firmId; // 企业ID
@property (nonatomic, copy) NSString *firmName; // 企业名称
@property (nonatomic, assign) NSInteger goodsCount; // 产品上架数量
@property (nonatomic, strong) NSArray *goodslist; // 企业所属产品(若当前有在售药品，则返回10条数据)
@property (nonatomic, copy) NSString *logoImg; // logo
@property (nonatomic, strong) NSArray *scopeList; // 配送说明
@property (nonatomic, assign) NSInteger sendCount; // 发货数量
@property (nonatomic, copy) NSString *storeDeliveryStar; // 发货速度
@property (nonatomic, copy) NSString *storeName; // 店铺名称
@property (nonatomic, copy) NSString *storeServiceStar; // 服务评价
@property (nonatomic, copy) NSString *storeStar; // 店铺等级
@property (nonatomic, copy) NSString *freight; // 运费说明

@end

NS_ASSUME_NONNULL_END
