//
//  GLPGoodsDetailsMatchCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsMatchModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLPDetailsMatchCellBlock)(GLPGoodsMatchGoodsModel *goodsModel);


@interface GLPGoodsDetailsMatchCell : UITableViewCell


@property (nonatomic, strong) GLPGoodsMatchModel *matchModel;

// 点击
@property (nonatomic, copy) GLPDetailsMatchCellBlock matchCellBlock;

@end


#pragma mark - 商品
@interface GLPGoodsDetailsMatchGoodsView : UIView

@property (nonatomic, strong) GLPGoodsMatchGoodsModel *goodsModel;

@end

NS_ASSUME_NONNULL_END
