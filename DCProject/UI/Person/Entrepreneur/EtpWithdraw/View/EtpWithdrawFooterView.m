//
//  EtpWithdrawFooterView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "EtpWithdrawFooterView.h"

@interface EtpWithdrawFooterView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation EtpWithdrawFooterView

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
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    [self addSubview:_bgView];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.text = @"＋ 添加收款账户";
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLab];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _bgView.userInteractionEnabled = YES;
    [_bgView addGestureRecognizer:tapGesture1];
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    !_etpWithdrawFooterViewClickBlock ? : _etpWithdrawFooterViewClickBlock(@"");
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 15, 5, 15));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
