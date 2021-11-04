//
//  GLBIntentionListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBIntentionListCell.h"

@interface GLBIntentionListCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel1;
@property (nonatomic, strong) UILabel *infoLabel2;
@property (nonatomic, strong) UILabel *infoLabel3;
@property (nonatomic, strong) UIImageView *statusImage;

@end

@implementation GLBIntentionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImage.clipsToBounds = YES;
//    _iconImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
//    _titleLabel.text = @"第一批当归100亩已种植";
    [self.contentView addSubview:_titleLabel];
    
    _infoLabel1 = [[UILabel alloc] init];
    _infoLabel1.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _infoLabel1.font = PFRFont(11);
//    _infoLabel1.text = @"需求量：1000kg";
    [self.contentView addSubview:_infoLabel1];
    
    _infoLabel2 = [[UILabel alloc] init];
    _infoLabel2.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _infoLabel2.font = PFRFont(11);
//    _infoLabel2.text = @"意向价格：￥289.00/kg";
    [self.contentView addSubview:_infoLabel2];
    
    _infoLabel3 = [[UILabel alloc] init];
    _infoLabel3.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _infoLabel3.font = PFRFont(11);
//    _infoLabel3.text = @"预期提货时间：2019-05-09";
    [self.contentView addSubview:_infoLabel3];
    
    _statusImage = [[UIImageView alloc] init];
//    _statusImage.image = [UIImage imageNamed:@"dgyx_dqr"];
    [self.contentView addSubview:_statusImage];
    
    [self layoutIfNeeded];
}



#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(100, 90));
    }];
    
    [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.right.equalTo(self.contentView.right);
        make.size.equalTo(CGSizeMake(55, 55));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.top.equalTo(self.iconImage.top).offset(-3);
        make.right.equalTo(self.contentView.right).offset(-10);
    }];
    
    [_infoLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.bottom.equalTo(self.iconImage.bottom);
    }];
    
    [_infoLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.bottom.equalTo(self.infoLabel3.top).offset(0);
    }];
    
    [_infoLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.bottom.equalTo(self.infoLabel2.top).offset(0);
    }];

}


#pragma mark - setter
- (void)setIntentionModel:(GLBIntentionModel *)intentionModel
{
    _intentionModel = intentionModel;
    
    NSString *imageUrl = @"";
    if (_intentionModel.varietyImgs && [_intentionModel.varietyImgs count] > 0) {
        imageUrl = _intentionModel.varietyImgs[0];
    }
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _intentionModel.varietyName;
    _infoLabel1.text = [NSString stringWithFormat:@"需求量：%@kg",_intentionModel.reqAmount];
    _infoLabel2.text = [NSString stringWithFormat:@"意向价格：￥%.2f/kg",_intentionModel.orderPrice];
    _infoLabel3.text = [NSString stringWithFormat:@"预期提货时间：%@",_intentionModel.deliveryTime];
    
    if (_intentionModel.state == 0) { // 待确认
        _statusImage.image = [UIImage imageNamed:@"dgyx_dqr"];
    } else if (_intentionModel.state == 1) { // 已确认
        _statusImage.image = [UIImage imageNamed:@"dgyx_yqr"];
    } else if (_intentionModel.state == 2) { // 未通过
        _statusImage.image = [UIImage imageNamed:@"dgyx_wtg"];
    }
}


@end
