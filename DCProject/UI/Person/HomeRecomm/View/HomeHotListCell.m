//
//  HomeHotListCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "HomeHotListCell.h"

@implementation HomeHotListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - set
- (void)setModel:(GLPHomeDataListModel *)model{
    _model = model;
    
    //[cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"logo"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
        [self.imageV setImage:[UIImage dc_scaleToImage:self.imageV.image size:self.imageV.bounds.size]];
    }];
    GLPHomeDataGoodsModel *goodsVomodel = model.goodsVo;
    if (goodsVomodel == nil) {
        self.priceLab.text = @"¥0.00";
    }else{
        self.priceLab.text = [NSString stringWithFormat:@"¥%@",goodsVomodel.goodsPrice];
        _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    }
    self.nameLab.text = [NSString stringWithFormat:@"%@",model.infoTitle];
    self.btnView.layer.masksToBounds = YES;
    self.btnView.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRadiusType:(NSInteger)radiusType{
    _radiusType = radiusType;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_radiusType == 1) {
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:self.contentView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(10, 5)];
    }else if(_radiusType == 2){
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:self.contentView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(10, 5)];
    }
}

@end
