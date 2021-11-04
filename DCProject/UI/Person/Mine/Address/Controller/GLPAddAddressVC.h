//
//  GLPAddAddressVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLPGoodsAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPAddAddressVC : DCBasicViewController


@property (nonatomic, copy) dispatch_block_t GLPAddAddressVC_block;

@property(nonatomic,strong) GLPGoodsAddressModel *addressModel;


@end

NS_ASSUME_NONNULL_END
