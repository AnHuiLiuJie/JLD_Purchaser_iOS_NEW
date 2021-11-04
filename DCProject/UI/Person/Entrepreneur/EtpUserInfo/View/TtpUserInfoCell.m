//
//  TtpUserInfoCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "TtpUserInfoCell.h"

@interface TtpUserInfoCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *name_p;//placeholder
@property (nonatomic, strong) UITextField *name_tf;
@property (nonatomic, strong) UILabel *phone_p;
@property (nonatomic, strong) UITextField *phone_tf;
@property (nonatomic, strong) UILabel *identity_p;
@property (nonatomic, strong) UITextField *identity_tf;
@property (nonatomic, strong) UILabel *wx_p;
@property (nonatomic, strong) UITextField *wx_tf;
@property (nonatomic, strong) UILabel *area_p;
@property (nonatomic, strong) UITextField *area_tf;

@end


@implementation TtpUserInfoCell

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

    _name_p = [[UILabel alloc] init];
    _name_p.text = @"真实姓名";
    _name_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _name_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_name_p];
    _name_tf = [[UITextField alloc] init];
    _name_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _name_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _name_tf.text = @"******";
    _name_tf.enabled = NO;
    [_name_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_name_tf];
    
    _phone_p = [[UILabel alloc] init];
    _phone_p.text = @"联系电话";
    _phone_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _phone_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_phone_p];
    _phone_tf = [[UITextField alloc] init];
    _phone_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _phone_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _phone_tf.text = @"************";
    _phone_tf.enabled = NO;
    [_phone_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_phone_tf];
    
    _identity_p = [[UILabel alloc] init];
    _identity_p.text = @"身份证号";
    _identity_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _identity_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_identity_p];
    _identity_tf = [[UITextField alloc] init];
    _identity_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _identity_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _identity_tf.text = @"************************";
    _identity_tf.enabled = NO;
    [_identity_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_identity_tf];
    
    _wx_p = [[UILabel alloc] init];
    _wx_p.text = @"微信号";
    _wx_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _wx_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_wx_p];
    _wx_tf = [[UITextField alloc] init];
    _wx_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _wx_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _wx_tf.text = @"******";
    _wx_tf.enabled = NO;
    [_wx_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_wx_tf];
    
    _area_p = [[UILabel alloc] init];
    _area_p.text = @"所在地区";
    _area_p.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _area_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_area_p];
    _area_tf = [[UITextField alloc] init];
    _area_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _area_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _area_tf.text = @"******";
    _area_tf.enabled = NO;
    [_area_tf setBorderStyle:UITextBorderStyleNone]; //外框类型
    [_bgView addSubview:_area_tf];

}

#pragma mark - set
- (void)setUserInfoModel:(EntrepreneurInfoModel *)userInfoModel{
    _userInfoModel = userInfoModel;
    
    _name_tf.text = _userInfoModel.userName;
    _phone_tf.text = _userInfoModel.cellphone;
    _identity_tf.text = _userInfoModel.idCard;
    _wx_tf.text = _userInfoModel.wechat;
    _area_tf.text = _userInfoModel.areaName;
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    [_name_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(8);
        make.top.equalTo(self.bgView).offset(10);
        make.size.equalTo(CGSizeMake(90, 40));
    }];
    
    [_name_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_p.right).offset(5);
        make.centerY.equalTo(self.name_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.name_p);
    }];
    
    [_phone_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_p.left);
        make.top.equalTo(self.name_p.bottom).offset(0);
        make.size.equalTo(self.name_p);
    }];
    
    [_phone_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_tf.left);
        make.centerY.equalTo(self.phone_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.name_p);
    }];
    
    
    [_identity_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_p.left);
        make.top.equalTo(self.phone_p.bottom).offset(0);
        make.size.equalTo(self.name_p);
    }];
    
    [_identity_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_tf.left);
        make.centerY.equalTo(self.identity_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.name_p);
    }];
    
    [_wx_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_p.left);
        make.top.equalTo(self.identity_p.bottom).offset(0);
        make.size.equalTo(self.name_p);
    }];
    
    [_wx_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_tf.left);
        make.centerY.equalTo(self.wx_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.name_p);
    }];
    
    [_area_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_p.left);
        make.top.equalTo(self.wx_p.bottom).offset(0);
        make.size.equalTo(self.name_p);
    }];
    
    [_area_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_tf.left);
        make.centerY.equalTo(self.area_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.name_p);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
