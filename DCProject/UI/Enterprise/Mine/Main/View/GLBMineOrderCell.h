//
//  GLBMineOrderCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBMineOrderCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBMineOrderCell : UITableViewCell

// 数量
@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, copy) GLBMineOrderCellBlock orderCellBlock;

@end

NS_ASSUME_NONNULL_END
