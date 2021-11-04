//
//  GLBGoodsSendCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsSendCell.h"

@interface GLBGoodsSendCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation GLBGoodsSendCell

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
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLabel.text = @"配送说明";
    [self.contentView addSubview:_titleLabel];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"spxq_kd"];
    [self.contentView addSubview:_iconImage];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _detailLabel.font = PFRFont(13);
    _detailLabel.numberOfLines=3;
    [self.contentView addSubview:_detailLabel];
    
    
    [self layoutSubviews];
}



#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.size.equalTo(CGSizeMake(100, 36));
    }];
    
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.titleLabel.bottom).offset(8);
        make.bottom.equalTo(self.contentView.bottom).offset(-8);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.iconImage.centerY);
    }];
    
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    _detailLabel.text = _detailModel.deliveryExplain;
}

@end
