//
//  EaseBubbleView+Track.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/5.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Track.h"

@implementation HDBubbleView (Track)

- (void)_setupTrackBubbleConstraints  {
    
    [self.trackBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.top).offset(self.margin.top);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
    }];
    
    [self.cusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackBgView.mas_top).offset(5);
        make.left.equalTo(self.trackBgView.mas_left).offset(5);
        make.bottom.equalTo(self.trackBgView.mas_bottom).offset(-5);
        make.width.equalTo(self.cusImageView.mas_height).offset(0);
    }];
    
    [self.trackTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackBgView.mas_top).offset(10);
        make.left.equalTo(self.cusImageView.mas_right).offset(5);
        make.right.equalTo(self.trackBgView.mas_right).offset(-5);
    }];
    
    [self.cusPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.trackBgView.mas_bottom).offset(-8);
        make.left.equalTo(self.cusImageView.mas_right).offset(5);
        make.right.equalTo(self.cusDescLabel.mas_right).offset(0);
    }];

//    [self.cusDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.trackBgView.mas_top).offset(10);
//        make.left.equalTo(self.cusImageView.mas_right).offset(self.margin.left);
//        make.right.equalTo(self.trackBgView.mas_right).offset(-self.margin.right);
//    }];
    
//    [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.trackBgView.mas_left).offset(self.margin.left);
//        make.bottom.equalTo(self.trackBgView.mas_bottom).offset(-self.margin.bottom);
//        make.width.height.equalTo(0.1);
//    }];
}

- (void)setupTrackBubbleView {
    
    self.trackBgView = [[UIView alloc] init];

    self.trackBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.trackBgView.backgroundColor = [UIColor whiteColor];
    [self.backgroundImageView addSubview:self.trackBgView];
    
    self.trackTitleLabel = [[UILabel alloc] init];
    self.trackTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.trackTitleLabel.backgroundColor = [UIColor clearColor];
    self.trackTitleLabel.font = [UIFont systemFontOfSize:13];
    self.trackTitleLabel.textColor = [UIColor colorWithRed:14/255.0 green:14/255.0 blue:14/255.0 alpha:1.0];
    [self.trackBgView addSubview:self.trackTitleLabel];
    self.trackTitleLabel.numberOfLines = 2;
    
    self.cusImageView = [[UIImageView alloc] init];
    self.cusImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cusImageView.backgroundColor = [UIColor clearColor];
    self.cusImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.trackBgView addSubview:self.cusImageView];
    
    self.cusDescLabel = [[UILabel alloc] init];
    self.cusDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cusDescLabel.backgroundColor = [UIColor clearColor];
    self.cusDescLabel.font = [UIFont systemFontOfSize:13];
    self.cusDescLabel.textColor = UIColor.blackColor;
    self.cusDescLabel.numberOfLines = 2;
    self.cusDescLabel.hidden = YES;
    [self.trackBgView addSubview:self.cusDescLabel];
    
    self.cusPriceLabel = [[UILabel alloc] init];
    self.cusPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cusPriceLabel.backgroundColor = [UIColor clearColor];
    self.cusPriceLabel.font = [UIFont systemFontOfSize:15];
    self.cusPriceLabel.textColor = [UIColor redColor];
    [self.trackBgView addSubview:self.cusPriceLabel];
    
    self.sendButton = [[UIButton alloc] init];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sendButton.backgroundColor = RGBACOLOR(209, 224, 224, 1);
    self.sendButton.layer.cornerRadius = 10;
    [self.sendButton addTarget:self action:@selector(sendDeleteTrackMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitle:@"发送商品隐藏" forState:UIControlStateNormal];
    self.sendButton.hidden = YES;
    [self.trackBgView addSubview:self.sendButton];
    
    
    [self _setupTrackBubbleConstraints];
    
//    self.trackBgView.userInteractionEnabled = YES;
//    self.backgroundImageView.userInteractionEnabled = YES;
    
    [self.trackBgView setTag:1993];

}

- (void)updateTrackMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;

    [self _setupTrackBubbleConstraints];
    
    [self initiativeBtnAction:self.sendButton];//主动调用

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
   //触摸点若不在当前视图上则无法响应事件
   if ([self pointInside:point withEvent:event] == NO) return nil;
   //从后往前遍历子视图数组
   int count = (int)self.subviews.count;
   for (int i = count - 1; i >= 0; i--)
   {
       // 获取子视图
       UIView *childView = self.subviews[i];
       // 坐标系的转换,把触摸点在当前视图上坐标转换为在子视图上的坐标
       CGPoint childP = [self convertPoint:point toView:childView];
       //询问子视图层级中的最佳响应视图
       UIView *fitView = [childView hitTest:childP withEvent:event];
       if (fitView)
       {
           //如果子视图中有更合适的就返回
           return fitView;
       }
   }
   //没有在子视图中找到更合适的响应视图，那么自身就是最合适的
   return self;
}

@end
