//
//  RequestCommitVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestCommitVC : DCBasicViewController
@property(nonatomic,strong)NSArray *goodsArray;
@property(nonatomic,copy) NSString *allPrice;
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *quanlity;
@end

NS_ASSUME_NONNULL_END
