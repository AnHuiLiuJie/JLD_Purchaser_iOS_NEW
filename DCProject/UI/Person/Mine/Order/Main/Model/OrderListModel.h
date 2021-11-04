//
//  OrderListModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLPGoodsDetailsSpecModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderListModel : NSObject
@property (nonatomic, copy) NSString *closedType; // 交易关闭类型ID：1-买家取消订单；2-卖家取消订单；3-退款成功；4-运营商手动关闭订单；5-超时关闭；6-退货成功
@property (nonatomic, copy) NSString *evalState; //评价状态：11-买家未评价、卖家未评价；12-买家未评价、卖家已评价；21-买家已评价、卖家未评价；22-买家已评价、卖家已评价；买家：需要我评价-<20或1%；我已评价-21；对方已评-12；双方已评-22卖家：需要我评价-%1；我已评价-12；对方已评-21；双方已评-22
@property (nonatomic, copy) NSString *isBuyerDlyRecvGoods; // 买家是否申请过延期收货:买家延迟收货：0-未操作；1-已操作
@property (nonatomic, copy) NSString *isOtc; //是否非处方药订单：1-OTC（非处方药）；2-非OTC（处方药）
@property (nonatomic, copy) NSString *oprState; // 操作状态：【买家延迟收货：0-未操作；1-已操作】【买家退物流费用：0-未操作；1-已操作】，右侧扩展。\n示例：00-买家【未申请延迟发货、未申请退退物流费用】；01-买家【未申请延迟发货、已申请退物流费用】
@property (nonatomic, strong) NSArray *orderGoodsList; // 订单商品列表 OredrGoodsModel
@property (nonatomic, copy) NSString *orderNo; //订单编号
@property (nonatomic, copy) NSString *orderStateStr; //订单状态文字
@property (nonatomic, copy) NSString *orderState; //订单状态：订单状态：1-待付款；2-待接单，3-已接单；5-已发货；6-待评价；7-交易关闭；8-有退款
@property (nonatomic, copy) NSString *refundState; //退款状态：0-全部有退款订单，1-退款成功，2-退款失败，3-退款中,4-已拒绝
@property (nonatomic, copy) NSString *buyerReturnState; //用户退款状态：0-默认状态，1-已全部退款，2-已部分退款，3-已申请，4-已拒绝
@property (nonatomic, copy) NSString *payableAmount; //订单总金额：订单最后的应付款金额=商品总金额+物流金额-活动优惠金额-商品优惠金额-物流优惠金额-抵扣金额
@property (nonatomic, copy) NSString *sellerFirmId; //卖家企业ID
@property (nonatomic, copy) NSString *sellerFirmName; //卖家企业名称
@property (nonatomic, copy) NSString *sellerFirmImg; //卖家企业logo
@property (nonatomic, copy) NSString *orderTime; // 成交时间下单时间
@property (nonatomic, copy) NSString *modifyTime; // 订单修改时间

@property (nonatomic, copy) NSString *goodsCount; //总数
- (instancetype)initWithDic:(NSDictionary *)dic;

@property (nonatomic, assign) NSInteger rpState;//说明为：0-非处方单，1-生成中，2-查看
@property (nonatomic, copy) NSString *orderType;// 订单类型:1-普通；2-优惠；3-秒杀订单；4-拼团订单
@property (nonatomic, copy) NSString *joinState;// 参与状态：0-等待参与，1-成功，2-失败，3-等待付款

@end


#pragma mark **************************************** ReturnOrderListModel ****************************
@interface ReturnOrderListModel : NSObject

@property (nonatomic, copy) NSString *applyReturnAmount; //申请退款金额
@property (nonatomic, copy) NSString *applyTime; //申请退款时间
@property (nonatomic, copy) NSString *orderNo; //订单编号
@property (nonatomic, copy) NSString *reasonText; //申请原因
@property (nonatomic, copy) NSString *refundState; //退款状态：1-退款成功，2-退款失败，3-退款中，4-已拒绝
@property (nonatomic, strong) NSArray *retrunGoodsVO; // 申请退款商品列表
@property (nonatomic, copy) NSString *returnTime; //退款时间
@property (nonatomic, copy) NSString *returnTotalAmount; //退款总金额
@property (nonatomic, copy) NSString *returnType; //returnType
@property (nonatomic, copy) NSString *sellerFirmId; //卖家企业ID
@property (nonatomic, copy) NSString *sellerFirmName; //卖家企业名称
@property (nonatomic, copy) NSString *sellerFirmImg; //卖家企业logo
@property (nonatomic, copy) NSString *payableAmount; //订单总金额：订单最后的应付款金额=商品总金额+物流金额-活动优惠金额-商品优惠金额-物流优惠金额-抵扣金额
- (instancetype)initWithDic:(NSDictionary *)dic;

@end


#pragma mark **************************************** OredrGoodsModel ****************************

@interface OredrGoodsModel : NSObject
@property (nonatomic, copy) NSString *brandName; //
@property (nonatomic, copy) NSString *goodsImg; //商品图片
@property (nonatomic, copy) NSString *goodsTitle; //商品标题
@property (nonatomic, copy) NSString *packingSpec; //包装规格
@property (nonatomic, copy) NSString *quantity; //数量
@property (nonatomic, copy) NSString *sellPrice; //商城销售单价：单位元
@property (nonatomic, copy) NSString *chargeUnit;//计价单位
@property (nonatomic, copy) NSString *returnNum;//退款数量
@property (nonatomic, copy) NSString *returnAmount;//退款金额

@property (nonatomic, strong) GLPMarketingMixListModel *marketingMixVO;//组合医疗装信息 GLPMarketingMixListModel

//自定义参数 为了获取订单批次的状态
@property (nonatomic, copy) NSString *orderType;// 订单类型:1-普通；2-优惠；3-秒杀订单；4-拼团订单

- (instancetype)initWithDic:(NSDictionary *)dic;
@end




NS_ASSUME_NONNULL_END
