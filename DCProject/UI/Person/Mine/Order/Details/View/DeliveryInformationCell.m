//
//  DeliveryInformationCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import "DeliveryInformationCell.h"

@implementation DeliveryInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - set
-(void)setModel:(DeliveryInfoListModel *)model{
    _model = model;
    
    _contentLab.text = model.context;
    
    _timeLab.text = model.time;
}

- (void)setIsLastCell:(BOOL)isLastCell{
    _isLastCell = isLastCell;
    
    if (_isLastCell) {
        _topLineImg.hidden  = YES;
        [_topLineImg setImage:[UIImage imageNamed:@"dc_order_xtsl"]];
        [_statusImg setImage:[UIImage imageNamed:@"dc_order_tyl"]];
        [_bottomLineImg setImage:[UIImage imageNamed:@"dc_order_xtsl"]];
    }else{
        _topLineImg.hidden  = NO;
        [_topLineImg setImage:[UIImage imageNamed:@"dc_order_xtsh"]];
        [_statusImg setImage:[UIImage imageNamed:@"dc_order_tyh"]];
        [_bottomLineImg setImage:[UIImage imageNamed:@"dc_order_xtsh"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
