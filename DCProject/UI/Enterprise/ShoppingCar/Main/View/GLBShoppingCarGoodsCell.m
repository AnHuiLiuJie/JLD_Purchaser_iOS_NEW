//
//  GLBShoppingCarGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBShoppingCarGoodsCell.h"

@interface GLBShoppingCarGoodsCell ()

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *allPriceLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *logoImage;

@end

@implementation GLBShoppingCarGoodsCell

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
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"dc_gx_no"] forState:0];
    [_editBtn setImage:[UIImage imageNamed:@"dc_gx_yes"] forState:UIControlStateSelected];
    _editBtn.adjustsImageWhenHighlighted = NO;
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    [self.contentView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _companyLabel.font = [UIFont fontWithName:PFR size:11];
    [self.contentView addSubview:_companyLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _timeLabel.font = [UIFont fontWithName:PFR size:11];
    [self.contentView addSubview:_timeLabel];
    
    _allPriceLabel = [[UILabel alloc] init];
    _allPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _allPriceLabel.font = [UIFont fontWithName:PFRSemibold size:14];
    [self.contentView addSubview:_allPriceLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _priceLabel.font = [UIFont fontWithName:PFR size:12];
    [self.contentView addSubview:_priceLabel];

    _countView = [[GLBEditCountView alloc] init];
    [self.contentView addSubview:_countView];
    
    _logoImage = [[UIImageView alloc] init];
    _logoImage.image = [UIImage imageNamed:@"ling"];
//    _logoImage.contentMode = UIViewContentModeScaleAspectFill;
//    _logoImage.clipsToBounds = YES;
    [self.contentView addSubview:_logoImage];

    [self layoutIfNeeded];
}


#pragma mark - 点击事件
- (void)editBtnClick:(UIButton *)button
{
    _goodsModel.isSelected = ! _goodsModel.isSelected;
    
    if (_goodsCellBlock) {
        _goodsCellBlock(_goodsModel);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(-16);
        make.left.equalTo(self.contentView.left);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.editBtn.centerY);
        make.left.equalTo(self.editBtn.mas_right);
        make.size.equalTo(CGSizeMake(110, 110));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.right).offset(17);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.goodsImage.top);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsImage.bottom);
        make.left.equalTo(self.titleLabel.left).offset(20);
    }];
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.centerY);
        make.right.equalTo(self.priceLabel.left).offset(-5);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel.top).offset(-5);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
    }];
    
    [_allPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(32);
    }];
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(0);
        make.size.equalTo(CGSizeMake(90, 40));
    }];
}


#pragma mark - setter
- (void)setGoodsModel:(GLBShoppingCarGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",_goodsModel.goodsName,_goodsModel.packingSpec];
    _companyLabel.text = _goodsModel.manufactory;
    _editBtn.selected = _goodsModel.isSelected;
    _countView.countTF.text = [NSString stringWithFormat:@"%ld",_goodsModel.quantity];
    
    CGFloat price = _goodsModel.price;
    if (_goodsModel.hasCtrl) {
        price = _goodsModel.ctrlPrice;
    }
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    CGFloat allPrice = price *_goodsModel.quantity;
    _allPriceLabel.attributedText = [self attributeWithMoney:[NSString stringWithFormat:@"%.2f",allPrice]];

    NSString *time = _goodsModel.effectTime;
    if ([time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    if (time && ![time dc_isNull] && time.length > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"有效期:%@",time];
    } else {
        _timeLabel.hidden = YES;
    }
    
    if (_goodsModel.priceType && [_goodsModel.priceType isEqualToString:@"2"]) {
        _logoImage.image = [UIImage imageNamed:@"zheng"];
    } else {
        _logoImage.image = [UIImage imageNamed:@"ling"];
    }
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
