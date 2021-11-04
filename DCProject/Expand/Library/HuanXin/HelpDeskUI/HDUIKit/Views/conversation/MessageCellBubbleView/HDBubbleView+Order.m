//
//  EaseBubbleView+Order.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/6.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Order.h"

@implementation HDBubbleView (Order)

- (void)_setupOrderBubbleConstraints  {
    
    [self.orderBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(self.margin.bottom);
    }];
    
    [self.orderNoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderBgView.mas_top).offset(0);
        make.left.equalTo(self.orderBgView.mas_left).offset(5);
        make.height.equalTo(20);
    }];
    
//    [self.orderNoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
//        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
//        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
//        make.height.equalTo(15);
//    }];
//
//    [self.orderBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.orderTitleLabel.mas_bottom).offset(5);
//        make.left.equalTo(self.backgroundImageView.mas_left).offset(5);
//        make.right.equalTo(self.backgroundImageView.mas_right).offset(-10);
//        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-5);
//    }];
    
    [self.orderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoLabel.mas_bottom);
        make.left.equalTo(self.orderBgView.mas_left).offset(-self.margin.left);
        make.bottom.equalTo(self.orderBgView.mas_bottom).offset(-self.margin.bottom-3);
        make.width.equalTo(self.orderBgView.mas_height);
    }];
    
    [self.orderTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderImageView.mas_top).offset(5);
        make.right.equalTo(self.orderBgView.mas_right).offset(-5);
        make.left.equalTo(self.orderImageView.mas_right).offset(5);
    }];
    
    [self.orderPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderImageView.mas_right).offset(5);
        make.right.equalTo(self.orderBgView.mas_right).offset(0);
        make.bottom.equalTo(self.orderBgView.mas_bottom).offset(-self.margin.bottom-5);
    }];

}

- (void)setupOrderBubbleView {
    
    self.orderBgView = [[UIView alloc] init];
    self.orderBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderBgView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.orderBgView];
    
    self.orderTitleLabel = [[UILabel alloc] init];
    self.orderTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderTitleLabel.backgroundColor = [UIColor clearColor];
    self.orderTitleLabel.font = [UIFont systemFontOfSize:13];
    self.orderTitleLabel.numberOfLines = 2;
    [self.orderBgView addSubview:self.orderTitleLabel];
    
    self.orderNoLabel = [[UILabel alloc] init];
    self.orderNoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderNoLabel.backgroundColor = [UIColor clearColor];
    self.orderNoLabel.font = [UIFont systemFontOfSize:12];
    [self.orderBgView addSubview:self.orderNoLabel];
    
    self.orderImageView = [[UIImageView alloc] init];
    self.orderImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderImageView.backgroundColor = [UIColor clearColor];
    self.orderImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.orderBgView addSubview:self.orderImageView];
    
    self.orderDescLabel = [[UILabel alloc] init];
    self.orderDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderDescLabel.backgroundColor = [UIColor clearColor];
    self.orderDescLabel.font = [UIFont systemFontOfSize:13];
    self.orderDescLabel.numberOfLines = 3;
    self.orderDescLabel.hidden = YES;
    [self.orderBgView addSubview:self.orderDescLabel];
    
    self.orderPriceLabel = [[UILabel alloc] init];
    self.orderPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderPriceLabel.backgroundColor = [UIColor clearColor];
    self.orderPriceLabel.font = [UIFont systemFontOfSize:15];
    self.orderPriceLabel.textColor = [UIColor redColor];
    [self.orderBgView addSubview:self.orderPriceLabel];
    [self _setupOrderBubbleConstraints];
    
    [self.orderBgView setTag:1992];
}

- (void)updateOrderMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;

    [self _setupOrderBubbleConstraints];
}
@end
