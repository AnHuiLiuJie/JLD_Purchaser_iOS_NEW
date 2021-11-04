//
//  GLBStoreFiltrateCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBStoreFiltrateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreFiltrateCell : UITableViewCell


- (void)setValueWithStoreModel:(GLBStoreFiltrateModel *)storeModel selectArray:(NSArray *)selectArray;


@end

NS_ASSUME_NONNULL_END
