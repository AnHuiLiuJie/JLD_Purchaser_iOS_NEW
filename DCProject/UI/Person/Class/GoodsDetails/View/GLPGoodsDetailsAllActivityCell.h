//
//  GLPGoodsDetailsAllActivityCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/18.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsAllActivityCell : UITableViewCell

// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;
// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;

@property (nonatomic, copy) void(^GLPGoodsDetailsAllActivityCell_block)(NSString *title);

@end

NS_ASSUME_NONNULL_END
