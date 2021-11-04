//
//  GLBExhibitListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBExhibitListCell.h"

@interface GLBExhibitListCell ()
{
    CGFloat _spacing;
    CGFloat _btnWidth;
    CGFloat _btnHeight;
}

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *goodsBtn1;
@property (nonatomic, strong) UIButton *goodsBtn2;
@property (nonatomic, strong) UIButton *goodsBtn3;
@property (nonatomic, strong) UILabel *goodslabel1;
@property (nonatomic, strong) UILabel *goodslabel2;
@property (nonatomic, strong) UILabel *goodslabel3;

@end

@implementation GLBExhibitListCell

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
    
    [self.contentView dc_cornerRadius:5];
    
    _spacing = 28;
    _btnWidth = (kScreenW - 10*2 - 15*2 - _spacing*2)/3;
    _btnHeight = _btnWidth;
    
    _iconImage = [[UIImageView alloc] init];
//    _iconImage.backgroundColor = [UIColor redColor];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:20];
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.text = @"源安堂旗舰店";
    [self.contentView addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _descLabel.font = PFRFont(12);
    _descLabel.text = @"通企旗舰店，您身边的医药专家";
    [self.contentView addSubview:_descLabel];
    
    _goodsBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsBtn1 setImage:[UIImage imageNamed:@"placher-3"] forState:0];
    _goodsBtn1.contentMode = UIViewContentModeScaleAspectFill;
    _goodsBtn1.clipsToBounds = YES;
    _goodsBtn1.tag = 1;
    [_goodsBtn1 addTarget:self action:@selector(goodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodsBtn1];
    
    _goodsBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsBtn2 setImage:[UIImage imageNamed:@"placher-3"] forState:0];
    _goodsBtn2.contentMode = UIViewContentModeScaleAspectFill;
    _goodsBtn2.clipsToBounds = YES;
    _goodsBtn2.titleLabel.font = PFRFont(14);
    _goodsBtn2.tag = 2;
    [_goodsBtn2 addTarget:self action:@selector(goodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodsBtn2];
    
    _goodsBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsBtn3 setImage:[UIImage imageNamed:@"placher-3"] forState:0];
    _goodsBtn3.contentMode = UIViewContentModeScaleAspectFill;
    _goodsBtn3.clipsToBounds = YES;
    _goodsBtn3.tag = 2;
    [_goodsBtn3 addTarget:self action:@selector(goodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodsBtn3];
    
    _goodslabel1 = [[UILabel alloc] init];
    _goodslabel1.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _goodslabel1.font = PFRFont(14);
    _goodslabel1.textAlignment = NSTextAlignmentCenter;
    _goodslabel1.text = @"￥5.880";
    [self.contentView addSubview:_goodslabel1];
    
    _goodslabel2 = [[UILabel alloc] init];
    _goodslabel2.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _goodslabel2.font = PFRFont(14);
    _goodslabel2.textAlignment = NSTextAlignmentCenter;
    _goodslabel2.text = @"￥5.880";
    [self.contentView addSubview:_goodslabel2];
    
    _goodslabel3 = [[UILabel alloc] init];
    _goodslabel3.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _goodslabel3.font = PFRFont(14);
    _goodslabel3.textAlignment = NSTextAlignmentCenter;
    _goodslabel3.text = @"￥5.880";
    [self.contentView addSubview:_goodslabel3];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)goodsBtnClick:(UIButton *)button
{
    
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spacing = _spacing;
    CGFloat width = _btnWidth;
    CGFloat height = _btnHeight;
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top).offset(18);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(25);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.iconImage.top);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.bottom.equalTo(self.iconImage.bottom);
    }];
    
    [_goodsBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.iconImage.bottom).offset(23);
        make.bottom.equalTo(self.contentView.bottom).offset(-40);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_goodsBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsBtn1.right).offset(spacing);
        make.centerY.equalTo(self.goodsBtn1.centerY);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_goodsBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsBtn2.right).offset(spacing);
        make.centerY.equalTo(self.goodsBtn2.centerY);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_goodslabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodsBtn1.centerX);
        make.top.equalTo(self.goodsBtn1.bottom);
    }];
    
    [_goodslabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodsBtn2.centerX);
        make.top.equalTo(self.goodsBtn2.bottom);
    }];
    
    [_goodslabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodsBtn3.centerX);
        make.top.equalTo(self.goodsBtn3.bottom);
    }];
}


#pragma mark - setter
- (void)setCompanyModel:(GLBExhibitCompanyModel *)companyModel
{
    _companyModel = companyModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_companyModel.firmImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _companyModel.firmName;
    _descLabel.text = _companyModel.firmIntroduce;
    
    
}

@end
