//
//  GLBRegisterController.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRegisterController.h"
#import "DCTextField.h"
#import "DCCodeButton.h"

#import "GLBProtocolModel.h"

#import "GLBRegisterNextController.h"

@interface GLBRegisterController ()<DCCodeButtonDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DCTextField *mobileTF;
@property (nonatomic, strong) UIImageView *mobileLine;
@property (nonatomic, strong) DCTextField *imageCodeTF;
@property (nonatomic, strong) UIImageView *imageCodeLine;
@property (nonatomic, strong) UIImageView *codeImage;
@property (nonatomic, strong) DCTextField *smsCodeTF;
@property (nonatomic, strong) UIImageView *smsCodeLine;
@property (nonatomic, strong) DCCodeButton *codeBtn;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSMutableArray<GLBProtocolModel *> *protocolArray;

@end

@implementation GLBRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUpUI];
    
    [self requestImageCode];
    [self requestRegisterProtocol];
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
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"阅读并同意%@",protocolStr]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 5)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(5, attrStr.length - 5)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentLeft;
    [attrStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attrStr.length)];
    
    return attrStr;
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
        [SVProgressHUD showInfoWithStatus:@"请输入计算结果"];
        return;
    }
    
    if (self.smsCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机验证码"];
        return;
    }
    
    [self requestCheckSMSCode];
}

- (void)imageTapAction:(id)sender
{
    [self requestImageCode];
}

- (void)protocolAction:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.protocolLabel];
    
    if (point.y < 19) { // 第一个

        if (self.protocolArray.count > 0) {
            NSString *name = [self.protocolArray[0] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > 60 && point.x <(60+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[0] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[0] api]];
                [self dc_pushWebController:@"/public/agree.html" params:params];
            }
        }
        
        

    } else if (point.y >= 19 && point.y < 38){ // 第二个

        if (self.protocolArray.count > 1) {
            NSString *name = [self.protocolArray[1] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > 0 && point.x <(0+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[1] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[1] api]];
                [self dc_pushWebController:@"/public/agree.html" params:params];
            }
        }

    } else if (point.y >= 38 && point.y < 57){ // 第三个

        if (self.protocolArray.count > 2) {
            NSString *name = [self.protocolArray[2] name];
            CGSize size = [name boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size;
            
            if (point.x > 0 && point.x <(0+size.width+10)) { //
                NSLog(@"点击了%@",[self.protocolArray[2] name]);
                NSString *params = [NSString stringWithFormat:@"api=%@",[self.protocolArray[2] api]];
                [self dc_pushWebController:@"/public/agree.html" params:params];
            }
        }
    }
    
    
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


#pragma mark - 请求 校验短信验证码
- (void)requestCheckSMSCode
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCheckSMSCodeWithCaptcha:self.smsCodeTF.text phoneNumber:self.mobileTF.text token:self.token userId:self.userId success:^(id response) {
        if (response) {
            
            GLBRegisterNextController *vc = [GLBRegisterNextController new];
            vc.phone = weakSelf.mobileTF.text;
            vc.userId = weakSelf.userId;
            [weakSelf dc_pushNextController:vc];
            
        }
    } failture:^(NSError *_Nullable error) {
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
    _titleLabel.text = @"企业用户注册";
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
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBtn setImage:[UIImage imageNamed:@"dc_placeholder_bg"] forState:0];
    [_agreeBtn setImage:[UIImage imageNamed:@"dlygx"] forState:UIControlStateSelected];
    _agreeBtn.adjustsImageWhenHighlighted = NO;
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _agreeBtn.selected = YES;
    [self.view addSubview:_agreeBtn];
    
    _protocolLabel = [[UILabel alloc] init];
    _protocolLabel.font = PFRFont(12);
    _protocolLabel.textAlignment = NSTextAlignmentLeft;
    _protocolLabel.attributedText = [self dc_attributeStr];
    _protocolLabel.userInteractionEnabled = YES;
    _protocolLabel.numberOfLines = 0;
    [self.view addSubview:_protocolLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolAction:)];
    [_protocolLabel addGestureRecognizer:tap];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_nextBtn setTitle:@"下一步，完善资料" forState:0];
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
    
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smsCodeTF.left).offset(-10);
        make.top.equalTo(self.smsCodeTF.bottom).offset(10);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeBtn.right);
        make.top.equalTo(self.agreeBtn.top).offset(10);
        make.right.equalTo(self.mobileTF.right);
//        make.height.equalTo(30);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(self.agreeBtn.bottom).offset(120);
        make.height.equalTo(44);
    }];
}


#pragma mark - lazy load
- (NSMutableArray<GLBProtocolModel *> *)protocolArray{
    if (!_protocolArray) {
        _protocolArray = [NSMutableArray array];
    }
    return _protocolArray;
}


@end
