//
//  GLBClassTypeCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBTypeModel.h"
#import "GLPClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBClassTypeCell : UITableViewCell

// 赋值 - 企业版
- (void)setValueWithTitles:(NSArray<GLBTypeModel *> *)titles indexPath:(NSIndexPath *)indexPath selectIndex:(NSInteger)selectIndex;


// 赋值 - 个人版
- (void)setPersonValueWithTitles:(NSArray<GLPClassModel *> *)titles indexPath:(NSIndexPath *)indexPath selectIndex:(NSInteger)selectIndex;

@end

NS_ASSUME_NONNULL_END
