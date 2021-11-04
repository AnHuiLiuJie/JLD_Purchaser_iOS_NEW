//
//  GLBStoreEvaluateHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBEvaluateDetailModel.h"

typedef void(^GLBEvaluateViewBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreEvaluateHeadView : UIView

// 评价汇总
@property (nonatomic, strong) GLBEvaluateDetailModel *detailModel;

@property (nonatomic, copy) GLBEvaluateViewBlock evaluetaBtnBlock;


@end

NS_ASSUME_NONNULL_END
