//
//  GLPAddShoppingCarController.h
//  DCProject
//
//  Created by bigbing on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLPGoodsDetailModel.h"

typedef void(^GLPAddShoppingCarCellBlock)(NSString *_Nullable countStr);

NS_ASSUME_NONNULL_BEGIN

@interface GLPAddShoppingCarController : DCBasicViewController


@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;


@property (nonatomic, assign) NSInteger buyCount;


// 点击回调
@property (nonatomic, copy) GLPAddShoppingCarCellBlock carCellBlock;


@end

NS_ASSUME_NONNULL_END
