//
//  GLBYcjListCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBYcjModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBYcjListCell : UITableViewCell

@property (nonatomic, strong) GLBYcjGoodsModel *goodsModel;
@property (nonatomic, strong) GLBYcjModel *cjModel;
@property (nonatomic, strong) UIButton *buyBtn;
@end

NS_ASSUME_NONNULL_END
