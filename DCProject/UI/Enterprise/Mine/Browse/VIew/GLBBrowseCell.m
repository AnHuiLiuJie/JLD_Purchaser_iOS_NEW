//
//  GLBBrowseCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBBrowseCell.h"

@interface GLBBrowseCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *shopImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *sellCountLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIImageView *retailImage;
@property (nonatomic, strong) UILabel *retailNowPriceLabel;
@property (nonatomic, strong) UILabel *retailOldPriceLabel;
@property (nonatomic, strong) UIImageView *fullImage;
@property (nonatomic, strong) UILabel *fullNowPriceLabel;
@property (nonatomic, strong) UILabel *fullOldPriceLabel;

@end

@implementation GLBBrowseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView dc_cornerRadius:5];
    [self dc_cornerRadius:5];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.contentView addSubview:_bgView];
    
    _shopImage = [[UIImageView alloc] init];
    _shopImage.image = [UIImage imageNamed:@"dianpu"];
    [self.contentView addSubview:_shopImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopNameLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _shopNameLabel.text = @"致健旗舰店";
    [_bgView addSubview:_shopNameLabel];
    
    _sellCountLabel = [[UILabel alloc] init];
    _sellCountLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _sellCountLabel.font = [UIFont fontWithName:PFR size:11];
    _sellCountLabel.text = @"已售2300盒";
    _sellCountLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_sellCountLabel];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F7F7"];
    [_bgView addSubview:_line];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    _goodsImage.image = [UIImage imageNamed:@"placher-1"];
    [_bgView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"复方丹参滴丸 27mg*180丸复方丹参滴丸 27mg*180丸";
    [_bgView addSubview:_titleLabel];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _companyLabel.font = [UIFont fontWithName:PFR size:11];
    _companyLabel.text = @"华润三九医药股份有限公司";
    [_bgView addSubview:_companyLabel];
    
    _tagView = [[UIView alloc] init];
//    _tagView.backgroundColor = [UIColor redColor];
    [_bgView addSubview:_tagView];
    
    _retailImage = [[UIImageView alloc] init];
    _retailImage.image = [UIImage imageNamed:@"ling"];
    [_bgView addSubview:_retailImage];
    
    _retailNowPriceLabel = [[UILabel alloc] init];
    _retailNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _retailNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _retailNowPriceLabel.text = @"￥5.880";
    [_bgView addSubview:_retailNowPriceLabel];
    
    _retailOldPriceLabel = [[UILabel alloc] init];
    _retailOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _retailOldPriceLabel.font = PFRFont(12)
    _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥7.880  "];
    [_bgView addSubview:_retailOldPriceLabel];
    
    _fullImage = [[UIImageView alloc] init];
    _fullImage.image = [UIImage imageNamed:@"zheng"];
    [_bgView addSubview:_fullImage];
    
    _fullNowPriceLabel = [[UILabel alloc] init];
    _fullNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _fullNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _fullNowPriceLabel.text = @"￥15.880";
    [_bgView addSubview:_fullNowPriceLabel];
    
    _fullOldPriceLabel = [[UILabel alloc] init];
    _fullOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _fullOldPriceLabel.font = PFRFont(12)
    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥18.880  "];
    [_bgView addSubview:_fullOldPriceLabel];
    
    [self layoutIfNeeded];
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.height.equalTo(1);
        make.top.equalTo(self.bgView.top).offset(27);
    }];
    
    [_sellCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.bgView.top);
        make.bottom.equalTo(self.line.top);
        make.width.lessThanOrEqualTo(100);
    }];
    
    [_shopImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.centerY.equalTo(self.sellCountLabel.centerY);
        make.width.equalTo(15);
        make.height.equalTo(15);
    }];
    
    [_shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImage.right).offset(5);
        make.right.equalTo(self.sellCountLabel.left).offset(-5);
        make.centerY.equalTo(self.sellCountLabel.centerY);
    }];
    
    [_goodsImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.line.bottom).offset(10);
        make.width.height.equalTo(90);
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.top);
        make.left.equalTo(self.goodsImage.right).offset(18);
        make.right.equalTo(self.bgView.right).offset(-10);
    }];
    
    [_companyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];
    

    [_tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.companyLabel.bottom).offset(10);
        make.right.equalTo(self.titleLabel.right);
        make.height.equalTo(14);
    }];
    
    CGFloat spacing1 = self.tagView.hidden ? 0 : 18;
    [_retailImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.tagView.bottom).offset(spacing1);
        make.width.height.equalTo(16);
    }];
    
    [_retailNowPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailImage.mas_right).offset(8);
        make.centerY.equalTo(self.retailImage.centerY);
    }];
    
    [_retailOldPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailNowPriceLabel.mas_right).offset(20);
        make.centerY.equalTo(self.retailImage.centerY);
    }];
    
    CGFloat spacing2 = self.retailImage.hidden ? 0 : 8;
    [_fullImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.retailImage.bottom).offset(spacing2);
        make.width.height.equalTo(16);
        make.bottom.equalTo(self.bgView.bottom).offset(-17);
    }];
    
    [_fullNowPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullImage.mas_right).offset(8);
        make.centerY.equalTo(self.fullImage.centerY);
    }];
    
    [_fullOldPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullNowPriceLabel.mas_right).offset(20);
        make.centerY.equalTo(self.fullImage.centerY);
    }];
    
}


#pragma mark - setter
- (void)setBrowseModel:(GLBBrowseModel *)browseModel
{
    _browseModel = browseModel;
    
    _shopNameLabel.text = _browseModel.frimName;
    _sellCountLabel.text = [NSString stringWithFormat:@"已售%@盒",_browseModel.totalSales];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_browseModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _browseModel.goodsName;
    _companyLabel.text = _browseModel.manufactory;
    
    if (_browseModel.zeroPrice && _browseModel.zeroPrice.length > 0) {
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%.3f",[_browseModel.zeroPrice floatValue]];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    } else {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
    }
    
    if (_browseModel.wholePrice && [_browseModel.wholePrice length] >0) {
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_browseModel.wholePrice floatValue]];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    } else {
        _fullImage.hidden = YES;
        _fullNowPriceLabel.hidden = YES;
    }
    
    
    _tagView.hidden = YES;
    _fullOldPriceLabel.hidden = YES;
    _retailOldPriceLabel.hidden = YES;
    
    [self layoutSubviews];
}

@end
