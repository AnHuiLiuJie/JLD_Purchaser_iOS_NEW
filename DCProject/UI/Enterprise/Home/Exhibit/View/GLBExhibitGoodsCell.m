//
//  GLBExhibitGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBExhibitGoodsCell.h"

@interface GLBExhibitGoodsCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation GLBExhibitGoodsCell

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImage.clipsToBounds = YES;
    [self.contentView addSubview:_iconImage];
    self.iconImage.layer.minificationFilter = kCAFilterTrilinear;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.text = @"咳特灵胶囊";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _moneyLabel.font = PFRFont(14);
    _moneyLabel.text = @"￥5.880";
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_moneyLabel];

    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];

    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(5);
        make.right.equalTo(self.contentView.right).offset(-5);
        make.top.equalTo(self.contentView.top).offset(15);
        make.height.equalTo(self.iconImage.width).multipliedBy(0.75);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.iconImage.bottom).offset(3);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(3);
    }];
    
}


#pragma mark - setter
- (void)setGoodsModel:(GLBExhibitGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _goodsModel.goodsTitle;
    
    
    if (_goodsModel.price && _goodsModel.price.length > 0) {
        _moneyLabel.hidden = NO;
        _moneyLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.price];
        _moneyLabel = [UILabel setupAttributeLabel:_moneyLabel textColor:_moneyLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    } else {
        _moneyLabel.hidden = YES;
    }
    
}

@end
