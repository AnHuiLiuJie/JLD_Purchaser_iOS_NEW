//
//  GLBPlantSectionView.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBPlantSectionView.h"

@interface GLBPlantSectionView ()

@property (nonatomic, strong) UIImageView *leftLine;
@property (nonatomic, strong) UIImageView *rightLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleImage;

@end

@implementation GLBPlantSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _leftLine = [[UIImageView alloc] init];
    _leftLine.backgroundColor = [UIColor dc_colorWithHexString:@"#333333"];
    [self.contentView addSubview:_leftLine];
    
    _rightLine = [[UIImageView alloc] init];
    _rightLine.backgroundColor = [UIColor dc_colorWithHexString:@"#333333"];
    [self.contentView addSubview:_rightLine];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.text = @"种植户";
    [self.contentView addSubview:_titleLabel];
    
    _titleImage = [[UIImageView alloc] init];
    _titleImage.image = [UIImage imageNamed:@"zzh"];
    [self.contentView addSubview:_titleImage];
    
    [self layoutIfNeeded];
}


#pragma mark - setter
- (void)setSection:(NSInteger)section
{
    _section = section;
    
    if (_section == 0) {
        _titleLabel.text = @"种植户";
        _titleImage.image = [UIImage imageNamed:@"zzh"];
    } else {
        _titleLabel.text = @"原料药品种";
        _titleImage.image = [UIImage imageNamed:@"ylypz"];
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX).offset(10);
        make.centerY.equalTo(self.contentView.centerY).offset(5);
    }];
    
    [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.titleLabel.left).offset(-6);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleImage.left).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(16, 1));
    }];
    
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(16, 1));
    }];
}




@end
