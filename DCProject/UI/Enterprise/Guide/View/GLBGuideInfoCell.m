//
//  GLBGuideInfoCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGuideInfoCell.h"

@interface GLBGuideInfoCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *pictureImage;

@end

@implementation GLBGuideInfoCell

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
    [self dc_cornerRadius:5];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"xin"];
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _titleLabel.font = [UIFont fontWithName:PFR size:12];
    _titleLabel.text = @"互联网药品交易服务资格证书";
    [self.contentView addSubview:_titleLabel];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _numberLabel.font = [UIFont fontWithName:PFR size:14];
    _numberLabel.text = @"国 A201300001";
    [self.contentView addSubview:_numberLabel];
    
    _pictureImage = [[UIImageView alloc] init];
    _pictureImage.image = [UIImage imageNamed:@"zhengzhao"];
    _pictureImage.contentMode = UIViewContentModeScaleAspectFill;
    _pictureImage.clipsToBounds = YES;
    [self.contentView addSubview:_pictureImage];
    
    _pictureImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_pictureImage addGestureRecognizer:tap];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)tapAction:(id)sender
{
    if (_infoCellBlock) {
        _infoCellBlock();
    }
    
//    // 网络图片
//    YBImageBrowseCellData *data0 = [YBImageBrowseCellData new];
//   data0.thumbImage = [UIImage imageNamed:@"zhengzhao"];
//    // 设置数据源数组并展示
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = @[data0];
//    browser.currentIndex = 0;
//    [browser show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-20);
        make.top.equalTo(self.contentView.top).offset(20);
        make.bottom.equalTo(self.contentView.bottom).offset(-20);
        make.size.equalTo(CGSizeMake(95, 66));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerY.equalTo(self.pictureImage.centerY);
        make.size.equalTo(CGSizeMake(22, 29));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(20);
        make.right.equalTo(self.pictureImage.left).offset(-20);
        make.bottom.equalTo(self.iconImage.centerY).offset(-2);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(4);
    }];
}

@end
