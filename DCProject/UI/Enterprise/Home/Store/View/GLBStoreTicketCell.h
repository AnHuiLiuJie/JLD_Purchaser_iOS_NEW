//
//  GLBStoreTicketCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBStoreTicketModel.h"

typedef void(^GLBStoreTickCellBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreTicketCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray<GLBStoreTicketModel *> *ticketArray;

@property (nonatomic, copy) GLBStoreTickCellBlock ticketCellBlock;

@end

NS_ASSUME_NONNULL_END
