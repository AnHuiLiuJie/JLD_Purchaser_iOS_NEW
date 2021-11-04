//
//  GLPShoppingCarModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLPNewTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPShoppingCarModel : NSObject

@property (nonatomic, copy) NSString *existCoupons; // 是否有可领取优惠券0-没有优惠券 1-有优惠券
@property (nonatomic, strong) NSArray *invalidGoodsList; // 失效商品列表 不展示 不做解析
@property (nonatomic, assign) BOOL isFirmInvalid; // 企业是否失效
@property (nonatomic, copy) NSString *mallLogo; // 店铺logo
@property (nonatomic, copy) NSString *mallname; // 卖家店铺名称
@property (nonatomic, assign) NSInteger sellerFirmId; // 卖家企业id
@property (nonatomic, copy) NSString *sellerFirmName; // 卖家企业名称
@property (nonatomic, assign) NSInteger sellerFirmState; // 企业状态：1-正常；2-禁用；3-待提交审核资料；4-审核中
@property (nonatomic, copy) NSString *sellerFirmStateMsg; // 企业状态对应消息提示
@property (nonatomic, strong) NSArray *validActInfoList; // 有效商品,有活动的商品列表
@property (nonatomic, strong) NSArray *validNoActGoodsList; // 有效商品，无活动的商品列表
@property (nonatomic, copy) NSString *deliveryTime;//发货时间：文字显示，1.24小时内发货，2.2-7天发货

#pragma mark - 自定义属性
@property (nonatomic, copy) NSString *payType; // 支付方式
@property (nonatomic, copy) NSString *sendType; // 配送方式
@property (nonatomic, assign) CGFloat yufei; // 运费
//@property (nonatomic, strong) GLPNewTicketModel *ticketModel; //券模型
@property (nonatomic, copy) NSString *remark; // 订单备注

@property (nonatomic, strong) NSMutableArray *ticketArray; // 选择的券
@property (nonatomic, assign) CGFloat couponsDiscount; // 优惠券最优的优惠总金额,优惠券优惠金额
@property (nonatomic, copy) NSString *couponsId; // 默认最优选的优惠券id集合，优惠券ID
@property (nonatomic, assign) NSInteger couponsClass; // 优惠券最优的类型：2：店铺通用券，3：商品通用券.

@end



#pragma mark - 活动商品列表
@interface GLPShoppingCarActivityModel : NSObject

@property (nonatomic, copy) NSString *actBtime; // 活动开始时间
@property (nonatomic, strong) NSArray *actCartGoodsList; // 活动中商品列表
@property (nonatomic, copy) NSString *actEtime; // 活动结束时间
@property (nonatomic, assign) NSInteger actId; // 活动id
@property (nonatomic, copy) NSString *actImg; // 活动图片
@property (nonatomic, copy) NSString *actRealEtime; // 活动实际结束时间：默认与活动结束时间一致
@property (nonatomic, copy) NSString *actTitle; // 活动标题
@property (nonatomic, assign) CGFloat discAfterTotalPrice; // 活动优惠后商品总价
@property (nonatomic, assign) CGFloat discountAmount; // 优惠金额 .
@property (nonatomic, assign) CGFloat goodsTotalPrice; // 活动商品总价
@property (nonatomic, assign) CGFloat requireAmount; // 金额要求

@property (nonatomic, assign) NSInteger isOtc; // 是否otc 2是otc

@end



#pragma mark - 非活动商品列表
@interface GLPShoppingCarNoActivityModel : NSObject

@property (nonatomic, assign) NSInteger actGroupId; // 团购Id
@property (nonatomic, assign) CGFloat actGroupPrice; // 团购价
@property (nonatomic, assign) NSInteger actId; // 生效商品当前参与的活动
@property (nonatomic, copy) NSString *attrDesc; // 属性描述
@property (nonatomic, assign) NSInteger cartId; // 购物车ID
@property (nonatomic, copy) NSString *chargeUnit; // 计价单位
@property (nonatomic, copy) NSString *goodsId; // 商品id
@property (nonatomic, copy) NSString *originalgoodsId; // 商品原始id（不带规格id）
@property (nonatomic, copy) NSString *goodsImg; // 商品图片
@property (nonatomic, copy) NSString *goodsImg1Small; // 商品缩略图
@property (nonatomic, copy) NSString *goodsTitle; //商品标题 .
@property (nonatomic, assign) BOOL isActGroup; // 是否是团购
@property (nonatomic, assign) BOOL isBatchInvalid; // 商品是否失效
@property (nonatomic, assign) BOOL isGoodsInvalid; // 商品是否失效
@property (nonatomic, assign) BOOL isMedicalGoods; // 是否医药商品
@property (nonatomic, assign) BOOL isOverStock; // 加入购物车数量是否超出当前商品库存
@property (nonatomic, assign) NSInteger logisticsTplId; // 邮费模板:0表示免邮费
@property (nonatomic, assign) CGFloat marketPrice; // 药店价：单位元
@property (nonatomic, strong) NSArray *orderCartList; // 商品列表
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, assign) NSInteger quantity; // 商品数量
@property (nonatomic, assign) CGFloat sellPrice; // 商品最新商城销售单价：单位元
@property (nonatomic, copy) NSString *snapshotId; // 快照ID：每次商品销售属性发生变化时生成一次快照
@property (nonatomic, assign) NSInteger stock; // 库存
@property (nonatomic, assign) CGFloat totalPrice; // 商品小计：单位元; 商品小计= 数量 *商品最新商城销售单价sellPrice

@property (nonatomic, assign) NSInteger isOtc; // 是否otc 2是otc

#pragma mark - 自定义属性
@property (nonatomic, assign) BOOL isSelected;// 是否选中

@end



#pragma mark - 活动商品列表
@interface GLPShoppingCarActivityGoodsModel : NSObject

@property (nonatomic, assign) NSInteger actGroupId; // 团购Id
@property (nonatomic, assign) CGFloat actGroupPrice; // 团购价
@property (nonatomic, assign) NSInteger actId; // 生效商品当前参与的活动
@property (nonatomic, copy) NSString *attrDesc; // 属性描述
@property (nonatomic, assign) NSInteger cartId; // 购物车ID
@property (nonatomic, copy) NSString *chargeUnit; // 计价单位
@property (nonatomic, copy) NSString *goodsId; //商品id
@property (nonatomic, copy) NSString *originalgoodsId; // 商品原始id（不带规格id）
@property (nonatomic, copy) NSString *goodsImg; // 商品图片
@property (nonatomic, copy) NSString *goodsImg1Small; // 商品缩略图
@property (nonatomic, copy) NSString *goodsTitle; // 商品标题 .
@property (nonatomic, assign) BOOL isActGroup; // 是否是团购
@property (nonatomic, assign) BOOL isBatchInvalid; // 是否失效
@property (nonatomic, assign) BOOL isGoodsInvalid; // 商品是否失效
@property (nonatomic, assign) BOOL isMedicalGoods; // 是否医药商品
@property (nonatomic, assign) BOOL isOverStock; // 加入购物车数量是否超出当前商品库存
@property (nonatomic, assign) NSInteger logisticsTplId; // 邮费模板:0表示免邮费
@property (nonatomic, assign) CGFloat marketPrice; // 药店价：单位元
@property (nonatomic, strong) NSArray *orderCartList; // 商品列表
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, assign) NSInteger quantity; // 商品数量
@property (nonatomic, assign) CGFloat sellPrice; // 商品最新商城销售单价：单位元
@property (nonatomic, copy) NSString *snapshotId; // 快照ID：每次商品销售属性发生变化时生成一次快照
@property (nonatomic, assign) NSInteger stock; // 库存
@property (nonatomic, assign) CGFloat totalPrice; // 商品小计：单位元; 商品小计= 数量 *商品最新商城销售单价sellPrice

#pragma mark - 自定义属性
@property (nonatomic, assign) BOOL isSelected;// 是否选中

//isOtc ： null：非药品类商品；1：OTC类药品（流通药品，不必凭处方购买）；2：处方药（需凭处方购买的药品） 其中OTC 药品可以 分为：甲类OTC，乙类OTC以及 甲乙双跨类
@property (nonatomic, assign) NSInteger isOtc; // 是否otc 2是otc

@end


#pragma mark - 商品详情
@interface GLPShoppingCarGoodsModel : NSObject

@property (nonatomic, copy) NSString *attrDesc; // 属性描述
@property (nonatomic, assign) NSInteger cartId; // 购物车ID
@property (nonatomic, copy) NSString *chargeUnit; // 计价单位
@property (nonatomic, assign) BOOL isBatchInvalid; // 是否失效
@property (nonatomic, assign) BOOL isOverStock; // 加入购物车数量是否超出当前商品库存
@property (nonatomic, assign) CGFloat marketPrice; // 药店价：单位元
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, assign) NSInteger quantity; // 商品数量
@property (nonatomic, assign) CGFloat sellPrice; // 商品最新商城销售单价：单位元
@property (nonatomic, copy) NSString *snapshotId; // 快照ID：每次商品销售属性发生变化时生成一次快照
@property (nonatomic, assign) NSInteger stock; // 库存
@property (nonatomic, assign) CGFloat totalPrice; // 商品小计：单位元; 商品小计= 数量 *商品最新商城销售单价sellPrice

@end


NS_ASSUME_NONNULL_END
