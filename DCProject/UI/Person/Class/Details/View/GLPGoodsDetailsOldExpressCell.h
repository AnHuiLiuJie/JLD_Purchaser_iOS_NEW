//
//  GLPGoodsDetailsOldExpressCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsOldExpressCell : UITableViewCell


@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;


@property (nonatomic, copy) dispatch_block_t moreBtnBlock;

@end

NS_ASSUME_NONNULL_END
