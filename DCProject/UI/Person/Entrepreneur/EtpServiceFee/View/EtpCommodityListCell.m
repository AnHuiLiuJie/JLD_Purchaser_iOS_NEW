//
//  EtpCommodityListCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "EtpCommodityListCell.h"

@implementation EtpCommodityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - set
- (void)setGoodsModel:(PSFGoodsListModel *)goodsModel{
    _goodsModel = goodsModel;
    
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
            [self.goodsImg setImage:[UIImage dc_scaleToImage:self.goodsImg.image size:self.goodsImg.bounds.size]];
    }];
    
    _payPriceLab.text = _goodsModel.payPrice;
    _goodsNameLab.text = _goodsModel.goodsName;
    _manufactoryLab.text = _goodsModel.manufactory;
    _buyNumLab.text = [NSString stringWithFormat:@"X%@",_goodsModel.buyNum];
    _extendUserAmountLab.text = [NSString stringWithFormat:@"¥%@",_goodsModel.extendUserAmount];;
    _extendUserAmountLab = [UILabel setupAttributeLabel:_extendUserAmountLab textColor:_extendUserAmountLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
