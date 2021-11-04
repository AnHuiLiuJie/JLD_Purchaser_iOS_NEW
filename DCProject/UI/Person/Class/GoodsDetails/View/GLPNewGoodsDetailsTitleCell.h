//
//  GLPNewGoodsDetailsTitleCell.h
//  DCProject
//
//  Created by LiuMac on 2021/7/20.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"




NS_ASSUME_NONNULL_BEGIN

@interface GLPNewGoodsDetailsTitleCell : UITableViewCell

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;

//收藏
@property (nonatomic, copy) dispatch_block_t GLPNewGoodsDetailsTitleCell_Block;

// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;


@end

NS_ASSUME_NONNULL_END
