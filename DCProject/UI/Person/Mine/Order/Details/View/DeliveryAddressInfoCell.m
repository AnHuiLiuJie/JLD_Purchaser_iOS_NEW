//
//  DeliveryAddressInfoCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "DeliveryAddressInfoCell.h"

@implementation DeliveryAddressInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - set
-(void)setModel:(GLPOrderDetailModel *)model{
    _model = model;
    
    _nameLab.text = _model.receiverName;
    
    _contentLab.text = _model.receiverAddr;
    
    if (_model.receiverCellphone.length > 4) {
        _phoneLab.text = [NSString stringWithFormat:@"%@ **** %@",[_model.receiverCellphone substringToIndex:3],[_model.receiverCellphone substringFromIndex:_model.receiverCellphone.length-4]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
