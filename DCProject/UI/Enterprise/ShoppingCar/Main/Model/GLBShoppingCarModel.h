//
//  GLBShoppingCarModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/14.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLBMineTicketModel.h"
@class GLBShoppingCarFreightModel;
@class GLBShoppingCarGoodsInfoModel;


NS_ASSUME_NONNULL_BEGIN

@interface GLBShoppingCarModel : NSObject

@property (nonatomic, strong) NSArray *cartGoodsList; // 商品列表
@property (nonatomic, strong) GLBShoppingCarFreightModel *freight; // 运费规则
@property (nonatomic, assign) BOOL haveCash; // 是否存在优惠券，true:存在，false:不存在
@property (nonatomic, copy) NSString *orderMinPrice; // 店铺最小起订量，为空客户端不做最小起订判断
@property (nonatomic, copy) NSString *suppierFirmId; // 供应商企业Id
@property (nonatomic, copy) NSString *suppierFirmLogo; // 供应商LOGO
@property (nonatomic, copy) NSString *suppierFirmName; // 供应商名称

@property (nonatomic, assign) CGFloat accountPeriod; // 企业账期可用额度 仅确认下单有效
@property (nonatomic, assign) NSInteger periodState; // 供应商是否开通了账期，1:开通，2:未开通 仅确认下单有效
@property (nonatomic, strong) GLBMineTicketCouponsModel *coupon; // 默认最优优惠券

#pragma mark - 自定义属性
@property (nonatomic, assign) BOOL isClosed; // 是否关闭列表展示
@property (nonatomic, assign) BOOL isSelected; // 是否选中
@property (nonatomic, assign) NSInteger payType; // 支付方式 仅确认下单有效
@property (nonatomic, assign) CGFloat discountMoney; // 优惠金额
//@property (nonatomic, copy) NSString *couponiD; // 优惠券id
// 券模型
@property (nonatomic, strong) GLBMineTicketCouponsModel *_Nullable ticketModel;
// 最迟还款天数 仅选择账期支付时有效
@property (nonatomic, assign) NSInteger repatmentEndDate;



@end


#pragma mark - 购物车中的商品模型
@interface GLBShoppingCarGoodsModel : NSObject

@property (nonatomic, copy) NSString *batchId; // 批次ID：货号ID
@property (nonatomic, copy) NSString *batchNum; // 批号
@property (nonatomic, assign) NSInteger cartId; // 购物车ID
@property (nonatomic, copy) NSString *certifiNum; // 批准文号
@property (nonatomic, assign) CGFloat ctrlPrice; // 促销价格
@property (nonatomic, copy) NSString *effectTime; // 有效期至
@property (nonatomic, copy) NSString *goodsId; // 商品ID
@property (nonatomic, copy) NSString *goodsImg; // 商品图片
@property (nonatomic, copy) NSString *goodsName; // 商品名称(通用名)
@property (nonatomic, assign) BOOL hasCtrl; // 是否有促销
@property (nonatomic, copy) NSString *manufactory; // 生产厂家
@property (nonatomic, copy) NSString *packingSpec; // 规格包装
@property (nonatomic, assign) CGFloat price; // 交易价格
@property (nonatomic, copy) NSString *priceType; // 价格类型:2.整件终端价，4.拆零终端价
@property (nonatomic, assign) NSInteger quantity; // 商品数量
@property (nonatomic, strong) GLBShoppingCarGoodsInfoModel *goodsAttribute;

#pragma mark - 自定义属性
@property (nonatomic, assign) BOOL isSelected; // 是否选中


@end


#pragma mark - 购物车中的运费模型
@interface GLBShoppingCarFreightModel : NSObject

@property (nonatomic, copy) NSString *freight; // 运费
@property (nonatomic, copy) NSString *requireAmount; // 金额要求，表示没达到这个金额是需要的运费，达到后如果没有更高金额要求运费就为0

@end


#pragma mark - 购物车中的商品特定属性
@interface GLBShoppingCarGoodsInfoModel : NSObject

@property (nonatomic, copy) NSString *pkgPackingNum; // 件装量
@property (nonatomic, assign) NSInteger sellType; // 产品销售方式： 2-整件、4-拆零、3-同时支持
@property (nonatomic, copy) NSString *wholeMinBuyNum; // 整件最小起订量
@property (nonatomic, copy) NSString *zeroMinBuy; // 拆零最小起订数量、拆零最小起订金额
@property (nonatomic, copy) NSString *zeroMinType; // 拆零最小起订量类型：1.数量；2.金额 .
@property (nonatomic, copy) NSString *zeroPackNum; // 如果是拆零中包，中包装量
@property (nonatomic, copy) NSString *zeroSellType; // 如果存在拆零销售，拆零销售方式：0-不支持拆零；1.拆零中包；2.拆零小包 .

@end

NS_ASSUME_NONNULL_END
