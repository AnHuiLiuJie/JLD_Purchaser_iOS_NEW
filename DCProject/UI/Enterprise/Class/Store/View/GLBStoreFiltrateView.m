//
//  GLBStoreFiltrateView.m
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreFiltrateView.h"

@interface GLBStoreFiltrateView ()

@property (nonatomic, strong) UIButton *rankBtn;
@property (nonatomic, strong) UIButton *filtrateBtn;;

@end

@implementation GLBStoreFiltrateView

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
    
    _rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rankBtn setTitle:@"排序" forState:0];
    [_rankBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_rankBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    _rankBtn.titleLabel.font = PFRFont(13);
    [_rankBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    [_rankBtn setImage:[UIImage imageNamed:@"dc_arrow_up_lu"] forState:UIControlStateSelected];
    _rankBtn.adjustsImageWhenHighlighted = NO;
    _rankBtn.tag = 900;
    _rankBtn.bounds = CGRectMake(0, 0, kScreenW/4, 40);
    [_rankBtn dc_buttonIconRightWithSpacing:8];
    [_rankBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rankBtn];
    
    
    _filtrateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_filtrateBtn setTitle:@"筛选" forState:0];
    [_filtrateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_filtrateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    _filtrateBtn.titleLabel.font = PFRFont(13);
    [_filtrateBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    [_filtrateBtn setImage:[UIImage imageNamed:@"dc_arrow_up_lu"] forState:UIControlStateSelected];
    _filtrateBtn.adjustsImageWhenHighlighted = NO;
    _filtrateBtn.tag = 901;
    _filtrateBtn.bounds = CGRectMake(0, 0, kScreenW/4, 40);
    [_filtrateBtn dc_buttonIconRightWithSpacing:8];
    [_filtrateBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_filtrateBtn];
    
    [self layoutIfNeeded];
}



#pragma mark - action
- (void)filtrateBtnClick:(UIButton *)button
{
    if (_filtrateBtnBlock) {
        _filtrateBtnBlock(button.tag);
    }
    
    self.rankBtn.selected = NO;
    self.filtrateBtn.selected = NO;
    
    button.selected = YES;
}


#pragma mark -  恢复初始状态
- (void)dc_recoverInit
{
    self.rankBtn.selected = NO;
    self.filtrateBtn.selected = NO;
}



#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/2);
    }];
    
    
    [_filtrateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rankBtn.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/2);
    }];
}

@end
