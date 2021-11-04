//
//  GLBStoreGoodsFiltrateView.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBFiltrateBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreGoodsFiltrateView : UIView


@property (nonatomic, strong) UIButton *promotionBtn;


@property (nonatomic, copy) GLBFiltrateBlock filtrateBlock;

// 恢复初始状态
- (void)dc_recoverInit;

@end

NS_ASSUME_NONNULL_END
