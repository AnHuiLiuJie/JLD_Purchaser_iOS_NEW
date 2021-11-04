//
//  GLBAddressSwitchCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddressSwitchCell.h"

@interface GLBAddressSwitchCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBAddressSwitchCell


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
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.text = @"设置为默认";
    [self.contentView addSubview:_titleLabel];
    
    _defaultSwitch = [[UISwitch alloc] init];
    _defaultSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [_defaultSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    _defaultSwitch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_defaultSwitch];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)switchClick:(UIButton *)button
{
    
}



#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(80);
        make.height.equalTo(50);
    }];
    
    [_defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.size.equalTo(CGSizeMake(50, 30));
    }];
    
    
}


@end
