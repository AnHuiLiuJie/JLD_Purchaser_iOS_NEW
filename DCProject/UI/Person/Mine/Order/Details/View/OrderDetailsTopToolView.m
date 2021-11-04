//
//  OrderDetailsTopToolView.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "OrderDetailsTopToolView.h"

@interface OrderDetailsTopToolView ()

/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;
/* 右边Item */
@property (strong , nonatomic)UIButton *rightItemButton;
@property (strong , nonatomic)UILabel *msgCountLabel;

@end

@implementation OrderDetailsTopToolView

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
    _titleLabel.text = @"订单详情";
    
    _rightItemButton = ({
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"dianpuxiangqzhankai"] forState:UIControlStateNormal];//mine_whitesetting
        [button addTarget:self action:@selector(rightButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    _msgCountLabel = [[UILabel alloc] init];
    _msgCountLabel.backgroundColor = [UIColor whiteColor];
    _msgCountLabel.font = PFRFont(10);
    _msgCountLabel.textColor = [UIColor dc_colorWithHexString:@"#FC4516"];
    _msgCountLabel.textAlignment = NSTextAlignmentCenter;
    [_msgCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:9];
    _msgCountLabel.text = @"0";
    _msgCountLabel.hidden = YES;
    [self addSubview:_msgCountLabel];
    
    [self addSubview:_rightItemButton];
    [self addSubview:_titleLabel];
    [self addSubview:_leftItemButton];
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
        make.left.equalTo(self.leftItemButton.mas_right).offset(0);
        //make.centerX.equalTo(self);
    }];
    
    [_rightItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftItemButton.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-0);
        make.height.equalTo(@(height));
        make.width.equalTo(@(height));
    }];
    
    [_msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightItemButton.centerX);
        make.top.equalTo(self.rightItemButton.top);
        make.size.equalTo(CGSizeMake(18, 18));
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

#pragma mark - setter
- (void)setCount:(NSInteger)count
{
    _count = count;
    
    NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
    long unreadCount = 0;
    for (HDConversation *conv in hConversations) {
        unreadCount += conv.unreadMessagesCount;
    }
    
    if (_count + unreadCount > 0) {
        _msgCountLabel.hidden = NO;
        _msgCountLabel.text = [NSString stringWithFormat:@"%ld",_count + unreadCount];
    } else {
        _msgCountLabel.hidden = YES;
    }
}


@end
