//
//  AddressInfoCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import "AddressInfoCell.h"

@implementation AddressInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

- (void)setViewUI{
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    
    _addressTf.enabled = NO;
    
    _addressBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _addressBgView.tag = 1;
    [_addressBgView addGestureRecognizer:tap3];
    
    [_nameTF addTarget:self action:@selector(name_tfDidChange:) forControlEvents:UIControlEventEditingChanged];

    [_phoneTf addTarget:self action:@selector(tel_tfDidChange:) forControlEvents:UIControlEventEditingChanged];

    [_detailedTf addTarget:self action:@selector(addres_tfDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)name_tfDidChange:(UITextField *)textField{
    if (textField.text.length > 30) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:30];
    }
    !_AddressInfoCell_block ? : _AddressInfoCell_block(textField.text,1);
}

- (void)tel_tfDidChange:(UITextField *)textField{
    if (textField.text.length > 11) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:11];
    }
    !_AddressInfoCell_block ? : _AddressInfoCell_block(textField.text,2);
}

- (void)addres_tfDidChange:(UITextField *)textField{
    if (textField.text.length > 100) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:100];
    }
    !_AddressInfoCell_block ? : _AddressInfoCell_block(textField.text,3);
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    !_AddressInfoCell_Block ? : _AddressInfoCell_Block();
}

#pragma mark - set
- (void)setModel:(GLPGoodsAddressModel *)model{
    _model = model;
    
    _nameTF.text = [NSString stringWithFormat:@"%@",self.model.recevier];

    _phoneTf.text = [NSString stringWithFormat:@"%@",self.model.cellphone];
    
    _addressTf.text = [NSString stringWithFormat:@"%@",self.model.areaName];

    _detailedTf.text = [NSString stringWithFormat:@"%@",self.model.streetInfo];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
