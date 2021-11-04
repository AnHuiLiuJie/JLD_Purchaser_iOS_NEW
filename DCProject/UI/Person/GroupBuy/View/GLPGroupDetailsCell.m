//
//  GLPGroupDetailsCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import "GLPGroupDetailsCell.h"

@implementation GLPGroupDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewUI];
}

#pragma mark - base
- (void)setViewUI{
    
    [_bgView dc_cornerRadius:10];
    
    [_functionBtn addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - memod
- (void)functionBtnAction:(UIButton *)button{
    !_GLPGroupDetailsCell_btnBlock ? : _GLPGroupDetailsCell_btnBlock(button.titleLabel.text,_model);
}


#pragma mark - setting
- (void)setModel:(DCCollageListModel *)model{
    _model = model;
    
    if ([_model.collageState integerValue] == 1) {
        //进行中
        [_functionBtn setTitle:@"拼团" forState:UIControlStateNormal];
        [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#00B7AB"]];
        [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:_functionBtn.dc_height/2];

    }else if ([_model.collageState integerValue] == 2) {
        //已结束
        [_functionBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#999999"]];
        [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#999999"] radius:_functionBtn.dc_height/2];
    }else if ([_model.collageState integerValue] == 3) {
        //库存不足
        [_functionBtn setTitle:@"已售罄" forState:UIControlStateNormal];
        [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#999999"]];
        [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#999999"] radius:_functionBtn.dc_height/2];
    }else{
        //未开始
        [_functionBtn setTitle:@"未开始" forState:UIControlStateNormal];
        [_functionBtn setBackgroundColor:[UIColor dc_colorWithHexString:@"#8736E2"]];
        [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_functionBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#8736E2"] radius:_functionBtn.dc_height/2];
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

    _priceLab.text = [NSString stringWithFormat:@"¥%@",_model.price];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];
    
    _originalLab.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" ¥%@ ",_model.sellPrice]];

}

- (void)setMyModel:(DCMyCollageListModel *)myModel{
    _myModel = myModel;
    
    
    _functionBtn.hidden = YES;


    NSString *title = [NSString stringWithFormat:@"%@%@",_myModel.goodsName,@""];//_myModel.packingSpec
    _titileLab.text = title;

    NSString *imageUrl = _myModel.goodsImg;
    //    WEAKSELF;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
    //        if (!weakSelf.isFristLoad) {
    //            [weakSelf.iconImage setImage:[UIImage dc_scaleToImage:weakSelf.iconImage size:weakSelf.iconImage.bounds.size]];
    //            //self.isFristLoad = YES;
    //        }
    }];

    _priceLab.text = [NSString stringWithFormat:@"¥%@",_myModel.buyPrice];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];

    _originalLab.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" ¥%@ ",_myModel.sellPrice]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
