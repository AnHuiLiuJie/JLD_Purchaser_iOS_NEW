//
//  PrecriptionGoodsCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PrecriptionGoodsCell.h"

@implementation PrecriptionGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _typeLab.hidden = YES;
    [_typeLab dc_cornerRadius:3];
    self.imageV.layer.minificationFilter = kCAFilterTrilinear;
}

#pragma mark set
-(void)setModel:(OredrGoodsModel *)model{
    _model = model;
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    self.wayLab.text = [NSString stringWithFormat:@"%@",model.packingSpec];
    
    if ([model.returnNum floatValue] > 0 ) {
        self.returnInfoLab.text = [NSString stringWithFormat:@"退%@%@,共%.2f元",model.returnNum,model.chargeUnit,[model.returnAmount floatValue]];
    }else
        self.returnInfoLab.text = @"";
    
    if ([_model.orderType isEqualToString:@"3"]) {
        _typeLab.hidden = NO;
        _typeLab.text = @" 秒杀 ";
        self.nameLab.text = [NSString stringWithFormat:@"        %@",model.goodsTitle];
        [_typeLab dc_cornerRadius:3];
    }else if([_model.orderType isEqualToString:@"4"]){
        _typeLab.hidden = NO;
        _typeLab.text = @" 拼团 ";
        self.nameLab.text = [NSString stringWithFormat:@"        %@",model.goodsTitle];
        [_typeLab dc_cornerRadius:3];
    }else{
        self.nameLab.text = [NSString stringWithFormat:@"%@",model.goodsTitle];
        _typeLab.hidden = YES;
    }
    
    GLPMarketingMixListModel *marketingMix = model.marketingMixVO;
    if (marketingMix.mixNum.length > 0) {//组合装
        int num = [model.quantity intValue] / [marketingMix.mixNum intValue];
        self.numLab.text = [NSString stringWithFormat:@"X%d",num];

        self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[marketingMix.mixNum floatValue] * [model.sellPrice floatValue]];
        
        self.mixTipLab.text = [NSString stringWithFormat:@"%@%@装",marketingMix.mixNum,model.chargeUnit];
        self.mixTipLab.hidden = NO;
    }else{
        self.numLab.text = [NSString stringWithFormat:@"X%@",model.quantity];
        self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.sellPrice floatValue]];
        self.mixTipLab.text = @"";
        self.mixTipLab.hidden = YES;
    }
    
    self.priceLab = [UILabel setupAttributeLabel:self.priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFR size:18] forReplace:@"¥"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
