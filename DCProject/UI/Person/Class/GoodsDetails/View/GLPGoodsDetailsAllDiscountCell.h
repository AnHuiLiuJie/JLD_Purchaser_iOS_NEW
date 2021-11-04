//
//  GLPGoodsDetailsAllDiscountCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/18.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsAllDiscountCell : UITableViewCell

// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;
// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;

@property (nonatomic, assign) NSInteger showType;

@property (nonatomic, copy) void(^GLPGoodsDetailsAllDiscountCell_block)(NSString *title);

@end

NS_ASSUME_NONNULL_END
