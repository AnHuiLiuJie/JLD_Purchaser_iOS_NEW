//
//  GLPGoodsDetailsExpressCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsExpressCell : UITableViewCell


@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;


@property (nonatomic, copy) dispatch_block_t GLPGoodsDetailsExpressCell_block;

@end

NS_ASSUME_NONNULL_END
