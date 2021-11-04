//
//  KFCommodityRecordCell.h
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import <UIKit/UIKit.h>
#import "GLPMineSeeModel.h"
#import "GLPMineCollectModel.h"
#import "GLPShoppingCarModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface KFCommodityRecordCell : UITableViewCell

@property (nonatomic, assign) NSInteger customerType;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;//商品图
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLab;//商品标题
@property (weak, nonatomic) IBOutlet UILabel *payableAmountLab;//订单总金额


@property (nonatomic, strong) GLPMineSeeGoodsModel *model2;
@property (nonatomic, strong) GLPMineCollectModel *model3;
@property (nonatomic, strong) GLPShoppingCarNoActivityModel *model4;


@end

NS_ASSUME_NONNULL_END
