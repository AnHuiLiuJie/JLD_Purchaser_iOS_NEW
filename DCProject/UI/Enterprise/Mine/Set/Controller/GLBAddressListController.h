//
//  GLBAddressListController.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBAddressModel.h"

typedef void(^GLBAddressSelectedBlock)(GLBAddressModel *_Nullable addressModel);

NS_ASSUME_NONNULL_BEGIN

@interface GLBAddressListController : DCTabViewController

// 选择地址
@property (nonatomic, copy) GLBAddressSelectedBlock selectedBlock;

@end

NS_ASSUME_NONNULL_END
