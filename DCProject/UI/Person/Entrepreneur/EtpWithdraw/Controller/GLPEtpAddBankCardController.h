//
//  GLPEtpAddBankCardController.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "DCBasicViewController.h"
#import "EtpAddBankCardCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpAddBankCardController : DCBasicViewController

@property (nonatomic, assign) EtpAddBankCardType showType;


@property (nonatomic, strong) EtpBankCardListModel *model;

@property (nonatomic, copy) void(^GLPEtpAddBankCardController_back_block)(NSInteger type);//1表示保存使用返回提现页面  2表示删除回到上一页


@end

NS_ASSUME_NONNULL_END
