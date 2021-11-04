//
//  GLBPlantListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBPlantListCell.h"

@interface GLBPlantListCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel1;
@property (nonatomic, strong) UILabel *infoLabel2;
@property (nonatomic, strong) UILabel *infoLabel3;
@property (nonatomic, strong) UIImageView *line;

@end

@implementation GLBPlantListCell

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
    _titleLabel.text = @"樟树市洲上乡洲山村枳壳种植合作社";
    [self.contentView addSubview:_titleLabel];
    
    _infoLabel1 = [[UILabel alloc] init];
    _infoLabel1.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _infoLabel1.font = PFRFont(11);
    _infoLabel1.text = @"所在地：江西省-宜春市-樟树市江西省…";
    [self.contentView addSubview:_infoLabel1];
    
    _infoLabel2 = [[UILabel alloc] init];
    _infoLabel2.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _infoLabel2.font = PFRFont(11);
    _infoLabel2.text = @"联系信息：陈四牙 13979557096";
    [self.contentView addSubview:_infoLabel2];
    
    _infoLabel3 = [[UILabel alloc] init];
    _infoLabel3.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _infoLabel3.font = PFRFont(11);
    _infoLabel3.text = @"品种范围：枳壳";
    [self.contentView addSubview:_infoLabel3];
 
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(100, 90));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.top.equalTo(self.iconImage.top).offset(-3);
        make.right.equalTo(self.contentView.right).offset(-15);
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
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(1);
    }];
}


#pragma mark - setter
- (void)setPeopleModel:(GLBPlantPeopleModel *)peopleModel
{
    _peopleModel = peopleModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_peopleModel.license] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _peopleModel.growerName;
    _infoLabel1.text = [NSString stringWithFormat:@"所在地：%@%@",_peopleModel.areaName,_peopleModel.address];
    _infoLabel2.text = [NSString stringWithFormat:@"联系信息：%@%@",_peopleModel.contactName,_peopleModel.contactPhone];
    _infoLabel3.text = [NSString stringWithFormat:@"品种范围：%@",_peopleModel.planRange];
}


- (void)setDrugModel:(GLBPlantDrugModel *)drugModel
{
    _drugModel = drugModel;
    
    NSString *imageUrl = @"";
    if (_drugModel.varietyImgs && [_drugModel.varietyImgs count] > 0) {
        imageUrl = _drugModel.varietyImgs[0];
    }
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _drugModel.growerName;
    _infoLabel1.text = [NSString stringWithFormat:@"种植时间：%@",_drugModel.plantTime];
    _infoLabel2.text = [NSString stringWithFormat:@"成熟时间：%@",_drugModel.matureTime];
    _infoLabel3.text = [NSString stringWithFormat:@"信息介绍：%@",_drugModel.varietyInfo];
}

@end
