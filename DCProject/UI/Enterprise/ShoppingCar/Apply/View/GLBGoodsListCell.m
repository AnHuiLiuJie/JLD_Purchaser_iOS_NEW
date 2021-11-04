//
//  GLBGoodsListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsListCell.h"

@interface GLBGoodsListCell ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *fullImage;
@property (nonatomic, strong) UILabel *fullNowPriceLabel;
@property (nonatomic, strong) UILabel *fullOldPriceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation GLBGoodsListCell

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
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    [self.contentView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _companyLabel.font = [UIFont fontWithName:PFR size:11];
    _companyLabel.text = @"湖南国华制药有限公司";
    [self.contentView addSubview:_companyLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _timeLabel.font = [UIFont fontWithName:PFR size:11];
    _timeLabel.text = @"有效期：-";
    [self.contentView addSubview:_timeLabel];
    
    _fullImage = [[UIImageView alloc] init];
    _fullImage.image = [UIImage imageNamed:@"zheng"];
    [self.contentView  addSubview:_fullImage];
    
    _fullNowPriceLabel = [[UILabel alloc] init];
    _fullNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _fullNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _fullNowPriceLabel.text = @"￥0";
    [self.contentView  addSubview:_fullNowPriceLabel];
    
    _fullOldPriceLabel = [[UILabel alloc] init];
    _fullOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _fullOldPriceLabel.font = PFRFont(12)
    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥0.00  "];
    [self.contentView  addSubview:_fullOldPriceLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _countLabel.font = [UIFont fontWithName:PFR size:12];
    _countLabel.text = @"× 0";
    [self.contentView addSubview:_countLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _priceLabel.font = [UIFont fontWithName:PFR size:12];
    _priceLabel.text = @"单品小计：0";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    
    [self layoutIfNeeded];
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15);
        make.left.equalTo(self.contentView.left).offset(10);
        make.size.equalTo(CGSizeMake(110, 110));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.right).offset(17);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.goodsImage.top);
    }];
    
    [_fullImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.goodsImage.bottom);
        make.width.height.equalTo(16);
    }];
    
    [_fullNowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullImage.right).offset(8);
        make.centerY.equalTo(self.fullImage.centerY);
    }];
    
    [_fullOldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullNowPriceLabel.right).offset(20);
        make.centerY.equalTo(self.fullImage.centerY);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fullImage.top).offset(-10);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.top).offset(0);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-10);
        make.top.equalTo(self.goodsImage.bottom).offset(10);
        make.height.equalTo(32);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.centerY.equalTo(self.priceLabel.centerY);
        make.width.lessThanOrEqualTo(120);
        make.right.equalTo(self.priceLabel.left).offset(-5);
    }];
    
}



#pragma mark - setter
- (void)setGoodsModel:(GLBShoppingCarGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",_goodsModel.goodsName,_goodsModel.packingSpec];
    _companyLabel.text = _goodsModel.manufactory;
    
    NSString *time = _goodsModel.effectTime;
    if (time && [time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    if (time && time.length > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"有效期：%@",time];
    } else {
        _timeLabel.hidden = YES;
    }
    if ([_goodsModel.priceType isEqualToString:@"2"]) {
        _fullImage.image = [UIImage imageNamed:@"zheng"];
    } else if ([_goodsModel.priceType isEqualToString:@"4"]) {
        _fullImage.image = [UIImage imageNamed:@"ling"];
    }
    _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",_goodsModel.price *_goodsModel.quantity];
    _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _fullOldPriceLabel.hidden = YES;
    _countLabel.text = [NSString stringWithFormat:@"× %ld",(long)_goodsModel.quantity];
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_goodsModel.price];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    
}

@end
