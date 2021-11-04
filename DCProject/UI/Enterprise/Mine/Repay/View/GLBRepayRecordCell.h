//
//  GLBRepayRecordCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBRepayRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayRecordCell : UITableViewCell

#pragma mark - 赋值
- (void)setValueWithRepayRecordModel:(GLBRepayRecordModel *)recordModel indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
