//
//  GLBGoodsDetailNavigationBar.h
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsDetailNavigationBar : UIView


@property (nonatomic, copy) dispatch_block_t backBtnBlock;


@property (nonatomic, copy) dispatch_block_t moreBtnBlock;

@end

NS_ASSUME_NONNULL_END
