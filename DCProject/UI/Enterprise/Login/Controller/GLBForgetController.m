//
//  GLBForgetController.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBForgetController.h"
#import "DCTextField.h"
#import "DCCodeButton.h"

@interface GLBForgetController ()<DCCodeButtonDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DCTextField *userTF;
@property (nonatomic, strong) UIImageView *userLine;
@property (nonatomic, strong) DCTextField *mobileTF;
@property (nonatomic, strong) UIImageView *mobileLine;
@property (nonatomic, strong) DCTextField *imageCodeTF;
@property (nonatomic, strong) UIImageView *imageCodeLine;
@property (nonatomic, strong) UIImageView *codeImage;
@property (nonatomic, strong) DCTextField *smsCodeTF;
@property (nonatomic, strong) UIImageView *smsCodeLine;
@property (nonatomic, strong) DCCodeButton *codeBtn;
@property (nonatomic, strong) DCTextField *passworldTF;
@property (nonatomic, strong) UIImageView *passworldLine;
@property (nonatomic, strong) UIButton *passworldBtn;
@property (nonatomic, strong) DCTextField *againTF;
@property (nonatomic, strong) UIImageView *againLine;
@property (nonatomic, strong) UIButton *againBtn;
@property (nonatomic, strong) UIButton *commintBtn;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;

@end

@implementation GLBForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self requestImageCode];
}


#pragma mark - action
- (void)passworldBtnClick:(UIButton *)button
{
    button.selected =! button.selected;
    
    self.passworldTF.secureTextEntry = ! button.self;
}

- (void)againBtnClick:(UIButton *)button
{
    button.selected =! button.selected;
    
    self.againTF.secureTextEntry = ! button.self;
}

- (void)commintBtnClick:(UIButton *)button
{
    if (self.userTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }
    
    if (self.mobileTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkTelNumber:self.mobileTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (self.imageCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入计算结果"];
        return;
    }
    
    if (self.smsCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机验证码"];
        return;
    }
    
    if (self.passworldTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入新密码"];
        return;
    }
    
    if (self.againTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请确认密码"];
        return;
    }
    
    if (![self.againTF.text isEqualToString:self.passworldTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
        return;
    }
    
    [self requestResetPassWorld];
}

- (void)imageTapAction:(id)sender
{
    [self requestImageCode];
}


#pragma mark - <DCCodeButtonDelegate>
- (void)dc_sendBtnClick:(DCCodeButton *)button
{
    if (self.userTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }
    
    if (self.mobileTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkTelNumber:self.mobileTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (self.imageCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入计算结果"];
        return;
    }
    
    [self requestSendSMSCode];
}


#pragma mark - 请求 获取图形验证码
- (void)requestImageCode
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestImageCodeWithToken:self.token userId:self.userId success:^(id response) {
        
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSString *string = response[@"imgCode"];
            weakSelf.token = response[@"token"];
            weakSelf.userId = response[@"userId"];
            
            [weakSelf.codeImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"placher-30"]];
        }
        
    } failture:^(NSError *_Nullable error) {
        
    }];
}


#pragma mark - 请求 发送短信验证码
- (void)requestSendSMSCode
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSendSMSCodeWithCaptcha:self.imageCodeTF.text phoneNumber:self.mobileTF.text token:self.token userId:self.userId success:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]] && response[DC_ResultCode_Key] && [response[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            [weakSelf.codeBtn startTimeGo];
        } else {
            [weakSelf requestImageCode];
        }
    } failture:^(NSError *_Nullable error) {
        
    }];
}


#pragma mark - 请求 重置密码
- (void)requestResetPassWorld
{
    [[DCAPIManager shareManager] dc_requestResetPswWithCaptcha:self.smsCodeTF.text phoneNumber:self.mobileTF.text token:self.token userId:self.userId loginName:self.userTF.text newPwd:self.passworldTF.text success:^(id response) {
        
        if (response) {
            
        }
        
    } failture:^(NSError *_Nullable error) {
        
    }];
}


#pragma mark - UI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:21];
    _titleLabel.text = @"忘记密码";
    [self.view addSubview:_titleLabel];
    
    _userTF = [[DCTextField alloc] init];
    _userTF.type = DCTextFieldTypeDefault;
    _userTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _userTF.font = PFRFont(16);
    _userTF.placeholder = @"请输入用户名";
    [self.view addSubview:_userTF];
    
    _userLine = [[UIImageView alloc] init];
    _userLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_userLine];
    
    _mobileTF = [[DCTextField alloc] init];
    _mobileTF.type = DCTextFieldTypeTelePhone;
    _mobileTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _mobileTF.font = PFRFont(16);
    _mobileTF.placeholder = @"请输入手机号";
    [self.view addSubview:_mobileTF];
    
    _mobileLine = [[UIImageView alloc] init];
    _mobileLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_mobileLine];
    
    _imageCodeTF = [[DCTextField alloc] init];
    _imageCodeTF.type = DCTextFieldTypeImageCode;
    _imageCodeTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _imageCodeTF.font = PFRFont(16);
    _imageCodeTF.placeholder = @"输入图形验证码";
    [self.view addSubview:_imageCodeTF];
    
    _imageCodeLine = [[UIImageView alloc] init];
    _imageCodeLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_imageCodeLine];
    
    _codeImage = [[UIImageView alloc] init];
    _codeImage.userInteractionEnabled = YES;
    [self.view addSubview:_codeImage];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
    [_codeImage addGestureRecognizer:imageTap];
    
    _smsCodeTF = [[DCTextField alloc] init];
    _smsCodeTF.type = DCTextFieldTypeSMSCode;
    _smsCodeTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _smsCodeTF.font = PFRFont(16);
    _smsCodeTF.placeholder = @"输入手机验证码";
    [self.view addSubview:_smsCodeTF];
    
    _smsCodeLine = [[UIImageView alloc] init];
    _smsCodeLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_smsCodeLine];
    
    _codeBtn = [[DCCodeButton alloc] init];
    _codeBtn.delegate = self;
    [_codeBtn setTitle:@"获取验证码" forState:0];
    [_codeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _codeBtn.titleLabel.font = PFRFont(12);
    [self.view addSubview:_codeBtn];
    
    _passworldTF = [[DCTextField alloc] init];
    _passworldTF.type = DCTextFieldTypePassWord;
    _passworldTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _passworldTF.font = PFRFont(16);
    _passworldTF.placeholder = @"输入6-16位登录密码";
    [self.view addSubview:_passworldTF];
    
    _passworldLine = [[UIImageView alloc] init];
    _passworldLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_passworldLine];
    
    _passworldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_passworldBtn setImage:[UIImage imageNamed:@"dc_pwd_visible"] forState:0];
    [_passworldBtn setImage:[UIImage imageNamed:@"dc_pwd_noVisible"] forState:UIControlStateSelected];
    _passworldBtn.adjustsImageWhenHighlighted = NO;
    [_passworldBtn addTarget:self action:@selector(passworldBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_passworldBtn];
    
    _againTF = [[DCTextField alloc] init];
    _againTF.type = DCTextFieldTypePassWord;
    _againTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _againTF.font = PFRFont(16);
    _againTF.placeholder = @"确认密码";
    [self.view addSubview:_againTF];
    
    _againLine = [[UIImageView alloc] init];
    _againLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_againLine];
    
    _againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_againBtn setImage:[UIImage imageNamed:@"yan"] forState:0];
    [_againBtn setImage:[UIImage imageNamed:@"byan"] forState:UIControlStateSelected];
    _againBtn.adjustsImageWhenHighlighted = NO;
    [_againBtn addTarget:self action:@selector(againBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_againBtn];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_commintBtn setTitle:@"确认" forState:0];
    [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
    _commintBtn.titleLabel.font = PFRFont(16);
    [_commintBtn dc_cornerRadius:22];
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commintBtn];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.top.equalTo(self.view.top).offset(kNavBarHeight + 14);
    }];
    
    [_userTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(self.titleLabel.bottom).offset(40);
        make.height.equalTo(50);
    }];
    
    [_userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userTF.left).offset(-3);
        make.right.equalTo(self.userTF.right).offset(3);
        make.bottom.equalTo(self.userTF.bottom).offset(-5);
        make.height.equalTo(1);
    }];
    
    [_mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(self.userTF.bottom).offset(10);
        make.height.equalTo(50);
    }];
    
    [_mobileLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileTF.left).offset(-3);
        make.right.equalTo(self.mobileTF.right).offset(3);
        make.bottom.equalTo(self.mobileTF.bottom).offset(-5);
        make.height.equalTo(1);
    }];
    
    [_imageCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileTF.left);
        make.right.equalTo(self.mobileTF.right);
        make.top.equalTo(self.mobileTF.bottom).offset(10);
        make.height.equalTo(self.mobileTF.height);
    }];
    
    [_imageCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileLine.left);
        make.right.equalTo(self.mobileLine.right);
        make.bottom.equalTo(self.imageCodeTF.bottom).offset(-5);
        make.height.equalTo(1);
    }];
    
    [_codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageCodeTF.centerY);
        make.right.equalTo(self.imageCodeTF.right);
        make.size.equalTo(CGSizeMake(70, 36));
    }];
    
    [_smsCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileTF.left);
        make.right.equalTo(self.mobileTF.right);
        make.top.equalTo(self.imageCodeTF.bottom).offset(10);
        make.height.equalTo(self.mobileTF.height);
    }];
    
    [_smsCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileLine.left);
        make.right.equalTo(self.mobileLine.right);
        make.bottom.equalTo(self.smsCodeTF.bottom).offset(-5);
        make.height.equalTo(1);
    }];
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.smsCodeTF.centerY);
        make.right.equalTo(self.smsCodeTF.right);
        make.size.equalTo(CGSizeMake(80, 35));
    }];
    
    [_passworldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileTF.left);
        make.right.equalTo(self.mobileTF.right);
        make.top.equalTo(self.smsCodeTF.bottom).offset(10);
        make.height.equalTo(self.mobileTF.height);
    }];
    
    [_passworldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileLine.left);
        make.right.equalTo(self.mobileLine.right);
        make.bottom.equalTo(self.passworldTF.bottom).offset(-5);
        make.height.equalTo(1);
    }];
    
    [_passworldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passworldTF.centerY);
        make.right.equalTo(self.passworldLine.right);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_againTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileTF.left);
        make.right.equalTo(self.mobileTF.right);
        make.top.equalTo(self.passworldTF.bottom).offset(10);
        make.height.equalTo(self.mobileTF.height);
    }];
    
    [_againLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileLine.left);
        make.right.equalTo(self.mobileLine.right);
        make.bottom.equalTo(self.againTF.bottom).offset(-5);
        make.height.equalTo(1);
    }];
    
    [_againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.againTF.centerY);
        make.right.equalTo(self.againLine.right);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(self.againTF.bottom).offset(70);
        make.height.equalTo(44);
    }];
}


@end
