//
//  EtpApplicationCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/15.
//

#import "EtpApplicationCell.h"
@interface EtpApplicationCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *name_p;//placeholder
@property (nonatomic, strong) UILabel *phone_p;
@property (nonatomic, strong) UILabel *identity_p;
@property (nonatomic, strong) UILabel *wx_p;
@property (nonatomic, strong) UILabel *area_p;




@end

@implementation EtpApplicationCell

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
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    //[DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    [self.contentView addSubview:_bgView];

    _name_p = [[UILabel alloc] init];
    _name_p.text = @"真实姓名";
    _name_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _name_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_name_p];
    _name_tf = [[UITextField alloc] init];
    _name_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _name_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _name_tf.placeholder = @"请填写真实姓名";
    _name_tf.keyboardType = UIKeyboardTypeDefault;
    [_name_tf addTarget:self action:@selector(name_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_name_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_bgView addSubview:_name_tf];
    
    _phone_p = [[UILabel alloc] init];
    _phone_p.text = @"联系电话";
    _phone_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _phone_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_phone_p];
    _phone_tf = [[DCTextField alloc] init];
    _phone_tf.type = DCTextFieldTypeTelePhone;
    _phone_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _phone_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _phone_tf.placeholder = @"请输入联系电话";
    _phone_tf.keyboardType = UIKeyboardTypePhonePad;
    [_phone_tf addTarget:self action:@selector(phone_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phone_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_bgView addSubview:_phone_tf];
    
    _identity_p = [[UILabel alloc] init];
    _identity_p.text = @"身份证号";
    _identity_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _identity_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_identity_p];
    _identity_tf = [[DCTextField alloc] init];
    _identity_tf.type = DCTextFieldTypeIDCard;
    _identity_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _identity_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _identity_tf.placeholder = @"请输入真实的身份证号";
    _identity_tf.keyboardType = UIKeyboardTypeASCIICapable;
    [_identity_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_identity_tf addTarget:self action:@selector(identity_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_identity_tf];
    
    _wx_p = [[UILabel alloc] init];
    _wx_p.text = @"微信号";
    _wx_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _wx_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_wx_p];
    _wx_tf = [[UITextField alloc] init];
    _wx_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _wx_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _wx_tf.placeholder = @"请填写微信号";
    _wx_tf.keyboardType = UIKeyboardTypeASCIICapable;
    [_wx_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [_wx_tf addTarget:self action:@selector(wx_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_wx_tf];
    

    _area_p = [[UILabel alloc] init];
    _area_p.text = @"所在地区";
    _area_p.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _area_p.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_area_p];
    _area_tf = [[UITextField alloc] init];
    _area_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _area_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _area_tf.placeholder = @"请选择所在地区";
    _area_tf.keyboardType = UIKeyboardTypeDefault;
    [_area_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    _area_tf.delegate = self;
    [_bgView addSubview:_area_tf];

}

#pragma mark - set
- (void)setModel:(EntrepreneurInfoModel *)model{
    _model = model;
    if (_model == nil) {
        return;
    }
    
    _name_tf.text = _model.userName;
    _phone_tf.text = _model.cellphone;
    _identity_tf.text = _model.idCard;
    _wx_tf.text = _model.wechat;
    _area_tf.text = _model.areaName;
}


#pragma mark - private method
- (void)name_tfDidChange:(UITextField *)textField
{
    [DCSpeedy editChange:textField length:20];
    if (textField.text.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"姓名限制20个字符"];
    }
    !_etpApplicationCell_name_tf_block ? : _etpApplicationCell_name_tf_block(textField.text);
}

- (void)phone_tfDidChange:(UITextField *)textField
{
    if (textField.text.length > 11) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:11];
    }
    !_etpApplicationCell_phone_tf_block ? : _etpApplicationCell_phone_tf_block(textField.text);
}

- (void)identity_tfDidChange:(UITextField *)textField
{
    if (textField.text.length > 18) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:18];
    }
    !_etpApplicationCell_identity_tf_block ? : _etpApplicationCell_identity_tf_block(textField.text);
}

- (void)wx_tfDidChange:(UITextField *)textField
{
    if (textField.text.length > 30) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:30];
        [SVProgressHUD showInfoWithStatus:@"请输入有效微信"];
    }
    !_etpApplicationCell_wx_tf_block ? : _etpApplicationCell_wx_tf_block(textField.text);
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    !_etpApplicationCell_area_tf_block ? : _etpApplicationCell_area_tf_block(textField.text);
    return NO;
}

#pragma mark - 选择地区


#pragma mark - set

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat spacing1 = 10;

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 5, 15, 5));
    }];
    
    [_name_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(8);
        make.top.equalTo(self.bgView).offset(10);
        make.size.equalTo(CGSizeMake(75, 40));
    }];
    
    [_name_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_p.right).offset(5);
        make.centerY.equalTo(self.name_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.name_p);
    }];
    
    [_phone_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_p.left);
        make.top.equalTo(self.name_p.bottom).offset(spacing1);
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
        make.top.equalTo(self.phone_p.bottom).offset(spacing1);
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
        make.top.equalTo(self.identity_p.bottom).offset(spacing1);
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
        make.top.equalTo(self.wx_p.bottom).offset(spacing1);
        make.size.equalTo(self.name_p);
    }];
    
    [_area_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_tf.left);
        make.centerY.equalTo(self.area_p);
        make.right.equalTo(self.bgView);
        make.height.equalTo(self.name_p);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
