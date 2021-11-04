//
//  GLBOtherFiltrateCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBPackageModel.h"
#import "GLBRangModel.h"

typedef void(^GLBOtherCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBOtherFiltrateCell : UITableViewCell


@property (nonatomic, copy) GLBOtherCellBlock otherCellBlock;


#pragma mark - 商品-类型 / 店铺 - 优惠 / 店铺 - 起配金额
- (void)setTypeValueWithTypeArray:(NSArray *)typeArray selectTypeArray:(NSArray *)selectTypeArray;

#pragma mark - 商品-规格
- (void)setPackageValueWithPackageArray:(NSArray *)packageArray selectPackageArray:(NSArray *)selectPackageArray;


#pragma mark - 店铺-经营范围
- (void)setRangValueWithRangArray:(NSArray *)rangArray selectRangArray:(NSArray *)selectRangArray;

@end

NS_ASSUME_NONNULL_END
