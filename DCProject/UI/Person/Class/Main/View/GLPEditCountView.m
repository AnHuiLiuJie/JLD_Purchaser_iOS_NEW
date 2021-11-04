//
//  GLPEditCountView.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPEditCountView.h"

@interface GLPEditCountView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation GLPEditCountView

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
    
    _addLabel = [[UILabel alloc] init];
    _addLabel.frame = CGRectMake(0, 0, 30, 40);
    _addLabel.backgroundColor = [UIColor whiteColor];
    _addLabel.textColor = [UIColor dc_colorWithHexString:@"#CECECE"];
    _addLabel.textAlignment = NSTextAlignmentCenter;
    _addLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _addLabel.text = @"+";
    [_addLabel dc_borderForColor:[UIColor dc_colorWithHexString:@"#E5E5E5"] borderWidth:1 borderType:UIBorderSideTypeTop | UIBorderSideTypeBottom | UIBorderSideTypeLeft | UIBorderSideTypeRight];
    [self addSubview:_addLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.frame = CGRectMake(0, 0, 30, 40);
    _subLabel.backgroundColor = [UIColor whiteColor];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#CECECE"];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _subLabel.text = @"-";
    [_subLabel dc_borderForColor:[UIColor dc_colorWithHexString:@"#E5E5E5"] borderWidth:1 borderType:UIBorderSideTypeTop | UIBorderSideTypeBottom | UIBorderSideTypeLeft | UIBorderSideTypeRight];
    [self addSubview:_subLabel];
    
    
    _countTF = [[DCTextField alloc] init];
    _countTF.type = DCTextFieldTypeCount;
    _countTF.frame = CGRectMake(0, 0, 40, 40);
    _countTF.backgroundColor = [UIColor whiteColor];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_personCountChangeWithCountView:)]) {
        [self.delegate dc_personCountChangeWithCountView:self];
    }
    return NO;
}


#pragma mark - action
- (void)addBtnClick:(UIButton *)button
{
     //NSInteger count = [_countTF.text integerValue];
    //_countTF.text = [NSString stringWithFormat:@"%ld",count+1];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_personCountAddWithCountView:)]) {
        [self.delegate dc_personCountAddWithCountView:self];
    }
}

- (void)subBtnClick:(UIButton *)button
{
    NSInteger count = [_countTF.text integerValue];
    if (count == 1) {
        [SVProgressHUD showInfoWithStatus:@"不能再减了～"];
        return;
    }
//    else{
//         _countTF.text = [NSString stringWithFormat:@"%ld",count-1];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_personCountSubWithCountView:)]) {
        [self.delegate dc_personCountSubWithCountView:self];
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(0);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(30, 40));
    }];
    
    [_countTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.addLabel.left).offset(0);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countTF.left);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(30, 40));
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addLabel.centerX);
        make.centerY.equalTo(self.addLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 40));
    }];
    
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subLabel.centerX);
        make.centerY.equalTo(self.subLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 40));
    }];
    
}


@end
