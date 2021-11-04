//
//  GLPDetailEnsureCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPDetailEnsureCell.h"

@interface GLPDetailEnsureCell ()

@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation GLPDetailEnsureCell

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#8A8989"];
    _titleLabel.font = [UIFont fontWithName:PFR size:16];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#8A8989"];
    _subLabel.font = [UIFont fontWithName:PFR size:16];
    _subLabel.text = @"";
    [self.contentView addSubview:_subLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(20);
        make.top.equalTo(self.contentView.top).offset(5);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.top.equalTo(self.contentView.top);
        make.right.equalTo(self.contentView.right).offset(-15);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-40);
    }];
    
    
}


@end
