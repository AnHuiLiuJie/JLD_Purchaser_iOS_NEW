//
//  DCAlterView.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCAlterView.h"

@interface DCAlterView ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;

@property (nonatomic, copy) DCAlterBtnClickBlock btnClickBlock;

@end

@implementation DCAlterView

#pragma mark - 初始化
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {
    self = [super init];
    if (self) {
        [self setUpUIWithTitle:title content:content];
    }
    return self;
}


#pragma mark - UI
- (void)setUpUIWithTitle:(NSString *)title content:(NSString *)content
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgBtn.backgroundColor = [UIColor clearColor];
    [_bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:10];
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#030303"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = title;
    [_bgView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor dc_colorWithHexString:@"#5D5D5D"];
    _contentLabel.font = [UIFont fontWithName:PFR size:16];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.text = content;
    _contentLabel.numberOfLines = 0;
    [_bgView addSubview:_contentLabel];
    
    _line1 = [[UIImageView alloc] init];
    _line1.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_line1];
    
    _line2 = [[UIImageView alloc] init];
    _line2.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_line2];
    
    [self layoutIfNeeded];
}


#pragma mark - 添加点击事件
- (void)addActionWithTitle:(NSString *)title type:(DCAlterType)type halderBlock:(DCAlterBtnClickBlock __nullable)halderBlock {
    
    if (type == DCAlterTypeCancel) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:title forState:0];
        [_cancelBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
        _cancelBtn.titleLabel.font = PFRFont(17);
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        
    } else if (type == DCAlterTypeDone) {
        
        self.btnClickBlock = ^(UIButton *button) {
            if (halderBlock) {
                halderBlock(button);
            }
        };
        
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:title forState:0];
        [_doneBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
        _doneBtn.titleLabel.font = PFRFont(17);
        [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_doneBtn];
    }
    
    [self layoutSubviews];
}


#pragma mark - 添加点击事件 带颜色
- (void)addActionWithTitle:(NSString *)title color:(UIColor *)color type:(DCAlterType)type halderBlock:(DCAlterBtnClickBlock)halderBlock
{
    if (type == DCAlterTypeCancel) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:title forState:0];
        [_cancelBtn setTitleColor:color forState:0];
        _cancelBtn.titleLabel.font = PFRFont(17);
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        
    } else if (type == DCAlterTypeDone) {
        
        self.btnClickBlock = ^(UIButton *button) {
            if (halderBlock) {
                halderBlock(button);
            }
        };
        
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:title forState:0];
        [_doneBtn setTitleColor:color forState:0];
        _doneBtn.titleLabel.font = PFRFont(17);
        [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_doneBtn];
    }
    
    [self layoutSubviews];
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
    
    if (self.btnClickBlock) {
        self.btnClickBlock(button);
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
        make.width.equalTo(kScreenW*0.7);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.bgView.top).offset(17);
    }];
    
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(28);
    }];
    
    if ([self.bgView.subviews containsObject:self.cancelBtn] && [self.bgView.subviews containsObject:self.doneBtn]) {
        
        [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.left);
            make.right.equalTo(self.bgView.right);
            make.top.equalTo(self.contentLabel.bottom).offset(28);
            make.height.equalTo(1);
        }];
        
        [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.centerX);
            make.width.equalTo(1);
            make.height.equalTo(44);
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
        
    } else if ([self.bgView.subviews containsObject:self.cancelBtn] && ![self.bgView.subviews containsObject:self.doneBtn]) {

        [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.left);
            make.right.equalTo(self.bgView.right);
            make.top.equalTo(self.contentLabel.bottom).offset(28);
            make.height.equalTo(1);
        }];

        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.left);
            make.right.equalTo(self.bgView.right);
            make.top.equalTo(self.line1.bottom);
            make.bottom.equalTo(self.bgView.bottom);
            make.height.equalTo(44);
        }];

    } else if (![self.bgView.subviews containsObject:self.cancelBtn] && [self.bgView.subviews containsObject:self.doneBtn]) {

        [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.left);
            make.right.equalTo(self.bgView.right);
            make.top.equalTo(self.contentLabel.bottom).offset(28);
            make.height.equalTo(1);
        }];

        [self.doneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.left);
            make.right.equalTo(self.bgView.right);
            make.top.equalTo(self.line1.bottom);
            make.bottom.equalTo(self.bgView.bottom);
            make.height.equalTo(44);
        }];

    } else {
        
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left);
            make.right.equalTo(self.titleLabel.right);
            make.top.equalTo(self.titleLabel.bottom).offset(28);
            make.bottom.equalTo(self.bgView.bottom).offset(-28);
        }];
    }
}


@end
