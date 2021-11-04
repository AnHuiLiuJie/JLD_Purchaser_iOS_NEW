//
//  GLPAddShoppingCarCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPAddShoppingCarCell.h"

@interface GLPAddShoppingCarCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *markPriceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GLPAddShoppingCarCell

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImage.clipsToBounds = YES;
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = PFRFont(16);
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#F84B14"];
    _priceLabel.font = PFRFont(20);
    _priceLabel.text = @"¥0.00";
    [self.contentView addSubview:_priceLabel];
    
    _markPriceLabel = [[UILabel alloc] init];
    _markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    _markPriceLabel.font = PFRFont(14);
    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"¥0.00"];
    [self.contentView addSubview:_markPriceLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    _countLabel.font = PFRFont(12);
    _countLabel.text = @"库存 0";
    [self.contentView addSubview:_countLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5200"];
    _timeLabel.font = PFRFont(12);
    _timeLabel.text = @"（有效期至 -）";
    [self.contentView addSubview:_timeLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
//        make.bottom.equalTo(self.contentView.bottom).offset(-44);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(8);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.iconImage.top);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.iconImage.bottom);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel.centerY);
        make.left.equalTo(self.countLabel.right);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.left);
        make.bottom.equalTo(self.countLabel.top).offset(-5);
    }];
    
    [_markPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.centerY);
        make.left.equalTo(self.priceLabel.right).offset(5);
    }];
}


#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    NSString *imageUrl = _detailModel.goodsImgs;
    if ([imageUrl containsString:@","]) {
        imageUrl = [imageUrl componentsSeparatedByString:@","][0];
    }
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _detailModel.goodsTitle;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_detailModel.sellPrice];
    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"¥%.2f",_detailModel.marketPrice]];
    _countLabel.text = [NSString stringWithFormat:@"库存 %ld",(long)_detailModel.totalStock];
    
//    NSString *time = _detailModel.time
//    _timeLabel.text = [NSString stringWithFormat:@"（有效期至 -）"];
    _timeLabel.hidden = YES;
}


@end
