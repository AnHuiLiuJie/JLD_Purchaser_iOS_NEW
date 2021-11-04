//
//  EtpWithdrawalsDetailsCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawModel.h"

typedef NS_OPTIONS(NSUInteger, WithdrawalsDetailsType) {
    WithdrawalsDetailsTypeAlready   = 0,//已申请
    WithdrawalsDetailsTypeFailure   = 1,//提现失败
    WithdrawalsDetailsTypeBeging    = 2,//转账中
    WithdrawalsDetailsTypeArrive   = 3,//已到账
};

NS_ASSUME_NONNULL_BEGIN

@interface EtpWithdrawalsDetailsCell : UITableViewCell

@property (nonatomic, assign) WithdrawalsDetailsType showType;


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (weak, nonatomic) IBOutlet UIImageView *status_img;
@property (weak, nonatomic) IBOutlet UILabel *status_lab;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_lab;
@property (weak, nonatomic) IBOutlet UILabel *actual_lab;
@property (weak, nonatomic) IBOutlet UILabel *tax_lab;

@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *branchNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *singleLab;

@property (weak, nonatomic) IBOutlet UIView *accountBgView;
@property (weak, nonatomic) IBOutlet UIView *singleBgView;

@property (nonatomic, strong) EtpWithdrawalsListModel *model;


@end

NS_ASSUME_NONNULL_END
