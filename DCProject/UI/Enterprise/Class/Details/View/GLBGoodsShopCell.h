//
//  GLBGoodsShopCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsShopCell : UITableViewCell


@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;


@property (nonatomic, copy) dispatch_block_t openStoreBlock;

@end

NS_ASSUME_NONNULL_END
