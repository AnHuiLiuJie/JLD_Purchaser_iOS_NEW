//
//  GLBXiaohuController.m
//  DCProject
//
//  Created by bigbing on 2020/4/26.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "GLBXiaohuController.h"

#import "DCTextField.h"
#import "DCCodeButton.h"

#import "DCNavigationController.h"
#import "GLBOpenTypeController.h"

@interface GLBXiaohuController ()<DCCodeButtonDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DCTextField *mobileTF;
@property (nonatomic, strong) UIImageView *mobileLine;
@property (nonatomic, strong) DCTextField *imageCodeTF;
@property (nonatomic, strong) UIImageView *imageCodeLine;
@property (nonatomic, strong) UIImageView *codeImage;
@property (nonatomic, strong) DCTextField *smsCodeTF;
@property (nonatomic, strong) UIImageView *smsCodeLine;
@property (nonatomic, strong) DCCodeButton *codeBtn;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) DCAlterView *alterView;

@end

@implementation GLBXiaohuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self requestImageCode];
}



#pragma mark - action
- (void)agreeBtnClick:(UIButton *)button
{
    button.selected =! button.selected;
    
    self.nextBtn.enabled = button.selected;
}

- (void)nextBtnClick:(UIButton *)button
{
    if (self.mobileTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkTelNumber:self.mobileTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (self.imageCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入数字验证码"];
        return;
    }
    
    if (self.smsCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机验证码"];
        return;
    }

    if (![DC_KeyWindow.subviews.lastObject isKindOfClass:[DCAlterView class]]) {
        [DC_KeyWindow addSubview:self.alterView];
        [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
}

- (void)imageTapAction:(id)sender
{
    [self requestImageCode];
}


#pragma mark - <DCCodeButtonDelegate>
- (void)dc_sendBtnClick:(DCCodeButton *)button
{
    if (self.mobileTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkTelNumber:self.mobileTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (self.imageCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入数字验证码"];
        return;
    }
    
    [self requestSendSMSCode];}


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


#pragma mark -
- (void)requestChangePhone
{
    [[DCAPIManager shareManager] dc_requestXiaohuWithCellphone:self.mobileTF.text validInfo:self.smsCodeTF.text success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"注销账号成功"];
            [[DCLoginTool shareTool] dc_removeLoginDataWithCompany];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBOpenTypeController new]];
            });
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - UI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:21];
    _titleLabel.text = @"注销账号";
    [self.view addSubview:_titleLabel];
    
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
    _imageCodeTF.placeholder = @"输入数字验证码";
    [self.view addSubview:_imageCodeTF];
    
    _imageCodeLine = [[UIImageView alloc] init];
    _imageCodeLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_imageCodeLine];
    
    _codeImage = [[UIImageView alloc] init];
//    _codeImage.contentMode = UIViewContentModeScaleAspectFill;
//    _codeImage.clipsToBounds = YES;
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
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_nextBtn setTitle:@"确定" forState:0];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    _nextBtn.titleLabel.font = PFRFont(16);
    [_nextBtn dc_cornerRadius:22];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.top.equalTo(self.view.top).offset(kNavBarHeight + 14);
    }];
    
    [_mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(self.titleLabel.bottom).offset(60);
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
    
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(self.smsCodeTF.bottom).offset(120);
        make.height.equalTo(44);
    }];
}

- (DCAlterView *)alterView{
    if (!_alterView) {
        _alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"确定要注销账号？"];
        [_alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        WEAKSELF;
        [_alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            [weakSelf requestChangePhone];
        }];
    }
    return _alterView;
}
@end
