//
//  GLBRepayStageController.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayStageController.h"
#import "DCTextField.h"

@interface GLBRepayStageController ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nopayLabel;
@property (nonatomic, strong) UILabel *repayLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) DCTextField *moneyTF;
@property (nonatomic, strong) UILabel *remainLabel;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *commintBtn;

@end

@implementation GLBRepayStageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}


#pragma mark - action
- (void)bgBtnClick:(UIButton *)button
{
    [self cancelBtnClick:nil];
}

- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view removeFromSuperview];
}

- (void)commintBtnClick:(UIButton *)button
{
    if (self.moneyTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入本次还款金额"];
        return;
    }
    
    if ([self.moneyTF.text floatValue] <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的还款金额"];
        return;
    }
    
    if (_repayBlock) {
        _repayBlock([self.moneyTF.text floatValue]);
    }
}


#pragma mark - attributeStr
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)string
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余待还款金额：￥%@",string]];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:15],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF9900"]} range:NSMakeRange(attrStr.length - string.length, string.length)];
    return attrStr;
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.text = @"按金额分期还款";
    [_bgView addSubview:_titleLabel];
    
    _nopayLabel = [[UILabel alloc] init];
    _nopayLabel.font = [UIFont fontWithName:PFR size:12];
    _nopayLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _nopayLabel.text = @"待还款总额：￥0.00";
    [_bgView addSubview:_nopayLabel];
    
    _repayLabel = [[UILabel alloc] init];
    _repayLabel.font = [UIFont fontWithName:PFR size:12];
    _repayLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _repayLabel.text = @"已还款：￥0.00";
    [_bgView addSubview:_repayLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont fontWithName:PFR size:12];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _countLabel.text = @"剩余分期还款次数：0";
    [_bgView addSubview:_countLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = [UIFont fontWithName:PFR size:12];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _moneyLabel.text = @"本次还款金额：";
    [_bgView addSubview:_moneyLabel];
    
    _moneyTF = [[DCTextField alloc] init];
    _moneyTF.type = DCTextFieldTypeMoney;
    _moneyTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _moneyTF.font = PFRFont(12);
    _moneyTF.placeholder = @"请输入还款金额";
    _moneyTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _moneyTF.leftViewMode = UITextFieldViewModeAlways;
    [_moneyTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EDEDED"] radius:14];
    [_bgView addSubview:_moneyTF];
    
    _remainLabel = [[UILabel alloc] init];
    _remainLabel.font = [UIFont fontWithName:PFR size:12];
    _remainLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _remainLabel.attributedText = [self dc_attributeStr:@"0.00"];
    [_bgView addSubview:_remainLabel];
    
    _line1 = [[UIImageView alloc] init];
    _line1.backgroundColor = [UIColor dc_colorWithHexString:@"#E6E6E6"];
    [_bgView addSubview:_line1];
    
    _line2 = [[UIImageView alloc] init];
    _line2.backgroundColor = [UIColor dc_colorWithHexString:@"#E6E6E6"];
    [_bgView addSubview:_line2];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _cancelBtn.titleLabel.font = PFRFont(14);
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commintBtn setTitle:@"确认还款" forState:0];
    [_commintBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _commintBtn.titleLabel.font = PFRFont(14);
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_commintBtn];
    
    
    if (_repayListModel) {
        _nopayLabel.text = [NSString stringWithFormat:@"待还款总额：￥%.2f",_repayListModel.accountPeriodAmount];
        _repayLabel.text = [NSString stringWithFormat:@"已还款：￥%.2f",_repayListModel.hasPaymentAmount];
        _countLabel.text = [NSString stringWithFormat:@"剩余分期还款次数：0"];
        _remainLabel.attributedText = [self dc_attributeStr:[NSString stringWithFormat:@"%.2f",_repayListModel.paymentAmount]];
    }
    
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(-kNavBarHeight/2);
        make.width.equalTo(0.85*kScreenW);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.bgView.top).offset(15);
    }];
    
    [_nopayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.titleLabel.bottom).offset(23);
    }];
    
    [_repayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.nopayLabel.bottom).offset(15);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.repayLabel.bottom).offset(15);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.top.equalTo(self.countLabel.bottom).offset(15);
        make.width.equalTo(80);
    }];
    
    [_moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel.centerY);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.left.equalTo(self.moneyLabel.right).offset(15);
        make.height.equalTo(28);
    }];
    
    [_remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.moneyLabel.bottom).offset(15);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.remainLabel.bottom).offset(20);
        make.height.equalTo(1);
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.bottom);
        make.centerX.equalTo(self.bgView.centerX);
        make.size.equalTo(CGSizeMake(1, 40));
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.line2.left);
        make.top.equalTo(self.line1.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [_commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2.right);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.line1.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
}

@end
