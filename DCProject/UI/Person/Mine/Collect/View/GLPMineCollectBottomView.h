//
//  GLPMineCollectBottomView.h
//  DCProject
//
//  Created by bigbing on 2019/9/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPMineCollectBottomView : UIView

@property (nonatomic, strong) UIButton *selectBtn;

// 全选按钮
@property (nonatomic, copy) dispatch_block_t selectBtnBlock;

// 删除按钮
@property (nonatomic, copy) dispatch_block_t removeBtnBlock;

@end

NS_ASSUME_NONNULL_END
