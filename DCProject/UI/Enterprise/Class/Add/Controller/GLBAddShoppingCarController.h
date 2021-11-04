//
//  GLBAddShoppingCarController.h
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLBGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBAddShoppingCarController : DCBasicViewController

// 商品详情
@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;

@property (nonatomic, copy) dispatch_block_t successBlock;

@end

NS_ASSUME_NONNULL_END
