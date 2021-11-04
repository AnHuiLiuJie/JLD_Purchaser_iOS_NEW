//
//  GLPGoodsTicketModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsTicketModel : NSObject

@property (nonatomic, copy) NSString *couponsId; // 优惠券Id
@property (nonatomic, copy) NSString *discountAmount; // 优惠金额/折扣
@property (nonatomic, copy) NSString *firmId; // 企业Id
@property (nonatomic, copy) NSString *goodsId; // 商品ID
@property (nonatomic, copy) NSString *goodsImg1; // 商品图片
@property (nonatomic, copy) NSString *goodsName; // 商品名称
@property (nonatomic, copy) NSString *isReceive; // 是否领取 0：未领取，1：已领取
@property (nonatomic, copy) NSString *isconsume; // 是否消费 1：未消费 2：已消费 3：已绑定4：已过期
@property (nonatomic, copy) NSString *requireAmount; // 金额要求
@property (nonatomic, copy) NSString *useEndDate; // 使用结束日期
@property (nonatomic, copy) NSString *useStartDate; // 使用开始日期


@end

NS_ASSUME_NONNULL_END
