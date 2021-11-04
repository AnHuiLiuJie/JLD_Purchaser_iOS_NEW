//
//  EtpInviteTopToolView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "EtpInviteTopToolView.h"


@interface EtpInviteTopToolView ()

/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;
/* title */
@property (strong , nonatomic)UILabel *titleLabel;

@end

@implementation EtpInviteTopToolView

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
    
    _leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftItemButton setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];
    [_leftItemButton addTarget:self action:@selector(leftButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    _leftItemButton.backgroundColor = [UIColor clearColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:_leftItemButton];
    [self addSubview:_titleLabel];
}
#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = 44;
    
    [_leftItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.mas_left).offset(0);
        make.height.equalTo(@(33));
        make.width.equalTo(@(33));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftItemButton.mas_centerY);
        make.centerX.equalTo(self.mas_centerX).offset(-0);
        make.height.equalTo(@(height));
        make.width.equalTo(@(120));
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
@end
