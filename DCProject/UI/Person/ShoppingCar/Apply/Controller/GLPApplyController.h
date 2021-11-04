//
//  GLPApplyController.h
//  DCProject
//
//  Created by bigbing on 2019/9/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLPShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPApplyController : DCTabViewController

@property (nonatomic, strong) NSMutableArray<GLPShoppingCarModel *> *shoppingcarArray;

@property(nonatomic,copy) NSString *ispay;//1:直接购买 其他：购物车
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *quanlity;

@end

NS_ASSUME_NONNULL_END
