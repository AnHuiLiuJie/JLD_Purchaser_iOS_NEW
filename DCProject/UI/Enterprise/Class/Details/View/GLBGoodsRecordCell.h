//
//  GLBGoodsRecordCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsRecordCell : UITableViewCell

// 详情
@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;

// 查看更多记录
@property (nonatomic, copy) dispatch_block_t recordCellBlock;


@end

NS_ASSUME_NONNULL_END
