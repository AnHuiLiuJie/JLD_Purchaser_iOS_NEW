//
//  EtpAddBankCardCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "EtpAddBankCardCell.h"

@interface EtpAddBankCardCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *receive_p;//placeholder
@property (nonatomic, strong) UITextField *receive_tf;
@property (nonatomic, strong) UILabel *payee_p;
@property (nonatomic, strong) UITextField *payee_tf;
@property (nonatomic, strong) UILabel *bankName_p;
@property (nonatomic, strong) UITextField *bankName_tf;
@property (nonatomic, strong) UILabel *banch_p;
@property (nonatomic, strong) UITextField *banch_tf;
@property (nonatomic, strong) UITextField *area_tf;

@property (nonatomic, strong) UISwitch *defaultSwitch;
@property (nonatomic, strong) UILabel *default_p;
@property (nonatomic, strong) UIButton *deleteBtn;


@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end


static CGFloat const btn_w = 80;
static CGFloat const btn_H = 35;

@implementation EtpAddBankCardCell

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    //[DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    [self.contentView addSubview:_bgView];

    _receive_p = [[UILabel alloc] init];
    _receive_p.text = @"收款账号";
    _receive_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _receive_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_receive_p];
    _receive_tf = [[UITextField alloc] init];
    _receive_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _receive_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _receive_tf.placeholder = @"请填写银行卡号";
    _receive_tf.keyboardType = UIKeyboardTypeNumberPad;
    [_receive_tf addTarget:self action:@selector(receive_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_receive_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_bgView addSubview:_receive_tf];
    
    _payee_p = [[UILabel alloc] init];
    _payee_p.text = @"收 款 人";
    _payee_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _payee_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_payee_p];
    _payee_tf = [[UITextField alloc] init];
    _payee_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _payee_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _payee_tf.placeholder = @"请填收款人真实姓名";
    _payee_tf.keyboardType = UIKeyboardTypeDefault;
    [_payee_tf addTarget:self action:@selector(payee_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
//    _payee_tf.backgroundColor = [UIColor dc_colorWithHexString:@"#E9E9E9"];
    [_payee_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_bgView addSubview:_payee_tf];
    
    _bankName_p = [[UILabel alloc] init];
    _bankName_p.text = @"银行名称";
    _bankName_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _bankName_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_bankName_p];
    _bankName_tf = [[UITextField alloc] init];
    _bankName_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _bankName_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _bankName_tf.placeholder = @"请填写银行名称";
    _bankName_tf.keyboardType = UIKeyboardTypeDefault;
    [_bankName_tf addTarget:self action:@selector(bankName_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bankName_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_bgView addSubview:_bankName_tf];
    
    _banch_p = [[UILabel alloc] init];
    _banch_p.text = @"支行名称";
    _banch_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _banch_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_banch_p];
    _banch_tf = [[UITextField alloc] init];
    _banch_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _banch_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _banch_tf.placeholder = @"请填写支行名称";
    _banch_tf.keyboardType = UIKeyboardTypeDefault;
    [_banch_tf addTarget:self action:@selector(banch_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_banch_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_bgView addSubview:_banch_tf];
    
    
    _defaultSwitch = [[UISwitch alloc] init];
    _defaultSwitch.transform = CGAffineTransformMakeScale( 0.8, 0.8);//缩放
    [_bgView addSubview:_defaultSwitch];
    [_defaultSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    _default_p = [[UILabel alloc] init];
    _default_p.text = @"默认账户";
    _default_p.textColor = [UIColor dc_colorWithHexString:@"#555555"];
    _default_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_default_p];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
    [_bgView addSubview:_deleteBtn];
    
    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _resetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _resetBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [_resetBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _resetBtn.backgroundColor = [UIColor whiteColor];
    _resetBtn.bounds = CGRectMake(0, 0, btn_w, btn_H);
    [DCSpeedy dc_changeControlCircularWith:_resetBtn AndSetCornerRadius:_resetBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#333333"] canMasksToBounds:YES];
    [_bgView addSubview:_resetBtn];

    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _confirmBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
    _confirmBtn.bounds = CGRectMake(0, 0, btn_w, btn_H);
    [DCSpeedy dc_changeControlCircularWith:_confirmBtn AndSetCornerRadius:_confirmBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
    [_bgView addSubview:_confirmBtn];
}

#pragma mark - private method
- (void)receive_tfDidChange:(UITextField *)textField
{
    [DCSpeedy editChange:textField length:30];
    if (textField.text.length > 30) {
        [SVProgressHUD showInfoWithStatus:@"输入正确的银行卡号"];
    }
    !_etpApplicationCell_receive_tf_block ? : _etpApplicationCell_receive_tf_block(textField.text);
}

- (void)payee_tfDidChange:(UITextField *)textField
{
    [DCSpeedy editChange:textField length:20];
    if (textField.text.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"姓名限制20个字符"];
    }
    !_etpApplicationCell_payee_tf_block ? : _etpApplicationCell_payee_tf_block(textField.text);
}

- (void)bankName_tfDidChange:(UITextField *)textField
{
    [DCSpeedy editChange:textField length:30];
    if (textField.text.length > 30) {
        [SVProgressHUD showInfoWithStatus:@"输入正确的银行名"];
    }
//    if (textField.text.length > 18) {
//        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:18];
//    }
    !_etpApplicationCell_bankName_tf_block ? : _etpApplicationCell_bankName_tf_block(textField.text);
}

- (void)banch_tfDidChange:(UITextField *)textField
{
    [DCSpeedy editChange:textField length:30];
    if (textField.text.length > 30) {
        [SVProgressHUD showInfoWithStatus:@"输入正确的银行支行名"];
    }
    !_etpApplicationCell_banch_tf_block ? : _etpApplicationCell_banch_tf_block(textField.text);
}

#pragma mark - 默认
- (void)switchAction:(id)sender
{
    BOOL isButtonOn1 = [sender isOn];
    if (isButtonOn1) {
        !_etpAddBankCardCellClick_block ? : _etpAddBankCardCellClick_block(1);
    }else{
        !_etpAddBankCardCellClick_block ? : _etpAddBankCardCellClick_block(0);
    }
}

#pragma mark - set model
- (void)setModel:(EtpBankCardListModel *)model{
    _model = model;
    
    _receive_tf.text = _model.bankAccount;
    _payee_tf.text = _model.bankAccountName;
    _bankName_tf.text = _model.bankName;
    _banch_tf.text = _model.bankBranchName;
    
    if ([_model.isDefault isEqualToString:@"1"]) {
        [_defaultSwitch setOn:YES animated: YES];
    }else
        [_defaultSwitch setOn:NO animated: YES];

}

#pragma mark - 删除
- (void)deleteBtnAction:(UIButton *)button
{
    !_etpAddBankCardCellClick_block ? : _etpAddBankCardCellClick_block(2);
}

#pragma mark - 重置
- (void)resetBtnAction:(UIButton *)button
{
    _receive_tf.text = @"";
    _payee_tf.text = @"";
    _bankName_tf.text = @"";
    _banch_tf.text = @"";
    [_defaultSwitch setOn:YES animated: YES];
}
#pragma mark - 确定
- (void)confirmBtnAction:(UIButton *)button
{
    !_etpAddBankCardCellClick_block ? : _etpAddBankCardCellClick_block(3);
}

#pragma mark - set
- (void)setShowType:(EtpAddBankCardType)showType{
    _showType = showType;
    
    if (self.showType == EtpAddBankCardTypeAdd) {
        _resetBtn.hidden = NO;
        _confirmBtn.hidden = NO;
        [_defaultSwitch setOn:YES animated: YES];
        _deleteBtn.hidden = YES;
    }else{
        _resetBtn.hidden = YES;
        _confirmBtn.hidden = YES;
        [_defaultSwitch setOn:NO animated: YES];
        _deleteBtn.hidden = NO;
    }
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat spacing1 = 10;

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 5, 15, 5));
    }];
    
    [_receive_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(8);
        make.top.equalTo(self.bgView).offset(10);
        make.size.equalTo(CGSizeMake(75, 40));
    }];
    
    [_receive_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_p.right).offset(5);
        make.centerY.equalTo(self.receive_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.receive_p);
    }];
    
    [_payee_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_p.left);
        make.top.equalTo(self.receive_p.bottom).offset(spacing1);
        make.size.equalTo(self.receive_p);
    }];
    
    [_payee_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_tf.left);
        make.centerY.equalTo(self.payee_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.receive_p);
    }];
    
    
    [_bankName_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_p.left);
        make.top.equalTo(self.payee_p.bottom).offset(spacing1);
        make.size.equalTo(self.receive_p);
    }];
    
    [_bankName_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_tf.left);
        make.centerY.equalTo(self.bankName_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.receive_p);
    }];
    
    [_banch_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_p.left);
        make.top.equalTo(self.bankName_p.bottom).offset(spacing1);
        make.size.equalTo(self.receive_p);
    }];
    
    [_banch_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_tf.left);
        make.centerY.equalTo(self.banch_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.receive_p);
    }];
    
    [_defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receive_tf.left).offset(0);
        make.top.equalTo(self.banch_tf.bottom).offset(spacing1*1.5);
        make.size.equalTo(CGSizeMake(70, 25));
    }];
    
    [_default_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.defaultSwitch.right).offset(0);
        make.centerY.equalTo(self.defaultSwitch).offset(2);
        make.size.equalTo(self.receive_p);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.receive_tf.right);
        make.centerY.equalTo(self.defaultSwitch);
        make.size.equalTo(CGSizeMake(btn_H, btn_H));
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.receive_tf.right);
        make.top.equalTo(self.default_p.bottom).offset(spacing1*2);
        make.size.equalTo(CGSizeMake(btn_w, btn_H));
    }];
    
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.confirmBtn.left).offset(-10);
        make.centerY.equalTo(self.confirmBtn);
        make.size.equalTo(self.confirmBtn);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
