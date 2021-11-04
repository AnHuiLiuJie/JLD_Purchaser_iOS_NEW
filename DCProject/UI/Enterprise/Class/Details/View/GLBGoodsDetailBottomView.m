//
//  GLBGoodsDetailBottomView.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsDetailBottomView.h"

@interface GLBGoodsDetailBottomView ()

@property (nonatomic, strong) UIButton *serviceBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shoppingcarBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GLBGoodsDetailBottomView

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
    
    _serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _serviceBtn.frame = CGRectMake(0, 0, 50, 45);
    [_serviceBtn setImage:[UIImage imageNamed:@"spxq_kf"] forState:0];
    [_serviceBtn setTitle:@"客服" forState:0];
    [_serviceBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _serviceBtn.titleLabel.font = PFRFont(10);
    _serviceBtn.adjustsImageWhenHighlighted = NO;
    _serviceBtn.tag = 500;
    [_serviceBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_serviceBtn dc_buttonIconTopWithSpacing:10];
    [self addSubview:_serviceBtn];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(50, 0, 50, 45);
    [_collectBtn setImage:[UIImage imageNamed:@"spxq_sc"] forState:0];
    [_collectBtn setImage:[UIImage imageNamed:@"spxq_sch"] forState:UIControlStateSelected];
    [_collectBtn setTitle:@"收藏" forState:0];
    [_collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [_collectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _collectBtn.titleLabel.font = PFRFont(10);
    _collectBtn.adjustsImageWhenHighlighted = NO;
    _collectBtn.tag = 501;
    [_collectBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_collectBtn dc_buttonIconTopWithSpacing:10];
    [self addSubview:_collectBtn];
    
    _shoppingcarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingcarBtn.frame = CGRectMake(100, 0, 50, 45);
    [_shoppingcarBtn setImage:[UIImage imageNamed:@"spxq_gwc1"] forState:0];
    [_shoppingcarBtn setTitle:@"购物车" forState:0];
    [_shoppingcarBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _shoppingcarBtn.titleLabel.font = PFRFont(10);
    _shoppingcarBtn.adjustsImageWhenHighlighted = NO;
    _shoppingcarBtn.tag = 502;
    [_shoppingcarBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_shoppingcarBtn dc_buttonIconTopWithSpacing:10];
    [self addSubview:_shoppingcarBtn];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(150, 0, kScreenW - 150, 45);
    _addBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_addBtn setTitle:@"加入购物车" forState:0];
    [_addBtn setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
    _addBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _addBtn.tag = 503;
    [_addBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.frame = CGRectMake(CGRectGetMinX(_addBtn.frame) - 16, 0, 16, 16);
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = PFRFont(8);
    [_countLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _countLabel.text = @"0";
    _countLabel.hidden = YES;
    [self addSubview:_countLabel];
}


#pragma mark - action
- (void)bottomBtnClick:(UIButton *)button
{
    if (_bottomViewBlock) {
        _bottomViewBlock(button.tag);
    }
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    _collectBtn.selected = _detailModel.isCollected;
}


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

@end
