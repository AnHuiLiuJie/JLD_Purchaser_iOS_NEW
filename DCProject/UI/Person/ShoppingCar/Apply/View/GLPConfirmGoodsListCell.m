//
//  GLPConfirmGoodsListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "GLPConfirmGoodsListCell.h"

@implementation GLPConfirmGoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
    //[self dc_layerBorderWith:1 color:[UIColor redColor] radius:1];
}

- (void)setViewUI{
    self.backgroundColor = [UIColor whiteColor];
    self.goodsImg.layer.minificationFilter = kCAFilterTrilinear;
    [_statusBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateNormal];
    //[_statusBtn addTarget:self action:@selector(lookStatusAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - set

- (void)setNoActGoodsModel:(GLPNewShopCarGoodsModel *)noActGoodsModel
{
    _noActGoodsModel = noActGoodsModel;
    
    _bgImage.hidden = YES;
    _statusBtn.hidden = YES;
    _returnInfoLab.text = @"";
    _typeLab.hidden = YES;
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
    
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_noActGoodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    _titleLab.text = [NSString stringWithFormat:@"%@",_noActGoodsModel.goodsTitle];

    _wayLab.text = [NSString stringWithFormat:@"%@",_noActGoodsModel.packingSpec];

    if (_noActGoodsModel.mixTip.length > 0) {
        _mixTipLab.text = _noActGoodsModel.mixTip;
    }else{
        _mixTipLab.text = @"";
    }
    
    GLPMarketingMixListModel *marketingMix = _noActGoodsModel.marketingMix;
    if (marketingMix.mixId.length > 0) {//组合装
        int num = [_noActGoodsModel.quantity intValue] / [marketingMix.mixNum intValue];
        _numLab.text = [NSString stringWithFormat:@"x%d",num];
        _priceLab.text = [NSString stringWithFormat:@"¥%.2f",[marketingMix.mixNum floatValue] * [_noActGoodsModel.sellPrice floatValue]];
    }else{
        _priceLab.text = [NSString stringWithFormat:@"¥%@",_noActGoodsModel.sellPrice];
        _numLab.text = [NSString stringWithFormat:@"x%@",_noActGoodsModel.quantity];
    }
    
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:18] forReplace:@"¥"];
    
}


- (void)setActGoodsModel:(GLPNewShopCarGoodsModel *)actGoodsModel
{
    _actGoodsModel = actGoodsModel;
    
    _bgImage.hidden = NO;
    _statusBtn.hidden = YES;
    _returnInfoLab.text = @"";
    _typeLab.hidden = YES;
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
    
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_actGoodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    _titleLab.text = [NSString stringWithFormat:@"%@",_actGoodsModel.goodsTitle];

    _wayLab.text = [NSString stringWithFormat:@"%@",_actGoodsModel.packingSpec];

    if (_actGoodsModel.mixTip.length > 0) {
        _mixTipLab.text = _actGoodsModel.mixTip;
    }else{
        _mixTipLab.text = @"";
    }
    
    GLPMarketingMixListModel *marketingMix = _actGoodsModel.marketingMix;
    if (marketingMix.mixId.length > 0) {//组合装
        int num = [_actGoodsModel.quantity intValue] / [marketingMix.mixNum intValue];
        _numLab.text = [NSString stringWithFormat:@"x%d",num];
        _priceLab.text = [NSString stringWithFormat:@"¥%.2f",[marketingMix.mixNum floatValue] * [_actGoodsModel.sellPrice floatValue]];
    }else{
        _priceLab.text = [NSString stringWithFormat:@"¥%@",_actGoodsModel.sellPrice];
        _numLab.text = [NSString stringWithFormat:@"x%@",_actGoodsModel.quantity];
    }
    
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:18] forReplace:@"¥"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
