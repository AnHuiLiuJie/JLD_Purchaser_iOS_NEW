//
//  GLBRepayHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayHeadView.h"


@interface GLBRepayHeadView ()<UITextFieldDelegate>



@end

@implementation GLBRepayHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _searchTF = [[DCTextField alloc] init];
    _searchTF.delegate = self;
    _searchTF.type = DCTextFieldTypeDefault;
    _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
    _searchTF.placeholder = @"输入订单号";
    _searchTF.keyboardType=UIKeyboardTypeNumberPad;
    _searchTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _searchTF.font = PFRFont(14);
    [_searchTF dc_cornerRadius:15];
    _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 20)];
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:_searchTF];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [self addSubview:_searchImage];
    
    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_typeBtn setTitle:@"全部    " forState:0];
    [_typeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _typeBtn.titleLabel.font = PFRFont(12);
    [_typeBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    _typeBtn.adjustsImageWhenHighlighted = NO;
    [_typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _typeBtn.bounds = CGRectMake(0, 0, 70, 40);
    [_typeBtn dc_buttonIconRightWithSpacing:10];
    _typeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_typeBtn];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLabel.font = PFRFont(12);
    _timeLabel.text = @"完成日期";
    [self addSubview:_timeLabel];

    _andLabel = [[UILabel alloc] init];
    _andLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _andLabel.font = PFRFont(12);
    _andLabel.text = @"至";
    [self addSubview:_andLabel];

    _beginTF = [[DCTextField alloc] init];
    _beginTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _beginTF.font = PFRFont(9);
    _beginTF.delegate = self;
    _beginTF.textAlignment = NSTextAlignmentCenter;
    _beginTF.rightViewMode = UITextFieldViewModeAlways;
    [_beginTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EDEDED"] radius:10];
    [self addSubview:_beginTF];

    _endTF = [[DCTextField alloc] init];
    _endTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _endTF.font = PFRFont(9);
    _endTF.delegate = self;
    _endTF.textAlignment = NSTextAlignmentCenter;
    _endTF.rightViewMode = UITextFieldViewModeAlways;
    [_endTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EDEDED"] radius:10];
    [self addSubview:_endTF];

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 8, 5)];
    image1.image = [UIImage imageNamed:@"dc_arrow_bottom_hei"];
    [view1 addSubview:image1];
    _beginTF.rightView = view1;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 8, 5)];
    image2.image = [UIImage imageNamed:@"dc_arrow_bottom_hei"];
    [view2 addSubview:image2];
    _endTF.rightView = view2;

    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetBtn setTitle:@"重置" forState:0];
    [_resetBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _resetBtn.titleLabel.font = PFRFont(12);
    [_resetBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#333333"] radius:2];
    [_resetBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_resetBtn];

    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBtn setTitle:@"查询" forState:0];
    [_checkBtn setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
    _checkBtn.titleLabel.font = PFRFont(12);
    _checkBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_checkBtn dc_cornerRadius:2];
    [_checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkBtn];
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)checkBtnClick:(UIButton *)button
{
    if (self.lookblock) {
        self.lookblock();
    }
}

- (void)resetBtnClick:(UIButton *)button
{
    if (self.resetblock) {
        self.resetblock();
    }
}

- (void)typeBtnClick:(UIButton *)button
{
    if (self.clickblock) {
        self.clickblock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.top.equalTo(self.top).offset(7);
        make.height.equalTo(30);
    }];

    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.searchTF.bottom).offset(7);
        make.size.equalTo(CGSizeMake(80, 40));
    }];

    [_endTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeBtn.centerY);
        make.right.equalTo(self.right).offset(-10);
        make.size.equalTo(CGSizeMake(90, 20));
    }];

    [_andLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeBtn.centerY);
        make.right.equalTo(self.endTF.left).offset(-10);
    }];

    [_beginTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeBtn.centerY);
        make.right.equalTo(self.andLabel.left).offset(-10);
        make.size.equalTo(CGSizeMake(90, 20));
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeBtn.centerY);
        make.right.equalTo(self.beginTF.left).offset(-7);
    }];

    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeBtn.bottom).offset(8);
        make.right.equalTo(self.right).offset(-10);
        make.size.equalTo(CGSizeMake(60, 24));
    }];

    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBtn.centerY);
        make.right.equalTo(self.checkBtn.left).offset(-10);
        make.size.equalTo(CGSizeMake(60, 24));
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(30);
        make.centerY.equalTo(self.searchTF.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.beginTF)
    {
        
        if (self.begainblock) {
            self.begainblock();
        }
        return NO;
    }
    else if (textField==self.endTF)
    {
        [textField resignFirstResponder];
        if (self.endblock) {
            self.endblock();
        }
          return NO;
    }
    else{
          return YES;
    }
}

@end
