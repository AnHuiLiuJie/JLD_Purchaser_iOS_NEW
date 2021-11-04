//
//  GLBStoreNavigationBar.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreNavigationBar.h"
#import "DCTextField.h"

@interface GLBStoreNavigationBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) DCTextField *textField;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UIButton *shoppingcarBtn;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GLBStoreNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB" alpha:1];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:0];
    _backBtn.adjustsImageWhenHighlighted = NO;
    _backBtn.tag = 700;
    [_backBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _textField = [[DCTextField alloc] init];
    _textField.type = DCTextFieldTypeDefault;
    _textField.placeholder = @"搜索商品名称";
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    _textField.delegate = self;
    _textField.font = PFRFont(12);
    _textField.backgroundColor = [UIColor whiteColor];
    [_textField dc_cornerRadius:15];
    [self addSubview:_textField];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [self addSubview:_searchImage];
    
    _shoppingcarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shoppingcarBtn setImage:[UIImage imageNamed:@"dp_gwc"] forState:0];
    _shoppingcarBtn.adjustsImageWhenHighlighted = NO;
    _shoppingcarBtn.tag = 701;
    [_shoppingcarBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shoppingcarBtn];
    
    _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:[UIImage imageNamed:@"dp_dd"] forState:0];
    _msgBtn.adjustsImageWhenHighlighted = NO;
    _msgBtn.tag = 702;
    [_msgBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgBtn];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = PFRFont(8);
    [_countLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:6];
    _countLabel.text = @"0";
    _countLabel.hidden = YES;
    [self addSubview:_countLabel];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)buttonClick:(UIButton *)button
{
    if (_successBlock) {
        _successBlock(button.tag);
    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_successBlock) {
        _successBlock(703);
    }
    return NO;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-5);
        make.left.equalTo(self.left).offset(5);
        make.size.equalTo(CGSizeMake(34, 34));
    }];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-5);
        make.centerY.equalTo(self.backBtn.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_shoppingcarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.msgBtn.left).offset(-5);
        make.centerY.equalTo(self.msgBtn.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.right).offset(5);
        make.right.equalTo(self.shoppingcarBtn.left).offset(-10);
        make.centerY.equalTo(self.backBtn.centerY);
        make.height.equalTo(30);
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.left).offset(13);
        make.centerY.equalTo(self.textField.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shoppingcarBtn.top);
        make.right.equalTo(self.shoppingcarBtn.right);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
}


#pragma mark - setter
- (void)setCount:(NSInteger)count
{
    _count = count;
    
    if (_count > 0) {
        
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"%ld",_count];
        
    } else {
        _countLabel.hidden = YES;
    }
}

@end
