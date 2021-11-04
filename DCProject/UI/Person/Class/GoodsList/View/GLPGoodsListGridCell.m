//
//  GLPGoodsListGridCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/15.
//

#import "GLPGoodsListGridCell.h"

@interface GLPGoodsListGridCell ()

@property (nonatomic, copy) NSString  *extendType;//是否加入创业者

@end


@implementation GLPGoodsListGridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *view_bg = [[UIView alloc] initWithFrame:self.frame];
    view_bg.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:1];
    self.selectedBackgroundView = view_bg;
    
    [_goodsImageV dc_cornerRadius:5];
    self.goodsImageV.layer.minificationFilter = kCAFilterTrilinear;

    _extendType = [DCUpdateTool shareClient].currentUserB2C.extendType;
    
    _nameLab.font = [UIFont systemFontOfSize:17];
    
    _priceLab.font = [UIFont fontWithName:PFRSemibold size:19];
    
    [self dc_changeControlCircularWith:_rebateLab AndSetCornerRadius:_rebateLab.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    
    [self dc_changeControlCircularWith:_classView AndSetCornerRadius:5 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:NO];
}

#pragma mark - Setter Getter Methods
- (void)setModel:(TRStoreGoodsModel *)model
{
    _model = model;
    
    [_goodsImageV sd_setImageWithURL:[NSURL URLWithString:_model.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
            [self.goodsImageV setImage:[UIImage dc_scaleToImage:self.goodsImageV.image size:self.goodsImageV.bounds.size]];
    }];
    
    NSInteger blankNum = 0;
    NSString *goodsTitle = _model.goodsTitle;
    
    if (_model.frontClassName.length > 0) {
        _classView.hidden = NO;
        NSString *frontClassName = [NSString stringWithFormat:@" %@ ",_model.frontClassName];
        _classNameLab.text = frontClassName;
        
        blankNum = _model.frontClassName.length*2+5;
    }else{
        _classView.hidden = YES;
        _classNameLab.text = @"";
    }
    _classNameLab.textAlignment = NSTextAlignmentCenter;
    
    for (NSInteger i=0; i< blankNum; i++) {
        goodsTitle = [NSString stringWithFormat:@" %@",goodsTitle];
    }
    
    _nameLab.text = goodsTitle;
    
    if (_model.purchased.length > 0) {
        _alreadyLab.hidden = NO;
    }else
        _alreadyLab.hidden = YES;
    

    __block NSString *actTips = @"";
    __block NSString *priceStr = [NSString stringWithFormat:@"¥%@",_model.sellPrice];
    [_model.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([actModel.actType isEqualToString:@"seckill"]) {
            actTips = @"秒杀价";
            priceStr = [NSString stringWithFormat:@"¥%.2f",actModel.actSellPrice];
        }else if([actModel.actType isEqualToString:@"collage"]) {
            actTips = @"拼团价";
            priceStr = [NSString stringWithFormat:@"¥%.2f",actModel.actSellPrice];
        }else if([actModel.actType isEqualToString:@"group"]) {
            actTips = @"团购价";
            priceStr = [NSString stringWithFormat:@"¥%.2f",actModel.actSellPrice];
        }
    }];
    
    _priceLab.text = priceStr;//[NSString stringWithFormat:@"¥%@",_model.sellPrice];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRSemibold size:20] forReplace:@"¥"];
    
    [self create_typeLabelOnView:_model.activities];
    

    _rebateLab.hidden = YES;
    if (actTips.length != 0) {
        _oldPriceLab.hidden = NO;
        _oldPriceLab.attributedText = nil;
        _oldPriceLab.text = actTips;
        _oldPriceLab.textColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
        _oldPriceLab.font = [UIFont systemFontOfSize:12];
    }else{
        _oldPriceLab.font = [UIFont systemFontOfSize:14];
        _oldPriceLab.hidden = YES;
        if ([_extendType integerValue] == 1) {
            if (![DCSpeedy isBlankString:_model.spreadAmount]) {
                _rebateLab.hidden = NO;
                _rebateLab.text = [NSString stringWithFormat:@" 赚%@   ",_model.spreadAmount];
                _oldPriceLab.attributedText = nil;
                _oldPriceLab.text = @"";
            }else{
                _rebateLab.text = @"";
            }
        }else{
            if ([_model.marketPrice floatValue]>[_model.sellPrice floatValue]){
                _oldPriceLab.textColor = [UIColor dc_colorWithHexString:@"#D0D0D0"];
                _oldPriceLab.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" ¥%@ ",_model.marketPrice]];
                _oldPriceLab.hidden = NO;
            }
        }
    }
}
//活动类型：freePostage-包邮活动；coupon-单品优惠券；fullMinus-满减；seckill-秒杀；collage-拼团；group-团购,可用值:freePostage,coupon,fullMinus,seckill,collage,group
- (void)create_typeLabelOnView:(NSArray *)array
{
    UIView *view = [[UIView alloc] init];
    [[self.typeView viewWithTag:1001] removeFromSuperview];
    if (array.count == 0) {
        return;;
    }
    view.tag = 1001;
    CGFloat typeAll_w = 0;
    CGFloat index_w = 0;
    CGFloat index_H = 18;

    for (GLPGoodsActivitiesModel *actModel in array) {
        NSString *title = [NSString stringWithFormat:@" %@  ",[actModel.tips firstObject]];
        UIFont *font = [UIFont fontWithName:PFR size:10];
        CGFloat title_W = [DCSpeedy getWidthWithText:title height:index_H font:font];
        
        UIView *subType = nil;
        if ([actModel.actType isEqualToString:@"seckill"] || [actModel.actType isEqualToString:@"group"] || [actModel.actType isEqualToString:@"collage"]) {
            index_w = index_w+title_W+5+6;
            subType = [self creatLiJianView:actModel withFrame:CGRectMake(typeAll_w, 0, title_W+6, index_H)];
            typeAll_w = typeAll_w+title_W+5+6;
        }else if([actModel.actType isEqualToString:@"freePostage"]) {
            index_w = index_w+title_W+5;
            subType = [self creatFreePostageView:actModel withFrame:CGRectMake(typeAll_w, 0, title_W, index_H)];
            typeAll_w = typeAll_w+title_W+5;
        }else if([actModel.actType isEqualToString:@"coupon"]) {
            index_w = index_w+title_W+5+12;
            subType = [self creatCouponView:actModel withFrame:CGRectMake(typeAll_w, 0, title_W+12, index_H)];
            typeAll_w = typeAll_w+title_W+5+12;
        }else if([actModel.actType isEqualToString:@"fullMinus"]) {
            index_w = index_w+title_W+5;
            subType = [self creatFullMinusView:actModel withFrame:CGRectMake(typeAll_w, 0, title_W, index_H)];
            typeAll_w = typeAll_w+title_W+5;
        }

        
//        if (index_w > self.typeView.dc_width-10) {
//            break;
//        }
        [view addSubview:subType];
    }
    
    if ([self.model.isMixGoods isEqualToString:@"1"]) {
        NSString *title = [NSString stringWithFormat:@" %@  ",@"疗程优惠"];
        UIFont *font = [UIFont fontWithName:PFR size:10];
        CGFloat title_W = [DCSpeedy getWidthWithText:title height:index_H font:font];
        index_w = index_w+title_W+5+6;
        UIView *subType = [self creatLiaoChengView:title withFrame:CGRectMake(typeAll_w, 0, title_W+6, index_H)];
        [view addSubview:subType];
    }
    
    [self.typeView addSubview:view];
}

- (UIView *)creatFreePostageView:(GLPGoodsActivitiesModel *)model withFrame:(CGRect)frame{//包邮
    UIView *needView = [[UIView alloc] init];
    needView.frame = frame;
    needView.backgroundColor = [UIColor dc_colorWithHexString:@"#6C53EF"];
    UILabel *title = [[UILabel alloc] init];
    title.textAlignment  = NSTextAlignmentCenter;
    title.text = [NSString stringWithFormat:@"%@",[model.tips firstObject]];
    title.frame = needView.bounds;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:PFR size:10];
    [needView addSubview:title];
    [needView dc_layerBorderWith:0.1 color:[UIColor dc_colorWithHexString:@"#FFFFFF"] radius:2];
    return needView;
}

- (UIView *)creatCouponView:(GLPGoodsActivitiesModel *)model withFrame:(CGRect)frame{//卷 *减*
    UIView *needView = [[UIView alloc] init];
    needView.frame = frame;
    needView.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    UIImageView *icon = [[UIImageView alloc] init];
    icon.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    icon.frame = CGRectMake(2, 0, 10, needView.dc_height);
    icon.image = [UIImage imageNamed:@"dc_mjj_icon"];
    [needView addSubview:icon];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *title = [[UILabel alloc] init];
    title.textAlignment  = NSTextAlignmentCenter;
    title.text = [NSString stringWithFormat:@" %@  ",[model.tips firstObject]];
    title.frame = CGRectMake(10, 0, needView.dc_width-10, needView.dc_height);;
    title.textColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    title.font = [UIFont fontWithName:PFR size:10];
    [needView addSubview:title];
    [needView dc_layerBorderWith:0.8 color:[UIColor dc_colorWithHexString:@"#FF3B30"] radius:2];
    return needView;
}

- (UIView *)creatFullMinusView:(GLPGoodsActivitiesModel *)model withFrame:(CGRect)frame{//满*减*
    UIView *needView = [[UIView alloc] init];
    needView.frame = frame;
    needView.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];

    UILabel *title = [[UILabel alloc] init];
    title.textAlignment  = NSTextAlignmentCenter;
    title.text = [NSString stringWithFormat:@"%@  ",[model.tips firstObject]];
    title.frame = CGRectMake(0, 0, needView.dc_width, needView.dc_height);;
    title.textColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    title.font = [UIFont fontWithName:PFR size:10];
    [needView addSubview:title];
    [needView dc_layerBorderWith:0.8 color:[UIColor dc_colorWithHexString:@"#FF3B30"] radius:2];
    return needView;
}

- (UIView *)creatLiJianView:(GLPGoodsActivitiesModel *)model withFrame:(CGRect)frame{//带闪电的 立减
    UIView *needView = [[UIView alloc] init];
    needView.frame = frame;
    needView.backgroundColor = [UIColor clearColor];
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"dc_lj_jian"];
    [needView addSubview:icon];
    icon.frame = needView.bounds;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.backgroundColor = [UIColor clearColor];

    UILabel *title = [[UILabel alloc] init];
    title.textAlignment  = NSTextAlignmentLeft;
    title.text = [NSString stringWithFormat:@" %@  ",[model.tips firstObject]];
    title.frame = CGRectMake(0, 1, needView.dc_width, needView.dc_height);;
    title.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    title.font = [UIFont fontWithName:PFR size:10];
    [needView addSubview:title];
    return needView;
}

- (UIView *)creatLiaoChengView:(NSString *)titleStr withFrame:(CGRect)frame{//带闪电的 疗程优惠
    UIView *needView = [[UIView alloc] init];
    needView.frame = frame;
    needView.backgroundColor = [UIColor clearColor];
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"dc_lj_jian"];
    [needView addSubview:icon];
    icon.frame = needView.bounds;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.backgroundColor = [UIColor clearColor];

    UILabel *title = [[UILabel alloc] init];
    title.textAlignment  = NSTextAlignmentLeft;
    title.text = titleStr;
    title.frame = CGRectMake(0, 1, needView.dc_width, needView.dc_height);;
    title.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    title.font = [UIFont fontWithName:PFR size:10];
    [needView addSubview:title];
    return needView;
}


@end
