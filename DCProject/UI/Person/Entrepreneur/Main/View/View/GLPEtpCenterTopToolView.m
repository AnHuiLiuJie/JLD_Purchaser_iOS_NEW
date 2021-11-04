//
//  GLPEtpCenterTopToolView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import "GLPEtpCenterTopToolView.h"

@interface GLPEtpCenterTopToolView ()

/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;
/* 右边Item */
@property (strong , nonatomic)UIButton *rightItemButton;

@end

@implementation GLPEtpCenterTopToolView

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
    self.backgroundColor = [UIColor clearColor];
    _leftItemButton = ({
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"创业者中心";
    
    _rightItemButton = ({
        UIButton *button = [UIButton new];
//        [button setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];//mine_whitesetting
//        [button addTarget:self action:@selector(rightButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:_rightItemButton];
    [self addSubview:_titleLabel];
    [self addSubview:_leftItemButton];
    
//    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
//    layer.frame = self.bounds;
//    layer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.15].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.05].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.03].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.01].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
//    [self.layer addSublayer:layer];
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
        make.centerY.equalTo(self.leftItemButton.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-0);
        make.height.equalTo(@(height));
        make.width.equalTo(@(height));
    }];
    
}

- (void)wr_setBackgroundAlpha:(CGFloat)alpha {
    self.alpha = alpha;
//    self.backgroundImageView.alpha = alpha;
//    self.bottomLine.alpha = alpha;
}

#pragma 自定义右边导航Item点击
- (void)rightButtonItemClick {
    !_rightItemClickBlock ? : _rightItemClickBlock();
}

#pragma 自定义左边导航Item点击
- (void)leftButtonItemClick {
    !_leftItemClickBlock ? : _leftItemClickBlock();
}
@end
