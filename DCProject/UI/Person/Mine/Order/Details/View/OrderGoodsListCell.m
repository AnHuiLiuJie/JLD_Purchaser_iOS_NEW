//
//  OrderGoodsListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "OrderGoodsListCell.h"

@implementation OrderGoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

- (void)setViewUI{
    self.backgroundColor = [UIColor whiteColor];
    self.goodsImg.layer.minificationFilter = kCAFilterTrilinear;
    [_statusBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateNormal];
    [_statusBtn addTarget:self action:@selector(lookStatusAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - set
-(void)setModel:(GLPOrderGoodsListModel *)model{
    _model = model;
    
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"]];
            
    _wayLab.text = [NSString stringWithFormat:@"%@",model.packingSpec];
    
    if ([model.returnNum intValue] > 0) {
        _statusBtn.hidden = NO;
        [_statusBtn setTitle:[NSString stringWithFormat:@"  %@  ",@"查看进度"] forState:UIControlStateNormal];
        [DCSpeedy dc_changeControlCircularWith:_statusBtn AndSetCornerRadius:_statusBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
    }else{
        _statusBtn.hidden = YES;
    }

    
    if ([model.returnNum floatValue] > 0 ) {
        self.returnInfoLab.text = [NSString stringWithFormat:@"退%@%@,共%.2f元",model.returnNum,model.chargeUnit,[model.returnAmount floatValue]];
    }else
        self.returnInfoLab.text = @"";
    
    if ([_model.orderType isEqualToString:@"3"]) {
        _typeLab.hidden = NO;
        _typeLab.text = @" 秒杀 ";
        _titleLab.text = [NSString stringWithFormat:@"        %@",model.goodsTitle];
        [_typeLab dc_cornerRadius:3];
    }else if([_model.orderType isEqualToString:@"4"]){
        _typeLab.hidden = NO;
        _typeLab.text = @" 拼团 ";
        _titleLab.text = [NSString stringWithFormat:@"        %@",model.goodsTitle];
        [_typeLab dc_cornerRadius:3];
    }else{
        _titleLab.text = [NSString stringWithFormat:@"%@",model.goodsTitle];
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
        _priceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.sellPrice floatValue]];
        self.mixTipLab.text = @"";
        self.mixTipLab.hidden = YES;
    }
    
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFR size:18] forReplace:@"¥"];

}

- (void)setCarModel:(GLPNewShopCarGoodsModel *)carModel{
    _carModel = carModel;
    
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_carModel.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"]];
            
    _wayLab.text = [NSString stringWithFormat:@"%@",_carModel.packingSpec];
    
    _statusBtn.hidden = YES;

    self.returnInfoLab.text = @"";


//    if ([_model.orderType isEqualToString:@"3"]) {
//        _typeLab.hidden = NO;
//        _typeLab.text = @" 秒杀 ";
//        _titleLab.text = [NSString stringWithFormat:@"        %@",model.goodsTitle];
//        [_typeLab dc_cornerRadius:3];
//    }else if([_model.orderType isEqualToString:@"4"]){
//        _typeLab.hidden = NO;
//        _typeLab.text = @" 拼团 ";
//        _titleLab.text = [NSString stringWithFormat:@"        %@",model.goodsTitle];
//        [_typeLab dc_cornerRadius:3];
//    }else{
//        _titleLab.text = [NSString stringWithFormat:@"%@",model.goodsTitle];
//        _typeLab.hidden = YES;
//    }
    
    GLPMarketingMixListModel *marketingMix = _carModel.marketingMix;
    if (marketingMix.mixNum.length > 0) {//组合装
        int num = [_carModel.quantity intValue] / [marketingMix.mixNum intValue];
        self.numLab.text = [NSString stringWithFormat:@"X%d",num];

        self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[marketingMix.mixNum floatValue] * [_carModel.sellPrice floatValue]];
        
        self.mixTipLab.text = [NSString stringWithFormat:@"%@%@装",marketingMix.mixNum,_carModel.chargeUnit];
        self.mixTipLab.hidden = NO;
    }else{
        self.numLab.text = [NSString stringWithFormat:@"X%@",_carModel.quantity];
        _priceLab.text = [NSString stringWithFormat:@"¥%.2f",[_carModel.sellPrice floatValue]];
        self.mixTipLab.text = @"";
        self.mixTipLab.hidden = YES;
    }
    
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFR size:18] forReplace:@"¥"];
}

- (void)lookStatusAction:(UIButton *)button
{
    !_OrderGoodsListCell_block ? : _OrderGoodsListCell_block(_model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
