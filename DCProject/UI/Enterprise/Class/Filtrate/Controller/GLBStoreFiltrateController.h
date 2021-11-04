//
//  GLBStoreFiltrateController.h
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBStoreListModel.h"

typedef void(^GLBStoreFiltrateBlock)(NSArray *_Nullable selectedArray);


NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreFiltrateController : DCTabViewController

// 已选择的商家
@property (nonatomic, strong) NSMutableArray *selectStoreArray;

// 搜索名称
@property (nonatomic, copy) NSString *searchName;

// 选中的分类id
@property (nonatomic, copy) NSString *catIds;

// 点击选择
@property (nonatomic, copy) GLBStoreFiltrateBlock filtrateBlock;

// 点击确定
@property (nonatomic, copy) GLBStoreFiltrateBlock completeBlock;

// 点击取消
@property (nonatomic, copy) dispatch_block_t cancelBlock;


@property(nonatomic,copy) NSString *frameType;//1:GLBStoreGoodsController页面需要上移


@end

NS_ASSUME_NONNULL_END
