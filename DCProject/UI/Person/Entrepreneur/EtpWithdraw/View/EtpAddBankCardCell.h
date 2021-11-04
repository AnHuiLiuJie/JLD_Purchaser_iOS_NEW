//
//  EtpAddBankCardCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, EtpAddBankCardType) {
    EtpAddBankCardTypeAdd    = 0,//添加银行卡
    EtpAddBankCardTypeEidt   = 1,//编辑
};

@interface EtpAddBankCardCell : UITableViewCell

@property (nonatomic, copy) void(^etpAddBankCardCellClick_block)(NSInteger tag);
@property (nonatomic, assign) EtpAddBankCardType showType;


@property (copy, nonatomic) void(^etpApplicationCell_receive_tf_block)(NSString *text);
@property (copy, nonatomic) void(^etpApplicationCell_payee_tf_block)(NSString *text);
@property (copy, nonatomic) void(^etpApplicationCell_bankName_tf_block)(NSString *text);
@property (copy, nonatomic) void(^etpApplicationCell_banch_tf_block)(NSString *text);

@property (nonatomic, strong) EtpBankCardListModel *model;

@end

NS_ASSUME_NONNULL_END
