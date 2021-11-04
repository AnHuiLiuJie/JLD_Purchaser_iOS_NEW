//
//  GLPBankCardCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//
/**6212143000000000029
 卡号：6212143000000000029
 身份证：310115198903261113
 姓名：John
 手机号：13666666666
 */

#import "GLPBankCardCell.h"

@implementation GLPBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

#pragma mark - Intial
- (void)setViewUI{
    [_cardTf addTarget:self action:@selector(cardTf_DidChange:) forControlEvents:UIControlEventEditingChanged];
    [_certificateTf addTarget:self action:@selector(certificateTf_DidChange:) forControlEvents:UIControlEventEditingChanged];
    [_nameTf addTarget:self action:@selector(nameTf_DidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTf addTarget:self action:@selector(phoneTf_DidChange:) forControlEvents:UIControlEventEditingChanged];
    [_verificationTf addTarget:self action:@selector(verificationTf_DidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_debitBtn addTarget:self action:@selector(bankCardTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    _debitBtn.selected = YES;
    _creditBtn.selected = NO;
    [_creditBtn addTarget:self action:@selector(bankCardTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_obtainBtn addTarget:self action:@selector(obtainBtnAction:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - set
- (void)setModel:(GLPBankCardListModel *)model{
    _model = model;
}

#pragma mark - private method
- (void)cardTf_DidChange:(UITextField *)textField
{
    [DCSpeedy editChange:textField length:30];
    if (textField.text.length > 30) {
        [SVProgressHUD showInfoWithStatus:@"输入正确的银行卡号"];
    }
    !_GLPBankCardCell_cardTf_block ? : _GLPBankCardCell_cardTf_block(textField.text);
}

- (void)certificateTf_DidChange:(UITextField *)textField
{
    if (textField.text.length > 18) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:18];
    }
    !_GLPBankCardCell_certificateTf_block ? : _GLPBankCardCell_certificateTf_block(textField.text);
}

- (void)nameTf_DidChange:(UITextField *)textField
{
    [DCSpeedy editChange:textField length:20];
    if (textField.text.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"姓名限制20个字符"];
    }
    !_GLPBankCardCell_nameTf_block ? : _GLPBankCardCell_nameTf_block(textField.text);
}

- (void)phoneTf_DidChange:(UITextField *)textField
{
    if (textField.text.length > 11) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:11];
    }
    !_GLPBankCardCell_phoneTf_block ? : _GLPBankCardCell_phoneTf_block(textField.text);
}

- (void)verificationTf_DidChange:(UITextField *)textField
{
    !_GLPBankCardCell_verificationTf_block? : _GLPBankCardCell_verificationTf_block(textField.text);
}

#pragma buttonAction
- (void)bankCardTypeAction:(UIButton *)button{
    if ([button isEqual:_debitBtn]) {
        _debitBtn.selected = YES;
        _creditBtn.selected = NO;
        !_GLPBankCardCell_cardType_block ? : _GLPBankCardCell_cardType_block(1);
    }else{
        _debitBtn.selected = NO;
        _creditBtn.selected = YES;
        !_GLPBankCardCell_cardType_block ? : _GLPBankCardCell_cardType_block(2);
    }
}

- (void)obtainBtnAction:(UIButton *)button{
    
    if (self.cardTf.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请填写银行卡号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkBankNumber:self.cardTf.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的银行卡号"];
        return;
    }
    
    if (self.certificateTf.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入身份证号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkUserIdCard:self.certificateTf.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的身份证号"];
        return;
    }
    
    if (self.nameTf.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入持卡人姓名"];
        return;
    }
    
    if (self.phoneTf.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入预留手机号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkTelNumber:self.phoneTf.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    [self.obtainBtn startTimeGo];
    
    !_GLPBankCardCell_send_block ? : _GLPBankCardCell_send_block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
