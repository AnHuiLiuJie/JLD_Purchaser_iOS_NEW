//
//  GLPShoppingCarBottomView.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPNewShoppingCarModel.h"

typedef void(^GLPCarBottomViewSelectedBlock)(BOOL isSelected);

NS_ASSUME_NONNULL_BEGIN

@interface GLPShoppingCarBottomView : UIView

// 数据
@property (nonatomic, strong) NSMutableArray<GLPFirmListModel *> *dataArray;

// 是否编辑
@property (nonatomic, assign) BOOL isEdit;

// 选择按钮
@property (nonatomic, copy) GLPCarBottomViewSelectedBlock selectBtnClick;

// 支付按钮
@property (nonatomic, copy) dispatch_block_t payBtnClick;

// 删除按钮
@property (nonatomic, copy) dispatch_block_t deleteBtnClick;

// 收藏按钮
@property (nonatomic, copy) dispatch_block_t collectBtnClick;

@end

NS_ASSUME_NONNULL_END
