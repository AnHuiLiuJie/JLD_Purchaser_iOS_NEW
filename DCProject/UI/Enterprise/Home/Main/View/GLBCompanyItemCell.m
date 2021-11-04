//
//  GLBCompanyItemCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCompanyItemCell.h"

@interface GLBCompanyItemCell ()

@property (nonatomic, strong) UIImageView *companyImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation GLBCompanyItemCell

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
    
    _companyImage = [[UIImageView alloc] init];
    _companyImage.contentMode = UIViewContentModeScaleAspectFill;
    _companyImage.clipsToBounds = YES;
    [self.contentView addSubview:_companyImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _descLabel.font = [UIFont fontWithName:PFR size:10];
    _descLabel.numberOfLines = 2;
    [self.contentView addSubview:_descLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_companyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.height.equalTo(68);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyImage.top);
        make.left.equalTo(self.companyImage.right).offset(10);
        make.right.equalTo(self.contentView.right).offset(-10);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
    }];
}


#pragma mark - setter
- (void)setCompanyModel:(GLBCompanyModel *)companyModel
{
    _companyModel = companyModel;
    
    NSString *imageUrl = _companyModel.imgUrl;
    if (!imageUrl || [imageUrl dc_isNull] || imageUrl.length == 0) {
        imageUrl = _companyModel.logoImg;
    }
    
    NSString *title = _companyModel.infoTitle;
    if (!title || [title dc_isNull] || title.length == 0) {
        title = _companyModel.firmName;
    }
    
    [_companyImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = title;
    _descLabel.text = _companyModel.subTitle;
}

@end
