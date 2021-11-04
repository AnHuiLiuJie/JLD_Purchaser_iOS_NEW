//
//  GLBOpenTypeController.m
//  DCProject
//
//  Created by bigbing on 2019/12/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOpenTypeController.h"
#import "GLPLoginController.h"

#import "GLBGuideController.h"

@interface GLBOpenTypeController ()

@end

@implementation GLBOpenTypeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES];
    
    [[DCUpdateTool shareClient] requestIsUpdate];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}


- (void)companyBtnClick:(UIButton *)button
{
    [DCObjectManager dc_saveUserData:@(DCUserTypeWithCompany) forKey:DC_UserType_Key];
    [self dc_pushNextController:[GLBGuideController new]];
}

- (void)personBtnClick:(UIButton *)button
{
    [DCObjectManager dc_saveUserData:@(DCUserTypeWithPerson) forKey:DC_UserType_Key];
    [self dc_pushNextController:[GLPLoginController new]];
}



- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.image = [UIImage imageNamed:@"logo_1"];
    [self.view addSubview:logoImage];
    
    UIImageView *tipImage = [[UIImageView alloc] init];
    tipImage.image = [UIImage imageNamed:@"chahua"];
    [self.view addSubview:tipImage];
    
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [personBtn setBackgroundImage:[UIImage imageNamed:@"geren"] forState:0];
    personBtn.adjustsImageWhenHighlighted = NO;
    [personBtn addTarget:self action:@selector(personBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personBtn];
    
    UIButton *companyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [companyBtn setBackgroundImage:[UIImage imageNamed:@"qiye-1"] forState:0];
    companyBtn.adjustsImageWhenHighlighted = NO;
    [companyBtn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:companyBtn];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.backgroundColor = [UIColor dc_colorWithHexString:@"#FF7E28"];
    label1.textColor = [UIColor whiteColor];
    label1.font = PFRFont(14);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"进入>>";
    [label1 dc_cornerRadius:16];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor dc_colorWithHexString:@"#FF7E28"];
    label2.textColor = [UIColor whiteColor];
    label2.font = PFRFont(14);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"进入>>";
    [label2 dc_cornerRadius:16];
    [self.view addSubview:label2];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(kNavBarHeight);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).multipliedBy(0.47);
        make.height.equalTo(logoImage.width).multipliedBy(0.35);
    }];
    
    [tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImage.bottom).offset(44);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width);
        make.height.equalTo(tipImage.width).multipliedBy(0.65);
    }];
    
    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipImage.bottom).offset(64);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).multipliedBy(0.84);
        make.height.equalTo(personBtn.width).multipliedBy(0.2);
    }];
    
    [companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personBtn.bottom).offset(23);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).multipliedBy(0.84);
        make.height.equalTo(companyBtn.width).multipliedBy(0.2);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personBtn.centerY);
        make.right.equalTo(personBtn.right).offset(-40);
        make.size.equalTo(CGSizeMake(73, 32));
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(companyBtn.centerY);
        make.right.equalTo(companyBtn.right).offset(-40);
        make.size.equalTo(CGSizeMake(73, 32));
    }];
}

@end
