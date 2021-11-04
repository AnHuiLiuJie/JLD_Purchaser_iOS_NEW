//
//  GLBGoodsFiltrateView.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsFiltrateView.h"

@interface GLBGoodsFiltrateView ()

@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *rankBtn;
@property (nonatomic, strong) UIButton *storeBtn;
@property (nonatomic, strong) UIButton *filtrateBtn;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GLBGoodsFiltrateView

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
    _typeBtn.tag = 1;
    _typeBtn.bounds = CGRectMake(0, 0, kScreenW/4, 40);
    [_typeBtn dc_buttonIconRightWithSpacing:8];
    [_typeBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_typeBtn];
    
    _rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rankBtn setTitle:@"排序" forState:0];
    [_rankBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_rankBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    _rankBtn.titleLabel.font = PFRFont(13);
    [_rankBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    [_rankBtn setImage:[UIImage imageNamed:@"dc_arrow_up_lu"] forState:UIControlStateSelected];
    _rankBtn.adjustsImageWhenHighlighted = NO;
    _rankBtn.tag = 2;
    _rankBtn.bounds = CGRectMake(0, 0, kScreenW/4, 40);
    [_rankBtn dc_buttonIconRightWithSpacing:8];
    [_rankBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rankBtn];
    
    _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_storeBtn setTitle:@"商家" forState:0];
    [_storeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_storeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    _storeBtn.titleLabel.font = PFRFont(13);
    [_storeBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    [_storeBtn setImage:[UIImage imageNamed:@"dc_arrow_up_lu"] forState:UIControlStateSelected];
    _storeBtn.adjustsImageWhenHighlighted = NO;
    _storeBtn.tag = 3;
    _storeBtn.bounds = CGRectMake(0, 0, kScreenW/4, 40);
    [_storeBtn dc_buttonIconRightWithSpacing:8];
    [_storeBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_storeBtn];
    
    _filtrateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_filtrateBtn setTitle:@"筛选" forState:0];
    [_filtrateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_filtrateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    _filtrateBtn.titleLabel.font = PFRFont(13);
    [_filtrateBtn setImage:[UIImage imageNamed:@"dc_arrow_bottom_hei"] forState:0];
    [_filtrateBtn setImage:[UIImage imageNamed:@"dc_arrow_up_lu"] forState:UIControlStateSelected];
    _filtrateBtn.adjustsImageWhenHighlighted = NO;
    _filtrateBtn.tag = 4;
    _filtrateBtn.bounds = CGRectMake(0, 0, kScreenW/4, 40);
    [_filtrateBtn dc_buttonIconRightWithSpacing:8];
    [_filtrateBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_filtrateBtn];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont fontWithName:PFR size:11];
    [_countLabel dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FF9900"] radius:7];
    _countLabel.hidden = YES;
    [self addSubview:_countLabel];
    
    [self layoutIfNeeded];
}



#pragma mark - action
- (void)filtrateBtnClick:(UIButton *)button
{
    if (_filtrateBtnBlock) {
        _filtrateBtnBlock(button.tag);
    }
    
    self.typeBtn.selected = NO;
    self.rankBtn.selected = NO;
    self.storeBtn.selected = NO;
    self.filtrateBtn.selected = NO;
    
    button.selected = YES;
}


#pragma mark -  恢复初始状态
- (void)dc_recoverInit
{
    self.typeBtn.selected = NO;
    self.rankBtn.selected = NO;
    self.storeBtn.selected = NO;
    self.filtrateBtn.selected = NO;
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



#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/4);
    }];
    
    [_rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeBtn.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/4);
    }];
    
    [_storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rankBtn.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/4);
    }];
    
    [_filtrateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeBtn.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/4);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.storeBtn.right).offset(-5);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
}

@end
