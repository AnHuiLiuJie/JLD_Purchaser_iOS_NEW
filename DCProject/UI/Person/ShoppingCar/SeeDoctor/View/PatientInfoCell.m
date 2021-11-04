//
//  PatientInfoCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "PatientInfoCell.h"

@interface PatientInfoCell ()


@end

@implementation PatientInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

- (void)setViewUI
{
//    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(10, 1)];
    

    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    
    _name_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _name_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _name_tf.placeholder = @"请输入用药人真实姓名";
    _name_tf.keyboardType = UIKeyboardTypeDefault;
    [_name_tf addTarget:self action:@selector(name_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_name_tf setBorderStyle:UITextBorderStyleNone];
    
    _idCar_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _idCar_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _idCar_tf.placeholder = @"请请输入用药人身份证号码";
    _idCar_tf.keyboardType = UIKeyboardTypeASCIICapable;
    [_idCar_tf addTarget:self action:@selector(identity_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_idCar_tf setBorderStyle:UITextBorderStyleNone];
    
    _weight_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _weight_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _weight_tf.placeholder = @"请填写体重，单位是公斤";
    _weight_tf.keyboardType = UIKeyboardTypeDecimalPad;
    [_weight_tf addTarget:self action:@selector(weight_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_weight_tf setBorderStyle:UITextBorderStyleNone];
    
    _tel_tf.font = [UIFont fontWithName:PFRMedium size:14];
    _tel_tf.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _tel_tf.placeholder = @"用于接收购药信息，请准确填写";
    _tel_tf.keyboardType = UIKeyboardTypePhonePad;
    [_tel_tf addTarget:self action:@selector(tel_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tel_tf setBorderStyle:UITextBorderStyleNone];
    
    _tapBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _tapBgView.userInteractionEnabled = YES;
    [_tapBgView addGestureRecognizer:tapGesture1];

    _promptLine.hidden = YES;
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{

//    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(0.01, 1)];
//    _promptLine.hidden = NO;
    
    !_PatientInfoCell_Block ? : _PatientInfoCell_Block(self.model);
}

#pragma make - set
-(void)setModel:(MedicalPersListModel *)model{
    _model = model;
    _name_tf.text = model.patientName;
    
    _idCar_tf.text = model.idCard;
    
    _weight_tf.text = model.weight;
    
    _tel_tf.text = model.patientTel;
}

#pragma mark - private method
- (void)name_tfDidChange:(UITextField *)textField{
    [DCSpeedy editChange:textField length:20];
    if (textField.text.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"输入正确的姓名"];
    }
    !_PatientInfoCell_block ? : _PatientInfoCell_block(textField.text,1);
}

- (void)identity_tfDidChange:(UITextField *)textField
{
    if (textField.text.length > 18) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:18];
    }
    !_PatientInfoCell_block ? : _PatientInfoCell_block(textField.text,2);
}

- (void)weight_tfDidChange:(UITextField *)textField{
    if (textField.text.length > 10) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:10];
    }
    !_PatientInfoCell_block ? : _PatientInfoCell_block(textField.text,3);
}

- (void)tel_tfDidChange:(UITextField *)textField{
    if (textField.text.length > 11) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:11];
    }
    !_PatientInfoCell_block ? : _PatientInfoCell_block(textField.text,4);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
