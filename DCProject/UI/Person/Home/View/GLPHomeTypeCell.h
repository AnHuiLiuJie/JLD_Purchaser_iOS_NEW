//
//  GLPHomeTypeCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLPHomeTypeCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPHomeTypeCell : UITableViewCell


@property (nonatomic, copy) GLPHomeTypeCellBlock typeCellBlock;

@end

NS_ASSUME_NONNULL_END
