//
//  DCLoginController.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCLoginController.h"
#import "DCTextField.h"

#import "GLBProtocolModel.h"

#import "GLBRegisterController.h"
#import "GLBForgetController.h"
#import "DCTabbarController.h"

#import "GLBRegisterNextController.h"

/*Add_环信_标识
 *
 */
#import "AppDelegate+HelpDesk.h"
//#import "ChatDemoHelper.h"

@interface DCLoginController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DCTextField *mobileTF;
@property (nonatomic, strong) UIImageView *mobileLine;
@property (nonatomic, strong) DCTextField *passworldTF;
@property (nonatomic, strong) UIImageView *passworldLine;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) NSMutableArray<GLBProtocolModel *> *protocolArray;

@end

@implementation DCLoginController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isPresent) {
        [self dc_navBarHidden:YES];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isPresent) {
        [self dc_navBarHidden:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_isPresent) {
        [self.view addSubview:self.backBtn];
    }
    
    [self setUpUI];
    
//    [self dc_pushNextController:[GLBRegisterNextController new]];

//    self.mobileTF.text = @"ldy123";
//    self.passworldTF.text = @"a111111";
    
//    self.mobileTF.text = @"A111111a";
//    self.passworldTF.text = @"a111111";
    
    [self requestRegisterProtocol];
    
    self.mobileTF.text = [DCObjectManager dc_readUserDataForKey:DC_Company_loginName_Key];
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


#pragma mark - action
- (void)showBtnClick:(UIButton *)button
{
    button.selected =! button.selected;
    
    self.passworldTF.secureTextEntry =! button.selected;
}

- (void)registerBtnClick:(UIButton *)button
{
    [self dc_pushNextController:[GLBRegisterController new]];
}

- (void)loginBtnClick:(UIButton *)button
{
    if (self.mobileTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名或密码"];
        return;
    }
    
    if (self.passworldTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入登录密码"];
        return;
    }
    
    [self requestLogin];
}

- (void)forgetBtnClick:(UIButton *)button
{
    [self dc_pushNextController:[GLBForgetController new]];
}

- (void)backBtnClick:(UIButton *)button
{
    if (_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)protocolAction:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.protocolLabel];;
    
    if (point.y < 19) { // 第一个
        
        if (self.protocolArray.count > 0) {
            NSString *name = [self.protocolArray[0] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > (kScreenW/2 - 50) && point.x <((kScreenW/2 - 50)+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[0] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[0] api]];
                [self dc_pushWebController:@"/public/agree.html" params:params];
            }
        }
        
        
        
    } else if (point.y >= 19 && point.y < 38){ // 第二个
        
        if (self.protocolArray.count > 1) {
            NSString *name = [self.protocolArray[1] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > (kScreenW - size.width)/2  && point.x <((kScreenW - size.width)/2+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[1] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[1] api]];
                [self dc_pushWebController:@"/public/agree.html" params:params];
            }
        }
        
    } else if (point.y >= 38 && point.y < 57){ // 第三个
        
        if (self.protocolArray.count > 2) {
            NSString *name = [self.protocolArray[2] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > (kScreenW - size.width)/2 && point.x <((kScreenW - size.width)/2+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[2] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[2] api]];
                [self dc_pushWebController:@"/public/agree.html" params:params];
            }
        }
    }
}


#pragma mark - 请求 登录
- (void)requestLogin
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestPsdLoginWithLoginName:self.mobileTF.text loginPwd:self.passworldTF.text userType:@"1" success:^(id response) {
        
        if (response) {
            NSDictionary *dic = response[@"data"];
            NSString *alias = [NSString stringWithFormat:@"jld_enterprise_%@",dic[@"userId"]];
            // 设置推送别名
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"设置推送别名回调 - rescode: %ld, \nseq: %ld, \nalias: %@\n", (long)iResCode, (long)seq , iAlias);
            } seq:0];
            
            [JPUSHService setTags:[NSSet setWithObject:@"jld_enterprise"]completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            } seq:0];
            
            /*Add_HX_标识
             *登录环信
             */
            [DC_Appdelegate huanxinLogin:nil successBlock:^{
                
//                HDPushOptions *options = [[HDClient sharedClient] hdPushOptions];
//                options.displayStyle = HDPushDisplayStyleMessageSummary;
//                options.displayName = [[HDClient sharedClient] hdPushOptions].displayName;
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [DCObjectManager dc_saveUserData:weakSelf.mobileTF.text forKey:DC_Company_loginName_Key];
                
                NSString *logoImg = @"";
                if (dic && dic[@"logoImg"]) {
                    logoImg = dic[@"logoImg"];
                }
                
                [DCObjectManager dc_saveUserData:weakSelf.mobileTF.text forKey:DC_UserName_Key];
                [DCObjectManager dc_saveUserData:logoImg forKey:DC_UserImage_Key];
                
                //[DCObjectManager dc_saveUserData:@"https://img0.123ypw.com/icon/ad/ad3c0ddff.jpg" forKey:DC_UserImage_Key];
                    
                NSDictionary *userInfo = @{@"userId":[NSString stringWithFormat:@"b2b_%@",[DCObjectManager dc_readUserDataForKey:DC_UserID_Key]],@"headImg":[NSString stringWithFormat:@"%@",logoImg]};
                [[DCUpdateTool shareClient] updateEaseUser:userInfo];
                
                if (weakSelf.isPresent) {
                    if (weakSelf.successBlock) {
                        weakSelf.successBlock();
                    }
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        DCTabbarController *tabbarVC = [[DCTabbarController alloc] init];
                        DC_KeyWindow.rootViewController = tabbarVC;
//                        [CSDemoAccountManager shareLoginManager].homeVC1 = tabbarVC;
//                        [CSDemoAccountManager shareLoginManager].homeVC = nil;
                    });
                }
            } failBlock:^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [DCObjectManager dc_saveUserData:weakSelf.mobileTF.text forKey:DC_Company_loginName_Key];
                
                NSString *logoImg = @"";
                if (dic && dic[@"logoImg"]) {
                    logoImg = dic[@"logoImg"];
                }
                
                [DCObjectManager dc_saveUserData:weakSelf.mobileTF.text forKey:DC_UserName_Key];
                [DCObjectManager dc_saveUserData:logoImg forKey:DC_UserImage_Key];
                
                //[DCObjectManager dc_saveUserData:@"https://img0.123ypw.com/icon/ad/ad3c0ddff.jpg" forKey:DC_UserImage_Key];
                    
                NSDictionary *userInfo = @{@"userId":[NSString stringWithFormat:@"b2b_%@",[DCObjectManager dc_readUserDataForKey:DC_UserID_Key]],@"headImg":[NSString stringWithFormat:@"%@",logoImg]};
                [[DCUpdateTool shareClient] updateEaseUser:userInfo];
                
                if (weakSelf.isPresent) {
                    if (weakSelf.successBlock) {
                        weakSelf.successBlock();
                    }
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        DCTabbarController *tabbarVC = [[DCTabbarController alloc] init];
                        DC_KeyWindow.rootViewController = tabbarVC;
//                        [CSDemoAccountManager shareLoginManager].homeVC1 = tabbarVC;
//                        [CSDemoAccountManager shareLoginManager].homeVC = nil;
                    });
                }
            }];
        }
        
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - 请求 获取注册协议
- (void)requestRegisterProtocol
{
    [self.protocolArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestRegisterProtocolWithSuccess:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.protocolArray addObjectsFromArray:response];
            
            weakSelf.protocolLabel.attributedText = [weakSelf dc_attributeStr];
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
    _titleLabel.text = @"企业用户登录";
    [self.view addSubview:_titleLabel];
    
    _mobileTF = [[DCTextField alloc] init];
    _mobileTF.type = DCTextFieldTypeDefault;
    _mobileTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _mobileTF.font = PFRFont(16);
    _mobileTF.placeholder = @"请输入用户名或手机号";
    [self.view addSubview:_mobileTF];
    
    _mobileLine = [[UIImageView alloc] init];
    _mobileLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_mobileLine];
    
    _passworldTF = [[DCTextField alloc] init];
    _passworldTF.type = DCTextFieldTypePassWord;
    _passworldTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _passworldTF.font = PFRFont(16);
    _passworldTF.placeholder = @"输入登录密码";
    [self.view addSubview:_passworldTF];
    
    _passworldLine = [[UIImageView alloc] init];
    _passworldLine.backgroundColor = [UIColor dc_colorWithHexString:@"#EDEDED"];
    [self.view addSubview:_passworldLine];
    
    _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showBtn setImage:[UIImage imageNamed:@"dc_pwd_noVisible"] forState:0];
    [_showBtn setImage:[UIImage imageNamed:@"dc_pwd_visible"] forState:UIControlStateSelected];
    _showBtn.adjustsImageWhenHighlighted = NO;
    [_showBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showBtn];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetBtn setTitle:@"忘记密码" forState:0];
    [_forgetBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _forgetBtn.titleLabel.font = PFRFont(12);
    _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetBtn];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_loginBtn setTitle:@"登录" forState:0];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    _loginBtn.titleLabel.font = PFRFont(16);
    [_loginBtn dc_cornerRadius:22];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"注册" forState:0];
    [_registerBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _registerBtn.titleLabel.font = PFRFont(16);
    [_registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    _protocolLabel = [[UILabel alloc] init];
    _protocolLabel.font = PFRFont(12);
    _protocolLabel.textAlignment = NSTextAlignmentCenter;
    _protocolLabel.numberOfLines = 0;
    _protocolLabel.attributedText = [self dc_attributeStr];
    _protocolLabel.userInteractionEnabled = YES;
    [self.view addSubview:_protocolLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolAction:)];
    [_protocolLabel addGestureRecognizer:tap];
    
    
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
    
    [_passworldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileTF.left);
        make.right.equalTo(self.mobileTF.right);
        make.top.equalTo(self.mobileTF.bottom).offset(10);
        make.height.equalTo(self.mobileTF.height);
    }];
    
    [_passworldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileLine.left);
        make.right.equalTo(self.mobileLine.right);
        make.bottom.equalTo(self.passworldTF.bottom).offset(-5);
        make.height.equalTo(1);
    }];
    
    [_showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passworldTF.centerY);
        make.right.equalTo(self.passworldLine.right);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passworldLine.right);
        make.top.equalTo(self.passworldTF.bottom).offset(5);
        make.size.equalTo(CGSizeMake(80, 35));
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(self.passworldTF.bottom).offset(130);
        make.height.equalTo(44);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn.left);
        make.right.equalTo(self.loginBtn.right);
        make.top.equalTo(self.loginBtn.bottom).offset(10);
        make.height.equalTo(44);
    }];
    
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.bottom.equalTo(self.view.bottom).offset(-15);
    }];
}


#pragma mark - lazy load
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(5, kStatusBarHeight, 44, 44);
        [_backBtn setImage:[UIImage imageNamed:@"dc_fanhui_hei"] forState:0];
        _backBtn.adjustsImageWhenHighlighted = NO;
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (NSMutableArray<GLBProtocolModel *> *)protocolArray{
    if (!_protocolArray) {
        _protocolArray = [NSMutableArray array];
    }
    return _protocolArray;
}

@end
