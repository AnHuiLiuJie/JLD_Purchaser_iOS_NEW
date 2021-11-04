//
//  GLPDetailsStoreCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/29.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsStoreCell : UITableViewCell

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;


// 点击按钮
@property (nonatomic, copy) void(^GLPGoodsDetailsStoreCell_block)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
