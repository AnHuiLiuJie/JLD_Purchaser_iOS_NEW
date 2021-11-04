//
//  GLPApplyAddressCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPApplyAddressCell.h"

@interface GLPApplyAddressCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *topLineImg;
@property (nonatomic, strong) UIImageView *moreImg;

@end

@implementation GLPApplyAddressCell

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
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    [self.contentView addSubview:_titleLabel];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.textColor = [UIColor dc_colorWithHexString:@"#898989"];
    _addressLabel.font = [UIFont fontWithName:PFR size:14];
    _addressLabel.numberOfLines = 0;
    [self.contentView addSubview:_addressLabel];
    
    
    self.moreImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dc_arrow_right_cuhei"]];
    [self.contentView addSubview:self.moreImg];
    
    self.topLineImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dc_cell1_line"]];
    [self.contentView addSubview:self.topLineImg];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top).offset(10);
        make.right.equalTo(self.contentView.right).offset(-15);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-35);
        make.top.equalTo(self.titleLabel.bottom);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.moreImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [self.topLineImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(0);
    }];
}


- (void)setAddressModel:(GLPGoodsAddressModel *)addressModel
{
    _addressModel = addressModel;
    
    NSString *tel = _addressModel.cellphone;
    if (_addressModel.cellphone.length > 4) {
        tel = [NSString stringWithFormat:@"%@ **** %@",[_addressModel.cellphone substringToIndex:3],[_addressModel.cellphone substringFromIndex:_addressModel.cellphone.length-4]];
    }
    
    _titleLabel.text = [NSString stringWithFormat:@"%@ %@",_addressModel.recevier,tel];

    _addressLabel.text = [NSString stringWithFormat:@"%@ %@",_addressModel.areaName,_addressModel.streetInfo];
}

@end
