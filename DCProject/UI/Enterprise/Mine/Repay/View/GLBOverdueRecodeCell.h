//
//  GLBOverdueRecodeCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBRepayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBOverdueRecodeCell : UITableViewCell

#pragma mark - 复制
- (void)setValueWithDelayModel:(GLBRepayListDelayModel *)delayModel indexPath:(NSIndexPath *)indexpath;

@end

NS_ASSUME_NONNULL_END
