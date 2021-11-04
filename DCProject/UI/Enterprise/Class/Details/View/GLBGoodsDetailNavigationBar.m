//
//  GLBGoodsDetailNavigationBar.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsDetailNavigationBar.h"

@interface GLBGoodsDetailNavigationBar ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation GLBGoodsDetailNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:0];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, kStatusBarHeight + 4, 40, 40);
    [_backBtn setImage:[UIImage imageNamed:@"dc_fanhui_bei"] forState:0];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(kScreenW - 40 - 10, kStatusBarHeight + 4, 40, 40);
    [_moreBtn setImage:[UIImage imageNamed:@"dc_spxq_more"] forState:0];
    _moreBtn.adjustsImageWhenHighlighted = NO;
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    
}


#pragma mark - action
- (void)backBtnClick:(UIButton *)button
{
    if (_backBtnBlock) {
        _backBtnBlock();
    }
}

- (void)moreBtnClick:(UIButton *)button
{
    if (_moreBtnBlock) {
        _moreBtnBlock();
    }
}

@end
