//
//  GLPDetailTicketSelectCell.h
//  DCProject
//
//  Created by bigbing on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPDetailTicketSelectCell : UITableViewCell

// 优惠券
@property (nonatomic, strong) GLPGoodsTicketModel *ticketModel;

@end

NS_ASSUME_NONNULL_END
