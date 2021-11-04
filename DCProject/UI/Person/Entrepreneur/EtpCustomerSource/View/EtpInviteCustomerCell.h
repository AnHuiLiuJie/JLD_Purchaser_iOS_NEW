//
//  EtpInviteCustomerCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "CustomerSourceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EtpInviteCustomerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *titileView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (nonatomic, copy) dispatch_block_t etpInviteCustomerCellClick_blcok;

@property (nonatomic, strong) CustomerExplainModel *model;

@end

NS_ASSUME_NONNULL_END
