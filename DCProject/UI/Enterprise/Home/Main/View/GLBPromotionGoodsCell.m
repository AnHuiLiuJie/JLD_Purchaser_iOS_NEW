//
//  GLBPromotionGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBPromotionGoodsCell.h"
#import "GLBGoodsTimeView.h"

@interface GLBPromotionGoodsCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *batchLabel;
@property (nonatomic, strong) GLBGoodsTimeView *timeView;
@property (nonatomic, strong) UIImageView *retailImage;
@property (nonatomic, strong) UILabel *retailNowPriceLabel;
@property (nonatomic, strong) UILabel *retailOldPriceLabel;
@property (nonatomic, strong) UIImageView *fullImage;
@property (nonatomic, strong) UILabel *fullNowPriceLabel;
@property (nonatomic, strong) UILabel *fullOldPriceLabel;
@property (nonatomic, strong) UILabel *sellCountLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation GLBPromotionGoodsCell

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
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    [_bgView addSubview:_goodsImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"";
    [_bgView addSubview:_titleLabel];
    
    _batchLabel = [[UILabel alloc] init];
    _batchLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _batchLabel.text = @"";
    _batchLabel.font = PFRFont(12);
    [_bgView addSubview:_batchLabel];
    
    _timeView = [[GLBGoodsTimeView alloc] init];
    [_bgView addSubview:_timeView];
    
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
    
    _slider = [[UISlider alloc] init];
    _slider.minimumTrackTintColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _slider.maximumTrackTintColor = [UIColor dc_colorWithHexString:@"#F0F0F0"];
    _slider.maximumValue = 100;
    _slider.minimumValue = 0;
    _slider.value = 0;
    _slider.thumbTintColor = [UIColor clearColor];
    [_bgView addSubview:_slider];
    
    _sellCountLabel = [[UILabel alloc] init];
    _sellCountLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _sellCountLabel.font = [UIFont fontWithName:PFR size:11];
    _sellCountLabel.text = @"已抢0件";
    [_bgView addSubview:_sellCountLabel];
    
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    [_buyBtn setTitle:@"马上抢" forState:0];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:0];
    _buyBtn.titleLabel.font = PFRFont(12);
    [_buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBtn dc_cornerRadius:5];
    _buyBtn.userInteractionEnabled = NO;
    [_bgView addSubview:_buyBtn];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)buyBtnClick:(UIButton *)button
{
    
}


#pragma mark - setter
- (void)setGoodsModel:(GLBPromoteModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    NSString *imageUrl = _goodsModel.imgUrl;
    if (!imageUrl || [imageUrl dc_isNull] || imageUrl.length == 0) {
        imageUrl = _goodsModel.goodsImg;
    }
    
    NSString *title = _goodsModel.infoTitle;
    if (!title || [title dc_isNull] || title.length == 0) {
        title = _goodsModel.goodsName;
    }
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = title;
    _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%.3f",_goodsModel.zeroNotaxPrice];
    _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
     _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%.3f",_goodsModel.wholeNotaxPrice];
    _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _batchLabel.text = [NSString stringWithFormat:@"批次：%@",_goodsModel.batchNum];
    
    NSInteger count = _goodsModel.activitySales;
    _sellCountLabel.text = [NSString stringWithFormat:@"已抢%ld件",count];
    
    _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"  ￥ %.3f  ",_goodsModel.oldZeroNotaxPrice]];
    _retailOldPriceLabel = [UILabel setupAttributeLabel:_retailOldPriceLabel textColor:_retailOldPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"  ￥ %.3f  ",_goodsModel.oldZeroNotaxPrice]];
    _fullOldPriceLabel = [UILabel setupAttributeLabel:_fullOldPriceLabel textColor:_fullOldPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    
    _slider.minimumValue = 0;
    _slider.maximumValue = 0;
    _slider.value = 0;
    
    _slider.minimumValue = 0;
    _slider.maximumValue = _goodsModel.promotionStock;
    _slider.value = count;
    
    _timeView.goodsModel = _goodsModel;
    
    if (_goodsModel.zeroNotaxPrice==0)
    {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
        _retailOldPriceLabel.hidden = YES;
    }
    else{
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailOldPriceLabel.hidden = NO;
    }
    if (_goodsModel.wholeNotaxPrice==0)
       {
           _fullImage.hidden = YES;
           _fullNowPriceLabel.hidden = YES;
           _fullOldPriceLabel.hidden = YES;
       }
       else{
           _fullImage.hidden = NO;
           _fullNowPriceLabel.hidden = NO;
           _fullOldPriceLabel.hidden = NO;
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
        make.width.height.equalTo(110);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.top);
        make.left.equalTo(self.goodsImage.right).offset(18);
        make.right.equalTo(self.bgView.right).offset(-10);
    }];
    
    [_batchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.batchLabel.bottom).offset(10);
        make.right.equalTo(self.titleLabel.right);
        make.height.equalTo(18);
    }];
    
    [_retailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.timeView.bottom).offset(12);
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
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.fullImage.mas_bottom).offset(30);
        make.height.equalTo(4);
        make.width.equalTo(0.46*kScreenW);
        make.bottom.equalTo(self.bgView.bottom).offset(-18);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.slider.centerY);
        make.width.equalTo(60);
        make.height.equalTo(27);
    }];
    
    [_sellCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider.centerY);
        make.left.equalTo(self.slider.right).offset(12);
        make.right.equalTo(self.buyBtn.left);
    }];
}

@end
