//
//  GLBNewsListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBNewsListCell.h"

@interface GLBNewsListCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *seeImage;
@property (nonatomic, strong) UILabel *seeLabel;
//@property (nonatomic, strong) UIImageView *zanImage;
//@property (nonatomic, strong) UILabel *zanLabel;

@end

@implementation GLBNewsListCell

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
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImage.clipsToBounds = YES;
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont fontWithName:PFR size:11];
    [self.contentView addSubview:_timeLabel];
    
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _tagLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _tagLabel.font = [UIFont fontWithName:PFR size:11];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [_tagLabel dc_cornerRadius:3];
    [self.contentView addSubview:_tagLabel];
    
    _seeImage = [[UIImageView alloc] init];
    _seeImage.image = [UIImage imageNamed:@"yjh_liulan"];
    [self.contentView addSubview:_seeImage];
    
    _seeLabel = [[UILabel alloc] init];
    _seeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _seeLabel.font = [UIFont fontWithName:PFR size:11];
    [self.contentView addSubview:_seeLabel];
    
//    _zanImage = [[UIImageView alloc] init];
//    _zanImage.image = [UIImage imageNamed:@"yjh_dz"];
//    [self.contentView addSubview:_zanImage];
//
//    _zanLabel = [[UILabel alloc] init];
//    _zanLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
//    _zanLabel.font = [UIFont fontWithName:PFR size:11];
//    [self.contentView addSubview:_zanLabel];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(15);
        make.size.equalTo(CGSizeMake(100, 90));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.iconImage.top);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.iconImage.bottom);
        make.size.equalTo(CGSizeMake(52, 16));
    }];
    
    [_seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.right);
        make.centerY.equalTo(self.tagLabel.centerY);
    }];
    
    [_seeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.seeLabel.centerY);
        make.right.equalTo(self.seeLabel.left).offset(-8);
        make.size.equalTo(CGSizeMake(15, 10));
    }];
    
//    [_seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.zanImage.right).offset(-24);
//        make.centerY.equalTo(self.tagLabel.centerY);
//    }];
//
//    [_seeImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.seeLabel.centerY);
//        make.right.equalTo(self.seeLabel.left).offset(-8);
//        make.size.equalTo(CGSizeMake(10, 10));
//    }];
    
}


#pragma mark - setter
- (void)setNewsModel:(GLBNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_newsModel.newsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _newsModel.newsTitle;
    _timeLabel.text = _newsModel.createTime;
    _seeLabel.text = _newsModel.accessCount;
    
    if (_newsModel.catId && [_newsModel.catId count] > 0) {
        _tagLabel.text = [_newsModel.catId[0] valuessssss];
    }
}

@end
