//
//  GLPGoodsDetailsOldStoreCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

typedef void(^GLPDetailsStoreCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsOldStoreCell : UITableViewCell

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;


// 点击按钮
@property (nonatomic, copy) GLPDetailsStoreCellBlock storeCellBlock;

@end

NS_ASSUME_NONNULL_END
