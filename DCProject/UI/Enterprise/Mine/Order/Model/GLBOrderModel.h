//
//  GLBOrderModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/14.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBOrderModel : NSObject

@property (nonatomic, copy) NSString *goods; // 下单商品
@property (nonatomic, assign) NSInteger goodsCount; // 商品数量
@property (nonatomic, assign) NSInteger orderNo; // 订单号
@property (nonatomic, assign) NSInteger orderState; // 订单状态:1-待审核；4-待付款；5-待发货；6-部分发货；7-待验收；8-已验收（存在异议）；9-交易关闭;10-交易完成；
@property (nonatomic, copy) NSString *orderStateCN; // 订单状态文字说明
@property (nonatomic, copy) NSString *orderTime; // 下单时间
@property (nonatomic, assign) CGFloat paymentAmount; // 订单金额
@property (nonatomic, copy) NSString *purchaserFirmName; // 采购商企业名称
@property (nonatomic, assign) NSInteger suppierFirmId; // 供应商企业编码
@property (nonatomic, copy) NSString *suppierFirmName; // 供应商企业名称
@property (nonatomic, assign) NSInteger tradeType; // 交易方式,1-担保；2-账期；3-预付款
@property (nonatomic, copy) NSString *evalState; // 1待评价 2已评价

@end

NS_ASSUME_NONNULL_END
