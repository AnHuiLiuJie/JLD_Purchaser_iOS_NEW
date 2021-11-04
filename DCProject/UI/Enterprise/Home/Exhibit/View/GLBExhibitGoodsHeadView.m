//
//  GLBExhibitGoodsHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBExhibitGoodsHeadView.h"

@interface GLBExhibitGoodsHeadView ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBExhibitGoodsHeadView

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
    _iconImage.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [self addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.text = @"感冒药";
    [self addSubview:_titleLabel];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(25);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(2, 10));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(5);
        make.right.equalTo(self.right).offset(-25);
        make.centerY.equalTo(self.iconImage.centerY);
    }];
    
}


#pragma mark - setter
- (void)setInfoModel:(GLBExhibitInfoModel *)infoModel
{
    _infoModel = infoModel;
    
    _titleLabel.text = _infoModel.typeName;
    
}


@end
