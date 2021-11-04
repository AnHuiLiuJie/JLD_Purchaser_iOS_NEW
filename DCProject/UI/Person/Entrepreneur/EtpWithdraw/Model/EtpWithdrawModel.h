//
//  EtpWithdrawModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/20.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EtpWithdrawModel : DCBaseModel

@end


#pragma mark - WithDrawAmountModel 提现首页
@interface WithDrawAmountModel : DCBaseModel

@property (nonatomic, copy) NSString *withdrawAmount;//可提现金额
@property (nonatomic, copy) NSString *taxAmount;//个税
@property (nonatomic, copy) NSString *receiveAmount;//实际到账金额

@end


#pragma mark - EtpBankCardListModel 银行卡信息
@interface EtpBankCardListModel : DCBaseModel

@property (nonatomic, copy) NSString *bankAccount;//卡号
@property (nonatomic, copy) NSString *bankAccountName;//账户名
@property (nonatomic, copy) NSString *bankBranchName;//支行
@property (nonatomic, copy) NSString *bankName;//银行名称
@property (nonatomic, copy) NSString *cardId;//主键id

@property (nonatomic, copy) NSString *isDefault;

@end


#pragma mark - EtpWithdrawalsListModel 提现记录列表
@interface EtpWithdrawalsListModel : DCBaseModel

@property (nonatomic, copy) NSString *auditRemark;//审核备注
@property (nonatomic, copy) NSString *auditTime;//审核时间
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *auditUser;//审核人
@property (nonatomic, copy) NSString *bankAccount;//银行账号
@property (nonatomic, copy) NSString *bankAccountName;//银行账号姓名
@property (nonatomic, copy) NSString *bankBranchName;//支行名称
@property (nonatomic, copy) NSString *bankName;//银行名称
@property (nonatomic, copy) NSString *feeAmount;//手续费金额
@property (nonatomic, copy) NSString *pioneerUserId;//创业者ID
@property (nonatomic, copy) NSString *receivedAmount;//到账金额（到账金额=提现金额-税费金额-收费金额）
@property (nonatomic, copy) NSString *state;//提现状态值：0-待审核,1-审核通过(转账中)，2-转账成功，3-转账失败，4-审核不通过
@property (nonatomic, copy) NSString *stateStr;//提现状态字符串：0-待审核,1-审核通过(转账中)，2-转账成功，3-转账失败，4-审核不通过
@property (nonatomic, copy) NSString *taxAmount;//税费金额
@property (nonatomic, copy) NSString *withdrawAmount;//提现金额
@property (nonatomic, copy) NSString *withdrawId;//业务ID


@end


NS_ASSUME_NONNULL_END
