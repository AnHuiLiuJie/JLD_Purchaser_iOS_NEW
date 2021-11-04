//
//  TRGoodsCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRGoodsCell.h"

@implementation TRGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodsImageV.layer.minificationFilter = kCAFilterTrilinear;

    UIView *view_bg = [[UIView alloc]initWithFrame:self.frame];
    view_bg.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:1];
    self.selectedBackgroundView = view_bg;
}


#pragma mark - 适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image = [UIImage imageNamed:@"dc_gx_no"];
                    }
                }
            }
        }
    }
}


#pragma mark - lazy load
- (void)layoutSubviews {
    
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image = [UIImage imageNamed:@"dc_gx_yes"];
                    }else
                    {
                        img.image = [UIImage imageNamed:@"dc_gx_no"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
}


#pragma mark - setter
- (void)setCollectModel:(GLPMineCollectModel *)collectModel
{
    _collectModel = collectModel;
    _storeLab.hidden = NO;
    _icn_stau.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.typeLab1.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.typeLab1.layer.borderWidth = 1;
    self.typeLab1.layer.masksToBounds = YES;
    self.typeLab1.layer.cornerRadius = 1;
    self.typeLab2.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.typeLab2.layer.borderWidth = 1;
    self.typeLab2.layer.masksToBounds = YES;
    self.typeLab2.layer.cornerRadius = 1;
    
    if (_collectModel.sellerFirmId  == 1) // 自营
    {
        _bqImageV.hidden = NO;
        _nameLab.text = [NSString stringWithFormat:@"   %@",_collectModel.goodsName];
    }
    else{
        _bqImageV.hidden = YES;
        _nameLab.text = [NSString stringWithFormat:@"%@",_collectModel.goodsName];
        
    }
    [_goodsImageV sd_setImageWithURL:[NSURL URLWithString:_collectModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _storeLab.text = [NSString stringWithFormat:@"%@",_collectModel.sellerFirmName];
    
    if (_collectModel.packingSpec && _collectModel.packingSpec.length > 0) {
        _numLab.text = [NSString stringWithFormat:@"%@",_collectModel.packingSpec];
        _line.hidden = NO;
    } else {
        _numLab.text = @"";
        _line.hidden = YES;
    }
    
//   _numLab.text = [NSString stringWithFormat:@"%@",_collectModel.packingSpec];

    _xsLab.text = [NSString stringWithFormat:@"已销售%@件",_collectModel.totalSales];
    _xsLab.hidden = NO;
    if ([_collectModel.totalSales  intValue] <100) {
        _xsLab.hidden = YES;
    }
    _mjLab.hidden = YES;
    if (_collectModel.goodsCouponsBean && _collectModel.goodsCouponsBean.couponsId) {
        _mjLab.hidden = NO;
        _mjLab.text = [NSString stringWithFormat:@"满%@减%@",_collectModel.goodsCouponsBean.requireAmount,_collectModel.goodsCouponsBean.discountAmount];
        _xsLab.text = [NSString stringWithFormat:@"  已销售%@件",_collectModel.totalSales];
        _xsLab.hidden = NO;
        if ([_collectModel.totalSales  intValue] <100) {
            _xsLab.hidden = YES;
        }
    }
    
    _typeLab1.hidden = YES;
    _typeLab2.hidden = YES;
    
    NSString *goodsTagNameList = _collectModel.goodsTagNameList;
    if ([goodsTagNameList containsString:@","]) {
         NSArray *arr = [goodsTagNameList componentsSeparatedByString:@","];
        if ([arr count] > 0) {
            for (int i=0; i<arr.count; i++) {
                if (i == 0) {
                    _typeLab1.hidden = NO;
                    _typeLab1.text = [NSString stringWithFormat:@"  %@  ",arr[i]];
                }
                if (i == 1) {
                    _typeLab2.hidden = NO;
                    _typeLab2.text = [NSString stringWithFormat:@"  %@  ",arr[i]];
                }
            }
        }
    }
    
    _priceLab.text = [NSString stringWithFormat:@"¥%.2f",_collectModel.sellPrice];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
    _oldPriceLab.text = [NSString stringWithFormat:@"市场价¥%@",_collectModel.marketPrice];
    _oldPriceLab = [UILabel setupAttributeLabel:_oldPriceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
    NSUInteger  stau = [collectModel.frontClassState integerValue];
    if (stau==0) {
       _icn_stau.hidden = YES;
    }else{
         _icn_stau.hidden = NO;
    }
    if (stau == 1) {
        _icn_stau.image = [UIImage imageNamed:@"xbtj"];
    }
    if (stau == 2) {
       _icn_stau.image = [UIImage imageNamed:@"ksfh"];
    }
    if ([_collectModel.marketPrice floatValue]<=_collectModel.sellPrice)
    {
        _oldPriceLab.hidden = YES;
        _lineLab.hidden = YES;
    }
    else{
        _oldPriceLab.hidden = NO;
        _lineLab.hidden = NO;
    }
    
    _gwcBtn.hidden = YES;
    _numLab.hidden = NO;
}


#pragma mark - setter
- (void)setSeeModel:(GLPMineSeeGoodsModel *)seeModel
{
    _seeModel = seeModel;
//      _storeLab.hidden = NO;
//    _icn_stau.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.typeLab1.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.typeLab1.layer.borderWidth = 1;
    self.typeLab1.layer.masksToBounds = YES;
    self.typeLab1.layer.cornerRadius = 1;
    self.typeLab2.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.typeLab2.layer.borderWidth = 1;
    self.typeLab2.layer.masksToBounds = YES;
    self.typeLab2.layer.cornerRadius = 1;
    
    if (_seeModel.sellerFirmId  == 1) // 自营
    {
        _bqImageV.hidden = NO;
        _nameLab.text = [NSString stringWithFormat:@"   %@",_seeModel.goodsName];
    }
    else{
        _bqImageV.hidden = YES;
        _nameLab.text = [NSString stringWithFormat:@"%@",_seeModel.goodsName];
        
    }
    [_goodsImageV sd_setImageWithURL:[NSURL URLWithString:_seeModel.goodsImg1] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _storeLab.text = [NSString stringWithFormat:@"%@",_seeModel.sellerFirmName];
    _storeLab.hidden = NO;
    if (_seeModel.packingSpec && _seeModel.packingSpec.length > 0) {
        _numLab.text = [NSString stringWithFormat:@"%@",_seeModel.packingSpec];
        _line.hidden = NO;
    } else {
        _numLab.text = @"";
        _line.hidden = YES;
    }
    
    _xsLab.text = [NSString stringWithFormat:@"已销售%ld件",_seeModel.totalSales];
    _xsLab.hidden = NO;
    if (_seeModel.totalSales <100) {
        _xsLab.hidden = YES;
    }
    _mjLab.hidden = YES;
    if (_seeModel.goodsCouponsBean && _seeModel.goodsCouponsBean.couponsId) {
        _mjLab.hidden = NO;
        _mjLab.text = [NSString stringWithFormat:@"满%@减%@",_seeModel.goodsCouponsBean.requireAmount,_seeModel.goodsCouponsBean.discountAmount];
        _xsLab.text = [NSString stringWithFormat:@"  已销售%ld件",_seeModel.totalSales];
        _xsLab.hidden = NO;
        if (_seeModel.totalSales  <100) {
            _xsLab.hidden = YES;
        }
    }
    
    _typeLab1.hidden = YES;
    _typeLab2.hidden = YES;
    NSUInteger  stau = [seeModel.frontClassState integerValue];
    if (stau==0) {
      _icn_stau.hidden = YES;
    }else{
        _icn_stau.hidden = NO;
    }
    if (stau == 1) {
       _icn_stau.image = [UIImage imageNamed:@"xbtj"];
    }
    if (stau == 2) {
      _icn_stau.image = [UIImage imageNamed:@"ksfh"];
    }
    NSString *goodsTagNameList = _seeModel.goodsTagNameList;
    if ([goodsTagNameList containsString:@","]) {
        NSArray *arr = [goodsTagNameList componentsSeparatedByString:@","];
        if ([arr count] > 0) {
            for (int i=0; i<arr.count; i++) {
                if (i == 0) {
                    _typeLab1.hidden = NO;
                    _typeLab1.text = [NSString stringWithFormat:@"  %@  ",arr[i]];
                }
                if (i == 1) {
                    _typeLab2.hidden = NO;
                    _typeLab2.text = [NSString stringWithFormat:@"  %@  ",arr[i]];
                }
            }
        }
    }
    
    _priceLab.text = [NSString stringWithFormat:@"¥%.2f",_seeModel.sellPrice];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
    _oldPriceLab.text = [NSString stringWithFormat:@"市场价¥%@",_seeModel.marketPrice];
    _oldPriceLab = [UILabel setupAttributeLabel:_oldPriceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];

    if ([_seeModel.marketPrice floatValue]<=_seeModel.sellPrice)
    {
        _oldPriceLab.hidden = YES;
        _lineLab.hidden = YES;
    }
    else{
        _oldPriceLab.hidden = NO;
        _lineLab.hidden = NO;
    }
    
    _gwcBtn.hidden = YES;
    _numLab.hidden = NO;
}

@end
