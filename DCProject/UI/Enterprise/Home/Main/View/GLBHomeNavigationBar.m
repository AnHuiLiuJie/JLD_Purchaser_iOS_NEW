//
//  GLBHomeNavigationBar.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBHomeNavigationBar.h"

@interface GLBHomeNavigationBar ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UIImageView *tipImage;

@end

@implementation GLBHomeNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"dc_fanhui_bei"] forState:0];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:[UIImage imageNamed:@"xiaoxisy"] forState:0];
    _msgBtn.adjustsImageWhenHighlighted = NO;
    [_msgBtn addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgBtn];
    
    _searchView = [[UIView alloc] init];
    _searchView.backgroundColor = [UIColor whiteColor];
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
    
    _tipImage = [[UIImageView alloc] init];
    _tipImage.backgroundColor = [UIColor redColor];
    [_tipImage dc_cornerRadius:3];
    _tipImage.hidden = YES;
    [self addSubview:_tipImage];
    
    [self layoutIfNeeded];
}


#pragma mark - 点击事件
- (void)backBtnClick:(UIButton *)button
{
    if (_navBarBlock) {
        _navBarBlock(900);
    }
}

- (void)msgBtnClick:(UIButton *)button
{
    if (_navBarBlock) {
        _navBarBlock(901);
    }
}

- (void)searchViewClick:(id)sender
{
    if (_navBarBlock) {
        _navBarBlock(902);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.bottom.equalTo(self.bottom);
        make.width.height.equalTo(44);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.centerY.equalTo(self.msgBtn.centerY);
        make.width.height.equalTo(44);
    }];
    
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.right).offset(5);
        make.right.equalTo(self.msgBtn.left).offset(-5);
        make.centerY.equalTo(self.msgBtn.centerY);
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
    
    [_tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgBtn.top).offset(3);
        make.right.equalTo(self.msgBtn.right).offset(-3);
        make.size.equalTo(CGSizeMake(6, 6));
    }];
}


#pragma mark - setter
- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    
    if (_isTop) {
//        [_messageBtn setImage:[UIImage imageNamed:@"index_xiaoxi-1"] forState:0];
//        [_shoppingcarBtn setImage:[UIImage imageNamed:@"gwcl"] forState:0];
        _searchView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor alpha:1];
    }else{
//        [_messageBtn setImage:[UIImage imageNamed:@"index_xiaoxi"] forState:0];
//        [_shoppingcarBtn setImage:[UIImage imageNamed:@"gwcb"] forState:0];
        _searchView.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:1];
    }
}


- (void)setCount:(NSInteger)count
{
    _count = count;
    
    if (_count > 0) {
        _tipImage.hidden = NO;
    } else {
        _tipImage.hidden = YES;
    }
}

@end
