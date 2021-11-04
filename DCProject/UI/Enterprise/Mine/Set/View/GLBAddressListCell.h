//
//  GLBAddressListCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBAddressListCell : UITableViewCell

// 地址列表
@property (nonatomic, strong) GLBAddressModel *addressModel;

// 确认订单选择的地址
@property (nonatomic, strong) GLBAddressModel *orderAddressModel;


@property (nonatomic, copy) dispatch_block_t editBtnBlock;

@end

NS_ASSUME_NONNULL_END
