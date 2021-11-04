//
//  GLBMineLogoutCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineLogoutCell.h"

@interface GLBMineLogoutCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBMineLogoutCell

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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"退出登录";
    _titleLabel.backgroundColor = [UIColor whiteColor];
    [_titleLabel dc_cornerRadius:5];
    [self.contentView addSubview:_titleLabel];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 10, 10));
        make.height.equalTo(38);
    }];
    
}



@end
