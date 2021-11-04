//
//  GLBStoreGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreGoodsCell.h"
#import "GLBGoodsTagView.h"

@interface GLBStoreGoodsCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *sellCountLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *batchLabel;
@property (nonatomic, strong) GLBGoodsTagView *tagView;
@property (nonatomic, strong) UIImageView *retailImage;
@property (nonatomic, strong) UILabel *retailNowPriceLabel;
@property (nonatomic, strong) UILabel *retailOldPriceLabel;
@property (nonatomic, strong) UIImageView *fullImage;
@property (nonatomic, strong) UILabel *fullNowPriceLabel;
@property (nonatomic, strong) UILabel *fullOldPriceLabel;
@property (nonatomic, strong) UIButton *shoppingCarBtn;

@property (nonatomic, strong) UILabel *loginLabel;

@end

@implementation GLBStoreGoodsCell

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
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.contentView addSubview:_bgView];
    
    _sellCountLabel = [[UILabel alloc] init];
    _sellCountLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _sellCountLabel.font = [UIFont fontWithName:PFR size:11];
    _sellCountLabel.text = @"已售0盒";
    _sellCountLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_sellCountLabel];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    [_bgView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"";
    [_bgView addSubview:_titleLabel];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _companyLabel.font = [UIFont fontWithName:PFR size:11];
    _companyLabel.text = @"";
    [_bgView addSubview:_companyLabel];
    
    _batchLabel = [[UILabel alloc] init];
    _batchLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _batchLabel.font = [UIFont fontWithName:PFR size:11];
    _batchLabel.text = @"";
    [_bgView addSubview:_batchLabel];
    
    _tagView = [[GLBGoodsTagView alloc] init];
    [_bgView addSubview:_tagView];
    
    _retailImage = [[UIImageView alloc] init];
    _retailImage.image = [UIImage imageNamed:@"ling"];
    [_bgView addSubview:_retailImage];
    
    _retailNowPriceLabel = [[UILabel alloc] init];
    _retailNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _retailNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _retailNowPriceLabel.text = @"￥0.00";
    [_bgView addSubview:_retailNowPriceLabel];
    
    _retailOldPriceLabel = [[UILabel alloc] init];
    _retailOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _retailOldPriceLabel.font = PFRFont(12)
    _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥0.00  "];
    [_bgView addSubview:_retailOldPriceLabel];
    
    _fullImage = [[UIImageView alloc] init];
    _fullImage.image = [UIImage imageNamed:@"zheng"];
    [_bgView addSubview:_fullImage];
    
    _fullNowPriceLabel = [[UILabel alloc] init];
    _fullNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _fullNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _fullNowPriceLabel.text = @"￥0.00";
    [_bgView addSubview:_fullNowPriceLabel];
    
    _fullOldPriceLabel = [[UILabel alloc] init];
    _fullOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _fullOldPriceLabel.font = PFRFont(12)
    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥0.00  "];
    [_bgView addSubview:_fullOldPriceLabel];
    
    _shoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shoppingCarBtn setBackgroundImage:[UIImage imageNamed:@"jgwc"] forState:0];
    _shoppingCarBtn.adjustsImageWhenHighlighted = NO;
    [_shoppingCarBtn addTarget:self action:@selector(shoppingCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _shoppingCarBtn.userInteractionEnabled = NO;
    [_bgView addSubview:_shoppingCarBtn];
    
    _loginLabel = [[UILabel alloc] init];
    _loginLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _loginLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _loginLabel.text = @"登录可见";
    _loginLabel.hidden = YES;
    _loginLabel.userInteractionEnabled = YES;
    [_bgView addSubview:_loginLabel];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipAction:)];
    [_loginLabel addGestureRecognizer:tap1];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)shoppingCarBtnClick:(UIButton *)button
{
    
}

- (void)tipAction:(id)sender
{
    if (_loginBlcok) {
        _loginBlcok();
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.bgView.top).offset(10);
        make.width.height.equalTo(90);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.top);
        make.left.equalTo(self.goodsImage.right).offset(18);
        make.right.equalTo(self.bgView.right).offset(-10);
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];
    
    [_batchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.companyLabel.bottom).offset(5);
    }];
    
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.batchLabel.bottom).offset(10);
        make.right.equalTo(self.titleLabel.right);
        make.height.equalTo(14);
    }];
    
    [_retailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.tagView.bottom).offset(18);
        make.width.height.equalTo(16);
    }];
    
    [_retailNowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailImage.mas_right).offset(8);
        make.centerY.equalTo(self.retailImage.centerY);
    }];
    
    [_retailOldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailNowPriceLabel.mas_right).offset(20);
        make.centerY.equalTo(self.retailImage.centerY);
    }];
    
    [_fullImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.retailImage.bottom).offset(8);
        make.width.height.equalTo(16);
    }];
    
    [_fullNowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullImage.mas_right).offset(8);
        make.centerY.equalTo(self.fullImage.centerY);
    }];
    
    [_fullOldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullNowPriceLabel.mas_right).offset(20);
        make.centerY.equalTo(self.fullImage.centerY);
    }];
    
    [_sellCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.fullImage.bottom).offset(10);
        make.bottom.equalTo(self.bgView.bottom).offset(-15);
    }];
    
    [_shoppingCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.bottom.equalTo(self.sellCountLabel.top).offset(-19);
        make.width.equalTo(36);
        make.height.equalTo(36);
    }];
    
    [_loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.retailImage.top);
        make.bottom.equalTo(self.fullImage.bottom);
    }];
}


#pragma mark - setter
- (void)setGoodsModel:(GLBStoreGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",_goodsModel.goodsName,_goodsModel.packingSpec];
    _companyLabel.text = _goodsModel.manufactoryAbbr;
    _batchLabel.text = [NSString stringWithFormat:@"批次：%@",_goodsModel.batchNum];
    _sellCountLabel.text = [NSString stringWithFormat:@"已售%@盒",_goodsModel.batchTotalSale];

    _retailOldPriceLabel.hidden = YES;
    _fullOldPriceLabel.hidden = YES;
    
    _tagView.storeGoodsModel = _goodsModel;
    
    _retailImage.hidden = YES;
    _retailNowPriceLabel.hidden = YES;
    _fullImage.hidden = YES;
    _fullNowPriceLabel.hidden = YES;
    
    if (_goodsModel.sellType == 2) { //整售
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        
    } else if (_goodsModel.sellType == 4) { // 零售
        
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    } else if (_goodsModel.sellType == 3) { // 整 + 零
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        
    }

    if (_retailNowPriceLabel.hidden == NO && [_goodsModel.zeroPrice floatValue] == 0) {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
    }
    
    if (_fullNowPriceLabel.hidden == NO && [_goodsModel.wholePrice floatValue] == 0) {
        _fullImage.hidden = YES;
        _fullNowPriceLabel.hidden = YES;
    }

    if ([[DCLoginTool shareTool] dc_isLogin]) {
        _loginLabel.hidden = YES;
    } else {
        _loginLabel.hidden = NO;
    }
}


@end
