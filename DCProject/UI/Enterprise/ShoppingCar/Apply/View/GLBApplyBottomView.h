//
//  GLBApplyBottomView.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBApplyBottomView : UIView

@property (nonatomic, strong) NSMutableArray<GLBShoppingCarModel *> *dataArray;


@property (nonatomic, copy) dispatch_block_t completeBlock;

@end

NS_ASSUME_NONNULL_END
