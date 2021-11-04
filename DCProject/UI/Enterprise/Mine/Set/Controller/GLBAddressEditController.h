//
//  GLBAddressEditController.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBAddressEditController : DCTabViewController


// 有值：编辑。 无值：新增
@property (nonatomic, strong) GLBAddressModel *addressModel;

@end

NS_ASSUME_NONNULL_END
