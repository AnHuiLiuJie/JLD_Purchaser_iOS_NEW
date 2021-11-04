//
//  GLPGroupHomeTopToolView.m
//  DCProject
//
//  Created by LiuMac on 2021/9/26.
//

#import "GLPGroupHomeTopToolView.h"

@interface GLPGroupHomeTopToolView ()

/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;

/* 右边Item */
@property (strong , nonatomic)UIButton *rightItemButton;

/* 右边Item */
@property (strong , nonatomic)UIButton *rightItemButton2;
@end

@implementation GLPGroupHomeTopToolView

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
        button.tag = 1;
        [button setImage:[UIImage imageNamed:@"sy_fenx"] forState:UIControlStateNormal];//dc_icon_rule
        [button addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
//    _rightItemButton2 = ({
//        UIButton *button = [UIButton new];
//        button.tag = 2;
//        [button setImage:[UIImage imageNamed:@"dc_icon_rule"] forState:UIControlStateNormal];//dc_icon_rule
//        [button addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
//        button;
//    });
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"拼团";
    
    [self addSubview:_titleLabel];
    [self addSubview:_leftItemButton];
    [self addSubview:_rightItemButton];
    //[self addSubview:_rightItemButton2];
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
    
//    [_rightItemButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.rightItemButton.mas_left).offset(10);
//        make.centerY.equalTo(self.rightItemButton.centerY);
//        make.size.equalTo(self.rightItemButton);
//    }];
    
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

- (void)rightButtonItemClick:(UIButton *)button {
    !_rightItemClickBlock ? : _rightItemClickBlock(button.tag);
}


@end
