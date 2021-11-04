//
//  AddressSwitchNewCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import "AddressSwitchNewCell.h"

@implementation AddressSwitchNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewUI];
}

- (void)setViewUI{
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
}


#pragma mark - set
-(void)setModel:(GLPGoodsAddressModel *)model{
    _model = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
