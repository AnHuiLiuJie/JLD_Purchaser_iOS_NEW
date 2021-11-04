//
//  DCListGrid_m
//  DCProject
//
//  Created by 赤道 on 2021/3/29.
//

#import "DCListGridCell.h"

@interface DCListGridCell ()

@property (nonatomic, copy) NSString  *extendType;//是否加入创业者

@end

@implementation DCListGridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.goodsImageV.layer.minificationFilter = kCAFilterTrilinear;
    
    UIView *view_bg = [[UIView alloc]initWithFrame:self.frame];
    view_bg.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:1];
    self.selectedBackgroundView = view_bg;
    
    [_gwcBtn addTarget:self action:@selector(addbuyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _extendType = [DCUpdateTool shareClient].currentUserB2C.extendType;
    
    _nameLab.font = [UIFont systemFontOfSize:17];
    
    _priceLab.font = [UIFont fontWithName:PFRSemibold size:19];
    //圆角
    [self dc_changeControlCircularWith:_rebateLab AndSetCornerRadius:_rebateLab.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    
    [self dc_changeControlCircularWith:_classView AndSetCornerRadius:5 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:NO];

}

- (void)addbuyClick:(UIButton *)button{
    !_colonClickBlock ? : _colonClickBlock(button.tag);
    NSLog(@"====>:%ld",button.tag);
}

#pragma mark - Setter Getter Methods
- (void)setModel:(TRStoreGoodsModel *)model
{
    _model = model;
    
    if ([_extendType integerValue] == 1) {
        _rebateLab.hidden = NO;
        if (![DCSpeedy isBlankString:_model.spreadAmount]) {
            _rebateLab.text = [NSString stringWithFormat:@" 赚%@   ",_model.spreadAmount];
        }else{
            _rebateLab.text = @"";
        }
    }else
        _rebateLab.hidden = YES;
    
    if ([[NSString stringWithFormat:@"%@",_model.sellerFirmId] isEqualToString:@"1"])
    {
        _bqImageV.hidden = NO;
        _nameLab.text = [NSString stringWithFormat:@"       %@",_model.goodsTitle];
    }
    else{
         _bqImageV.hidden = YES;
         _nameLab.text = [NSString stringWithFormat:@"%@",_model.goodsTitle];
    }
    [_goodsImageV sd_setImageWithURL:[NSURL URLWithString:_model.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
            [self.goodsImageV setImage:[UIImage dc_scaleToImage:self.goodsImageV.image size:self.goodsImageV.bounds.size]];
    }];
    
    _store_H_LayoutConstraint.constant = 0;
//    _storeLab.text = [NSString stringWithFormat:@"%@",_model.sellerFirmName];
//    _numLab.text = [NSString stringWithFormat:@"%@",_model.packingSpec];
//    _numLab.hidden = NO;
//    _line.hidden = NO;
//    _storeLab.hidden = NO;

    NSDictionary *dic = _model.goodsCouponsBean;
    if (dic==nil||[dic isEqualToDictionary:@{}])
    {
        _mjLab.hidden = YES;
        _mjLab.text = @"";
        _xsLab.text = [NSString stringWithFormat:@"已销售%d件",[_model.totalSales intValue]];
        _xsLab.hidden = NO;
        if ([_model.totalSales  intValue] <100) {
            _xsLab.hidden = YES;
            _Mj_H_LayoutContraint.constant = 0;
        }
    }
    else{
        _mjLab.hidden = NO;
        _mjLab.text = [NSString stringWithFormat:@"满%@减%@",dic[@"requireAmount"],dic[@"discountAmount"]];
        _xsLab.text = [NSString stringWithFormat:@"  已销售%d件",[_model.totalSales intValue]];
        _xsLab.hidden = NO;
        if ([_model.totalSales  intValue] <100) {
            _xsLab.hidden = YES;
        }
    }
    NSString *goodsTagNameList=_model.goodsTagNameList;
    if (goodsTagNameList.length!=0)
    {
        NSArray *arr = [goodsTagNameList componentsSeparatedByString:@","];
        if (arr.count==0){
            _typeView.hidden = YES;
            _type_H_LayoutContraint.constant = 0;
        }else{
            _typeView.hidden = NO;
            _type_H_LayoutContraint.constant = 20;
            [self create_typeLabelOnView:arr];
        }
    }
    
    _priceLab.text = [NSString stringWithFormat:@"¥%@",_model.sellPrice];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFRSemibold size:19] forReplace:@"¥"];

    _oldPriceLab.text = [NSString stringWithFormat:@"市场价¥%@",_model.marketPrice];
    _oldPriceLab = [UILabel setupAttributeLabel:_oldPriceLab textColor:_oldPriceLab.textColor minFont:[UIFont fontWithName:PFR size:11] maxFont:[UIFont fontWithName:PFRSemibold size:13] forReplace:@"¥"];
    if ([_model.marketPrice floatValue]<=[_model.sellPrice floatValue])
    {
        _oldPriceLab.hidden = YES;
        _lineLab.hidden = YES;
    }
    else{
        _oldPriceLab.hidden = NO;
        _lineLab.hidden = NO;
    }
    
    if (_model.frontClassName.length > 0) {
        _classView.hidden = NO;
        //[_classIconImg sd_setImageWithURL:[NSURL URLWithString:_model.frontClassIcon] placeholderImage:[UIImage imageNamed:@"logo"]];
        CGFloat title_w = [DCSpeedy getWidthWithText:_model.frontClassName height:_nameLab.dc_height font:[UIFont fontWithName:PFR size:11]];
        if (title_w>25) {
            _calssView_W_LayoutConstraint.constant = 42;
            _nameLab.text = [NSString stringWithFormat:@"         %@",_model.goodsTitle];
        }else{
            _calssView_W_LayoutConstraint.constant = 32;
            _nameLab.text = [NSString stringWithFormat:@"       %@",_model.goodsTitle];
        }
        _classNameLab.text = _model.frontClassName;
    }else{
        _classView.hidden = YES;
        _calssView_W_LayoutConstraint.constant = 0;
        _nameLab.text = [NSString stringWithFormat:@"%@",_model.goodsTitle];
    }
    
    CGFloat titleH = [DCSpeedy getLabelHeightWithText:_nameLab.text width:_nameLab.dc_width font:_nameLab.font];
    if (titleH>25) {
        
    }
}

- (void)create_typeLabelOnView:(NSArray *)array
{
    UIView *view = [[UIView alloc] init];
    [[self.typeView viewWithTag:1001] removeFromSuperview];
    view.tag = 1001;
    CGFloat typeAll_w = 0;
    CGFloat index_w = 0;
    for (NSString *str in array) {
        NSString *title = [NSString stringWithFormat:@" %@ ",str];
        UIFont *font = [UIFont fontWithName:PFR size:10];
        CGFloat title_W = [DCSpeedy getWidthWithText:title height:20 font:font];
        index_w = index_w+title_W+5;
        if (index_w > self.typeView.dc_width-10) {
            break;
        }
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.frame = CGRectMake(typeAll_w, 0, title_W, 20);
        typeAll_w = typeAll_w+title_W+5;
        //NSLog(@"%@ %f  %f ",title,title_W,typeAll_w);
        typeLabel.textColor = RGB_COLOR(0, 190, 179);
        typeLabel.font = font;
        typeLabel.text = title;
        [typeLabel dc_layerBorderWith:1 color:RGB_COLOR(0, 190, 179) radius:2];
        [view addSubview:typeLabel];
    }
    
    [self.typeView addSubview:view];
}

@end
