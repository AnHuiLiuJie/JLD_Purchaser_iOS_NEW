//
//  GLPBindController.m
//  DCProject
//
//  Created by bigbing on 2019/8/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPBindController.h"

#import "DCTextField.h"
#import "DCCodeButton.h"
#import "GLBProtocolModel.h"
#import "GLPTabBarController.h"
/*Add_环信_标识
 *
 */
#import "AppDelegate+HelpDesk.h"
// Views
#import "CaptchaView.h"
@interface GLPBindController ()<DCCodeButtonDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) DCTextField *phoneTF;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) DCTextField *smsCodeTF;
@property (nonatomic, strong) DCCodeButton *codeBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *protocolBtn;

@property (nonatomic, strong) NSMutableArray<GLBProtocolModel *> *protocolArray;
@end

@implementation GLPBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self requestRegisterProtocol];
    self.protocolBtn.selected = YES;
}

#pragma mark - action
- (void)registerBtnClick:(UIButton *)button
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
    if (self.protocolBtn.selected==NO)
    {
        [SVProgressHUD showInfoWithStatus:@"请先阅读并同意用户协议"];
        return;
    }
    
    NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    if (userId.length == 0) {
        userId = [[DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key];
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestThirdRegisterWithCellphone:self.phoneTF.text tempUserId:userId thirdLoginId:self.thirdLoginId thirdType:self.thirdType validInfo:self.smsCodeTF.text success:^(id response) {
        if (response) {
            [weakSelf requestThirdLogin];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}



#pragma mark - 请求 第三方授权登录
- (void)requestThirdLogin
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestThirdLogoutWithBlindId:self.thirdLoginId channel:self.thirdType success:^(id response) {
        
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictttt = response;
            NSDictionary *dic = dictttt[@"data"];
            
            NSString *alias = [NSString stringWithFormat:@"jld_person_%@",dic[@"userId"]];
            // 设置推送别名
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"设置推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
            } seq:0];
            
            [JPUSHService setTags:[NSSet setWithObject:@"jld_person"]completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            } seq:0];
            
            [DCObjectManager dc_saveUserData:dic[@"token"] forKey:P_Token_Key];
            [DCObjectManager dc_saveUserData:dic[@"userId"] forKey:P_UserID_Key];
            
            /*Add_HX_标识
             *登录环信
             */
            [DC_Appdelegate huanxinLogin:nil successBlock:^{
                [weakSelf verification_Huanxin_LoginAfter:dic];
            } failBlock:^{
                [weakSelf verification_Huanxin_LoginAfter:dic];
            }];
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}

- (void)verification_Huanxin_LoginAfter:(NSDictionary *)dic
{
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    [DCObjectManager dc_saveUserData:self.phoneTF.text forKey:DC_Person_loginName_Key];
    
    NSString *logoImg = @"";
    if (dic && dic[@"logoImg"]) {
        logoImg = dic[@"logoImg"];
    }
    
    [DCObjectManager dc_saveUserData:self.phoneTF.text forKey:DC_UserName_Key];
    [DCObjectManager dc_saveUserData:logoImg forKey:DC_UserImage_Key];
    
    NSString *nickname = @"";
    if ([DCUpdateTool shareClient].currentUserB2C && [DCUpdateTool shareClient].currentUserB2C.userName && ![[DCUpdateTool shareClient].currentUserB2C.userName dc_isNull] && [DCUpdateTool shareClient].currentUserB2C.userName.length > 0) {
        nickname = [DCUpdateTool shareClient].currentUserB2C.userName;
    }
    NSDictionary *userInfo = @{@"userId":[NSString stringWithFormat:@"b2c_%@",[DCObjectManager dc_readUserDataForKey:P_UserID_Key]],@"nickname":[NSString stringWithFormat:@"%@",nickname],@"headImg":[NSString stringWithFormat:@"%@",logoImg]};
    [[DCUpdateTool shareClient] updateEaseUser:userInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GLPTabBarController *tabbarVC = [[GLPTabBarController alloc] init];
        DC_KeyWindow.rootViewController = tabbarVC;
        //                [CSDemoAccountManager shareLoginManager].homeVC = tabbarVC;
        //                [CSDemoAccountManager shareLoginManager].homeVC1 = nil;
    });
}


- (void)protocolBtnClick:(UIButton *)button
{
    self.protocolBtn.selected = !self.protocolBtn.selected;
}

#pragma mark - <DCCodeButtonDelegate>
- (void)dc_sendBtnClick:(DCCodeButton *)button
{
    if (self.phoneTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
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
            @"isReg": @"1",//接口是否验证已经注册用户:1-是注册请求；2-非注册请求
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
                [weakSelf.view makeToast:@"改手机号已被其他账号使用，请更换手机号" duration:Toast_During position:CSToastPositionBottom];
            }else if ([response[DC_ResultCode_Key] integerValue] == DC_Result_NotExist){
                //不已存在
            }else{
                [SVProgressHUD showErrorWithStatus:response[DC_ResultMsg_Key]];
            }
        } failture:^(NSError * _Nullable error) {
        }];
    }];
}


#pragma mark - 请求 获取注册协议
- (void)requestRegisterProtocol
{
    [self.protocolArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager]person_RegisterProtocolsuccess:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.protocolArray addObjectsFromArray:response];
            
            weakSelf.protocolLabel.attributedText = [weakSelf dc_attributeStr];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - attributeStr
- (NSMutableAttributedString *)dc_attributeStr
{
    NSString *protocolStr = @"";
    if (self.protocolArray.count > 0) {
        for (NSInteger i = 0; i<self.protocolArray.count; i++) {
            GLBProtocolModel *model = self.protocolArray[i];
            if (protocolStr.length == 0) {
                protocolStr = [NSString stringWithFormat:@"%@",model.name];
            } else {
                protocolStr = [NSString stringWithFormat:@"%@\n%@",protocolStr,model.name];
            }
        }
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"注册即表示同意%@",protocolStr]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 7)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(7, attrStr.length - 7)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentCenter;
    [attrStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attrStr.length)];
    
    return attrStr;
}

- (void)protocolAction:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.protocolLabel];;
    
    if (point.y < 19) { // 第一个
        
        if (self.protocolArray.count > 0) {
            NSString *name = [self.protocolArray[0] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            if (point.x > (kScreenW/2 - 100) && point.x <((kScreenW/2 - 100)+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[0] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[0] api]];
                [self dc_pushWebController:@"/public/agree_geren.html" params:params];
            }
        }
        
    } else if (point.y >= 19 && point.y < 38){ // 第二个
        
        if (self.protocolArray.count > 1) {
            NSString *name = [self.protocolArray[1] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > (kScreenW - size.width)/2  && point.x <((kScreenW - size.width)/2+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[1] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[1] api]];
                [self dc_pushWebController:@"/public/agree_geren.html" params:params];
            }
        }
        
    } else if (point.y >= 38 && point.y < 57){ // 第三个
        
        if (self.protocolArray.count > 2) {
            NSString *name = [self.protocolArray[2] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > (kScreenW - size.width)/2 && point.x <((kScreenW - size.width)/2+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[2] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[2] api]];
                [self dc_pushWebController:@"/public/agree_geren.html" params:params];
            }
        }
    }
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"注册";
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    
    _logoImage = [[UIImageView alloc] init];
    _logoImage.image = [UIImage imageNamed:@"logo"];
    [_scrollView addSubview:_logoImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#191919"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:20];
    _titleLabel.text = @"注册金利达";
    [_scrollView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#787878"];
    _subLabel.font = [UIFont fontWithName:PFR size:16];
    _subLabel.text = @"注册后体验更多功能";
    [_scrollView addSubview:_subLabel];
    
    _phoneTF = [[DCTextField alloc] init];
    _phoneTF.type = DCTextFieldTypeTelePhone;
    _phoneTF.placeholder = @"手机号码";
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
    _smsCodeTF.type = DCTextFieldTypeCount;
    _smsCodeTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"输入验证码"];
    _smsCodeTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _smsCodeTF.font = PFRFont(14);
    _smsCodeTF.keyboardType=UIKeyboardTypeNumberPad;
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
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#02A299"];
    [_registerBtn setTitle:@"注册" forState:0];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:0];
    _registerBtn.titleLabel.font = PFRFont(15);
    [_registerBtn dc_cornerRadius:3];
    [_registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_registerBtn];
    
    _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_protocolBtn setImage:[UIImage imageNamed:@"xuanz"] forState:0];
    [_protocolBtn setImage:[UIImage imageNamed:@"tongyi"] forState:UIControlStateSelected];
    _protocolBtn.adjustsImageWhenHighlighted = NO;
    [_protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_protocolBtn];
    
    _protocolLabel = [[UILabel alloc] init];
    _protocolLabel.textColor = [UIColor dc_colorWithHexString:@"#7A7A7A"];
    _protocolLabel.font = PFRFont(11);
    _protocolLabel.attributedText = [self dc_attributeStr];
    _protocolLabel.userInteractionEnabled = YES;
    _protocolLabel.numberOfLines=0;
    _protocolLabel.userInteractionEnabled = YES;
    [_scrollView addSubview:_protocolLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolAction:)];
    [_protocolLabel addGestureRecognizer:tap];
    
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
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(38);
        make.top.equalTo(self.scrollView.top).offset(40);
        make.size.equalTo(CGSizeMake(28, 28));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImage.right).offset(8);
        make.centerY.equalTo(self.logoImage.centerY);
        make.right.equalTo(self.scrollView.right).offset(-38);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImage.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.logoImage.bottom).offset(10);
    }];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subLabel.left);
        make.right.equalTo(self.subLabel.right);
        make.top.equalTo(self.subLabel.bottom).offset(23);
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
        make.left.equalTo(self.subLabel.left);
        make.right.equalTo(self.subLabel.right);
        make.top.equalTo(self.phoneView.bottom).offset(20);
        make.height.equalTo(50);
    }];
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.smsCodeTF.right).offset(-10);
        make.top.equalTo(self.smsCodeTF.top);
        make.bottom.equalTo(self.smsCodeTF.bottom);
        make.width.equalTo(100);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subLabel.left);
        make.right.equalTo(self.subLabel.right);
        make.top.equalTo(self.smsCodeTF.bottom).offset(44);
        make.height.equalTo(50);
    }];
    
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.registerBtn.centerX).offset(10);
        make.top.equalTo(self.registerBtn.bottom).offset(20);
        make.bottom.equalTo(self.scrollView.bottom).offset(-30);
    }];
    
    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerBtn.bottom).offset(13);
        make.right.equalTo(self.protocolLabel.left).offset(-10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
}

- (NSMutableArray<GLBProtocolModel *> *)protocolArray{
    if (!_protocolArray) {
        _protocolArray = [NSMutableArray array];
    }
    return _protocolArray;
}

@end
