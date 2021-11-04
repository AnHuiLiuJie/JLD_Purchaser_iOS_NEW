//
//  GLBBrowseTimeCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBBrowseTimeCell.h"

@interface GLBBrowseTimeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBBrowseTimeCell

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
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = PFRFont(13);
    _titleLabel.textAlignment= NSTextAlignmentCenter;
    _titleLabel.text = @"7月13日";
    [self.contentView addSubview:_titleLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.left);
//        make.right.equalTo(self.contentView.right);
//        make.bottom.equalTo(self.contentView.bottom);
        make.edges.equalTo(self.contentView);
        make.height.equalTo(25);
    }];
    
    
}

@end
