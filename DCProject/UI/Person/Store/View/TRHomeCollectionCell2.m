//
//  TRHomeCollectionCell2.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRHomeCollectionCell2.h"

@implementation TRHomeCollectionCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - set
- (void)setModel:(GLPHomeDataListModel *)model{
    _model = model;
    
    
    //[self.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"logo"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
        [self.imageV setImage:[UIImage dc_scaleToImage:self.imageV.image size:self.imageV.bounds.size]];
    }];
    
    GLPHomeDataGoodsModel*goodsVomodel=model.goodsVo;
    if (goodsVomodel == nil) {
         self.priceLab.text = @"¥0.00";
    }else{
         self.priceLab.text = [NSString stringWithFormat:@"¥%@",goodsVomodel.goodsPrice];
        _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
    }
   
    self.nameLab.text = [NSString stringWithFormat:@"%@",model.infoTitle];
}

@end
