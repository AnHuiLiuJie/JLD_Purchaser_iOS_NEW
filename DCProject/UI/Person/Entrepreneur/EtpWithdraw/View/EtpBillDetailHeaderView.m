//
//  EtpBillDetailHeaderView.m
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "EtpBillDetailHeaderView.h"

@interface EtpBillDetailHeaderView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *incomeAmountL;
@property (nonatomic, strong) UILabel *incomeAmountP;

@property (nonatomic, strong) UILabel *extendAmountL;
@property (nonatomic, strong) UILabel *extendAmountP;

@property (nonatomic, strong) UILabel *taxAmountL;
@property (nonatomic, strong) UILabel *taxAmountP;
@property (nonatomic, strong) UIImageView *taxAmountImg;


@end

@implementation EtpBillDetailHeaderView

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
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    [self addSubview:_bgView];
    
    _incomeAmountL = [[UILabel alloc] init];
    _incomeAmountL.text = @"¥**.**";
    _incomeAmountL.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _incomeAmountL.font = [UIFont fontWithName:PFRMedium size:18];
    _incomeAmountL.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_incomeAmountL];
    _incomeAmountP = [[UILabel alloc] init];
    _incomeAmountP.text = @"*月服务费";
    _incomeAmountP.textColor = [UIColor dc_colorWithHexString:@"#F0F0F0"];
    _incomeAmountP.font = [UIFont fontWithName:PFRMedium size:12];
    _incomeAmountP.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_incomeAmountP];
    
    _extendAmountL = [[UILabel alloc] init];
    _extendAmountL.text = @"¥**.**";
    _extendAmountL.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _extendAmountL.font = [UIFont fontWithName:PFRMedium size:15];
    _extendAmountL.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_extendAmountL];
    _extendAmountP = [[UILabel alloc] init];
    _extendAmountP.text = @"*月结算总计";
    _extendAmountP.textColor = [UIColor dc_colorWithHexString:@"#F0F0F0"];
    _extendAmountP.font = [UIFont fontWithName:PFRMedium size:12];
    _extendAmountP.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_extendAmountP];
    
    _taxAmountL = [[UILabel alloc] init];
    _taxAmountL.text = @"¥**.**";
    _taxAmountL.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _taxAmountL.font = [UIFont fontWithName:PFRMedium size:15];
    _taxAmountL.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_taxAmountL];
    _taxAmountP = [[UILabel alloc] init];
    _taxAmountP.text = @"*代缴个税";
    _taxAmountP.textColor = [UIColor dc_colorWithHexString:@"#F0F0F0"];
    _taxAmountP.font = [UIFont fontWithName:PFRMedium size:12];
    _taxAmountP.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_taxAmountP];
    _taxAmountImg = [[UIImageView alloc] init];
    [_taxAmountImg setImage:[UIImage imageNamed:@"etp_gth"]];
    [_bgView addSubview:_taxAmountImg];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _taxAmountImg.userInteractionEnabled = YES;
    [_taxAmountImg addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _taxAmountP.userInteractionEnabled = YES;
    [_taxAmountP addGestureRecognizer:tapGesture2];
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    !_EtpBillDetailHeaderViewClickBlock ? : _EtpBillDetailHeaderViewClickBlock();
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 15, 5, 15));
    }];
    
    [_incomeAmountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top).offset(10);
        make.left.equalTo(self.bgView.left).offset(15);
        make.height.equalTo(30);
    }];
    
    [_incomeAmountP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.incomeAmountL.bottom);
        make.left.equalTo(self.incomeAmountL.right).offset(8);
        make.height.equalTo(25);
    }];
    
    [_extendAmountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.incomeAmountL.bottom).offset(10);
        make.left.equalTo(self.incomeAmountL.left);
        make.height.equalTo(20);
    }];
    
    [_extendAmountP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.extendAmountL.bottom).offset(0);
        make.left.equalTo(self.extendAmountL.left);
        make.height.equalTo(self.incomeAmountL.height);
    }];
    
    [_taxAmountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.extendAmountL.top);
        make.left.equalTo(self.left).offset(self.dc_width/2-15);
        make.height.equalTo(self.incomeAmountL.height);
    }];
    
    [_taxAmountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taxAmountL.bottom).offset(0);
        make.left.equalTo(self.taxAmountL.left);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    
    [_taxAmountP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.taxAmountImg.centerY);
        make.left.equalTo(self.taxAmountImg.right).offset(5);
        make.height.equalTo(self.incomeAmountL.height);
    }];
}

#pragma mark - set
-(void)setModel:(EtpBillListModel *)model{
    _model  = model;
    
    NSString *title1 = [NSString stringWithFormat:@"¥%@",model.incomeAmount];
    _incomeAmountL.text = title1;
    _incomeAmountL = [UILabel setupAttributeLabel:_incomeAmountL textColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] minFont:[UIFont fontWithName:PFR size:12] maxFont:nil forReplace:@"¥"];
    _incomeAmountP.text = [NSString stringWithFormat:@"%@服务费",[NSString getFirstNoZoneStr:model.month]];
    
    NSString *title2 = [NSString stringWithFormat:@"¥%@",model.extendAmount];
    _extendAmountL.text = title2;
    _extendAmountL = [UILabel setupAttributeLabel:_extendAmountL textColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] minFont:[UIFont fontWithName:PFR size:12] maxFont:nil forReplace:@"¥"];
    _extendAmountP.text = [NSString stringWithFormat:@"%@月结算总计",[NSString getFirstNoZoneStr:model.month]];
    
    NSString *title3 = [NSString stringWithFormat:@"¥%@",model.taxAmount];
    _taxAmountL.text = title3;
    _taxAmountL = [UILabel setupAttributeLabel:_taxAmountL textColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] minFont:[UIFont fontWithName:PFR size:12] maxFont:nil forReplace:@"¥"];
    _taxAmountP.text = [NSString stringWithFormat:@"%@代缴个税",@""];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
