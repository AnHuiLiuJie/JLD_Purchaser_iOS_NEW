//
//  AddressListCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "AddressListCell.h"

@implementation AddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setViewUI];
}

#pragma mark viewUI
- (void)setViewUI{
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [DCSpeedy dc_changeControlCircularWith:self.bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];


    _mrLab.textColor = [UIColor dc_colorWithHexString:DC_BtnColor];
}

#pragma mark action
- (void)deleteAction:(UIButton *)button{
    !_AddressListCellDel_block ? : _AddressListCellDel_block();
}

- (void)editAction:(UIButton *)button{
    !_AddressListCellEid_block ? : _AddressListCellEid_block();
}

#pragma mark - set
- (void)setModel:(GLPGoodsAddressModel *)model{
    _model = model;
    
    _nameLab.text = [NSString stringWithFormat:@"%@",model.recevier];
    _phoneLab.text = [NSString stringWithFormat:@"%@",model.cellphone];
    if (_model.cellphone.length > 4) {
        _phoneLab.text = [NSString stringWithFormat:@"%@ **** %@",[_model.cellphone substringToIndex:3],[_model.cellphone substringFromIndex:_model.cellphone.length-4]];
    }
    _addressLab.text = [NSString stringWithFormat:@"%@%@",model.areaName,model.streetInfo];
    NSString *mrselct = [NSString stringWithFormat:@"%@",model.isDefault];
    if ([mrselct isEqualToString:@"1"])
    {
        _mrLab.text = @"  默认地址  ";
        _mrLab.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
        [DCSpeedy dc_changeControlCircularWith:_mrLab AndSetCornerRadius:_mrLab.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
    }else{
        _mrLab.text = @"";
        _mrLab.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
