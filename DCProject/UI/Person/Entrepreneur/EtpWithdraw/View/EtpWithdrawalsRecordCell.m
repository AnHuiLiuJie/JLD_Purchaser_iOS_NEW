//
//  EtpWithdrawalsRecordCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "EtpWithdrawalsRecordCell.h"

@implementation EtpWithdrawalsRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

#pragma mark - view
- (void)setViewUI{
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:8 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPressGesture2.minimumPressDuration = 0.8f;//设置长按 时间
    _bankAccount_lab.userInteractionEnabled = YES;
    [_bankAccount_lab addGestureRecognizer:longPressGesture2];
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_model.bankAccount.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _model.bankAccount;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma mark - set model
- (void)setModel:(EtpWithdrawalsListModel *)model{
    _model = model;
    
    _time_lab.text = _model.createTime;
    NSString *stateStr = _model.stateStr;
    if ([_model.state isEqualToString:@"1"]) {//0-待审核,1-审核通过(转账中)，2-转账成功，3-转账失败，4-审核不通过
        _status_lab.textColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
    }else if([_model.state isEqualToString:@"2"]){
        _status_lab.textColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
    }else if([_model.state isEqualToString:@"3"]){
        _status_lab.textColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];
    }else if([_model.state isEqualToString:@"4"]){
        _status_lab.textColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
    }else{
        _status_lab.textColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
    }
    _status_lab.text = stateStr;

    
    NSString *title = [NSString stringWithFormat:@"¥%@",_model.withdrawAmount];
    _withdraw_lab.text = title;
    _withdraw_lab = [UILabel setupAttributeLabel:_withdraw_lab textColor:_withdraw_lab.textColor minFont:[UIFont fontWithName:PFRMedium size:12] maxFont:nil forReplace:@"¥"];    
    _bankAccount_lab.text = _model.bankAccount;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
