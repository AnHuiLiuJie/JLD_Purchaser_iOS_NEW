//
//  GLPShoppingCarGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPShoppingCarGoodsCell.h"

@interface GLPShoppingCarGoodsCell ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *spacLabel;
@property (nonatomic, strong) UILabel *ydPriceLabel;
@property (nonatomic, strong) UILabel *allPriceLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *mixTipLab;

@end

@implementation GLPShoppingCarGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"bg"];
    _bgImage.hidden = YES;
    [self.contentView addSubview:_bgImage];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"weixuanz"] forState:0];
    [_editBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    _editBtn.adjustsImageWhenHighlighted = NO;
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    _goodsImage.image = [UIImage imageNamed:@"img1"];
    [self.contentView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _spacLabel = [[UILabel alloc] init];
    _spacLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _spacLabel.font = [UIFont fontWithName:PFR size:14];
    _spacLabel.text = @"";
    [self.contentView addSubview:_spacLabel];
    
    _mixTipLab = [[UILabel alloc] init];
    _mixTipLab.textColor = [UIColor dc_colorWithHexString:@"#FF4A13"];
    _mixTipLab.font = [UIFont fontWithName:PFR size:12];
    _mixTipLab.text = @"";
    [self.contentView addSubview:_mixTipLab];
    
    _ydPriceLabel = [[UILabel alloc] init];
    _ydPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _ydPriceLabel.font = [UIFont fontWithName:PFR size:12];
    _ydPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"市场价￥0.00"];
    [self.contentView addSubview:_ydPriceLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4A13"];
    _priceLabel.font = [UIFont fontWithName:PFRSemibold size:18];
    _priceLabel.text = @"¥0.00";
    [self.contentView addSubview:_priceLabel];
    
    _allPriceLabel = [[UILabel alloc] init];
    _allPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4A13"];
    _allPriceLabel.font = [UIFont fontWithName:PFR size:12];
    _allPriceLabel.text = @"单品小计：¥0.00";
    [self.contentView addSubview:_allPriceLabel];
    
    _countView = [[GLPEditCountView alloc] init];
//    _countView.delegate = self;
//    _countView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_countView];
    
    [self layoutIfNeeded];
}



#pragma mark - 点击事件
- (void)editBtnClick:(UIButton *)button
{
    button.selected =! button.selected;
    
    if (_goodsCellBlock) {
        _goodsCellBlock(button.selected);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(25);
        make.left.equalTo(self.contentView.left).offset(50);
        make.size.equalTo(CGSizeMake(84, 84));
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodsImage.centerY);
        make.left.equalTo(self.contentView.left).offset(10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.right).offset(7);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.goodsImage.top).offset(-8);
    }];
    
    [_spacLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];

    
    [_ydPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.bottom.equalTo(self.goodsImage.bottom).offset(8);
    }];
    
    [_mixTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.ydPriceLabel.bottom).offset(2.5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.bottom).offset(15);
        make.left.equalTo(self.titleLabel.left);
    }];
    
    [_allPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.bottom).offset(5);
        make.left.equalTo(self.titleLabel.left);
    }];
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.size.equalTo(CGSizeMake(100, 40));
    }];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}



#pragma mark - setter
- (void)setNoActGoodsModel:(GLPNewShopCarGoodsModel *)noActGoodsModel
{
    _noActGoodsModel = noActGoodsModel;
    
    _bgImage.hidden = YES;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_noActGoodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _noActGoodsModel.goodsTitle;
    _spacLabel.text = _noActGoodsModel.packingSpec;
    
    
    CGFloat goodsSubtotal = [_noActGoodsModel.quantity floatValue] * [_noActGoodsModel.sellPrice floatValue];
    _noActGoodsModel.goodsSubtotal = [NSString stringWithFormat:@"%.2f",goodsSubtotal];
    _allPriceLabel.attributedText = [self attributeWithMoney:_noActGoodsModel.goodsSubtotal];
    
    if (_noActGoodsModel.mixTip.length > 0) {
//        _mixTipLab.text = _noActGoodsModel.mixTip;
//        _ydPriceLabel.hidden = YES;
        
        _ydPriceLabel.attributedText = [NSString dc_strikethroughWithString:@""];
        _ydPriceLabel.text = _noActGoodsModel.mixTip;
        _ydPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#F84B14"];
    }else{
//        _mixTipLab.text = @"";
//        _ydPriceLabel.hidden = NO;
        
        _ydPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"市场价￥%@",_noActGoodsModel.marketPrice]];
        _ydPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    }
    
    GLPMarketingMixListModel *marketingMix = _noActGoodsModel.marketingMix;
    if (marketingMix.mixId.length > 0) {//组合装
        int num = [_noActGoodsModel.quantity intValue] / [marketingMix.mixNum intValue];
        _countView.countTF.text = [NSString stringWithFormat:@"%d",num];
        _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[marketingMix.mixNum floatValue] * [_noActGoodsModel.sellPrice floatValue]];
    }else{
        _countView.countTF.text = [NSString stringWithFormat:@"%@",_noActGoodsModel.quantity];
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",_noActGoodsModel.sellPrice];
    }
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:16] forReplace:@"¥"];

    
    _editBtn.selected = _noActGoodsModel.isSelected;
}


- (void)setActGoodsModel:(GLPNewShopCarGoodsModel *)actGoodsModel
{
    _actGoodsModel = actGoodsModel;
    
    _bgImage.hidden = NO;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_actGoodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _actGoodsModel.goodsTitle;
    _spacLabel.text = _actGoodsModel.packingSpec;

    CGFloat goodsSubtotal = [_actGoodsModel.quantity floatValue] * [_actGoodsModel.sellPrice floatValue];
    _actGoodsModel.goodsSubtotal = [NSString stringWithFormat:@"%.2f",goodsSubtotal];
    _allPriceLabel.attributedText = [self attributeWithMoney:_actGoodsModel.goodsSubtotal];
    
    
    if (_actGoodsModel.mixTip.length > 0) {
//        _mixTipLab.text = _actGoodsModel.mixTip;
//        _ydPriceLabel.hidden = YES;
        
        _ydPriceLabel.attributedText = [NSString dc_strikethroughWithString:@""];
        _ydPriceLabel.text = _actGoodsModel.mixTip;
        _ydPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#F84B14"];
    }else{
//        _mixTipLab.text = @"";
//        _ydPriceLabel.hidden = NO;
        
        _ydPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"市场价￥%@",_actGoodsModel.marketPrice]];
        _ydPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    }
    
    GLPMarketingMixListModel *marketingMix = _actGoodsModel.marketingMix;
    if (marketingMix.mixId.length > 0) {//组合装
        int num = [_actGoodsModel.quantity intValue] / [marketingMix.mixNum intValue];
        _countView.countTF.text = [NSString stringWithFormat:@"%d",num];
        _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[marketingMix.mixNum floatValue] * [_actGoodsModel.sellPrice floatValue]];
    }else{
        _countView.countTF.text = [NSString stringWithFormat:@"%@",_actGoodsModel.quantity];
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",_actGoodsModel.sellPrice];
    }
    
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:[UIFont fontWithName:PFRMedium size:15] maxFont:[UIFont fontWithName:PFRSemibold size:17] forReplace:@"¥"];

    _editBtn.selected = _actGoodsModel.isSelected;
}

#pragma mark - 富文本
- (NSMutableAttributedString *)attributeWithMoney:(NSString *)money
{
    NSString *text = [NSString stringWithFormat:@"单品小计：¥%@",money];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSString *floStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(0, 5)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(5, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(6, attrStr.length - 6)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:range2];
    
    return attrStr;
}

@end
