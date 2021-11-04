//
//  GLBTCMShopCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBStoreListModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^GLBTCMGoodsBlock)(GLBStoreListGoodsModel *goodsModel);

@interface GLBTCMShopCell : UITableViewCell

@property (nonatomic, strong) GLBStoreListModel *listModel;


// 点击商品回调
@property (nonatomic, copy) GLBTCMGoodsBlock goodsBlock;

@end

NS_ASSUME_NONNULL_END
