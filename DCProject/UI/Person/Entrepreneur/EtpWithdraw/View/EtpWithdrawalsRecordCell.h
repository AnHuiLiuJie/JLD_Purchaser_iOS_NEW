//
//  EtpWithdrawalsRecordCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EtpWithdrawalsRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *time_lab;
@property (weak, nonatomic) IBOutlet UILabel *status_lab;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_lab;
@property (weak, nonatomic) IBOutlet UILabel *bankAccount_lab;

@property (nonatomic, strong) EtpWithdrawalsListModel *model;


@end

NS_ASSUME_NONNULL_END
