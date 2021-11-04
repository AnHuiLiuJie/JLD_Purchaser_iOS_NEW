//
//  GLPGoodsDetailsTitleCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"
#import "GLPGoodsAddressModel.h"
#import "GLPEditCountView.h"

typedef void(^GLPGoodsDetailTitleCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsTitleCell : UITableViewCell


@property (nonatomic, strong) GLPEditCountView *countView;

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;

// 默认收货地址与运费
@property (nonatomic, strong) GLPGoodsAddressModel *addressModel;

// 按钮点击事件
@property (nonatomic, copy) GLPGoodsDetailTitleCellBlock titleCellBlock;


// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;

@end

NS_ASSUME_NONNULL_END
