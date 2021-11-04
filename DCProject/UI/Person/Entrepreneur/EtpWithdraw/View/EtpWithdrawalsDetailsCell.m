//
//  EtpWithdrawalsDetailsCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "EtpWithdrawalsDetailsCell.h"
#import "UILabel+Category.h"
@implementation EtpWithdrawalsDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

#pragma mark - view
- (void)setViewUI{
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPressGesture.minimumPressDuration = 0.8f;//设置长按 时间
    _accountLab.userInteractionEnabled = YES;
    [_accountLab addGestureRecognizer:longPressGesture];
    
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent2:)];
    longPressGesture2.minimumPressDuration = 0.8f;//设置长按 时间
    _singleLab.userInteractionEnabled = YES;
    [_singleLab addGestureRecognizer:longPressGesture2];
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_model.bankAccount.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _model.bankAccount;
    [SVProgressHUD showSuccessWithStatus:@"收款账号复制成功"];
}

- (void)longPressEvent2:(UILongPressGestureRecognizer *)longPress {
    if (_model.withdrawId.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _model.withdrawId;
    [SVProgressHUD showSuccessWithStatus:@"流水号复制成功"];
}

#pragma mark - set model
- (void)setModel:(EtpWithdrawalsListModel *)model{
    _model = model;
    
    self.showType = [_model.state integerValue];
    self.topBgView.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
    if (self.showType == WithdrawalsDetailsTypeAlready) {
        self.status_lab.text = @"已申请";
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_ywc"]];
    }else if (self.showType == WithdrawalsDetailsTypeFailure){
        self.topBgView.backgroundColor = [UIColor dc_colorWithHexString:@"#FF6030"];
        self.status_lab.text = @"转账失败";
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_jygb"]];
    }else if (self.showType == WithdrawalsDetailsTypeBeging){
        self.status_lab.text = @"转账中";
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_dfk"]];
    }else if (self.showType == WithdrawalsDetailsTypeArrive){
        self.status_lab.text = @"已到账";
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_ywc"]];
    }
    
    NSString *stateStr = _model.stateStr;
    if ([_model.state isEqualToString:@"1"]) {//0-待审核,1-审核通过(转账中)，2-转账成功，3-转账失败，4-审核不通过
        self.topBgView.backgroundColor= [UIColor dc_colorWithHexString:DC_OtherStatusColor];
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_dfk"]];
    }else if([_model.state isEqualToString:@"2"]){
        self.topBgView.backgroundColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];//DC_SuccessStatusColor
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_ywc"]];
    }else if([_model.state isEqualToString:@"3"]){
        self.topBgView.backgroundColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_jygb"]];
    }else if([_model.state isEqualToString:@"4"]){
        self.topBgView.backgroundColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_jygb"]];
    }else{
        self.topBgView.backgroundColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
        [self.status_img setImage:[UIImage imageNamed:@"ddxq_ywc"]];
    }
    
    self.status_lab.text = stateStr;
        
    _withdraw_lab.text =  [NSString stringWithFormat:@"¥%@",model.withdrawAmount];
    _withdraw_lab = [UILabel setupAttributeLabel:_withdraw_lab textColor:_withdraw_lab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _withdraw_lab = [UILabel setupAttributeLabel:_withdraw_lab textColor:_withdraw_lab.textColor minFont:[UIFont fontWithName:PFR size:12] maxFont:nil forReplace:@"¥"];
    
    _accountLab.text = _model.bankAccount;
    _nameLab.text = _model.bankAccountName;
    _bankNameLab.text = _model.bankName;
    _branchNameLab.text = _model.bankBranchName;
    _timeLab.text = _model.createTime;
    _singleLab.text = _model.withdrawId;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
