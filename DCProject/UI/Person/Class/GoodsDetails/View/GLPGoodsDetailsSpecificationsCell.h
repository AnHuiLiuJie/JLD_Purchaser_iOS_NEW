//
//  GLPGoodsDetailsSpecificationsCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/22.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsAddressModel.h"
#import "GLPGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsSpecificationsCell : UITableViewCell

// 默认收货地址与运费
@property (nonatomic, strong) GLPGoodsAddressModel *addressModel;
// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
/*规格*/
@property (nonatomic,copy) NSString *specificationsStr;


@property (nonatomic, copy) dispatch_block_t GLPGoodsDetailsSpecificationsCell_block;

@end

NS_ASSUME_NONNULL_END
