//
//  GLBGoodsTicketCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBGoodsDetailModel.h"
#import "GLBGoodsDetailTicketModel.h"

typedef void(^GLBGoodsTicketCellBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsTicketCell : UITableViewCell


@property (nonatomic, strong) GLBGoodsDetailModel *detailModel;

// 券类型
@property (nonatomic, strong) GLBGoodsDetailTicketModel *ticketModel;


@property (nonatomic, copy) GLBGoodsTicketCellBlock  ticketCellBlock;

@end

NS_ASSUME_NONNULL_END
