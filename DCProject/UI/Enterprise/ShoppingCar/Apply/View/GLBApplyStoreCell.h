//
//  GLBApplyStoreCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBShoppingCarModel.h"
#import "DCTextView.h"

typedef void(^GLBTypeBtnClickBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBApplyStoreCell : UITableViewCell

// 输入框
@property (nonatomic, strong) DCTextView *textView;

// 模型
@property (nonatomic, strong) GLBShoppingCarModel *carModel;


// 点击运费
@property (nonatomic, copy) dispatch_block_t yunfeiBlock;

// 点击交易方式问好
@property (nonatomic, copy) dispatch_block_t typeBlock;

// 点击交易方式
@property (nonatomic, copy) GLBTypeBtnClickBlock typeBtnBlock;

// 点击商品
@property (nonatomic, copy) dispatch_block_t goodsBlock;

// 点击优惠
@property (nonatomic, copy) dispatch_block_t discountBlock;


@end

NS_ASSUME_NONNULL_END
