//
//  GLPOrderForPayModel.h
//  DCProject
//
//  Created by LiuMac on 2021/8/16.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPOrderForPayModel : DCBaseModel

@property (nonatomic, copy) NSString *key;//密钥
@property (nonatomic, copy) NSString *orderAmt;//订单金额
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *orderTime;//下单时间
@property (nonatomic, copy) NSString *orderTimeForShow;//下单时间--显示
@property (nonatomic, copy) NSString *payAmt;//支付金额

@end

NS_ASSUME_NONNULL_END
