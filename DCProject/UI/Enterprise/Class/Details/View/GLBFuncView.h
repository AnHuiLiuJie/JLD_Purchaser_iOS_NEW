//
//  GLBFuncView.h
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBFuncViewBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBFuncView : UIView


@property (nonatomic, copy) GLBFuncViewBlock funcViewBlock;


@property (nonatomic, copy) dispatch_block_t cancelBlock;


#pragma mark - 开始动画
- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
