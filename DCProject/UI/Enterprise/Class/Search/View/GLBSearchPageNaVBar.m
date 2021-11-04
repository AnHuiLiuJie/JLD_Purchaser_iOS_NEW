//
//  GLBSearchPageNaVBar.m
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSearchPageNaVBar.h"

@interface GLBSearchPageNaVBar ()

@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation GLBSearchPageNaVBar

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
    
    _textField = [[DCTextField alloc] init];
    _textField.type = DCTextFieldTypeDefault;
    _textField.attributedPlaceholder = [NSString dc_placeholderWithString:@"搜索"];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [_textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.font = PFRFont(12);
    _textField.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
    [_textField dc_cornerRadius:15];
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [self addSubview:_textField];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [self addSubview:_searchImage];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:0];
    _cancelBtn.titleLabel.font = PFRFont(12);
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
    if (_cancelBtnClick) {
        _cancelBtnClick();
    }
}


- (void)textFieldValueChange:(UITextField *)textField
{
    
}




#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-5);
        make.right.equalTo(self.right).offset(-5);
        make.size.equalTo(CGSizeMake(50, 34));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(12);
        make.right.equalTo(self.cancelBtn.left).offset(0);
        make.centerY.equalTo(self.cancelBtn.centerY);
        make.height.equalTo(30);
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.left).offset(13);
        make.centerY.equalTo(self.textField.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
}

@end
