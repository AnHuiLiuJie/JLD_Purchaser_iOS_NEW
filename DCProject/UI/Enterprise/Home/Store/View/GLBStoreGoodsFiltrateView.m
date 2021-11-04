//
//  GLBStoreGoodsFiltrateView.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreGoodsFiltrateView.h"

@interface GLBStoreGoodsFiltrateView ()

@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *rankBtn;


@end

@implementation GLBStoreGoodsFiltrateView

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
    _typeBtn.bounds = CGRectMake(0, 0, kScreenW/3, 40);
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
    
    _promotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_promotionBtn setTitle:@"有促销" forState:0];
    [_promotionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FF9900"] forState:0];
    [_promotionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _promotionBtn.titleLabel.font = PFRFont(11);
    [_promotionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FF9900"] radius:11];
    [_promotionBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] size:CGSizeMake(45, 22)] forState:0];
    [_promotionBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:@"#FF9900"] size:CGSizeMake(45, 22)] forState:UIControlStateSelected];
    _promotionBtn.tag = 3;
    [_promotionBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_promotionBtn];
    
    
    [self layoutIfNeeded];
}



#pragma mark - action
- (void)filtrateBtnClick:(UIButton *)button
{
    if (button.tag == 3) {
        button.selected =! button.selected;
    }
    
    if (_filtrateBlock) {
        _filtrateBlock(button.tag);
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/3);
    }];
    
    [_rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeBtn.right).offset(kScreenW/8);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(kScreenW/4);
    }];
    
    [_promotionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-20);
        make.centerY.equalTo(self.typeBtn.centerY);
        make.size.equalTo(CGSizeMake(45, 22));
    }];

}


#pragma mark - 恢复初始状态
- (void)dc_recoverInit
{
    self.typeBtn.selected = NO;
    self.rankBtn.selected = NO;
}

@end
