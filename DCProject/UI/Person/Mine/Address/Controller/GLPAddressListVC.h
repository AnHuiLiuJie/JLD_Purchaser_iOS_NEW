//
//  GLPAddressListVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLPGoodsAddressModel.h"
NS_ASSUME_NONNULL_BEGIN


typedef void (^AddressBlock)(GLPGoodsAddressModel *model);

@interface GLPAddressListVC : DCBasicViewController

@property(nonatomic,copy) NSString *isChose;//1:代表点击地址需要返回地址内容到上一界面   其余：均不返回
@property(nonatomic,copy) AddressBlock addressblock;

@end

NS_ASSUME_NONNULL_END
