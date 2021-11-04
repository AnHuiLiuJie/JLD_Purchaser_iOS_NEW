//
//  GLPMineOrderCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLPMineOrderCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPMineOrderCell : UITableViewCell


@property (nonatomic, copy) GLPMineOrderCellBlock orderCellBlock;
@property(nonatomic,strong)NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
