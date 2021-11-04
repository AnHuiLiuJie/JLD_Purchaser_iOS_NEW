//
//  GLBGuideItmeCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBGuideItmeCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBGuideItmeCell : UITableViewCell

@property (nonatomic, copy) GLBGuideItmeCellBlock itemCellBlock;

@end

NS_ASSUME_NONNULL_END
