//
//  GLPMineCollectModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLPMineCollectTicketModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPMineCollectModel : NSObject

@property (nonatomic, copy) NSString *brandName; // 品牌名称
@property (nonatomic, assign) NSInteger collectionId; // 收藏标识
@property (nonatomic, strong) GLPMineCollectTicketModel *goodsCouponsBean; // 商品优惠券信息
@property (nonatomic, copy) NSString *goodsId; // 商品ID
@property (nonatomic, copy) NSString *goodsImg; // 商品图片
@property (nonatomic, copy) NSString *goodsName; // 商品名称（通用名）
@property (nonatomic, copy) NSString *marketPrice; // 单价
@property (nonatomic, copy) NSString *packingSpec; // 商品规格
@property (nonatomic, assign) CGFloat sellPrice; // 商城价
@property (nonatomic, assign) NSInteger sellerFirmId; // 卖家企业Id
@property (nonatomic, copy) NSString *sellerFirmName; // 供应商名称
@property (nonatomic, copy) NSString *totalSales;
@property (nonatomic, copy) NSString *goodsTagNameList;
@property (nonatomic, copy) NSString *frontClassState ;
@property (nonatomic, copy) NSString *spreadAmount ;//返利 佣金

@end


#pragma mark - 券模型
@interface GLPMineCollectTicketModel : NSObject

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
