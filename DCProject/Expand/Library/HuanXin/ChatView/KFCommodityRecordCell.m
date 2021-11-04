//
//  KFCommodityRecordCell.m
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import "KFCommodityRecordCell.h"

@implementation KFCommodityRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setViewUI];
}

- (void)setViewUI
{
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    self.contentView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _goodsImg.layer.masksToBounds = YES;
    _goodsImg.layer.cornerRadius = 5;
    self.goodsImg.layer.minificationFilter = kCAFilterTrilinear;

}

#pragma mark - set
- (void)setModel2:(GLPMineSeeGoodsModel *)model2{
    _model2 = model2;
    
    _goodsTitleLab.text = _model2.goodsName;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_model2.goodsImg1] placeholderImage:[UIImage imageNamed:@"logo"]];
    _payableAmountLab.text = _model2.marketPrice;

}

- (void)setModel3:(GLPMineCollectModel *)model3{
    _model3 = model3;
    
    _goodsTitleLab.text = _model3.goodsName;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_model3.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    _payableAmountLab.text = _model3.marketPrice;
}

- (void)setModel4:(GLPShoppingCarNoActivityModel *)model4{
    _model4 = model4;
    _goodsTitleLab.text = _model4.goodsTitle;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_model4.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    _payableAmountLab.text = [NSString stringWithFormat:@"%0.2f",_model4.sellPrice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
