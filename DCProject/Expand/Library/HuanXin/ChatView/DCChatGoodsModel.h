//
//  DCChatGoodsModel.h
//  DCProject
//
//  Created by bigbing on 2019/12/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCChatGoodsModel : DCBaseModel

@property (nonatomic, copy) NSString *type; //类型 1商品 2订单
@property (nonatomic, copy) NSString *goodsImage;// 商品图片
@property (nonatomic, copy) NSString *goodsId; // 商品id
@property (nonatomic, copy) NSString *batchId; // 批号id
@property (nonatomic, copy) NSString *goodsName;  // 商品名称
@property (nonatomic, copy) NSString *order_title;//订单名称
@property (nonatomic, copy) NSString *item_url;//商品 或者 订单 url
@property (nonatomic, copy) NSString *manufactory; // 生产单位
@property (nonatomic, copy) NSString *price; // 展示单价
@property (nonatomic, copy) NSString *orderNo; // 订单号
@property (nonatomic, copy) NSString *goodsCount; // 商品个数
@property (nonatomic, copy) NSString *totalPrice; // 订单总价
@property (nonatomic, copy) NSString *sendType; // 发送人类型 1采购版个人 2采购版企业 3商业版批发商 4商业版零售商 5商业版服务商



@end

NS_ASSUME_NONNULL_END
