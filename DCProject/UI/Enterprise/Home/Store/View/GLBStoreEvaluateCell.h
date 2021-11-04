//
//  GLBStoreEvaluateCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBStoreEvaluateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreEvaluateCell : UITableViewCell

#pragma mark - 赋值
- (void)setValueWithModel:(GLBStoreEvaluateModel *)evaluateModel type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
