//
//  GLBTypeFiltrateController.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"

typedef void(^GLBTypeFiltrateBlock)(NSMutableArray *_Nullable selectArray);

NS_ASSUME_NONNULL_BEGIN

@interface GLBTypeFiltrateController : DCTabViewController

// 商品分类
@property (nonatomic, copy) NSString *catIds;

// 选中的类型
@property (nonatomic, strong) NSMutableArray *userTypeArray;

// 点击取消
@property (nonatomic, copy) dispatch_block_t cancelBlock;

// 点击确定
@property (nonatomic, copy) GLBTypeFiltrateBlock successBlock;

@property(nonatomic,copy) NSString *frameType;//1:GLBStoreGoodsController页面需要上移

@end

NS_ASSUME_NONNULL_END
