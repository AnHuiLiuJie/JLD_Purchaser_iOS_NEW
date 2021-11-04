//
//  GLPOrderDetailModel.h
//  DCProject
//
//  Created by LiuMac on 2021/6/18.
//

#import "DCBaseModel.h"
#import "GLPGoodsDetailsSpecModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GLPOrderDeliveryBeanModel;
@class GLPOrderDeliverModel;
@interface GLPOrderDetailModel : DCBaseModel

@property (nonatomic, copy) NSString *actDiscount;//活动优惠金额：系统活动自动扣减
@property (nonatomic, copy) NSString *buyerCellPhone;//买家手机号
@property (nonatomic, copy) NSString *buyerReturnState;//用户退款状态：0-默认状态，1-已全部退款，2-已部分退款，3-已申请，4-已拒绝
@property (nonatomic, copy) NSString *closedDesc;//交易关闭描述：例如-付款超时取消订单
@property (nonatomic, copy) NSString *closedType;//交易关闭类型ID：1-买家取消订单；2-卖家取消订单；3-退款成功；4-运营商手动关闭订单；5-超时关闭；6-退货成功
@property (nonatomic, copy) NSString *couponsIssue;//优惠券发行方:0-无(未使用优惠券); 1-平台，2-商家，3-商品
@property (nonatomic, copy) NSString *deductibleAmount;//抵扣金额（优惠券、积分等）：订单总金额=订单实付金额+抵扣金额 订单明细页面优惠金额=返回结果中的  ActDiscount（存在活动时优惠金额）+ deductibleAmount（使用优惠券时抵扣金额）
@property (nonatomic, retain) GLPOrderDeliverModel *deliver;//物流信息（新，针对是否分开发货时添加
@property (nonatomic, copy) NSString *deliverTime;//发货时间
@property (nonatomic, copy) NSString *evalState;//评价状态：11-买家未评价、卖家未评价；12-买家未评价、卖家已评价；21-买家已评价、卖家未评价；22-买家已评价、卖家已评价；买家：需要我评价-<20或1%；我已评价-21；对方已评-12；双方已评-22卖家：需要我评价-%1；我已评价-12；对方已评-21；双方已评-22
@property (nonatomic, copy) NSString *finishTime;//交易结束时间：确认收货（交易成功）时间或取消订单（交易关闭）时间
@property (nonatomic, copy) NSString *goodsDiscount;//商品优惠金额：手动修改价格后的价格差
@property (nonatomic, copy) NSString *goodsTotalAmount;//商品总金额：优惠前总金额
@property (nonatomic, copy) NSString *isBuyerDlyRecvGoods;//买家是否申请过延期收货:买家延迟收货：0-未操作；1-已操作
@property (nonatomic, copy) NSString *isRecOrder;//是否接单：0-否，1-是
@property (nonatomic, copy) NSString *leaveMsg;//买家给卖家留言
@property (nonatomic, copy) NSString *lockFlag;//流程锁定标识（流程锁定，不能发货、收货）：1-正常；2-锁定；3-解除锁定
@property (nonatomic, copy) NSString *logisticsAmount;//物流金额
@property (nonatomic, copy) NSString *logisticsDiscount;//物流优惠金额：手动修改价格后的价格差
@property (nonatomic, copy) NSString *modifyTime;//修改时间
@property (nonatomic, copy) NSString *objectionFlag;//异议标识：1-正常（无异议)；2-有待仲裁的异议；3-所有异议仲裁完毕
@property (nonatomic, copy) NSString *oprEtime;//操作截止时间：当前状态的操作截止时间，例如：等待卖家发货状态时，该值表示卖家发货截止时间
@property (nonatomic, copy) NSString *oprState;//操作状态：【买家延迟收货：0-未操作；1-已操作】【买家退物流费用：0-未操作；1-已操作】，右侧扩展。\n示例：00-买家【未申请延迟发货、未申请退退物流费用】；01-买家【未申请延迟发货、已申请退物流费用】；
@property (nonatomic, strong) NSArray *orderGoodsList;//订单商品列表
@property (nonatomic, retain) GLPOrderDeliveryBeanModel *orderDeliveryBean;//物流信息
@property (nonatomic, strong) NSArray *orderReturnApplyList;//订单退货、退款纪录列表

@property (nonatomic, copy) NSString *orderNo;//订单编号
@property (nonatomic, copy) NSString *orderRefundReason;//买家申请整笔订单退款原因
@property (nonatomic, copy) NSString *orderState;//订单状态：1-待付款；2-待接单，3-已接单；5-已发货；6-待评价；7-交易关闭；8-已退款【全额退款】
@property (nonatomic, copy) NSString *orderStateStr;//订单状态，已转换成文字
@property (nonatomic, copy) NSString *orderTime;//成交时间：下单时间
@property (nonatomic, copy) NSString *payTime;//付款时间
@property (nonatomic, copy) NSString *payUrl;//payUrl
@property (nonatomic, copy) NSString *payableAmount;//订单总金额：订单最后的应付款金额=商品总金额+物流金额-活动优惠金额-商品优惠金额-物流优惠金额-抵扣金额
@property (nonatomic, copy) NSString *prescriptionImg;//处方图片
@property (nonatomic, copy) NSString *receiverAddr;//配送地址
@property (nonatomic, copy) NSString *receiverCellphone;//收件人号码
@property (nonatomic, copy) NSString *receiverName;//收件人
@property (nonatomic, copy) NSString *refundState;//退款状态位：0-无退款，1-退款成功，2-退款失败，3-退款中,4-已拒绝
@property (nonatomic, copy) NSString *refundStateStr;//退款状态字符串
@property (nonatomic, copy) NSString *refundStateTs;//退款提示
@property (nonatomic, copy) NSString *returnApplyTime;//申请整笔订单退款时间
@property (nonatomic, copy) NSString *rpState;//0-非处方单，1-生成中，2-查看  0 时调用 【/b2c/order/manage/onlineDetail】获取处方状态根据 rejectState 判断处方状态 ，拒绝原因统一用字段  auditReason
@property (nonatomic, copy) NSString *sellerFirmId;//卖家企业ID
@property (nonatomic, copy) NSString *sellerFirmImg;//卖家企业Logo
@property (nonatomic, copy) NSString *sellerFirmName;//卖家企业名称
@property (nonatomic, copy) NSString *sellerFirmUserId;//卖家企业用户Id
@property (nonatomic, copy) NSString *sellerReturnState;//商家退款状态：0-默认状态，1-已全部退款，2-已部分退款
@property (nonatomic, copy) NSString *orderType;// 订单类型:1-普通；2-优惠；3-秒杀订单；4-拼团订单
@property (nonatomic, copy) NSString *joinState;// 参与状态：0-等待参与，1-成功，2-失败，3-等待付款


@end


#pragma mark ############################### GLPOrderGoodsListModel #################################################

@interface GLPOrderGoodsListModel : DCBaseModel//订单商品列表

@property (nonatomic, copy) NSString *applyState;//0-初始状态（可退款退货）;1-退款申请中；10-退款中；11-退款失败；2-同意退款；3-待平台仲裁；4-平台仲裁中；41-仲裁退款失败；5-异议处理完成
@property (nonatomic, copy) NSString *brandName;//品牌名称
@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *batchId;//
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsTitle;//商品标题
@property (nonatomic, copy) NSString *orderGoodsId;//订单商品ID
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *quantity;//数量
@property (nonatomic, copy) NSString *returnAmount;//退款金额
@property (nonatomic, copy) NSString *returnNum;//退款数量
@property (nonatomic, copy) NSString *returnType;//退货退款类别：1-退货退款；2-仅退款
@property (nonatomic, copy) NSString *sellPrice;//商城销售单价：单位元
@property (nonatomic, copy) NSString *chargeUnit;//计价单位

@property (nonatomic, strong) GLPMarketingMixListModel *marketingMixVO;//组合医疗装信息 GLPMarketingMixListModel

//自定义参数 为了获取订单批次的状态
@property (nonatomic, copy) NSString *orderType;// 订单类型:1-普通；2-优惠；3-秒杀订单；4-拼团订单


- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end


#pragma mark ############################### GLPOrderReturnApplyListModel ############################################

@interface GLPOrderReturnApplyListModel : DCBaseModel//订单退货、退款纪录列表

@property (nonatomic, copy) NSString *applyAmount;//申请退款金额
@property (nonatomic, copy) NSString *applyId;//申请ID
@property (nonatomic, copy) NSString *applyState;//0-初始状态（可退款退货）;1-退款申请中；10-退款中；11-退款失败；2-同意退款；3-待平台仲裁；4-平台仲裁中；41-仲裁退款失败；5-异议处理完成
@property (nonatomic, copy) NSString *chargeUnit;//计价单位
@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *goodsTitle;//商品标题
@property (nonatomic, copy) NSString *imgs;//凭证图片1
@property (nonatomic, copy) NSString *manufactory;//生产单位
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *payableAmount;//商品应付总金额：优惠后商品总金额 = 优惠前总金额 - 活动优惠金额 - 卖家优惠金额
@property (nonatomic, copy) NSString *quantity;//数量
@property (nonatomic, copy) NSString *reasonDesc;//原因描述：退款说明
@property (nonatomic, copy) NSString *reasonText;//原因：退款原因ID对应的文本
@property (nonatomic, copy) NSString *returnAmount;//核定退款金额：同意退款或运营商仲裁后的结果
@property (nonatomic, copy) NSString *returnType;//退货退款类别：1-退货退款；2-仅退款
@property (nonatomic, copy) NSString *sellerRemark;//卖家备注
@property (nonatomic, copy) NSString *totalAmount;//优惠前总金额

@end

#pragma mark ############################### GLPOrderDeliveryBeanModel ############################################

@interface GLPOrderDeliveryBeanModel : DCBaseModel//物流信息

@property (nonatomic, copy) NSString *logisticsFirmCode;//物流公司编码：0表示非物流公司库中的数据
@property (nonatomic, copy) NSString *logisticsFirmName;//物流公司
@property (nonatomic, copy) NSString *logisticsInfo;//物流信息：JSON格式
@property (nonatomic, copy) NSString *logisticsNo;//物流单号
@property (nonatomic, copy) NSString *logisticsState;//物流状态：0-在途，即货物处于运输过程中；1-揽件，货物已由快递公司揽收并且产生了第一条跟踪信息；2-疑难，货物寄送过程出了问题；3-签收，收件人已签收；4-退签，即货物由于用户拒签、超区等原因退回，而且发件人已经签收；5-派件，即快递正在进行同城派件；6-退回，货物正处于退回发件人的途中
@property (nonatomic, copy) NSString *logisticsTime;//发货时间


@end

#pragma mark ############################### GLPOrderDeliverModel ############################################

@interface GLPOrderDeliverModel : DCBaseModel//物流信息

@property (nonatomic, copy) NSString *isSeparate;//是否分开发货0-暂无物流信息，1-分开发货，2-统一发货 .
@property (nonatomic, copy) NSString *logisticsFirmName;//物流快递公司名称 (在统一发货时显示)
@property (nonatomic, copy) NSString *logisticsNo;//物流单号.(在统一发货时显示)



@end



NS_ASSUME_NONNULL_END
