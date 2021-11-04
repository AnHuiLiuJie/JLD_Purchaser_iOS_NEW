//
//  GLPPaymentPasswordVC.m
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import "GLPPaymentPasswordVC.h"
// Controllers
#import "GLPForgotPaymentPasswordVC.h"
// Models
// Views
#import "HWTFCursorView.h"
/* cell */
/* head */
/* foot */
// Vendors
// Categories
#import "DCAPIManager+Payment.h"
#import "NSTimer+eocBlockSupports.h"
// Others

@interface GLPPaymentPasswordVC ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *forgetBtn;

@property (nonatomic, strong) HWTFCursorView *passwordView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *promptLab;
@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, copy) NSString *firstPwd;//第一次输入密码
@property (nonatomic, copy) NSString *secondPwd;//再次确定密码
@property (nonatomic, assign) NSInteger errorNum;//输入密码错误次数
@property (nonatomic, assign) NSInteger limitErrorCount;//限制错误次数

//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property(nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger secondsCountDown;//倒计时总的秒数

@end

static CGFloat cell_spacing_x = 15;


@implementation GLPPaymentPasswordVC
#pragma mark - LazyLoad


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewUI];
    
    [self setBaseData];
}

#pragma mark - UI
- (void)setViewUI{
    self.title = @"支付密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_topView];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.text = @"输入协议支付密码";
    _titleLab.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    [_topView addSubview:_titleLab];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topView addSubview:_forgetBtn];
    [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetBtn setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    [_forgetBtn addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    _forgetBtn.hidden = YES;
    
    _passwordView = [[HWTFCursorView alloc] initWithCount:6 margin:20];
    _passwordView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_passwordView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_bottomView];
    
    _promptLab = [[UILabel alloc] init];
    _promptLab.font = [UIFont fontWithName:PFR size:12];
    _promptLab.textColor = [UIColor dc_colorWithHexString:@"#FF0000"];
    _promptLab.textAlignment = NSTextAlignmentLeft;
    _promptLab.numberOfLines = 0;
    [_bottomView addSubview:_promptLab];
    _promptLab.hidden = YES;
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.font = [UIFont fontWithName:PFR size:14];
    _timeLab.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_timeLab];
    _timeLab.hidden = YES;
    
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.equalTo(60);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.left).offset(cell_spacing_x);
        make.centerY.equalTo(self.topView);
    }];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.right).offset(-cell_spacing_x);
        make.centerY.equalTo(self.topView);
        make.height.equalTo(self.topView.height);
    }];
    
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(cell_spacing_x);
        make.right.equalTo(self.topView.right).offset(-cell_spacing_x);
        make.top.equalTo(self.topView.bottom).offset(5);
        make.height.equalTo(60);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.passwordView.bottom).offset(5);
    }];
    
    [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.left).offset(cell_spacing_x);
        make.right.equalTo(self.bottomView.right).offset(-cell_spacing_x);
        make.top.equalTo(self.bottomView.top).offset(5);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.promptLab.bottom).offset(20);
        make.bottom.equalTo(self.bottomView.bottom).offset(5);
    }];
    
}
#pragma mark - base
- (void)setBaseData{
    if (self.showType == PasswordFunctionTypeSite) {
        [self setSetPayPwdData];
    }else if(self.showType == PasswordFunctionTypeConfirmForSet || self.showType == PasswordFunctionTypeConfirmForVerify) {
        self.errorNum = 0;
        self.titleLab.text = @"输入协议支付密码";
        self.promptLab.hidden = NO;
        self.promptLab.text = @"请输入您在金利达设置的协议支付密码，不要输入您的银行卡密码。";
        [self requsetGetPayPwdErrorInfo];
    }
    
    WEAKSELF;
    __weak typeof(_passwordView) weakPV = _passwordView;
    _passwordView.HWTFCursorView_InputComplete_block = ^(NSString * _Nonnull password) {
        NSLog(@"输入完成：%@",password);
        if (weakSelf.showType == PasswordFunctionTypeSite) {
            if (weakSelf.firstPwd.length == 0) {
                weakSelf.firstPwd = password;
                weakPV.isResetView = YES;
                weakSelf.titleLab.text = @"确认协议支付密码";
                weakSelf.promptLab.text = @"注：该支付密码用于在金利达商城使用银行卡、余额等购物时使用的密码，请不要与银行卡密码一致！";
            }else{
                weakSelf.secondPwd = password;
                
                if ([weakSelf.firstPwd isEqualToString:weakSelf.secondPwd]) {
                    //2次都正确
                    [weakSelf requsetSetPayPwd];
                }else{
                    weakPV.isResetView = YES;
                    weakSelf.firstPwd = @"";
                    weakSelf.secondPwd = @"";
                    weakSelf.promptLab.text = @"两次支付密码不一致，请重新输入！";
                    weakSelf.titleLab.text = @"请输入协议支付密码";
                }
            }
        }else if(weakSelf.showType == PasswordFunctionTypeConfirmForSet) {
            weakSelf.firstPwd = password;
            [weakSelf requsetVerifyPayPwd];
        }else if(weakSelf.showType == PasswordFunctionTypeConfirmForVerify) {
            weakSelf.firstPwd = password;
            [weakSelf requsetVerifyPayPwd];
        }
    };
}

#pragma mark - requsetData
//设置密码
- (void)requsetSetPayPwd{
    NSString *md5Pwd = [NSString md5String:self.firstPwd];
    WEAKSELF;
    [[DCAPIManager shareManager] payment_b2c_account_pay_setPayPwdWithPassword:md5Pwd success:^(id  _Nullable response) {
        //正确
        [weakSelf.navigationController popViewControllerAnimated:YES];
        !weakSelf.GLPPaymentPasswordVC_block ? : weakSelf.GLPPaymentPasswordVC_block(md5Pwd);
    } failture:^(NSError * _Nullable error) {
        
    }];
}

//验证密码
- (void)requsetVerifyPayPwd{
    WEAKSELF;
    NSString *md5Pwd = [NSString md5String:self.firstPwd];
    [[DCAPIManager shareManager] payment_b2c_account_pay_verifyPayPwdWithPassword:md5Pwd success:^(id  _Nullable response) {
        GLPVerifyPayPwdModel *model = [GLPVerifyPayPwdModel mj_objectWithKeyValues:response[@"data"]];
        weakSelf.errorNum = [model.errorCount integerValue];
        if ([model.isRight intValue] == 1) {
            //密码输入正确
            if (weakSelf.showType == PasswordFunctionTypeConfirmForSet) {
                weakSelf.showType = PasswordFunctionTypeSite;
                [weakSelf setSetPayPwdData];
                weakSelf.passwordView.isResetView = YES;
                [weakSelf.view.window makeToast:@"操作成功" duration:Toast_During position:CSToastPositionBottom];
            }else if(weakSelf.showType == PasswordFunctionTypeConfirmForVerify){
                [weakSelf.navigationController popViewControllerAnimated:YES];
                !weakSelf.GLPPaymentPasswordVC_block ? : weakSelf.GLPPaymentPasswordVC_block(md5Pwd);
            }
        }else{
            weakSelf.passwordView.isResetView = YES;
            if (weakSelf.errorNum == 1) {
                weakSelf.promptLab.hidden = NO;
                weakSelf.promptLab.text = @"支付付密码错误，请重新输入!";
            }else if(weakSelf.errorNum == 2){
                weakSelf.promptLab.text = @"您已连续两次支付密码输入错误，第三次输入错误将被锁定6小时无法使用支付密码！";
            }else if(weakSelf.errorNum == 3){
                weakSelf.promptLab.text = @"由于您连续三次输入密码错误，支付功能已被锁定，你可以在倒计时结束后再尝试，或者使用微信和支付宝进行支付！";
            }
            if (model.ts.length > 0) {
                weakSelf.promptLab.text =  model.ts;
            }
            if (weakSelf.errorNum == weakSelf.limitErrorCount) {
                weakSelf.passwordView.userInteractionEnabled = NO;
                //限制
                if (model.errorTime.length > 0) {
                    weakSelf.timeLab.hidden = NO;
                    //weakSelf.timeLab.text = model.errorTime;
                    [weakSelf startTriggerTimer:model.errorTime];
                }
            }
        }
    } failture:^(NSError * _Nullable error) {
        
    }];
}

//校验是否能继续进行密码操作 仅限于输入密码
- (void)requsetGetPayPwdErrorInfo{
    WEAKSELF;
    [[DCAPIManager shareManager] payment_b2c_account_pay_getPayPwdErrorInfoWithSuccess:^(id  _Nullable response) {
        GLPVerifyPayPwdModel *model = [GLPVerifyPayPwdModel mj_objectWithKeyValues:response[@"data"]];
        weakSelf.errorNum = [model.errorCount integerValue];
        weakSelf.limitErrorCount = [model.limitErrorCount integerValue];
        if (weakSelf.errorNum == weakSelf.limitErrorCount) {
            weakSelf.passwordView.userInteractionEnabled = NO;
            //限制
            if (model.errorTime.length > 0) {
                weakSelf.timeLab.hidden = NO;
                //weakSelf.timeLab.text = model.errorTime;
                [weakSelf startTriggerTimer:model.errorTime];
            }
        }
        if (model.ts.length > 0) {
            weakSelf.promptLab.hidden = NO;
            weakSelf.promptLab.text =  model.ts;
        }
        
    } failture:^(NSError * _Nullable error) {
        
    }];
}

- (void)setSetPayPwdData{
    self.firstPwd = @"";
    self.secondPwd = @"";
    self.promptLab.hidden = NO;
    self.titleLab.text = @"设置协议支付密码";
    self.promptLab.text = @"注：该支付密码用于在金利达商城使用银行卡、余额等购物时使用的密码，请不要与银行卡密码一致！";
}

- (void)startTriggerTimer:(NSString *)startTime{
    self.secondsCountDown = 6*3600-(NSInteger) [DCSpeedy getTotalTimeForIntWithStartTime:startTime endTime:[DCSpeedy getNowTimeTimesForm:@"yyyy-MM-dd HH:mm:ss"]];
    //设置定时器
    __weak typeof(self)weakSelf = self;
     self.countDownTimer = [NSTimer eocScheduledTimerWithTimeInterval:1.0 block:^{
         [weakSelf countDownAction];
     } repeats:YES];

    //启动倒计时后会每秒钟调用一次方法 countDownAction

    //设置倒计时显示的时间
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    self.timeLab.text = [NSString stringWithFormat:@"倒计时   %@",format_time];
    //设置文字颜色
    self.timeLab.textColor = [UIColor  blackColor];
}

//实现倒计时动作
- (void)countDownAction{
    //倒计时-1
    self.secondsCountDown--;
    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.secondsCountDown/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    self.timeLab.text = [NSString stringWithFormat:@"倒计时   %@",format_time];
    //当倒计时到0时做需要的操作，
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        self.passwordView.userInteractionEnabled = YES;
    }
}

#pragma mark - private method
- (void)forgetPasswordAction:(UIButton *)button{
    GLPForgotPaymentPasswordVC *vc = [[GLPForgotPaymentPasswordVC alloc] init];
    [self dc_pushNextController:vc];
}


- (void)dealloc{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
