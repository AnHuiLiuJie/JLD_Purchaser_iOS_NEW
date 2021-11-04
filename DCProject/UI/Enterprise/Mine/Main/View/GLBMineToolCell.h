//
//  GLBMineToolCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBMineToolCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBMineToolCell : UITableViewCell


@property (nonatomic, copy) GLBMineToolCellBlock toolCellBlock;

@end

NS_ASSUME_NONNULL_END
