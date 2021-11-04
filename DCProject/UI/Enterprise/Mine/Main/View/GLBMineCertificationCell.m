//
//  GLBMineCertificationCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineCertificationCell.h"

@interface GLBMineCertificationCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation GLBMineCertificationCell

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
    _iconImage.image = [UIImage imageNamed:@"wode_qyrz"];
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _titleLabel.text = @"资质状态";
    [self.contentView addSubview:_titleLabel];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor dc_colorWithHexString:@"#FF8B63"];
    _statusLabel.font = PFRFont(11);
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.text = @"";
    [_statusLabel dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FF8B63"] radius:10];
    [self.contentView addSubview:_statusLabel];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [_statusLabel sizeThatFits:CGSizeMake(200, 30)];
    
    [_statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-14);
        make.top.equalTo(self.contentView.top).offset(16);
        make.bottom.equalTo(self.contentView.bottom).offset(-16);
        make.size.equalTo(CGSizeMake(size.width + 10, 20));
    }];
    
    [_iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLabel.centerY);
        make.left.equalTo(self.contentView.left).offset(14);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(14);
        make.right.equalTo(self.statusLabel.left).offset(-12);
        make.centerY.equalTo(self.statusLabel.centerY);
    }];
}


#pragma mark - setter
- (void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    if (_infoDict && _infoDict[@"qcStateStr"]) {
        _statusLabel.text = _infoDict[@"qcStateStr"];
    }

    if (_statusLabel.text.length == 0) {
        _statusLabel.hidden = YES;
    } else {
        _statusLabel.hidden = NO;
    }
    
    [self layoutSubviews];
}

@end
