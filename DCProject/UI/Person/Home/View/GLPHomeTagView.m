//
//  GLPHomeTagView.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeTagView.h"

@interface GLPHomeTagView ()

@property (nonatomic, strong) UIImageView *tuanImage;
@property (nonatomic, strong) UIImageView *cuImage;
@property (nonatomic, strong) UIImageView *importImage;

@end

@implementation GLPHomeTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _tuanImage = [[UIImageView alloc] init];
    _tuanImage.image = [UIImage imageNamed:@"tuan"];
    _tuanImage.hidden = YES;
    [self addSubview:_tuanImage];
    
    _cuImage = [[UIImageView alloc] init];
    _cuImage.image = [UIImage imageNamed:@"chu"];
    _cuImage.hidden = YES;
    [self addSubview:_cuImage];
    
    _importImage = [[UIImageView alloc] init];
    _importImage.image = [UIImage imageNamed:@"jinkoi"];
    _importImage.hidden = YES;
    [self addSubview:_importImage];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0;
    
    [_tuanImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(x);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(19, 19));
    }];
    
    if (_tuanImage.hidden == NO) {
        x += (20+10);
    }
    [_cuImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(x);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(19, 19));
    }];
    
    if (_cuImage.hidden == NO) {
        x += (20+10);
    }
    [_importImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(x);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(28.5, 19));
    }];
}


#pragma mark - setter
- (void)setGoodsModel:(GLPHomeDataGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    _tuanImage.hidden = YES;
    if (_goodsModel && [_goodsModel.isGroup isEqualToString:@"1"]) { // 团购
        _tuanImage.hidden = NO;
    }
    
    _cuImage.hidden = YES;
    if (_goodsModel && [_goodsModel.isPromotion isEqualToString:@"1"]) { // 促销
        _cuImage.hidden = NO;
    }
    
    _importImage.hidden = YES;
    if (_goodsModel && [_goodsModel.isImport isEqualToString:@"1"]) { // 进口
        _importImage.hidden = NO;
    }
    
    [self layoutSubviews];
}

@end
