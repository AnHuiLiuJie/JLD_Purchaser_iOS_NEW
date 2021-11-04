//
//  PatientListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/10.
//

#import "PatientListCell.h"

@implementation PatientListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

#pragma mark viewUI
- (void)setViewUI{
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _relationLab.textColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    _relationLab.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
    [DCSpeedy dc_changeControlCircularWith:_relationLab AndSetCornerRadius:_relationLab.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
    
    
    _isDefaultLab.textColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    _isDefaultLab.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
    [DCSpeedy dc_changeControlCircularWith:_isDefaultLab AndSetCornerRadius:_isDefaultLab.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
    
    _authenticateLab.textColor = [UIColor dc_colorWithHexString:@"#4CC268"];
    _authenticateLab.backgroundColor = [UIColor dc_colorWithHexString:@"#D9FDDD"];
    [DCSpeedy dc_changeControlCircularWith:_authenticateLab AndSetCornerRadius:_authenticateLab.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#4CC268"] canMasksToBounds:YES];
    
    [DCSpeedy dc_changeControlCircularWith:self.bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];


}

#pragma mark action
- (void)deleteAction:(UIButton *)button{
    !_PatientListCellDel_block ? : _PatientListCellDel_block();
}

- (void)editAction:(UIButton *)button{
    !_PatientListCellEid_block ? : _PatientListCellEid_block();
}

#pragma mark set
- (void)setModel:(MedicalPersListModel *)model{
    _model = model;
    
    _nameLab.text = model.patientName;
    NSString *patientGender = [model.patientGender isEqualToString:@"1"] ? @"男" : @"女";
    NSString *patientTel = model.patientTel;
    if (_model.patientTel.length > 4) {
        patientTel = [NSString stringWithFormat:@"%@ **** %@",[_model.patientTel substringToIndex:3],[_model.patientTel substringFromIndex:_model.patientTel.length-4]];
    }
    
    _infoLab.text = [NSString stringWithFormat:@"%@  %@岁  %@",patientGender,model.patientAge,patientTel];
    
    if ([model.relation isEqualToString:@"2"]) {
        _relationLab.text = @"  家属  ";
    }else if([model.relation isEqualToString:@"3"]){
        _relationLab.text = @"  亲戚  ";
    }else if([model.relation isEqualToString:@"3"]){
        _relationLab.text = @"  朋友  ";
    }else{
        _relationLab.text = @"  本人  ";
    }
    
    if ([model.isDefault isEqualToString:@"1"]) {
        _isDefaultLab.text = @"  默认  ";
        _isDefault_X_LayoutConstraint.constant = 15;
        _isDefaultLab.hidden = NO;
    }else{
        _isDefaultLab.text = @"";
        _isDefaultLab.hidden = YES;
        _isDefault_X_LayoutConstraint.constant = 0;
    }
    
    _authenticateLab.text = @"  已认证  ";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
