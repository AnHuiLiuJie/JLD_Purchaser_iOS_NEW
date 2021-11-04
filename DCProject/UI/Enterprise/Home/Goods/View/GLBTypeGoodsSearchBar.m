//
//  GLBTypeGoodsSearchBar.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTypeGoodsSearchBar.h"

@interface GLBTypeGoodsSearchBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *searchImage;

@end

@implementation GLBTypeGoodsSearchBar

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
    _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
    [_searchTF dc_cornerRadius:15];
    _searchTF.placeholder = @"输入商品名称";
    _searchTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _searchTF.font = PFRFont(14);
    _searchTF.delegate = self;
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_searchTF];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [self addSubview:_searchImage];
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
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(10);
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
