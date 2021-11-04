//
//  GLPSearcgNavBar.m
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPSearcgNavBar.h"

@interface GLPSearcgNavBar ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIImageView *searchImage;

@end

@implementation GLPSearcgNavBar

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
    _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F6F7F8"];
    [_searchTF dc_cornerRadius:15];
    _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.textColor = [UIColor blackColor];
    _searchTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"搜索"];
    [self addSubview:_searchTF];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [self addSubview:_searchImage];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor dc_colorWithHexString:@"#20222E"] forState:0];
    _cancelBtn.titleLabel.font = PFRFont(16);
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
    if (_cancelBlock) {
        _cancelBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottom);
        make.size.equalTo(CGSizeMake(57, 44));
    }];
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn.centerY);
        make.left.equalTo(self.left).offset(16);
        make.right.equalTo(self.cancelBtn.left);
        make.height.equalTo(30);
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchTF.centerY);
        make.left.equalTo(self.searchTF.left).offset(9);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
}


@end
