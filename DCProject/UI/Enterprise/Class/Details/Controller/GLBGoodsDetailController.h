//
//  GLBGoodsDetailController.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBPromoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsDetailController : DCTabViewController


@property (nonatomic, assign) GLBGoodsDetailType detailType;

// 当为促销产品时，必传该参数
@property (nonatomic, strong) GLBPromoteModel *promoteModel;


@property (nonatomic, copy) NSString *goodsId;

// 批次id可不传
@property (nonatomic, copy) NSString *batchId;

@end

NS_ASSUME_NONNULL_END
