//
//  GLPLoginController.m
//  DCProject
//
//  Created by bigbing on 2019/8/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPLoginController.h"
#import "DCTextField.h"
#import "DCCodeButton.h"

#import "GLPRegisterController.h"
#import "GLPForgetController.h"
#import "GLPBindController.h"
#import "GLPTabBarController.h"
#import "GLBProtocolModel.h"
// Views
#import "CaptchaView.h"
/*Add_环信_标识
 *
 */
#import "AppDelegate+HelpDesk.h"
#import <UMSocialWechatHandler.h>
//#import "ChatDemoHelper.h"
#import "DCUMShareTool.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface GLPLoginController ()<DCCodeButtonDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) DCTextField *phoneTF;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) DCTextField *passwordTF;
@property (nonatomic, strong) UIButton *visibleBtn;
@property (nonatomic, strong) DCTextField *smsCodeTF;
@property (nonatomic, strong) DCCodeButton *codeBtn;
@property (nonatomic, strong) UIButton *exchageBtn;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *typelabel;
@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *appleBtn;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *protocolBtn;

@property (nonatomic, strong) NSMutableArray<GLBProtocolModel *> *protocolArray;

@end


static CGFloat Buttom_W = 44;

@implementation GLPLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"注册" color:[UIColor dc_colorWithHexString:DC_BtnColor] font:[UIFont fontWithName:PFR size:14] target:self action:@selector(registerBtnClick:)];
    [self setUpUI];
    [self requestRegisterProtocol];
    
    self.phoneTF.text = [DCObjectManager dc_readUserDataForKey:DC_Person_loginName_Key];
    //    self.passwordTF.text = @"a111111";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - action
- (void)visibleBtnClick:(UIButton *)button{
    //避免明文/密文切换后光标位置偏移
    self.passwordTF.enabled = NO;// the first one;
    self.passwordTF.secureTextEntry = button.selected;

    button.selected = !button.selected;

    self.passwordTF.enabled=YES;// the second one;
    [self.passwordTF becomeFirstResponder];// the third one
}

- (void)loginBtnClick:(UIButton *)button
{
    [DC_KEYWINDOW endEditing:YES];//关闭键盘
    
    if (self.exchageBtn.selected==YES)
    {
        if (self.protocolBtn.selected==NO) {
            [SVProgressHUD showInfoWithStatus:@"请先阅读并同意用户协议"];
            return;
        }
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
        
        NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
        NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
        if (token.length == 0) {
            token = [[DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key];
        }
        if (userId.length == 0) {
            userId = [[DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key];
        }
        //token或者userId为空这里应该提示重新 滑动验证码获取 return;
        
        WEAKSELF;
        [[DCAPIManager shareManager]person_requestSmsCodeLoginWithcaptcha:self.smsCodeTF.text phoneNumber:self.phoneTF.text token:token userId:userId userType:@"1" success:^(id response) {
            NSDictionary *dic = response[@"data"];
            NSString *alias = [NSString stringWithFormat:@"jld_person_%@",dic[@"userId"]];
            // 设置推送别名
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"设置推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
            } seq:0];
            
            [JPUSHService setTags:[NSSet setWithObject:@"jld_person"]completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            } seq:0];
            
            /*Add_HX_标识
             *登录环信
             */
            [DC_Appdelegate huanxinLogin:nil successBlock:^{
                [weakSelf verification_Huanxin_LoginAfter:dic phone:self.phoneTF.text ];
            } failBlock:^{
                [weakSelf verification_Huanxin_LoginAfter:dic phone:self.phoneTF.text ];
            }];
            
        } failture:^(NSError *error) {
            
        }];
    }
    else{
        if (self.protocolBtn.selected==NO) {
            [SVProgressHUD showInfoWithStatus:@"请先阅读并同意用户协议"];
            return;
        }
        if (self.phoneTF.text.length==0)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
            return;
        }
        if (self.passwordTF.text.length==0)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入密码"];
            return;
        }
        
        WEAKSELF;
        [[DCAPIManager shareManager]person_requestPsdLoginWithLoginName:self.phoneTF.text loginPwd:self.passwordTF.text userType:@"1" success:^(id response) {
            //[DCObjectManager dc_saveUserData:self.phoneTF.text forKey:DC_Person_loginName_Key];
            NSDictionary *dic = response[@"data"];
            NSString *alias = [NSString stringWithFormat:@"jld_person_%@",dic[@"userId"]];
            // 设置推送别名
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"设置推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
            } seq:0];
            
            [JPUSHService setTags:[NSSet setWithObject:@"jld_person"]completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            } seq:0];
            /*Add_HX_标识
             *登录环信
             */
            [DC_Appdelegate huanxinLogin:nil successBlock:^{
                [weakSelf verification_Huanxin_LoginAfter:dic phone:self.phoneTF.text ];
            } failBlock:^{
                [weakSelf verification_Huanxin_LoginAfter:dic phone:self.phoneTF.text ];
            }];
            
        } failture:^(NSError *error) {
            
        }];
    }
    
}

- (void)verification_Huanxin_LoginAfter:(NSDictionary *)dic phone:(NSString *)phone
{
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    [DCObjectManager dc_saveUserData:self.phoneTF.text forKey:DC_Person_loginName_Key];
    //友盟+在统计用户时以设备为标准，若需要统计应用自身的账号 PUID户账号ID Provider账号来源
    [MobClick profileSignInWithPUID:dic[@"userId"] provider:@"iOS"];
    
    NSDictionary *dict = @{@"loginNumer":@"登录次数",@"user":dic[@"userId"]};//UM统计 自定义搜索关键词事件
    [MobClick event:UMEventCollection_5 attributes:dict];
    
    NSString *logoImg = @"";
    if (dic && dic[@"logoImg"]) {
        logoImg = dic[@"logoImg"];
    }
    
    if (phone.length != 0) {
        [DCObjectManager dc_saveUserData:self.phoneTF.text forKey:DC_UserName_Key];
    }
    [DCObjectManager dc_saveUserData:logoImg forKey:DC_UserImage_Key];
    
    //[DCObjectManager dc_saveUserData:@"https://img0.123ypw.com/icon/ad/ad3c0ddff.jpg" forKey:DC_UserImage_Key];
    
    //登录过期重新登录时会导致闪退，弃用
    //    if ([DCUpdateTool shareClient].currentUserB2C && [DCUpdateTool shareClient].currentUserB2C.userName && ![[DCUpdateTool shareClient].currentUserB2C.userName dc_isNull] && [DCUpdateTool shareClient].currentUserB2C.userName.length > 0) {
    //        nickname = [DCUpdateTool shareClient].currentUserB2C.userName;
    //    }
    NSString *nickname = @"";
    if (dic && dic[@"userName"]) {
        nickname = dic[@"userName"];
    }
    
    NSDictionary *userInfo = @{@"userId":[NSString stringWithFormat:@"b2c_%@",[DCObjectManager dc_readUserDataForKey:P_UserID_Key]],@"nickname":[NSString stringWithFormat:@"%@",nickname],@"headImg":[NSString stringWithFormat:@"%@",logoImg]};
    [[DCUpdateTool shareClient] updateEaseUser:userInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GLPTabBarController *tabbarVC = [[GLPTabBarController alloc] init];
        DC_KeyWindow.rootViewController = tabbarVC;
        //                    [CSDemoAccountManager shareLoginManager].homeVC = tabbarVC;
        //                    [CSDemoAccountManager shareLoginManager].homeVC1 = nil;
    });
}

- (void)exchageBtnClick:(UIButton *)button
{
    self.exchageBtn.selected = ! self.exchageBtn.selected;
    
    if (self.exchageBtn.selected==YES) {
        
        self.passwordTF.hidden = YES;
        self.visibleBtn.hidden = YES;
        self.forgetBtn.hidden = YES;
        self.smsCodeTF.hidden = NO;
        self.codeBtn.hidden = NO;
    } else {
        
        self.passwordTF.hidden = NO;
        self.visibleBtn.hidden = NO;
        self.forgetBtn.hidden = NO;
        self.smsCodeTF.hidden = YES;
        self.codeBtn.hidden = YES;
    }
    
    [self updateMasonry];
}

- (void)forgetBtnClick:(UIButton *)button
{
    GLPForgetController *vc = [GLPForgetController new];
    [self dc_pushNextController:vc];
}

- (void)protocolBtnClick:(UIButton *)button
{
    _protocolBtn.selected = !_protocolBtn.selected;
}

- (void)buttonClick:(UIButton *)button
{
    if (self.protocolBtn.selected==NO) {
        [SVProgressHUD showInfoWithStatus:@"请先阅读并同意用户协议"];
        return;
    }
    UMSocialPlatformType type = 0;
    NSInteger channel = 0;
    if (button.tag == 900) {
        type = UMSocialPlatformType_WechatSession;
        channel = 2;
    } else if (button.tag == 902) {
        type = UMSocialPlatformType_QQ;
        channel = 1;
    } else if (button.tag == 901) {
        type = UMSocialPlatformType_UserDefine_Begin;
        channel = 4;
        [self authorizationAppleID];
        return;
    }
    
    WEAKSELF;
    [[DCUMShareTool shareClient] dc_umThirdLoginWidthType:type successBlock:^(UMSocialUserInfoResponse *_Nonnull resp) {
        if (resp) {
            [weakSelf requestThirdLoginWithBlindId:resp.openid channel:channel phone:@""];
        }
    }];
}

#pragma mark- 授权苹果ID
- (void)authorizationAppleID{
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider * appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest * authAppleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        //        authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        //如果 KeyChain 里面也有登录信息的话，可以直接使用里面保存的用户名和密码进行登录。
        //        ASAuthorizationPasswordRequest * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];
        
        NSMutableArray <ASAuthorizationRequest *> * array = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [array addObject:authAppleIDRequest];
        }
        //        if (passwordRequest) {
        //            [array addObject:passwordRequest];
        //        }
        NSArray <ASAuthorizationRequest *> * requests = [array copy];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}

#pragma mark- ASAuthorizationControllerDelegate
// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString *userID = credential.user;
        [self requestThirdLoginWithBlindId:userID channel:4 phone:@""];
        
        //        //把用户的唯一标识 传给后台 判断该用户是否绑定手机号，如果绑定了直接登录，如果没绑定跳绑定手机号页面
        //        // 苹果用户信息 如果授权过，可能无法再次获取该信息
        //        NSPersonNameComponents * fullName = credential.fullName;
        //        NSString * email = credential.email;
        //
        //        // 服务器验证需要使用的参数
        //        NSString * authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        //        NSString * identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        //
        //        // 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
        //        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        //
        //        NSLog(@"userID: %@", userID);
        //        NSLog(@"fullName: %@", fullName);
        //        NSLog(@"email: %@", email);
        //        NSLog(@"authorizationCode: %@", authorizationCode);
        //        NSLog(@"identityToken: %@", identityToken);
        //        NSLog(@"realUserStatus: %@", @(realUserStatus));
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        //        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        //        // 用户登录使用现有的密码凭证
        //        ASPasswordCredential * passwordCredential = (ASPasswordCredential *)authorization.credential;
        //        // 密码凭证对象的用户标识 用户的唯一标识
        //        NSString * user = passwordCredential.user;
        //
        //        //把用户的唯一标识 传给后台 判断该用户是否绑定手机号，如果绑定了直接登录，如果没绑定跳绑定手机号页面
        //
        //        // 密码凭证对象的密码
        //        NSString * password = passwordCredential.password;
        //        NSLog(@"userID: %@", user);
        //        NSLog(@"password: %@", password);
        
    } else {
        
    }
}

// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@", errorMsg);
}

#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return self.view.window;
}

#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification{
    NSLog(@"%@", notification.userInfo);
}

- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

- (void)registerBtnClick:(id)sender
{
    GLPRegisterController *vc = [GLPRegisterController new];
    vc.phoneStr = self.phoneTF.text;
    WEAKSELF;
    vc.GLPRegisterController_block = ^(NSString * _Nonnull phoneStr) {
        weakSelf.phoneTF.text = phoneStr;
    };
    [self dc_pushNextController:vc];
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
                if ([DCCheckRegular dc_checkTelNumber:weakSelf.phoneTF.text]) {
                    [[DCAlterTool shareTool] showCustomWithTitle:@"" message:@"该手机号尚未注册，是否前往注册" customTitle1:@"注册" handler1:^(UIAlertAction * _Nonnull action) {
                        [weakSelf registerBtnClick:nil];
                    } customTitle2:@"取消" handler2:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                }else
                    [weakSelf.view makeToast:@"用户不存在,请确认账号是否正确" duration:Toast_During position:CSToastPositionBottom];

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
    [[DCAPIManager shareManager] person_RegisterProtocolsuccess:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.protocolArray addObjectsFromArray:response];
            
            weakSelf.protocolLabel.attributedText = [weakSelf dc_attributeStr];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 第三方授权登录
- (void)requestThirdLoginWithBlindId:(NSString *)blindId channel:(NSInteger)channel phone:(NSString *)phone
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestThirdLogoutWithBlindId:blindId channel:channel success:^(id response) {
        
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = response;
            if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
                
                NSDictionary *dic= dict[@"data"];
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
                    [weakSelf verification_Huanxin_LoginAfter:dic phone:@""];
                } failBlock:^{
                    [weakSelf verification_Huanxin_LoginAfter:dic phone:@""];
                }];
            }
            else {
                GLPBindController *vc = [GLPBindController new];
                vc.thirdLoginId = blindId;
                vc.thirdType = channel;
                vc.phone = phone;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
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
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"登录即表示同意%@",protocolStr]];
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
    
    self.navigationItem.title = @"登录";
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    
    _logoImage = [[UIImageView alloc] init];
    _logoImage.image = [UIImage imageNamed:@"logo"];
    [_scrollView addSubview:_logoImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#191919"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:20];
    _titleLabel.text = @"登录金利达";
    [_scrollView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#787878"];
    _subLabel.font = [UIFont fontWithName:PFR size:16];
    _subLabel.text = @"登录后体验更多功能";
    [_scrollView addSubview:_subLabel];
    
    _phoneTF = [[DCTextField alloc] init];
    _phoneTF.type = DCTextFieldTypeUserName;
    _phoneTF.placeholder = @"请输入手机号码或用户名";
    _phoneTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _phoneTF.font = PFRFont(14);
    _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    [_phoneTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EBEBEB"] radius:2];
    [_scrollView addSubview:_phoneTF];
    
    //    _phoneView = [[UIView alloc] init];
    //    _phoneView.backgroundColor = [UIColor dc_colorWithHexString:@"#FAFAFA"];
    //    _phoneView.bounds = CGRectMake(0, 0, 66, 50);
    //    [_phoneView dc_cornerRadius:3 rectCorner:UIRectCornerTopLeft|UIRectCornerBottomLeft ];
    //    [_scrollView addSubview:_phoneView];
    
    //    _phoneLabel = [[UILabel alloc] init];
    //    _phoneLabel.textColor = [UIColor dc_colorWithHexString:@"#7A7A7A"];
    //    _phoneLabel.font = PFRFont(14);
    //    _phoneLabel.text = @"+ 86";
    //    _phoneLabel.hidden = YES;
    //    [_phoneView addSubview:_phoneLabel];
    //
    //    _phoneImage = [[UIImageView alloc] init];
    //    _phoneImage.hidden = YES;
    //    _phoneImage.image = [UIImage imageNamed:@"dc_arrow_down_hui"];
    //    [_phoneView addSubview:_phoneImage];
    
    _passwordTF = [[DCTextField alloc] init];
    _passwordTF.type = DCTextFieldTypePassWord;
    _passwordTF.placeholder = @"输入密码";
    _passwordTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _passwordTF.font = PFRFont(14);
    _passwordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    [_passwordTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EBEBEB"] radius:2];
    [_scrollView addSubview:_passwordTF];

    _visibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_visibleBtn setImage:[UIImage imageNamed:@"dc_pwd_noVisible"] forState:UIControlStateNormal];
    [_visibleBtn setImage:[UIImage imageNamed:@"dc_pwd_visible"] forState:UIControlStateSelected];
    [_visibleBtn addTarget:self action:@selector(visibleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_visibleBtn];
    
    _smsCodeTF = [[DCTextField alloc] init];
    _smsCodeTF.type = DCTextFieldTypeCount;
    _smsCodeTF.placeholder = @"输入验证码";
    _smsCodeTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _smsCodeTF.font = PFRFont(14);
    _smsCodeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    _smsCodeTF.leftViewMode = UITextFieldViewModeAlways;
    [_smsCodeTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EBEBEB"] radius:2];
    _smsCodeTF.hidden = YES;
    [_scrollView addSubview:_smsCodeTF];
    _smsCodeTF.clearButtonMode = UITextFieldViewModeNever;
    
    _codeBtn = [[DCCodeButton alloc] init];
    _codeBtn.delegate = self;
    [_codeBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:0];
    _codeBtn.titleLabel.font = PFRFont(14);
    _codeBtn.hidden = YES;
    [_scrollView addSubview:_codeBtn];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#02A299"];
    [_loginBtn setTitle:@"登录" forState:0];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    _loginBtn.titleLabel.font = PFRFont(15);
    [_loginBtn dc_cornerRadius:3];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_loginBtn];
    
    _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_protocolBtn setImage:[UIImage imageNamed:@"xuanz"] forState:0];
    [_protocolBtn setImage:[UIImage imageNamed:@"tongyi"] forState:UIControlStateSelected];
    _protocolBtn.adjustsImageWhenHighlighted = NO;
    [_protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (![DCObjectManager dc_readUserDataForKey:DC_IsFirstOpen_Key]) {
        _protocolBtn.selected = NO;
    }else
        _protocolBtn.selected = YES;
    
    [_scrollView addSubview:_protocolBtn];
    
    _protocolLabel = [[UILabel alloc] init];
    _protocolLabel.textColor = [UIColor dc_colorWithHexString:@"#7A7A7A"];
    _protocolLabel.font = PFRFont(11);
    _protocolLabel.attributedText = [self dc_attributeStr];
    _protocolLabel.numberOfLines = 0;
    _protocolLabel.userInteractionEnabled = YES;
    [_scrollView addSubview:_protocolLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolAction:)];
    [_protocolLabel addGestureRecognizer:tap];
    
    _exchageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exchageBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
    [_exchageBtn setTitle:@"密码登录" forState:UIControlStateSelected];
    [_exchageBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:0];
    _exchageBtn.titleLabel.font = PFRFont(14);
    _exchageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_exchageBtn addTarget:self action:@selector(exchageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_exchageBtn];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetBtn setTitle:@"忘记密码？" forState:0];
    [_forgetBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:0];
    _forgetBtn.titleLabel.font = PFRFont(14);
    _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_forgetBtn];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:@"#D8D8D8"];
    [_scrollView addSubview:_line];
    
    _typelabel = [[UILabel alloc] init];
    _typelabel.backgroundColor = [UIColor whiteColor];
    _typelabel.textColor = [UIColor dc_colorWithHexString:@"#6E777E"];
    _typelabel.font = PFRFont(12);
    _typelabel.textAlignment = NSTextAlignmentCenter;
    _typelabel.text = @"其他方式登录";
    [_scrollView addSubview:_typelabel];
    
    _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_wechatBtn setTitle:@"微信" forState:0];
    //[_wechatBtn setTitleColor:[UIColor dc_colorWithHexString:@"#2E3133"] forState:0];
    //_wechatBtn.titleLabel.font = PFRFont(12);
    [_wechatBtn setImage:[UIImage imageNamed:@"weixinLogin_color"] forState:0];
    //_wechatBtn.adjustsImageWhenHighlighted = NO;
    _wechatBtn.tag = 900;
    [_wechatBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _wechatBtn.bounds = CGRectMake(0, 0, Buttom_W, Buttom_W);
    //[_wechatBtn dc_buttonIconTopWithSpacing:10];
    [_scrollView addSubview:_wechatBtn];
    
    _appleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_appleBtn setTitle:@"苹果" forState:0];
    //[_appleBtn setTitleColor:[UIColor dc_colorWithHexString:@"#2E3133"] forState:0];
    //_appleBtn.titleLabel.font = PFRFont(12);
    [_appleBtn setImage:[UIImage imageNamed:@"appleLogin"] forState:0];
    //_appleBtn.adjustsImageWhenHighlighted = NO;
    _appleBtn.tag = 901;
    [_appleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _appleBtn.bounds = CGRectMake(0, 0, Buttom_W, Buttom_W);
    //[_appleBtn dc_buttonIconTopWithSpacing:10];
    [_scrollView addSubview:_appleBtn];
    
    _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_qqBtn setTitle:@"QQ" forState:0];
    //[_qqBtn setTitleColor:[UIColor dc_colorWithHexString:@"#2E3133"] forState:0];
    //_qqBtn.titleLabel.font = PFRFont(12);
    [_qqBtn setImage:[UIImage imageNamed:@"QQLogin_color"] forState:0];
    //_qqBtn.adjustsImageWhenHighlighted = NO;
    _qqBtn.tag = 902;
    [_qqBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _qqBtn.bounds = CGRectMake(0, 0, Buttom_W, Buttom_W);
    //[_qqBtn dc_buttonIconTopWithSpacing:10];
    [_scrollView addSubview:_qqBtn];
    
    
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
        make.size.equalTo(CGSizeMake(8, 8));
    }];
//    _typelabel.hidden = YES;
//    _qqBtn.hidden = YES;
//    _appleBtn.hidden = YES;
//    _wechatBtn.hidden = YES;
    if (@available(iOS 13.0, *)) {
        self.appleBtn.hidden = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    } else {
        self.appleBtn.hidden = YES;
    }
    [self updateMasonry];
    //[self requstThird];
}


#pragma mark - updateMasonry
- (void)updateMasonry
{
    if (self.exchageBtn.selected) {
        _phoneTF.placeholder = @"请输入手机号码";
        _phoneTF.text = [DCCheckRegular dc_checkTelNumber:_phoneTF.text] ? _phoneTF.text : @"";
        [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneTF.left).offset(1);
            make.top.equalTo(self.phoneTF.top).offset(1);
            make.bottom.equalTo(self.phoneTF.bottom).offset(-1);
            make.width.equalTo(66);
        }];
        
        [_smsCodeTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneTF.left);
            make.right.equalTo(self.phoneTF.right);
            make.top.equalTo(self.phoneTF.bottom).offset(20);
            make.height.equalTo(50);
        }];
        
        [_codeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.smsCodeTF.right).offset(-5);
            make.top.equalTo(self.smsCodeTF.top).offset(1);
            make.bottom.equalTo(self.smsCodeTF.bottom).offset(-1);
            make.width.equalTo(100);
        }];
        
        [_exchageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneTF.left);
            make.top.equalTo(self.codeBtn.bottom).offset(15);
            make.size.equalTo(CGSizeMake(100, 30));
        }];
        
        [_loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneTF.left);
            make.right.equalTo(self.phoneTF.right);
            make.top.equalTo(self.exchageBtn.bottom).offset(30);
            make.height.equalTo(50);
        }];
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginBtn.bottom).offset(60);
            make.left.equalTo(self.phoneTF.left).offset(12);
            make.right.equalTo(self.phoneTF.right).offset(-12);
            make.height.equalTo(1);
        }];
        
        [_typelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.line.centerY);
            make.centerX.equalTo(self.line.centerX);
            make.size.equalTo(CGSizeMake(100, 20));
        }];
        
        //        [_qqBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.equalTo(self.loginBtn.centerX);
        //            make.top.equalTo(self.line.bottom).offset(20);
        //            make.size.equalTo(CGSizeMake(70, 70));
        //        }];
        
        [_appleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.loginBtn.centerX);
            make.top.equalTo(self.line.bottom).offset(20);
            make.size.equalTo(CGSizeMake(Buttom_W, Buttom_W));
        }];
        
        [_wechatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.appleBtn.centerY);
            make.right.equalTo(self.appleBtn.left).offset(-50);
            make.size.equalTo(CGSizeMake(Buttom_W, Buttom_W));
        }];
        
        [_qqBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.appleBtn.centerY);
            make.left.equalTo(self.appleBtn.right).offset(50);
            make.size.equalTo(CGSizeMake(Buttom_W, Buttom_W));
        }];
        
        [_protocolLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.loginBtn.centerX).offset(10);
            make.top.equalTo(self.qqBtn.bottom).offset(40);
            make.bottom.equalTo(self.scrollView.bottom).offset(-30);
        }];
        
        [_protocolBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qqBtn.bottom).offset(33);
            make.right.equalTo(self.protocolLabel.left).offset(-10);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        
        
    } else {
        _phoneTF.placeholder = @"请输入手机号码或用户名";
        [_phoneView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneTF.left).offset(1);
            make.top.equalTo(self.phoneTF.top).offset(1);
            make.bottom.equalTo(self.phoneTF.bottom).offset(-1);
            make.width.equalTo(0);
        }];
        
        
        [_passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.subLabel.left);
            make.right.equalTo(self.subLabel.right);
            make.top.equalTo(self.phoneTF.bottom).offset(20);
            make.height.equalTo(50);
        }];
        
        [_visibleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.passwordTF.right).offset(-15);
            make.centerY.equalTo(self.passwordTF.centerY);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        
        [_exchageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneTF.left);
            make.top.equalTo(self.passwordTF.bottom).offset(15);
            make.size.equalTo(CGSizeMake(100, 30));
        }];
        
        [_forgetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.exchageBtn.centerY);
            make.right.equalTo(self.phoneTF.right);
            make.size.equalTo(CGSizeMake(100, 30));
        }];
        
        [_loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneTF.left);
            make.right.equalTo(self.phoneTF.right);
            make.top.equalTo(self.exchageBtn.bottom).offset(30);
            make.height.equalTo(50);
        }];
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginBtn.bottom).offset(60);
            make.left.equalTo(self.phoneTF.left).offset(12);
            make.right.equalTo(self.phoneTF.right).offset(-12);
            make.height.equalTo(1);
        }];
        
        [_typelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.line.centerY);
            make.centerX.equalTo(self.line.centerX);
            make.size.equalTo(CGSizeMake(100, 20));
        }];
        
        //        [_qqBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.equalTo(self.loginBtn.centerX);
        //            make.top.equalTo(self.line.bottom).offset(20);
        //            make.size.equalTo(CGSizeMake(70, 70));
        //        }];
        
        [_appleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.loginBtn.centerX);
            make.top.equalTo(self.line.bottom).offset(20);
            make.size.equalTo(CGSizeMake(Buttom_W, Buttom_W));
        }];
        
        [_wechatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.appleBtn.centerY);
            make.right.equalTo(self.appleBtn.left).offset(-50);
            make.size.equalTo(CGSizeMake(Buttom_W, Buttom_W));
        }];
        
        [_qqBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.appleBtn.centerY);
            make.left.equalTo(self.appleBtn.right).offset(50);
            make.size.equalTo(CGSizeMake(Buttom_W, Buttom_W));
        }];
        
        [_protocolLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.loginBtn.centerX).offset(10);
            make.top.equalTo(self.qqBtn.bottom).offset(40);
            make.bottom.equalTo(self.scrollView.bottom).offset(-30);
        }];
        
        [_protocolBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qqBtn.bottom).offset(33);
            make.right.equalTo(self.protocolLabel.left).offset(-10);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
    }
    
    //    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.subLabel.left);
    //        make.right.equalTo(self.subLabel.right);
    //        make.top.equalTo(self.phoneTF.bottom).offset(20);
    //        make.height.equalTo(50);
    //    }];
    //
    //    [_aginTF mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.subLabel.left);
    //        make.right.equalTo(self.subLabel.right);
    //        make.top.equalTo(self.passwordTF.bottom).offset(20);
    //        make.height.equalTo(50);
    //    }];
    //
    //    [_numCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.subLabel.left);
    //        make.right.equalTo(self.subLabel.right);
    //        make.top.equalTo(self.aginTF.bottom).offset(20);
    //        make.height.equalTo(50);
    //    }];
    //
    //    [_numImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.numCodeTF.top);
    //        make.right.equalTo(self.numCodeTF.right);
    //        make.bottom.equalTo(self.numCodeTF.bottom);
    //        make.width.equalTo(80);
    //    }];
    //
    //    [_smsCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.subLabel.left);
    //        make.right.equalTo(self.subLabel.right);
    //        make.top.equalTo(self.numCodeTF.bottom).offset(20);
    //        make.height.equalTo(50);
    //    }];
    //
    //    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.smsCodeTF.right);
    //        make.top.equalTo(self.smsCodeTF.top);
    //        make.bottom.equalTo(self.smsCodeTF.bottom);
    //        make.width.equalTo(100);
    //    }];
    //
    //    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.subLabel.left);
    //        make.right.equalTo(self.subLabel.right);
    //        make.top.equalTo(self.smsCodeTF.bottom).offset(84);
    //        make.height.equalTo(50);
    //    }];
    //
    //    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.registerBtn.centerX).offset(10);
    //        make.top.equalTo(self.registerBtn.bottom).offset(70);
    //        make.height.equalTo(30);
    //        make.bottom.equalTo(self.scrollView.bottom).offset(30);
    //    }];
    //
    //    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.protocolLabel.centerY);
    //        make.right.equalTo(self.protocolLabel.left).offset(-10);
    //        make.size.equalTo(CGSizeMake(30, 30));
    //    }];
}

- (void)requstThird{
    MJWeakSelf
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/thirdLogin" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSString *st = dict[@"data"];
        
        if ([st isKindOfClass:[NSString class]]) {
            if ([st integerValue] ==1) {
                weakSelf.typelabel.hidden = NO;
                weakSelf.qqBtn.hidden = NO;
                weakSelf.wechatBtn.hidden = NO;
                // 手机系统版本 不支持 时 隐藏苹果登录按钮
                if (@available(iOS 13.0, *)) {
                    weakSelf.appleBtn.hidden = NO;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
                } else {
                    weakSelf.appleBtn.hidden = YES;
                }
            }else{
                weakSelf.typelabel.hidden = YES;
                weakSelf.qqBtn.hidden = YES;
                weakSelf.appleBtn.hidden = YES;
                weakSelf.wechatBtn.hidden = YES;
            }
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
    }];
}

- (NSMutableArray<GLBProtocolModel *> *)protocolArray{
    if (!_protocolArray) {
        _protocolArray = [NSMutableArray array];
    }
    return _protocolArray;
}

@end
