//
//  PioneerServiceFeeModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/20.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PioneerServiceFeeModel : DCBaseModel

@property (nonatomic, copy) NSString *totalFee;
@property (nonatomic, copy) NSString *noSettleFee;
@property (nonatomic, copy) NSString *settleFee;
@property (nonatomic, copy) NSString *failFee;
@property (nonatomic, copy) NSString *canWithdrawFee;
@property (nonatomic, copy) NSString *withdrawFee;


@end


#pragma mark - 搜索模型
@interface PSFSearchConditionModel : DCBaseModel

//@property (nonatomic, copy) NSString *currentPage;//当前分页页码（默认为1）
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *startTime;//查询开始时间
@property (nonatomic, copy) NSString *endTime;//查询结束时间
@property (nonatomic, copy) NSString *goodsName;//商品名称
@property (nonatomic, copy) NSString *level;//客源级别：1-我的客源，2-二级客源，3-三级客源 为空就是全部
@property (nonatomic, copy) NSString *state;//状态：1-在途，2-成交，3-取消 //暂时没用 用不上
@property (nonatomic, copy) NSString *searchName;//模糊查询


@end


#pragma mark - 服务费明细订单-商品
@interface PSFGoodsListModel : DCBaseModel

@property (nonatomic, copy) NSString *buyNum;//购买数量
@property (nonatomic, copy) NSString *certifiNum;//批准文号,非药品为注册证号
@property (nonatomic, copy) NSString *chargeUnit;//计价单位
@property (nonatomic, copy) NSString *extendServicerDeptRatio;//推广服务商部门分成比例
@property (nonatomic, copy) NSString *extendServicerRatio;//推广服务商分成比例
@property (nonatomic, copy) NSString *extendUserAmount;//推广服务商员工分成金额
@property (nonatomic, copy) NSString *extendUserId;//推广服务商员工ID
@property (nonatomic, copy) NSString *extendUserRatio;//推广服务商员工分成比例
@property (nonatomic, copy) NSString *goodsExtendRatio;//商品推广费用比例
@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsName;//商品名称
@property (nonatomic, copy) NSString *manufactory;//生产厂家
@property (nonatomic, copy) NSString *orderId;//订单ID
@property (nonatomic, copy) NSString *orderTime;//下单时间
@property (nonatomic, copy) NSString *packingSpec;//规格型号,药品为包装规格
@property (nonatomic, copy) NSString *payPrice;//付款价格
@property (nonatomic, copy) NSString *realAmount;//最终成交金额
@property (nonatomic, copy) NSString *remark;//备注
@property (nonatomic, copy) NSString *tradeId;//唯一ID
@property (nonatomic, copy) NSString *tradeState;//交易状态：1：在途；2；成交；3；取消
@property (nonatomic, copy) NSString *tradeStateStr;//交易状态，文字显示


@end

#pragma mark - 服务费明细订单
@interface PSFOrderListModel : DCBaseModel

@property (nonatomic, copy) NSString *divideTotalAmount;//服务费金额
@property (nonatomic, copy) NSArray *extendGoodsListVO;//商品列表
@property (nonatomic, copy) NSString *extendLevel;//客源级别——数字
@property (nonatomic, copy) NSString *extendLevelStr;//客源级别——字符串
@property (nonatomic, copy) NSString *goodsCount;//商品数量
@property (nonatomic, copy) NSString *orderAmount;//订单金额
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *orderTime;//下单时间
@property (nonatomic, copy) NSString *tradeState;//交易状态——数字
@property (nonatomic, copy) NSString *tradeStateStr;//交易状态——字符串


@end





NS_ASSUME_NONNULL_END
