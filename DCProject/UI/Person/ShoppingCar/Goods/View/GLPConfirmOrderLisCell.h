//
//  GLPConfirmOrderLisCell.h
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import <UIKit/UIKit.h>
#import "GLPNewShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPConfirmOrderLisCell : UITableViewCell

// 活动商品详情
@property (nonatomic, strong) GLPNewShopCarGoodsModel *actGoodsModel;


// 非活动商品详情
@property (nonatomic, strong) GLPNewShopCarGoodsModel *noActGoodsModel;


@end

NS_ASSUME_NONNULL_END
