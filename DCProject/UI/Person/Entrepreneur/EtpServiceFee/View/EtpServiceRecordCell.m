//
//  EtpServiceRecordCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "EtpServiceRecordCell.h"

@interface EtpServiceRecordCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *totalFee_p;//placeholder
@property (nonatomic, strong) UITextField *totalFee_tf;
@property (nonatomic, strong) UILabel *pending_p;
@property (nonatomic, strong) UITextField *pending_tf;
@property (nonatomic, strong) UILabel *closed_p;
@property (nonatomic, strong) UITextField *closed_tf;
@property (nonatomic, strong) UILabel *invalid_p;
@property (nonatomic, strong) UITextField *invalid_tf;
@property (nonatomic, strong) UILabel *withdrawable_p;
@property (nonatomic, strong) UITextField *withdrawable_tf;
@property (nonatomic, strong) UILabel *withdrawn_p;
@property (nonatomic, strong) UITextField *withdrawn_tf;

@end

@implementation EtpServiceRecordCell

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
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    [self.contentView addSubview:_bgView];

    _totalFee_p = [[UILabel alloc] init];
    _totalFee_p.text = @"累计服务费";
    _totalFee_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _totalFee_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_totalFee_p];
    _totalFee_tf = [[UITextField alloc] init];
    _totalFee_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _totalFee_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _totalFee_tf.text = @"00.00";
    _totalFee_tf.enabled = NO;
    [_totalFee_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_totalFee_tf];
    
    _pending_p = [[UILabel alloc] init];
    _pending_p.text = @"待结算服务费";
    _pending_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _pending_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_pending_p];
    _pending_tf = [[UITextField alloc] init];
    _pending_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _pending_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _pending_tf.text = @"¥00.00";
    _pending_tf.enabled = NO;
    [_pending_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_pending_tf];
    
    _closed_p = [[UILabel alloc] init];
    _closed_p.text = @"已结算服务费";
    _closed_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _closed_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_closed_p];
    _closed_tf = [[UITextField alloc] init];
    _closed_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _closed_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _closed_tf.text = @"¥00.00";
    _closed_tf.enabled = NO;
    [_closed_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_closed_tf];
    
    _invalid_p = [[UILabel alloc] init];
    _invalid_p.text = @"无效服务费";
    _invalid_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _invalid_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_invalid_p];
    _invalid_tf = [[UITextField alloc] init];
    _invalid_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _invalid_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _invalid_tf.text = @"¥00.00";
    _invalid_tf.enabled = NO;
    [_invalid_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_invalid_tf];
    
    _withdrawable_p = [[UILabel alloc] init];
    _withdrawable_p.text = @"可提现服务费";
    _withdrawable_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _withdrawable_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_withdrawable_p];
    _withdrawable_tf = [[UITextField alloc] init];
    _withdrawable_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _withdrawable_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _withdrawable_tf.text = @"¥00.00";
    _withdrawable_tf.enabled = NO;
    [_withdrawable_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_withdrawable_tf];
    
    _withdrawn_p = [[UILabel alloc] init];
    _withdrawn_p.text = @"已提现服务费";
    _withdrawn_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _withdrawn_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_withdrawn_p];
    _withdrawn_tf = [[UITextField alloc] init];
    _withdrawn_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _withdrawn_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _withdrawn_tf.text = @"¥00.00";
    _withdrawn_tf.enabled = NO;
    [_withdrawn_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_withdrawn_tf];
}

#pragma mark - set model -
- (void)setModel:(PioneerServiceFeeModel *)model{
    _model = model;
    _totalFee_tf.text = [NSString stringWithFormat:@"¥%@",_model.totalFee];
    _pending_tf.text = [NSString stringWithFormat:@"¥%@",_model.noSettleFee];
    _closed_tf.text = [NSString stringWithFormat:@"¥%@",_model.settleFee];
    _invalid_tf.text = [NSString stringWithFormat:@"¥%@",_model.failFee];
    _withdrawable_tf.text = [NSString stringWithFormat:@"¥%@",_model.canWithdrawFee];
    _withdrawn_tf.text = [NSString stringWithFormat:@"¥%@",_model.withdrawFee];
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    [_totalFee_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(8);
        make.top.equalTo(self.bgView).offset(10);
        make.size.equalTo(CGSizeMake(110, 40));
    }];
    
    [_totalFee_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_p.right).offset(5);
        make.centerY.equalTo(self.totalFee_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.totalFee_p);
    }];
    
    [_pending_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_p.left);
        make.top.equalTo(self.totalFee_p.bottom).offset(0);
        make.size.equalTo(self.totalFee_p);
    }];
    
    [_pending_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_tf.left);
        make.centerY.equalTo(self.pending_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.totalFee_p);
    }];
    
    
    [_closed_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_p.left);
        make.top.equalTo(self.pending_p.bottom).offset(0);
        make.size.equalTo(self.totalFee_p);
    }];
    
    [_closed_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_tf.left);
        make.centerY.equalTo(self.closed_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.totalFee_p);
    }];
    
    [_invalid_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_p.left);
        make.top.equalTo(self.closed_p.bottom).offset(0);
        make.size.equalTo(self.totalFee_p);
    }];
    
    [_invalid_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_tf.left);
        make.centerY.equalTo(self.invalid_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.totalFee_p);
    }];
    
    [_withdrawable_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_p.left);
        make.top.equalTo(self.invalid_p.bottom).offset(0);
        make.size.equalTo(self.totalFee_p);
    }];
    
    [_withdrawable_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_tf.left);
        make.centerY.equalTo(self.withdrawable_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.totalFee_p);
    }];
    
    [_withdrawn_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_p.left);
        make.top.equalTo(self.withdrawable_p.bottom).offset(0);
        make.size.equalTo(self.totalFee_p);
    }];
    
    [_withdrawn_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalFee_tf.left);
        make.centerY.equalTo(self.withdrawn_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.totalFee_p);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
