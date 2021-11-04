//
//  GLBExhibitCompanyHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBExhibitCompanyHeadView.h"

@interface GLBExhibitCompanyHeadView ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *clickBtn;

@end

@implementation GLBExhibitCompanyHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:20];
    [self addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = PFRFont(14);
    [self addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _descLabel.font = PFRFont(12);
    _descLabel.numberOfLines = 3;
    [self addSubview:_descLabel];
    
    _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clickBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)clickBtnClick:(id)sender
{
    if (_companyClickBlock) {
        _companyClickBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(25);
        make.top.equalTo(self.top).offset(15);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(25);
        make.right.equalTo(self.right).offset(-25);
        make.top.equalTo(self.iconImage.top);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];

    [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
