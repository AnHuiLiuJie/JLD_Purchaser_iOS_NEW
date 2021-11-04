//
//  GLPMineOtherCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBMineOtherCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPMineOtherCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) GLBMineOtherCellBlock otherCellBlock;

@end

NS_ASSUME_NONNULL_END
