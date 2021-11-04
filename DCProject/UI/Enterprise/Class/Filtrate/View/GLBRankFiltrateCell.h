//
//  GLBRankFiltrateCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBFactoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBRankFiltrateCell : UITableViewCell

#pragma mark - 排序
- (void)setValueWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath selectIndexPath:(NSIndexPath *)selectIndexPath;


#pragma mark - 厂家
- (void)setCompanyValueWithCompanyArray:(NSArray *)companyArray indexPath:(NSIndexPath *)indexPath selectCompanyArray:(NSArray *)selectCompanyArray;

@end

NS_ASSUME_NONNULL_END
