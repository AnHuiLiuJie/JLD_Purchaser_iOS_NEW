//
//  GLBEditCountView.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBEditCountView.h"

@interface GLBEditCountView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *subBordLabel;
@property (nonatomic, strong) UILabel *addBordLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation GLBEditCountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _addBordLabel = [[UILabel alloc] init];
    _addBordLabel.frame = CGRectMake(0, 0, 20, 20);
    [_addBordLabel dc_borderForColor:[UIColor dc_colorWithHexString:@"#E5E5E5"] borderWidth:1 borderType:UIBorderSideTypeTop | UIBorderSideTypeBottom | UIBorderSideTypeLeft | UIBorderSideTypeRight];
    [self addSubview:_addBordLabel];
    
    _addLabel = [[UILabel alloc] init];
    _addLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _addLabel.textAlignment = NSTextAlignmentCenter;
    _addLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _addLabel.text = @"+";
    [self addSubview:_addLabel];
    
    _subBordLabel = [[UILabel alloc] init];
    _subBordLabel.frame = CGRectMake(0, 0, 20, 20);
    [_subBordLabel dc_borderForColor:[UIColor dc_colorWithHexString:@"#E5E5E5"] borderWidth:1 borderType:UIBorderSideTypeTop | UIBorderSideTypeBottom | UIBorderSideTypeLeft | UIBorderSideTypeRight];
    [self addSubview:_subBordLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _subLabel.text = @"-";
    [self addSubview:_subLabel];
    
    _countTF = [[DCTextField alloc] init];
    _countTF.type = DCTextFieldTypeCount;
    _countTF.frame = CGRectMake(0, 0, 40, 20);
    _countTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _countTF.textAlignment = NSTextAlignmentCenter;
    _countTF.font = [UIFont fontWithName:PFRSemibold size:12];
    _countTF.text = @"1";
    _countTF.delegate = self;
    [_countTF dc_borderForColor:[UIColor dc_colorWithHexString:@"#E5E5E5"] borderWidth:1 borderType:UIBorderSideTypeTop | UIBorderSideTypeBottom];
    [self addSubview:_countTF];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_subBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_countChangeWithCountView:)]) {
        [self.delegate dc_countChangeWithCountView:self];
    }
    return NO;
}


#pragma mark - action
- (void)addBtnClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_countAddWithCountView:)]) {
        [self.delegate dc_countAddWithCountView:self];
    }
}

- (void)subBtnClick:(UIButton *)button
{
    NSInteger count = [_countTF.text integerValue];
    if (count == 1) {
        [SVProgressHUD showInfoWithStatus:@"不能再减了～"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_countSubWithCountView:)]) {
        [self.delegate dc_countSubWithCountView:self];
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_addBordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    [_countTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.addBordLabel.left).offset(0);
        make.size.equalTo(CGSizeMake(40, 20));
    }];
    
    [_subBordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countTF.left);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addBordLabel.centerX);
        make.centerY.equalTo(self.addBordLabel.centerY);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subBordLabel.centerX);
        make.centerY.equalTo(self.subBordLabel.centerY);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.addBordLabel.centerX);
        make.centerY.equalTo(self.countTF.centerY).offset(-1);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subBordLabel.centerX);
        make.centerY.equalTo(self.countTF.centerY).offset(-1);
    }];
}


@end
