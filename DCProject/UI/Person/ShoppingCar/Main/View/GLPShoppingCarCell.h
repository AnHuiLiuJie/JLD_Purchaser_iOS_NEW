//
//  GLPShoppingCarCell.h
//  DCProject
//
//  Created by LiuMac on 2021/7/14.
//

#import <UIKit/UIKit.h>
#import "GLPNewShoppingCarModel.h"
#import "GLPEditCountView.h"
NS_ASSUME_NONNULL_BEGIN



@interface GLPShoppingCarCell : UITableViewCell

// 购物车模型
@property (nonatomic, strong) GLPFirmListModel *shoppingCarModel;

// 数量改变回调
@property (nonatomic, copy) void(^GLPShoppingCarCell_countViewBlock)(GLPEditCountView *_Nullable countView,NSInteger type,NSIndexPath *subIndexPath);

// 点击编辑按钮回调
@property (nonatomic, copy) void(^GLPShoppingCarCell_editBtnBlock)(GLPFirmListModel *newShoppingCarModel);

// 点击商品回调
@property (nonatomic, copy) void(^GLPShoppingCarCell_goodsBlock)(GLPNewShopCarGoodsModel *_Nullable noActivityModel,GLPNewShopCarGoodsModel *_Nullable activityGoodsModel);

// 点击领券按钮回调
@property (nonatomic, copy) dispatch_block_t ticketBtnBlock;

// 点击店铺回调
@property (nonatomic, copy) dispatch_block_t shopNameClickBlock;

@end



NS_ASSUME_NONNULL_END
