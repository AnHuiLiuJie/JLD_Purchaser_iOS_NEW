//
//  GLBRepayListCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBRepayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayListCell : UITableViewCell

// 回调
@property (nonatomic, copy) dispatch_block_t btnClickBlock;

// 账期
@property (nonatomic, strong) GLBRepayListModel *repayListModel;

@end

NS_ASSUME_NONNULL_END
