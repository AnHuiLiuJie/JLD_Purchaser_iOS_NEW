//
//  GLPGoodsDetailsTicketCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsTicketCell : UITableViewCell

@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
@property (nonatomic, copy) void(^GLPGoodsDetailsTicketCell_block)(NSInteger tag);

@end


@interface DiscountTicketInfoView : UIView

@property (nonatomic, strong) GLPGoodsDetailTicketModel *goodsTicketModel;
@property (nonatomic, strong) GLPGoodsDetailTicketModel *storeTicketModel;
@property (nonatomic, strong) GLPGoodsDetailTicketModel *bossTicketModel;

@property (nonatomic, copy) dispatch_block_t moreBtnBlock;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

NS_ASSUME_NONNULL_END
