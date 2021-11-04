//
//  GLBNormalGoodsCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsModel.h"
#import "GLBCollectModel.h"
#import "GLBGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBNormalGoodsCell : UITableViewCell

// 首页商品
@property (nonatomic, strong) GLBGoodsModel *goodsModel;

// 收藏模型
@property (nonatomic, strong) GLBCollectModel *collectModel;

// 分类商品列表模型
@property (nonatomic, strong) GLBGoodsListModel *goodListModel;


// 点击店铺名
@property (nonatomic, copy) dispatch_block_t shopNameBlock;

// 点击登录
@property (nonatomic, copy) dispatch_block_t loginBlock;

@end

NS_ASSUME_NONNULL_END
