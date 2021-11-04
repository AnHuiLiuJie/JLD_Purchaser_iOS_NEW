//
//  EtpWithdrawHeaderView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "EtpWithdrawHeaderView.h"

@interface EtpWithdrawHeaderView ()

@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong) UILabel *bankNaneLab;
@property (nonatomic, strong) UILabel *cardNumLab;

@property (nonatomic, strong) UIImageView *cardImg;
@property (nonatomic, strong) UIImageView *arrowImg;

@end

@implementation EtpWithdrawHeaderView

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
    
    _cardImg = [[UIImageView alloc] init];
    [_cardImg setImage:[UIImage imageNamed:@"etp_center_card"]];
    [_bgView addSubview:_cardImg];
    
    _bankNaneLab = [[UILabel alloc] init];
    _bankNaneLab.text = @"银行名称";
    _bankNaneLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _bankNaneLab.font = [UIFont fontWithName:PFRMedium size:15];
    [_bgView addSubview:_bankNaneLab];
    
    _cardNumLab = [[UILabel alloc] init];
    _cardNumLab.text = @"尾号****";
    _cardNumLab.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _cardNumLab.font = [UIFont fontWithName:PFR size:13];
    [_bgView addSubview:_cardNumLab];
    
    _arrowImg = [[UIImageView alloc] init];
    [_arrowImg setImage:[UIImage imageNamed:@"dc_arrow_right_xihui"]];
    [_bgView addSubview:_arrowImg];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _bgView.userInteractionEnabled = YES;
    [_bgView addGestureRecognizer:tapGesture1];
}

#pragma mark - set model -
- (void)setModel:(EtpBankCardListModel *)model{
    
    _model = model;
    
    _bankNaneLab.text = _model.bankName;
    
    if (_model.bankAccount.length > 4) {
        _cardNumLab.text = [NSString stringWithFormat:@"%@ **** %@",[_model.bankAccount substringToIndex:4],[_model.bankAccount substringFromIndex:_model.bankAccount.length-4]];
    }
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    !_etpWithdrawHeaderViewClickBlock ? : _etpWithdrawHeaderViewClickBlock(@"");
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 5, 15));
    }];
    
    [_cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.centerY.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(42, 27));
    }];
    
    [_bankNaneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImg.right).offset(10);
        make.centerY.equalTo(self.bgView).offset(-10);
        make.right.equalTo(self.bgView.right).offset(-30);
    }];
    
    [_cardNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankNaneLab.left);
        make.top.equalTo(self.bankNaneLab.bottom);
        make.right.equalTo(self.bgView.right).offset(-30);
    }];
    
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-12);
        make.centerY.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(6, 11));
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
