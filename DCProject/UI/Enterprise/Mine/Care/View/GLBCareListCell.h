//
//  GLBCareListCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBCareModel.h"
#import "GLBStoreListModel.h"

typedef void(^GLBStoreGoodsBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBCareListCell : UITableViewCell

@property (nonatomic, strong) GLBCareModel *careModel;

// 店铺模型
@property (nonatomic, strong) GLBStoreListModel *storeModel;


@property (nonatomic, copy) GLBStoreGoodsBlock goodsBlock;

@end

NS_ASSUME_NONNULL_END
