//
//  GLPShoppingCarGoodsCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPEditCountView.h"
#import "TRRequestGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRRequestGoodsCell : UITableViewCell
typedef void (^GoodsNumBlock)(TRRequestGoodsModel *model);
typedef void (^GoodchoseBlock)(TRRequestGoodsModel *model);
@property (nonatomic, strong) GLPEditCountView *countView;
@property(nonatomic,strong)TRRequestGoodsModel *model;
@property(nonatomic,copy)GoodsNumBlock goodsnumblock;
@property(nonatomic,copy)GoodchoseBlock choseblock;
@end

NS_ASSUME_NONNULL_END
