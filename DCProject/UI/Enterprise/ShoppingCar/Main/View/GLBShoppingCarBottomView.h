//
//  GLBShoppingCarBottomView.h
//  DCProject
//
//  Created by bigbing on 2019/7/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBShoppingCarModel.h"

typedef void(^GLBCarSelectBlock)(UIButton *_Nullable button);

NS_ASSUME_NONNULL_BEGIN

@interface GLBShoppingCarBottomView : UIView

@property (nonatomic, assign) BOOL isEdit;


@property (nonatomic, strong) NSMutableArray<GLBShoppingCarModel *> *dataArray;


// 选择按钮
@property (nonatomic, copy) GLBCarSelectBlock selectBtnClick;

// 支付按钮
@property (nonatomic, copy) dispatch_block_t payBtnClick;

// 删除按钮
@property (nonatomic, copy) dispatch_block_t deleteBtnClick;

// 收藏按钮
@property (nonatomic, copy) dispatch_block_t collectBtnClick;

@end

NS_ASSUME_NONNULL_END
