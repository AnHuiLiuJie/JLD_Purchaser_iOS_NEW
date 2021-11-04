//
//  GLPGoodsDetailsOldTicketCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

typedef void(^GLPTicketBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsOldTicketCell : UITableViewCell

@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;


// 点击更多券回调
@property (nonatomic, copy) GLPTicketBlock ticketBlock;

@end



#pragma mark - 券
@interface GLPGoodsDetailsTicketView : UIView

@property (nonatomic, strong) GLPGoodsDetailTicketModel *goodsTicketModel;
@property (nonatomic, strong) GLPGoodsDetailTicketModel *storeTicketModel;
@property (nonatomic, strong) GLPGoodsDetailTicketModel *bossTicketModel;

@property (nonatomic, copy) dispatch_block_t moreBtnBlock ;

@end

NS_ASSUME_NONNULL_END
