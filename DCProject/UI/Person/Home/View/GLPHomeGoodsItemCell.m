//
//  GLPHomeGoodsItemCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeGoodsItemCell.h"
#import "GLPHomeTagView.h"

@interface GLPHomeGoodsItemCell ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UIImageView *tipImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *spaceLabel;
@property (nonatomic, strong) GLPHomeTagView *tagView;

@end

@implementation GLPHomeGoodsItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self dc_cornerRadius:7];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    [self.contentView addSubview:_goodsImage];
    self.goodsImage.layer.magnificationFilter = kCAFilterTrilinear;

    _tipImage = [[UIImageView alloc] init];
    _tipImage.image = [UIImage imageNamed:@"chufang"];
    _tipImage.hidden = YES;
    [self.contentView addSubview:_tipImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];
    _priceLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _priceLabel.text = @"¥0.00";
    [self.contentView addSubview:_priceLabel];
    
    _spaceLabel = [[UILabel alloc] init];
    _spaceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _spaceLabel.font = [UIFont fontWithName:PFR size:12];
    _spaceLabel.text = @"";
    [self.contentView addSubview:_spaceLabel];
    
    _tagView = [[GLPHomeTagView alloc] init];
    _tagView.hidden = YES;
    [self.contentView addSubview:_tagView];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = (kScreenW - 14*2 - 10)/2;
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.contentView.top);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(height);
        make.width.equalTo(height);
    }];
    
    [_tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.left);
        make.bottom.equalTo(self.goodsImage.bottom);
        make.size.equalTo(CGSizeMake(50, 20));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(5);
        make.right.equalTo(self.contentView.right).offset(-5);
        make.top.equalTo(self.goodsImage.bottom).offset(5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(4);
    }];
    
    [_spaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.priceLabel.bottom).offset(3);
    }];
    
    CGFloat tagHeight = _tagView.hidden ? 0 : 20;
    
    [_tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.spaceLabel.bottom).offset(5);
        make.bottom.equalTo(self.contentView.bottom).offset(-5);
        make.height.equalTo(tagHeight);
    }];
}


#pragma mark - setter
- (void)setListModel:(GLPHomeDataListModel *)listModel
{
    _listModel = listModel;
        
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_listModel.imgUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];

    NSString *title = @"";
//    if (_listModel.subTitle && _listModel.subTitle.length > 0) {
//        title = _listModel.subTitle;
//    }
    if (title.length == 0) {
        title = _listModel.infoTitle;
    }
    _titleLabel.text = title;
    
    GLPHomeDataGoodsModel *goodsModel = _listModel.goodsVo;
    if (goodsModel && goodsModel.goodsPrice) {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.goodsPrice];
        _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    } else {
        _priceLabel.text = @"¥0.00";
    }
    
    if (goodsModel && goodsModel.packingSpec) {
        _spaceLabel.text = goodsModel.packingSpec;
    } else {
        _spaceLabel.text = @"";
    }
    
    if (!goodsModel || (![goodsModel.isImport isEqualToString:@"1"] && ![goodsModel.isPromotion isEqualToString:@"1"] && ![goodsModel.isGroup isEqualToString:@"1"])) {
        _tagView.hidden = YES;
    } else {
        _tagView.hidden = NO;
        _tagView.goodsModel = goodsModel;
    }
    
    _tipImage.hidden = NO;
    if (goodsModel && [goodsModel.isOtc isEqualToString:@"1"]) { // 是otc  不是处方药
        _tipImage.hidden = YES;
    }
    
    [self layoutSubviews];
}

@end
