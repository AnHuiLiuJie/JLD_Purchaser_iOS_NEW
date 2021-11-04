//
//  GLBGoodsListCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsListCell : UITableViewCell

@property (nonatomic, strong) GLBShoppingCarGoodsModel *goodsModel;

@end

NS_ASSUME_NONNULL_END
