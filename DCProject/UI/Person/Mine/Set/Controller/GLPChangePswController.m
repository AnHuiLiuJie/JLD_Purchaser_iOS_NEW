//
//  GLPChangePswController.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPChangePswController.h"
#import "DCTextField.h"
#import "GLPLoginController.h"
#import "DCNavigationController.h"
@interface GLPChangePswController ()

@property (nonatomic, strong) DCTextField *oldTF;
@property (nonatomic, strong) DCTextField *pswTF;
@property (nonatomic, strong) DCTextField *againTF;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;
@property (nonatomic, strong) UIImageView *line3;
@property (nonatomic, strong) UIButton *commintBtn;

@end

@implementation GLPChangePswController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"修改登录密码";
    
    [self setUpUI];
}


- (void)setUpUI
{
    _oldTF = [[DCTextField alloc] init];
    _oldTF.frame = CGRectMake(0, kNavBarHeight + 5, kScreenW, 54);
    _oldTF.backgroundColor = [UIColor whiteColor];
    _oldTF.type = DCTextFieldTypePassWord;
    _oldTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _oldTF.font = PFRFont(15);
    _oldTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"请输入旧密码"];
    _oldTF.leftViewMode = UITextFieldViewModeAlways;
    _oldTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self.view addSubview:_oldTF];
    
    _line1 = [[UIImageView alloc] init];
    _line1.frame = CGRectMake(0, CGRectGetMaxY(_oldTF.frame), kScreenW, 1);
    _line1.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.view addSubview:_line1];
    
    _pswTF = [[DCTextField alloc] init];
    _pswTF.frame = CGRectMake(0, CGRectGetMaxY(_line1.frame), kScreenW, 54);
    _pswTF.backgroundColor = [UIColor whiteColor];
    _pswTF.type = DCTextFieldTypePassWord;
    _pswTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _pswTF.font = PFRFont(15);
    _pswTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"请输入新密码"];
    _pswTF.leftViewMode = UITextFieldViewModeAlways;
    _pswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self.view addSubview:_pswTF];
    
    _line2 = [[UIImageView alloc] init];
    _line2.frame = CGRectMake(0, CGRectGetMaxY(_pswTF.frame), kScreenW, 1);
    _line2.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.view addSubview:_line2];
    
    _againTF = [[DCTextField alloc] init];
    _againTF.frame = CGRectMake(0, CGRectGetMaxY(_line2.frame), kScreenW, 54);
    _againTF.backgroundColor = [UIColor whiteColor];
    _againTF.type = DCTextFieldTypePassWord;
    _againTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _againTF.font = PFRFont(15);
    _againTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"请再次输入新密码"];
    _againTF.leftViewMode = UITextFieldViewModeAlways;
    _againTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self.view addSubview:_againTF];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commintBtn.frame = CGRectMake(30, CGRectGetMaxY(_againTF.frame)+30, kScreenW - 60, 50);
    _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#02A299"];
    [_commintBtn setTitle:@"提交" forState:0];
    [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
    _commintBtn.titleLabel.font = PFRFont(15);
    [_commintBtn dc_cornerRadius:25];
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commintBtn];
    
}


#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    if (self.oldTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入旧密码"];
        return;
    }
    if (self.pswTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入新密码"];
        return;
    }
    if (self.againTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请确认新密码"];
        return;
    }
    if (![self.pswTF.text isEqualToString:self.againTF.text])
    {
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不同"];
        return;
    }
    [[DCAPIManager shareManager]person_changePwdWitholdPwd:self.oldTF.text newPwd:self.againTF.text success:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:@"修改成功，请重新登录"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[DCAPIManager shareManager] person_requestLogoutWithSuccess:^(id response) {
                [[DCLoginTool shareTool] dc_logoutWithPerson];
            } failture:^(NSError *_Nullable error) {
    }];
            
        });
        
    } failture:^(NSError *error) {
        
    }];
}


@end
