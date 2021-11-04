//
//  GLBGoodsTitleCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsDetailModel.h"
#import "GLBYcjModel.h"
#import "GLBPromoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsTitleCell : UITableViewCell

// 类型
@property (nonatomic, assign) GLBGoodsDetailType detailType;

// 商铺详情
@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;

// 详情为药集采时必传
@property (nonatomic, strong) GLBYcjModel *ycjModel;

// 促销时必传
@property (nonatomic, strong) GLBPromoteModel *promoteModel;

// 登录
@property (nonatomic, copy) dispatch_block_t loginBlock;


@end

NS_ASSUME_NONNULL_END
