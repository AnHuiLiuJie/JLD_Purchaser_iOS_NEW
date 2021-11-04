//
//  GLPSpikeHomeListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "GLPSpikeHomeListCell.h"

@implementation GLPSpikeHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

#pragma mark - base
- (void)setViewUI{
    
//    [_iconImg sd_setImageWithURL:[NSURL URLWithString:_model.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
//            [self.iconImg setImage:[UIImage dc_scaleToImage:self.iconImg.image size:self.iconImg.bounds.size]];
//    }];
    
    [_functionBtn addTarget:self action:@selector(functionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _functionBtn.tag = 1;
    [_functionBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#FF3B30"]];
    [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FFFFFF"] radius:4];
}

#pragma mark - Setter Getter Methods
- (void)setGoodsType:(NSInteger)goodsType{
    _goodsType  = goodsType;
}

-(void)setModel:(DCSeckillListModel *)model{
    _model = model;
    
    if (_goodsType == 1) {
        if ([_model.isSellOut integerValue] == 1) {
            //已售完
            [_functionBtn setTitle:@"已售完" forState:UIControlStateNormal];
            [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#999999"]];
            [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#999999"] radius:2];
        }else{
            [_functionBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
            [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#FF3B30"]];
            [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FF3B30"] radius:2];
        }
    }else{
        if ([_model.isSubscribe integerValue] == 1) {
            //已订阅
            [_functionBtn setTitle:@"已设置" forState:UIControlStateNormal];
            [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#FFFFFF"]];
            [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FF3B30"] forState:UIControlStateNormal];
            [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FF3B30"] radius:2];
        }else{
            [_functionBtn setTitle:@"提醒我" forState:UIControlStateNormal];
            [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#8736E2"]];
            [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#8736E2"] radius:2];
        }
    }
    

    

    
    NSString *title = [NSString stringWithFormat:@"%@%@",_model.goodsName,@""];//_model.packingSpec
    _titileLab.text = title;
    
    NSString *imageUrl = _model.goodsImg;
//    WEAKSELF;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
//        if (!weakSelf.isFristLoad) {
//            [weakSelf.iconImage setImage:[UIImage dc_scaleToImage:weakSelf.iconImage size:weakSelf.iconImage.bounds.size]];
//            //self.isFristLoad = YES;
//        }
    }];

    _priceLab.text = [NSString stringWithFormat:@"秒杀价¥%@",_model.price];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"秒杀价¥"];
    
    _originalLab.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" ¥%@ ",_model.sellPrice]];

}

#pragma mark - private method
- (void)functionAction:(UIButton *)button{

    !_GLPSpikeHomeListCell_btnBlock ? : _GLPSpikeHomeListCell_btnBlock(_functionBtn.titleLabel.text,_model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRadiusType:(NSInteger)radiusType{
    _radiusType = radiusType;
    
//    if (_radiusType == 1) {
//        [self.contentView dc_cornerRadius:5 rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
//    }else if(_radiusType == 2){
//        [self.contentView dc_cornerRadius:5 rectCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
//    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_radiusType == 1) {
        //[DCSpeedy dc_setUpBezierPathCircularLayerWithControl:self.bgView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(10, 5)];
    }else if(_radiusType == 2){
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:self.bgView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(10, 5)];
    }
}

@end
/**
 NSInteger tag = button.tag;
 if (tag == 0) {
     [_functionBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
     [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#FF3B30"]];
     [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
     [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FF3B30"] radius:2];
 }else if(tag == 1){
     [_functionBtn setTitle:@"提醒我" forState:UIControlStateNormal];
     [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#8736E2"]];
     [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
     [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#8736E2"] radius:2];
 }else if(tag == 2){
     [_functionBtn setTitle:@"拼团" forState:UIControlStateNormal];
     [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#00B7AB"]];
     [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
     [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:_functionBtn.dc_height/2];
 }else{
     [_functionBtn setTitle:@"已设置" forState:UIControlStateNormal];
     [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#FFFFFF"]];
     [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FF3B30"] forState:UIControlStateNormal];
     [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#8736E2"] radius:2];
 }
 */
