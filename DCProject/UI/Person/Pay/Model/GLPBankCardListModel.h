//
//  GLPBankCardListModel.h
//  DCProject
//
//  Created by LiuMac on 2021/8/16.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPBankCardListModel : DCBaseModel


@property (nonatomic, copy) NSString *accName;//账户名
@property (nonatomic, copy) NSString *accNo;//绑定账号
@property (nonatomic, copy) NSString *accType;//卡类型：D-借记卡；C-贷记卡 .
@property (nonatomic, copy) NSString *bankId;//银行编号
@property (nonatomic, copy) NSString *bankName;//银行名称
@property (nonatomic, copy) NSString *bindSn;//绑定序列号
@property (nonatomic, copy) NSString *channel;//快捷支付接入类型：01：光大快捷支付；
@property (nonatomic, copy) NSString *iD;//主键ID

#pragma mark 自定义属性
@property (nonatomic, copy) NSString *titleName;

@end

NS_ASSUME_NONNULL_END
