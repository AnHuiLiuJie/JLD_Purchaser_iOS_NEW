//
//  GLBTypeFiltrateCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBTypeFiltrateCell : UITableViewCell


- (void)setValueWithTypeModel:(GLBTypeModel *)typeModel selectArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
