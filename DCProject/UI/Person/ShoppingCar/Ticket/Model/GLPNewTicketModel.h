//
//  GLPNewTicketModel.h
//  DCProject
//
//  Created by bigbing on 2019/10/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPNewTicketModel : NSObject

@property (nonatomic, assign) NSInteger couponsClass; // 优惠券种类，1：平台通用券（平台发行）（暂不使用），2：店铺通用券（商家发行）3：商品通用券（商家发行，发布商品通用券时需要选择平台在销商品，\n *同一商品只能参与有效的通用券）（暂不使用
@property (nonatomic, assign) NSInteger couponsId; // 优惠券ID
@property (nonatomic, assign) NSInteger couponsIssue; // 优惠券发行方，1：平台（暂不使用），2：商家
@property (nonatomic, assign) NSInteger couponsType; // 优惠券类型，1：现金券，2：折扣券，3：包邮券
@property (nonatomic, assign) NSInteger delFlag; // 删除标识：1-正常；2-删除
@property (nonatomic, assign) CGFloat discountAmount; // 优惠金额/折扣 .
@property (nonatomic, assign) NSInteger firmId; // 发行企业
@property (nonatomic, copy) NSString *firmName; // 发行名称
@property (nonatomic, assign) NSInteger isGive; // 是否可赠送，1：不可赠送，2：可赠送（暂不使用）
@property (nonatomic, assign) NSInteger isSupportAct; // 是否适用活动中的商品 1：是，2：否
@property (nonatomic, assign) NSInteger issueQuantity; // 发行张数
@property (nonatomic, assign) NSInteger receiveQuantity; // 领取张数，每个会员领取一次此字段+1
@property (nonatomic, assign) NSInteger receiveType; // 领取类型，1：免费领取，2：注册领取（暂不使用），3：消费领取（满xxx元送优惠券N张）（暂不使用） .
@property (nonatomic, copy) NSString *releaseEndDate; // 发放日期截止日期
@property (nonatomic, copy) NSString *remark; // 备注
@property (nonatomic, assign) CGFloat requireAmount; // 金额要求
@property (nonatomic, assign) NSInteger state; // 状态，1：可领取，2：暂停领取
@property (nonatomic, assign) NSInteger supportPlatform; // 支持平台，1：无限制，2：PC端（暂不使用），3：手机端（暂不使用）
@property (nonatomic, copy) NSString *useEndDate; // 使用结束日期
@property (nonatomic, assign) NSInteger useLimit; // 使用限制，1：一次性使用（一次消费只能使用一张），2：累计使用（可多张使用）（暂不使用）
@property (nonatomic, copy) NSString *useStartDate; // 使用开始日期
@property (nonatomic, copy) NSString *goodsId; // 商品ID(发行单品券时必填)

@end

NS_ASSUME_NONNULL_END
