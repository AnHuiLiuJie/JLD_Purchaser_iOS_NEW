//
//  GLBTCMFiltrateView.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTCMFiltrateView.h"

@interface GLBTCMFiltrateView ()

@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *rankBtn;

@end

@implementation GLBTCMFiltrateView

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
    
    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_typeBtn setTitle:@"选择分类" forState:0];
    [_typeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_typeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    _typeBtn.titleLabel.font = PFRFont(13);
    [_typeBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    [_typeBtn setImage:[UIImage imageNamed:@"dc_arrow_up_lu"] forState:UIControlStateSelected];
    _typeBtn.adjustsImageWhenHighlighted = NO;
    _typeBtn.tag = 800;
    _typeBtn.bounds = CGRectMake(0, 0, kScreenW/2, 40);
    [_typeBtn dc_buttonIconRightWithSpacing:8];
    [_typeBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_typeBtn];
    
    _rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rankBtn setTitle:@"筛选" forState:0];
    [_rankBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_rankBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    _rankBtn.titleLabel.font = PFRFont(13);
    [_rankBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    [_rankBtn setImage:[UIImage imageNamed:@"dc_arrow_up_lu"] forState:UIControlStateSelected];
    _rankBtn.adjustsImageWhenHighlighted = NO;
    _rankBtn.tag = 801;
    _rankBtn.bounds = CGRectMake(0, 0, kScreenW/2, 40);
    [_rankBtn dc_buttonIconRightWithSpacing:8];
    [_rankBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rankBtn];
    
    [self layoutIfNeeded];
}



#pragma mark - action
- (void)filtrateBtnClick:(UIButton *)button
{
    if (_filtrateBlock) {
        _filtrateBlock(button.tag);
    }
    
    self.typeBtn.selected = NO;
    self.rankBtn.selected = NO;
    
    button.selected = YES;
}


#pragma mark - 恢复初始话设置
- (void)dc_recoverInit
{
    self.typeBtn.selected = NO;
    self.rankBtn.selected = NO;
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/2);
    }];
    
    [_rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeBtn.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/2);
    }];
}

@end
