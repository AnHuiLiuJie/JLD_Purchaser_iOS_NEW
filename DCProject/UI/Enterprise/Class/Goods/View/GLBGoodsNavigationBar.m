//
//  GLBGoodsNavigationBar.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsNavigationBar.h"


@interface GLBGoodsNavigationBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIImageView *searchImage;

@end

@implementation GLBGoodsNavigationBar

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
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"dc_fanhui_hei"] forState:0];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _searchTF = [[DCTextField alloc] init];
    _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
    [_searchTF dc_cornerRadius:15];
    _searchTF.placeholder = @"输入商品名称";
    _searchTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _searchTF.font = PFRFont(14);
    _searchTF.delegate = self;
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_searchTF];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [self addSubview:_searchImage];
}


#pragma mark - action
- (void)backBtnClick:(id)sender
{
    if (_backBtnBlock) {
        _backBtnBlock();
    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTF resignFirstResponder];
    if (_searchTFBlock) {
        _searchTFBlock();
    }
    return YES;
}



#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(5);
        make.bottom.equalTo(self.bottom).offset(-3);
        make.size.equalTo(CGSizeMake(38, 38));
    }];
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.centerY);
        make.left.equalTo(self.backBtn.right).offset(0);
        make.right.equalTo(self.right).offset(-10);
        make.height.equalTo(30);
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTF.left).offset(12);
        make.centerY.equalTo(self.searchTF.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
}

@end
