//
//  GLPSpikeHomeTopToolView.m
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "GLPSpikeHomeTopToolView.h"

@interface GLPSpikeHomeTopToolView ()

/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;

/* 左边Item */
@property (strong , nonatomic)UIButton *rightItemButton;

@end

@implementation GLPSpikeHomeTopToolView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
//    self.backgroundColor = [UIColor dc_colorWithHexString:@"#F2390E" alpha:1];
    _leftItemButton = ({
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    _rightItemButton = ({
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"sy_fenx"] forState:UIControlStateNormal];//dc_icon_rule sy_fenx
        [button addTarget:self action:@selector(rightButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"秒杀";
    
    [self addSubview:_titleLabel];
    [self addSubview:_leftItemButton];
    [self addSubview:_rightItemButton];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = 44;
    
    [_leftItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.mas_left).offset(0);
        make.height.equalTo(@(height));
        make.width.equalTo(@(height));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftItemButton.mas_centerY);
        make.centerX.equalTo(self);
    }];
    
    [_rightItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight+1);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@(height));
        make.width.equalTo(@(height));
    }];
    
}

- (void)wr_setBackgroundAlpha:(CGFloat)alpha {
    self.alpha = alpha;
//    self.backgroundImageView.alpha = alpha;
//    self.bottomLine.alpha = alpha;
}

#pragma 自定义左边导航Item点击
- (void)leftButtonItemClick {
    !_leftItemClickBlock ? : _leftItemClickBlock();
}

- (void)rightButtonItemClick {
    !_rightItemClickBlock ? : _rightItemClickBlock();
}


@end
