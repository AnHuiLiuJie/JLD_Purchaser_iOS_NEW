//
//  GLBClassNavigationBar.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBClassNavigationBar.h"

@interface GLBClassNavigationBar ()

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UILabel *searchLabel;

@end

@implementation GLBClassNavigationBar

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
    
    _searchView = [[UIView alloc] init];
    _searchView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    [_searchView dc_cornerRadius:15];
    _searchView.userInteractionEnabled = YES;
    [self addSubview:_searchView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewClick:)];
    [_searchView addGestureRecognizer:tap];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [_searchView addSubview:_searchImage];
    
    _searchLabel = [[UILabel alloc] init];
    _searchLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _searchLabel.font = PFRFont(11);
    _searchLabel.text = @"商品名称、批准文号、助记码、生产厂家……";
    [_searchView addSubview:_searchLabel];
    
    [self layoutIfNeeded];
}


#pragma mark - 点击事件
- (void)searchViewClick:(id)sender
{
    if (_searchBlock) {
        _searchBlock();
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.bottom.equalTo(self.bottom).offset(-7);
        make.height.equalTo(30);
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView.centerY);
        make.left.equalTo(self.searchView.left).offset(10);
        make.width.height.equalTo(12);
    }];
    
    [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchImage.right).offset(10);
        make.right.equalTo(self.searchView.right).offset(-10);
        make.centerY.equalTo(self.searchView.centerY);
    }];
}


@end
