//
//  GLBSelectAddressCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSelectAddressCell.h"

@interface GLBSelectAddressCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImage;

@property (nonatomic, strong) UIImageView *topLineImg;

@end

@implementation GLBSelectAddressCell

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"sz_shdzgl"];
    [_bgView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:PFR size:14];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.text = @"选择收货地址";
    [_bgView addSubview:_titleLabel];
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [_bgView addSubview:_rightImage];
    
    self.topLineImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dc_cell1_line"]];
    [_bgView addSubview:self.topLineImg];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(55).priorityHigh();
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.left.equalTo(self.bgView.left).offset(15);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.centerY.equalTo(self.bgView.centerY);
    }];
    
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-15);
        make.centerY.equalTo(self.bgView.centerY);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [self.topLineImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bgView);
        make.height.equalTo(5);
    }];
}

@end
