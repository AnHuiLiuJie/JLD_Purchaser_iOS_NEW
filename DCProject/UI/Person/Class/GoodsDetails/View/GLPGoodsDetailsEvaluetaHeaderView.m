//
//  GLPGoodsDetailsEvaluetaHeaderVIew.m
//  DCProject
//
//  Created by bigbing on 2019/8/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsEvaluetaHeaderView.h"

static CGFloat cell_spacing_x = 0;
static CGFloat cell_spacing_y = 0;
static CGFloat cell_spacing_h = 44;
//static CGFloat view_spacing_y = 5;

@interface GLPGoodsDetailsEvaluetaHeaderView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *haopinLabel;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation GLPGoodsDetailsEvaluetaHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    //[_bgView dc_cornerRadius:cell_spacing_x];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.text = @"商品评价";
    [_bgView addSubview:_titleLabel];
    
    _haopinLabel = [[UILabel alloc] init];
    _haopinLabel.textColor = [UIColor dc_colorWithHexString:@"#FF330E"];
    _haopinLabel.font = [UIFont fontWithName:PFR size:14];
    _haopinLabel.text = @"";
    [_bgView addSubview:_haopinLabel];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setTitle:@"0条" forState:0];
    [_moreBtn setTitleColor:[UIColor dc_colorWithHexString:@"#A5A4A4"] forState:0];
    _moreBtn.titleLabel.font = PFRFont(14);
    [_moreBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xihui"] forState:0];
    _moreBtn.adjustsImageWhenHighlighted = NO;
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _moreBtn.bounds = CGRectMake(0, 0, 100, 30);
    [_moreBtn dc_buttonIconRightWithSpacing:10];
    [_bgView addSubview:_moreBtn];
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.centerY.equalTo(self.bgView.centerY);
    }];
    
    [_haopinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(2);
        make.centerY.equalTo(self.titleLabel.centerY);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.width.equalTo(CGSizeMake(100, 35));
    }];
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
    
}


#pragma mark - setter
- (void)setEvaluateModel:(GLPGoodsEvaluateModel *)evaluateModel
{
    _evaluateModel = evaluateModel;
    
    if (_evaluateModel.evalList.count == 0) {
        _titleLabel.text = @"暂时无评价";
        _moreBtn.hidden = YES;
    }else{
        _titleLabel.text = @"商品评价";
        _moreBtn.hidden = NO;

        [_moreBtn setTitle:[NSString stringWithFormat:@"%ld条",_evaluateModel.evalCount] forState:0];
        _haopinLabel.text = [NSString stringWithFormat:@"平均评分%.2f",_evaluateModel.praiseRate];
        if (_evaluateModel.praiseRate==0)
        {
            _haopinLabel.hidden = YES;
        }
        else{
             _haopinLabel.hidden = NO;
        }
    }
}

@end
