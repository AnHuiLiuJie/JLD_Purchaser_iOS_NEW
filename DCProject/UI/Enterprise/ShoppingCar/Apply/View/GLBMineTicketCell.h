//
//  GLBMineTicketCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBMineTicketModel.h"
#import "GLBShoppingCarModel.h"

#import "GLPTicketSelectModel.h"
#import "GLPShoppingCarModel.h"
#import "GLPNewTicketModel.h"

typedef void(^GLBTicketBlock)(BOOL isCanUse);

NS_ASSUME_NONNULL_BEGIN

@interface GLBMineTicketCell : UITableViewCell


// 赋值 企业版
- (void)setValueWithDataArray:(NSArray *)dataArray seletcedArray:(NSMutableArray *)seletcedArray carModel:(GLBShoppingCarModel *)carModel indexPath:(NSIndexPath *)indexPath;


// 赋值 个人版
- (void)setPersonValueWithDataArray:(NSArray *)dataArray seletcedArray:(NSMutableArray *)seletcedArray carModel:(GLPShoppingCarModel *)carModel indexPath:(NSIndexPath *)indexPath;


// 回调
@property (nonatomic, copy) GLBTicketBlock ticketBlock;

@end

NS_ASSUME_NONNULL_END
