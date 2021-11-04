//
//  GLPConfirmOrderStoreCell.h
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import <UIKit/UIKit.h>
#import "GLPNewShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPConfirmOrderStoreCell : UITableViewCell


@property (nonatomic, strong) GLPFirmListModel *firmModel;

@property (nonatomic, strong) NSMutableArray<GLPNewShopCarGoodsModel *> *goodsArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) dispatch_block_t clickGoodsView_Block;

@property (nonatomic, copy) dispatch_block_t clickMoreTicketView_Block;

// 店铺详情
@property (nonatomic, copy) dispatch_block_t clickShopBtnBlock_Block;

@property (nonatomic, copy) void(^GLPConfirmOrderStoreCell_block)(NSString *text);

@end


#pragma mark - 商品
@interface GLPConfirmOrderStoreCellGoodsView : UIView

@property (nonatomic, strong) GLPFirmListModel *firmModel;

@end

NS_ASSUME_NONNULL_END
