//
//  GLPXiaohuController.m
//  DCProject
//
//  Created by bigbing on 2020/4/26.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "GLPXiaohuController.h"

#import "DCTextField.h"
#import "DCCodeButton.h"
#import "GLBOpenTypeController.h"
#import "DCNavigationController.h"
// Views
#import "CaptchaView.h"
@interface GLPXiaohuController ()<DCCodeButtonDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DCTextField *phoneTF;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) DCTextField *pwdTF;
@property (nonatomic, strong) UIView *pwdView;
@property (nonatomic, strong) DCTextField *smsCodeTF;
@property (nonatomic, strong) DCCodeButton *codeBtn;
@property (nonatomic, strong) UIButton *completeBtn;

@property (nonatomic, strong) DCAlterView *alterView;

@end

@implementation GLPXiaohuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注销账号";
    
    [self setUpUI];
}

#pragma mark - action
- (void)completeBtnClick:(UIButton *)button
{
    if (self.phoneTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (self.smsCodeTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入短信验证码"];
        return;
    }
    
    if (![DC_KeyWindow.subviews.lastObject isKindOfClass:[DCAlterView class]]) {
        [DC_KeyWindow addSubview:self.alterView];
        [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
    
}
#pragma mark - <DCCodeButtonDelegate>
- (void)dc_sendBtnClick:(DCCodeButton *)button
{
    if (self.phoneTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入登录手机号码"];
        return;
    }
    [DC_KeyWindow endEditing:YES];//关闭键盘
    WEAKSELF;
    [CaptchaView showWithType:puzzle CompleteBlock:^(NSString *  result) {
        NSLog(@"result: %@", result);
        NSString *captchaStr = [DH_EncryptAndDecrypt encryptWithContent:result key:DC_Encrypt_Key];
        
        NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
        NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
        if (token.length == 0) {
            token = [[DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key];
        }
        if (userId.length == 0) {
            userId = [[DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key];
        }
        //token或者userId为空这里应该提示重新 滑动验证码获取 return;
        
        
        NSDictionary *patameters = @{
            @"captcha": captchaStr,
            @"phoneNumber": weakSelf.phoneTF.text,
            @"isReg": @"2",//接口是否验证已经注册用户:1-是注册请求；2-非注册请求
            @"token":token,
            @"userId":userId
        };
        
        [[DCAPIManager shareManager] dc_request_b2c_common_captcha_sendMessageWithDic:patameters Success:^(id  _Nullable response) {
            if ([response[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
                //验证码发送成功
                [weakSelf.view makeToast:@"短信验证码已发送，请注意查收" duration:Toast_During position:CSToastPositionBottom];
                [weakSelf.codeBtn startTimeGo];
            }else if ([response[DC_ResultCode_Key] integerValue] == DC_Result_Eegistered){
                //已注册
            }else if ([response[DC_ResultCode_Key] integerValue] == DC_Result_NotExist){
                //不已存在
                [weakSelf.view makeToast:@"用户不存在,请重新确认手机号" duration:Toast_During position:CSToastPositionBottom];
            }else{
                [SVProgressHUD showErrorWithStatus:response[DC_ResultMsg_Key]];
            }
        } failture:^(NSError * _Nullable error) {
        }];
    }];
}

#pragma mark - setUpUI
- (void)setUpUI
{
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    
    _phoneTF = [[DCTextField alloc] init];
    _phoneTF.type = DCTextFieldTypeTelePhone;
    _phoneTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"输入手机号码"];
    _phoneTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _phoneTF.font = PFRFont(14);
    _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    [_phoneTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EBEBEB"] radius:2];
    [_scrollView addSubview:_phoneTF];
    
    _phoneView = [[UIView alloc] init];
    _phoneView.backgroundColor = [UIColor dc_colorWithHexString:@"#FAFAFA"];
    _phoneView.bounds = CGRectMake(0, 0, 66, 50);
    [_phoneView dc_cornerRadius:3 rectCorner:UIRectCornerTopLeft|UIRectCornerBottomLeft ];
    [_scrollView addSubview:_phoneView];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = [UIColor dc_colorWithHexString:@"#7A7A7A"];
    _phoneLabel.font = PFRFont(14);
    _phoneLabel.text = @"+ 86";
    [_phoneView addSubview:_phoneLabel];
    
    _phoneImage = [[UIImageView alloc] init];
    _phoneImage.image = [UIImage imageNamed:@"dc_arrow_down_hui"];
    [_phoneView addSubview:_phoneImage];
    
    _smsCodeTF = [[DCTextField alloc] init];
    _smsCodeTF.type = DCTextFieldTypeTelePhone;
    _smsCodeTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"输入验证码"];
    _smsCodeTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _smsCodeTF.font = PFRFont(14);
    _smsCodeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    _smsCodeTF.leftViewMode = UITextFieldViewModeAlways;
    [_smsCodeTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EBEBEB"] radius:2];
    [_scrollView addSubview:_smsCodeTF];
    _smsCodeTF.clearButtonMode = UITextFieldViewModeNever;
    
    _codeBtn = [[DCCodeButton alloc] init];
    [_codeBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:0];
    _codeBtn.delegate = self;
    _codeBtn.titleLabel.font = PFRFont(14);
    [_scrollView addSubview:_codeBtn];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#02A299"];
    [_completeBtn setTitle:@"确定" forState:0];
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:0];
    _completeBtn.titleLabel.font = PFRFont(15);
    [_completeBtn dc_cornerRadius:3];
    [_completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_completeBtn];
    
    UIView *view = [[UIView alloc] init];
    [_scrollView addSubview:view];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top).offset(kNavBarHeight);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.right.equalTo(self.scrollView.right);
        make.top.equalTo(self.scrollView.top);
        make.height.equalTo(10);
        make.centerX.equalTo(self.scrollView.centerX);
    }];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(38);
        make.right.equalTo(self.scrollView.right).offset(-38);
        make.top.equalTo(self.scrollView.top).offset(14);
        make.height.equalTo(50);
    }];
    
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.left).offset(1);
        make.top.equalTo(self.phoneTF.top).offset(1);
        make.bottom.equalTo(self.phoneTF.bottom).offset(-1);
        make.width.equalTo(66);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneView.left).offset(13);
        make.centerY.equalTo(self.phoneView.centerY);
    }];
    
    [_phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel.right).offset(5);
        make.centerY.equalTo(self.phoneView.centerY);
        make.size.equalTo(CGSizeMake(6, 6));
    }];
    
    [_smsCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.left);
        make.right.equalTo(self.phoneTF.right);
        make.top.equalTo(self.phoneView.bottom).offset(20);
        make.height.equalTo(50);
    }];
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.smsCodeTF.right).offset(-10);
        make.top.equalTo(self.smsCodeTF.top);
        make.bottom.equalTo(self.smsCodeTF.bottom);
        make.width.equalTo(100);
    }];
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.left);
        make.right.equalTo(self.phoneTF.right);
        make.top.equalTo(self.smsCodeTF.bottom).offset(60);
        make.height.equalTo(50);
    }];
    
}


- (DCAlterView *)alterView{
    if (!_alterView) {
        _alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"账号申请注销后，如需再次登录，请重新申请账号！"];
        [_alterView addActionWithTitle:@"我再想想" type:DCAlterTypeCancel halderBlock:nil];
        WEAKSELF;
        [_alterView addActionWithTitle:@"确认" color:[UIColor dc_colorWithHexString:@"#00D3B7"] type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            
            [[DCAPIManager shareManager] person_xiaohuWithNewPhone:weakSelf.phoneTF.text validInfo:weakSelf.smsCodeTF.text success:^(id response) {
                if (response) {
                    [SVProgressHUD showSuccessWithStatus:@"注销账号成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [DCObjectManager dc_removeUserDataForkey:P_Token_Key];
                        [DCObjectManager dc_removeUserDataForkey:P_UserID_Key];
                        DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBOpenTypeController new]];
                    });
                }
            } failture:^(NSError *_Nullable error) {
            }];
        }];
    }
    return _alterView;
}

@end
