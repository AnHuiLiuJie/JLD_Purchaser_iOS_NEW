//
//  GLBStoreGoodsCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBStoreGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreGoodsCell : UITableViewCell

// 商品
@property (nonatomic, strong) GLBStoreGoodsModel *goodsModel;


// 登录
@property (nonatomic, copy) dispatch_block_t loginBlcok;

@end

NS_ASSUME_NONNULL_END
