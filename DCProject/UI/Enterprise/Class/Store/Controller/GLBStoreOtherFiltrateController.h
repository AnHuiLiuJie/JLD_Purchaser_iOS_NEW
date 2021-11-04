//
//  GLBStoreOtherFiltrateController.h
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBOtherFiltrateBlock)(NSArray *discountArray,NSArray *priceArray,NSArray *rangArray);


@interface GLBStoreOtherFiltrateController : DCTabViewController

// 选中的优惠数据
@property (nonatomic, strong) NSArray *userDiscountArray;
// 选中的价格数据
@property (nonatomic, strong) NSArray *userPriceArray;
// 选中的经营范围数据
@property (nonatomic, strong) NSArray *userRangArray;


@property (nonatomic, copy) dispatch_block_t cancelBlock;

@property (nonatomic, copy) GLBOtherFiltrateBlock successBlock;

@end

NS_ASSUME_NONNULL_END
