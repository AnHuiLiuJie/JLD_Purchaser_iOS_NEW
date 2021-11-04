//
//  GLPSearchHotGoodsItemCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPSearchHotGoodsItemCell.h"

@interface GLPSearchHotGoodsItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLPSearchHotGoodsItemCell

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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    _titleLabel.font = PFRFont(14);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:DC_BtnColor] radius:15];
    [self.contentView addSubview:_titleLabel];
    
    [self layoutSubviews];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}



#pragma mark - setter
- (void)setGoodsModel:(GLPSearchHotGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    _titleLabel.text = _goodsModel.keyword;
}

@end
