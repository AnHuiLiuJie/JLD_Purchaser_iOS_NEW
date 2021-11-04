//
//  RequestRefundListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "RequestRefundListCell.h"

@implementation RequestRefundListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected ;
    if (isSelected) {
        [_iconImg setImage:[UIImage imageNamed:@"dc_gx_yes"]];
    }else
        [_iconImg setImage:[UIImage imageNamed:@"dc_gx_no"]];

}

@end
