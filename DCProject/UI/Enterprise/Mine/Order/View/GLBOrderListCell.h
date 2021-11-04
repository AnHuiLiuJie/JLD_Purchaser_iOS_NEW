//
//  GLBOrderListCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBOrderModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBOrderBlock)(NSString *title);


@interface GLBOrderListCell : UITableViewCell


@property (nonatomic, strong) GLBOrderModel *orderModel;


@property (nonatomic, copy) GLBOrderBlock orderBlock;

@end

NS_ASSUME_NONNULL_END
