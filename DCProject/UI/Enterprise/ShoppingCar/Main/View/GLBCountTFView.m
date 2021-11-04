//
//  GLBCountTFView.m
//  DCProject
//
//  Created by bigbing on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCountTFView.h"

@interface GLBCountTFView ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;

@property (nonatomic, copy) DCAlterBtnClickBlock btnClickBlock;

@end

@implementation GLBCountTFView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgBtn.backgroundColor = [UIColor clearColor];
    [_bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"购买数量";
    [_bgView addSubview:_titleLabel];
    
    _textField = [[DCTextField alloc] init];
    _textField.type = DCTextFieldTypeCount;
    _textField.placeholder = @"请输入购买数量";
    _textField.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _textField.font = PFRFont(14);
    [_textField dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:DC_LineColor] radius:25];
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_bgView addSubview:_textField];
    
    _line1 = [[UIImageView alloc] init];
    _line1.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_line1];
    
    _line2 = [[UIImageView alloc] init];
    _line2.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_line2];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _cancelBtn.titleLabel.font = PFRFont(14);
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setTitle:@"确定" forState:0];
    [_doneBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _doneBtn.titleLabel.font = PFRFont(14);
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_doneBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)bgBtnClick:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)cancelBtnClick:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)doneBtnClick:(UIButton *)button
{
    [self cancelBtnClick:nil];
    
    if (self.successBlock) {
        self.successBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgBtn.centerX);
        make.centerY.equalTo(self.bgBtn.centerY).offset(-kNavBarHeight);
        make.width.equalTo(kScreenW*0.85);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.bgView.top).offset(17);
    }];
    
    [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(28);
        make.height.equalTo(50);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.textField.bottom).offset(28);
        make.height.equalTo(1);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.width.equalTo(1);
        make.height.equalTo(40);
        make.top.equalTo(self.line1.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.line2.left);
        make.top.equalTo(self.line1.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [self.doneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right);
        make.left.equalTo(self.line2.right);
        make.top.equalTo(self.line1.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
}


@end
