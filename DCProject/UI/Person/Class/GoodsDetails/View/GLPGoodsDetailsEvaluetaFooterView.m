//
//  GLPGoodsDetailsEvaluetaFooterView.m
//  DCProject
//
//  Created by bigbing on 2019/8/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsEvaluetaFooterView.h"

static CGFloat cell_spacing_x = 0;
static CGFloat cell_spacing_y = 0;
static CGFloat cell_spacing_h = 70;

@interface GLPGoodsDetailsEvaluetaFooterView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation GLPGoodsDetailsEvaluetaFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setTitle:@"查看全部评价" forState:0];
    [_moreBtn setTitleColor:[UIColor dc_colorWithHexString:@"#A5A4A4"] forState:0];
    _moreBtn.titleLabel.font = PFRFont(12);
    [_moreBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xh"] forState:0];
    _moreBtn.adjustsImageWhenHighlighted = NO;
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.bounds = CGRectMake(0, 0, 100, 34);
    [_moreBtn dc_buttonIconRightWithSpacing:3];
    [_moreBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#DEDEDE"] radius:17];
    [self.contentView addSubview:_moreBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)moreBtnClick:(UIButton *)button
{
    if (_allEvaluateBlock) {
        _allEvaluateBlock();
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];

    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.centerX.equalTo(self.bgView.centerX);
        make.size.equalTo(CGSizeMake(100, 34));
    }];
}


@end
