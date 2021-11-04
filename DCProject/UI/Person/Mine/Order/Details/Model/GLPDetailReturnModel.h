//
//  GLPDetailReturnModel.h
//  DCProject
//
//  Created by LiuMac on 2021/6/23.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPDetailReturnModel : DCBaseModel

@property (nonatomic, copy) NSString *applyTime;//申请时间
@property (nonatomic, copy) NSString *chargeUnit;//计价单位
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsName;//商品名称
@property (nonatomic, copy) NSString *goodsTitle;//商品标题
@property (nonatomic, copy) NSString *orderGoodsId;//订单商品ID
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *quantity;//购买数量
@property (nonatomic, copy) NSString *refundTime;//退款时间
@property (nonatomic, copy) NSString *returnNum;//退款数量returnNum
@property (nonatomic, copy) NSString *returnAmount;//退款金额
@property (nonatomic, copy) NSString *returnReason;//退款原因
@property (nonatomic, copy) NSString *returnState;//退款状态：0-默认状态，未调用退款接口时使用，1-退款成功，2-退款失败 .
@property (nonatomic, copy) NSString *sellPrice;//售价

@end

NS_ASSUME_NONNULL_END
