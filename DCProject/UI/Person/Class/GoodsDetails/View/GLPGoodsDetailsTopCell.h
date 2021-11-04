//
//  GLPGoodsDetailsTopCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/17.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsTopCell : UITableViewCell

// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;
// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;

@property (nonatomic, copy) void(^GLPGoodsDetailsTopCell_block)(NSString *title);


@end

NS_ASSUME_NONNULL_END
