//
//  GLPMeGroupBuyListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import "GLPMeGroupBuyListCell.h"

@implementation GLPMeGroupBuyListCell

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
    [_bgView dc_cornerRadius:10];
    
    [_bottomBtn1 addTarget:self action:@selector(functionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomBtn1 setTitle:@"查看订单" forState:UIControlStateNormal];
    [_bottomBtn1 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#6F6F6F"] radius:_bottomBtn1.dc_height/2];
    _bottomBtn1.tag = 0;


    [_bottomBtn2 addTarget:self action:@selector(functionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomBtn2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:_bottomBtn2.dc_height/2];
    _bottomBtn1.tag = 2;

    _orderLab.text = [NSString stringWithFormat:@"订单号：%@",@""];
    _stateLab.text = @"***";
}


#pragma mark - Setter Getter Methods
-(void)setModel:(DCMyCollageListModel *)model{
    _model = model;
    
    _stateLab.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _bottomBtn1.hidden = NO;

    _orderLab.text = [NSString stringWithFormat:@"订单号：%@",model.orderNo];
    //参与状态：0-等待参与，1-成功，2-失败，3-等待付款
    if ([_model.joinState isEqualToString:@"0"]) {
        _stateLab.text = @"拼团中";
        
        [_bottomBtn2 setTitle:@"拼团中" forState:UIControlStateNormal];
        [_bottomBtn2 setTitleColor:[UIColor dc_colorWithHexString:@"00B7AB"] forState:UIControlStateNormal];
        [_bottomBtn2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:_bottomBtn2.dc_height/2];
        
    }else if([_model.joinState isEqualToString:@"1"]) {
        _stateLab.text = @"拼团成功";

        [_bottomBtn2 setTitle:@"再开一团" forState:UIControlStateNormal];
        [_bottomBtn2 setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateNormal];
        [_bottomBtn2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:_bottomBtn2.dc_height/2];

    }else if([_model.joinState isEqualToString:@"2"]) {
        _stateLab.text = @"拼团失败";
        _stateLab.textColor = [UIColor dc_colorWithHexString:@"#FF3B30"];

        [_bottomBtn2 setTitle:@"再开一团" forState:UIControlStateNormal];
        [_bottomBtn2 setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateNormal];
        [_bottomBtn2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:_bottomBtn2.dc_height/2];

    }else if([_model.joinState isEqualToString:@"3"]) {
        _stateLab.text = @"等待付款";
//        _bottomBtn1.hidden = YES;
        
        [_bottomBtn2 setTitle:@"去付款" forState:UIControlStateNormal];
        [_bottomBtn2 setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateNormal];
        [_bottomBtn2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:_bottomBtn2.dc_height/2];
    }
    
    if ([_model.collageState integerValue] == 1) {
        //进行中
    }else if ([_model.collageState integerValue] == 2) {
        //已结束
        [_bottomBtn2 setTitle:@"活动结束" forState:UIControlStateNormal];
        [_bottomBtn2 setTitleColor:[UIColor dc_colorWithHexString:@"#6F6F6F"] forState:UIControlStateNormal];
        [_bottomBtn2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#6F6F6F"] radius:_bottomBtn2.dc_height/2];
    }else if ([_model.collageState integerValue] == 2) {
        //库存不足
        [_bottomBtn2 setTitle:@"已售罄" forState:UIControlStateNormal];
        [_bottomBtn2 setTitleColor:[UIColor dc_colorWithHexString:@"#6F6F6F"] forState:UIControlStateNormal];
        [_bottomBtn2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#6F6F6F"] radius:_bottomBtn2.dc_height/2];
    }else{
        //未开始
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

    _priceLab.text = [NSString stringWithFormat:@"¥%@",_model.buyPrice];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];
    
    _originalLab.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" ¥%@ ",_model.sellPrice]];
}
#pragma mark - private method
- (void)functionAction:(UIButton *)button{
    NSInteger tag = button.tag;
    if (tag == 0) {
        
    }else{
        
    }
    !_GLPMeGroupBuyListCell_btnBlock ? : _GLPMeGroupBuyListCell_btnBlock(button.titleLabel.text,tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
