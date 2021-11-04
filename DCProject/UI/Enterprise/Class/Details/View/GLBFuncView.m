//
//  GLBFuncView.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBFuncView.h"

@interface GLBFuncView ()

@property (nonatomic, strong) UIControl *cancelControl;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *homeBtn;
@property (nonatomic, strong) UILabel *homeLabel;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation GLBFuncView

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
    
    _cancelControl = [[UIControl alloc] init];
    [_cancelControl addTarget:self action:@selector(cancelControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelControl];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.9];
    _bgView.bounds = CGRectMake(0, 0, kScreenW, 165);
    [_bgView dc_cornerRadius:10 rectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.text = @"功能直达";
    [_bgView addSubview:_titleLabel];
    
    _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_homeBtn setBackgroundImage:[UIImage imageNamed:@"spxq_shouye"] forState:0];
    _homeBtn.adjustsImageWhenHighlighted = NO;
    _homeBtn.tag = 600;
    [_homeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_homeBtn];
    
    _homeLabel = [[UILabel alloc] init];
    _homeLabel.textAlignment = NSTextAlignmentCenter;
    _homeLabel.textColor = [UIColor whiteColor];
    _homeLabel.font = PFRFont(11);
    _homeLabel.text = @"首页";
    [_bgView addSubview:_homeLabel];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"dc_ssq_bai"] forState:0];
    _searchBtn.adjustsImageWhenHighlighted = NO;
    _searchBtn.tag = 601;
    [_searchBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_searchBtn];
    
    _searchLabel = [[UILabel alloc] init];
    _searchLabel.textAlignment = NSTextAlignmentCenter;
    _searchLabel.textColor = [UIColor whiteColor];
    _searchLabel.font = PFRFont(11);
    _searchLabel.text = @"搜索";
    [_bgView addSubview:_searchLabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"dc_scq_bai"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)cancelControlAction:(id)sender
{
    self.bgView.frame = CGRectMake(0, 0, kScreenW, 165);
    
    WEAKSELF;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, -165, kScreenW, 165);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (weakSelf.cancelBlock) {
            weakSelf.cancelBlock();
        }
    }];
}

- (void)buttonClick:(UIButton *)button
{
    if (_funcViewBlock) {
        _funcViewBlock(button.tag);
    }
    
    [self cancelControlAction:nil];
}


#pragma mark - 开始动画
- (void)startAnimation
{
    self.bgView.frame = CGRectMake(0, -165, kScreenW, 165);
    
    WEAKSELF;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, 0, kScreenW, 165);
    } completion:nil];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_cancelControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.height.equalTo(165);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.bgView.top).offset(34);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-15);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.titleLabel.bottom).offset(17);
        make.size.equalTo(CGSizeMake(60, 60));
    }];
    
    [_homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.homeBtn.centerX);
        make.top.equalTo(self.homeBtn.bottom).offset(5);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homeBtn.right).offset(27);
        make.centerY.equalTo(self.homeBtn.centerY);
        make.size.equalTo(CGSizeMake(60, 60));
    }];
    
    [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.searchBtn.centerX);
        make.top.equalTo(self.searchBtn.bottom).offset(5);
    }];
}

@end
