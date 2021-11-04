//
//  GLBCollectBottomView.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBCollectBottomView : UIView

// 全选按钮
@property (nonatomic, strong) UIButton *selectBtn;


@property (nonatomic, copy) dispatch_block_t selectBtnBlock;


@property (nonatomic, copy) dispatch_block_t removeBtnBlock;

@end

NS_ASSUME_NONNULL_END
