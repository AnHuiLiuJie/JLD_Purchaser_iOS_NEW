//
//  GLBAddressListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddressListCell.h"

@interface GLBAddressListCell ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *defaultImage;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation GLBAddressListCell

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
    
    _bgView = [[UIImageView alloc] init];
    _bgView.image = [UIImage imageNamed:@"gwc_dzcard"];
    [self.contentView addSubview:_bgView];
    
    _defaultImage = [[UIImageView alloc] init];
    _defaultImage.image = [UIImage imageNamed:@"gwc_mr"];
    _defaultImage.hidden = YES;
    [self.contentView addSubview:_defaultImage];
    
    _areaLabel = [[UILabel alloc] init];
    _areaLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _areaLabel.font = PFRFont(14);
    [self.contentView addSubview:_areaLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _detailLabel.font = PFRFont(14);
    _detailLabel.numberOfLines = 0;
    [self.contentView addSubview:_detailLabel];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _phoneLabel.font = PFRFont(13);
    [self.contentView addSubview:_phoneLabel];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:0];
    [_editBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8DA7EB"] forState:0];
    _editBtn.titleLabel.font = PFRFont(12);
    _editBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    [_editBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#8DA7EB"] radius:11];
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    [self updateMasonry];
}


#pragma mark - action
- (void)editBtnClick:(UIButton *)button
{
    if (_editBtnBlock) {
        _editBtnBlock();
    }
}


#pragma mark -
- (void)updateMasonry {
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    if (self.defaultImage.hidden) {
        
        [_areaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(12);
            make.top.equalTo(self.contentView.top).offset(12);
            make.right.equalTo(self.contentView.right).offset(-12);
        }];
        
    } else {
        
        [_areaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(12 + 30);
            make.top.equalTo(self.contentView.top).offset(12);
            make.right.equalTo(self.contentView.right).offset(-12);
        }];
        
        [_defaultImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.areaLabel.centerY);
            make.right.equalTo(self.areaLabel.left).offset(-5);
            make.size.equalTo(CGSizeMake(25, 15));
        }];
        
    }
    
    [_detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.areaLabel.bottom).offset(10);
    }];
    
    [_editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-12);
        make.size.equalTo(CGSizeMake(42, 22));
        make.left.equalTo(self.detailLabel.right).offset(10);
    }];
    
    [_phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.detailLabel.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-22);
        make.right.equalTo(self.contentView.right).offset(-12);
    }];
}


#pragma mark - setter
- (void)setAddressModel:(GLBAddressModel *)addressModel
{
    _addressModel = addressModel;
    
    self.defaultImage.hidden = _addressModel.isDefault == 1 ? NO : YES;
    self.areaLabel.text = _addressModel.areaName;
    self.detailLabel.text = _addressModel.streetInfo;
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ %@",_addressModel.recevier,_addressModel.cellphone];
    
    [self updateMasonry];
}


- (void)setOrderAddressModel:(GLBAddressModel *)orderAddressModel
{
    _orderAddressModel = orderAddressModel;
    
    self.editBtn.hidden = YES;
    
    self.defaultImage.hidden = _orderAddressModel.isDefault == 1 ? NO : YES;
    self.areaLabel.text = _orderAddressModel.areaName;
    self.detailLabel.text = _orderAddressModel.streetInfo;
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ %@",_orderAddressModel.recevier,_orderAddressModel.cellphone];
    
    [self updateMasonry];
}

@end
