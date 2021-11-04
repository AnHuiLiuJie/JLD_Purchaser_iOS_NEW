//
//  EtpWithdrawCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "EtpWithdrawCell.h"


@interface EtpWithdrawCell ()

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *descriptionBtn;

@property (nonatomic, strong) UILabel *withdrawable_p;
@property (nonatomic, strong) UILabel *withdrawable_L;
@property (nonatomic, strong) UIView *line;

@end

@implementation EtpWithdrawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    _bottomBgView = [[UIView alloc] init];
    _bottomBgView.backgroundColor = [UIColor whiteColor];
    _bottomBgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bottomBgView];

    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn addTarget:self action:@selector(descriptionBtnAction2:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _addBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    [_addBtn setTitle:@"＋ 添加收款账户" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _addBtn.backgroundColor = [UIColor whiteColor];
    [_bottomBgView addSubview:_addBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bgView];
    
    _withdrawable_p = [[UILabel alloc] init];
    _withdrawable_p.text = @"¥**.**";
    _withdrawable_p.textColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];
    _withdrawable_p.font = [UIFont fontWithName:PFRMedium size:20];
    [_bgView addSubview:_withdrawable_p];
    _withdrawable_L = [[UILabel alloc] init];
    _withdrawable_L.text = @"可提现服务费";
    _withdrawable_L.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _withdrawable_L.font = [UIFont fontWithName:PFR size:13];
    [_bgView addSubview:_withdrawable_L];
    

    _descriptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_descriptionBtn addTarget:self action:@selector(descriptionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _descriptionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _descriptionBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    [_descriptionBtn setTitle:@"提现说明" forState:UIControlStateNormal];
    [_descriptionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FF9900"] forState:UIControlStateNormal];
    _descriptionBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FFECD0"];
    [_bgView addSubview:_descriptionBtn];
    
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:@"#E7E7E7"];
    [_bgView addSubview:_line];
}

#pragma mark - set model -
- (void)setModel:(WithDrawAmountModel *)model{
    _model = model;
    
    _withdrawable_p.text = [NSString stringWithFormat:@"¥%@",_model.withdrawAmount];
    _withdrawable_p = [UILabel setupAttributeLabel:_withdrawable_p textColor:_withdrawable_p.textColor minFont:nil maxFont:nil forReplace:@"¥"];
}

#pragma mark - 说明
- (void)descriptionBtnAction:(UIButton *)button
{
    !_etpWithdrawCellClickBlock ? : _etpWithdrawCellClickBlock();
}

- (void)descriptionBtnAction2:(UIButton *)button
{
    !_etpWithdrawAddCellClickBlock ? : _etpWithdrawAddCellClickBlock();
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat spacing1 = 1;
    CGFloat view_w = self.dc_width;
    
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.top).offset(5);
        make.right.equalTo(self.right).offset(-15);
        make.height.equalTo(40);
    }];

    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBgView.left);
        make.right.equalTo(self.bottomBgView.right);
        make.top.equalTo(self.bottomBgView.top);
        make.bottom.equalTo(self.bottomBgView.bottom);
    }];

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBgView.left);
        make.right.equalTo(self.bottomBgView.right);
        make.top.equalTo(self.bottomBgView.bottom).offset(5);
        make.bottom.equalTo(self.bottom);
    }];
    
    [_withdrawable_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.bgView).offset(20);
        make.size.equalTo(CGSizeMake(view_w-90, 30));
    }];
    
    [_withdrawable_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawable_p.left).offset(0);
        make.top.equalTo(self.withdrawable_p.bottom).offset(spacing1);
        make.size.equalTo(CGSizeMake(view_w-90, 25));
    }];
    
    [_descriptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(25);
        make.right.equalTo(self.bgView.right);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom);
        make.height.equalTo(1);
    }];
    
    [DCSpeedy dc_changeControlCircularWith:_bottomBgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    
    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_descriptionBtn byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft size:CGSizeMake(10, _descriptionBtn.dc_height/2)];
    
    [_bgView dc_cornerRadius:10 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
