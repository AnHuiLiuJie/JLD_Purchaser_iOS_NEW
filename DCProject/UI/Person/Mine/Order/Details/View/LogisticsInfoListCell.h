//
//  LogisticsInfoListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import <UIKit/UIKit.h>
#import "DeliveryInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogisticsInfoListCell : UITableViewCell
{
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}
@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *logisticsFirmName;
@property (weak, nonatomic) IBOutlet UILabel *logisticsNo;
@property (weak, nonatomic) IBOutlet UIButton *replicateBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@property (nonatomic, strong) DeliveryListModel *model;

@property (nonatomic, strong) UIScrollView *scrollBgView;


@property (nonatomic, copy) void(^LogisticsInfoListCell_block)(GLPOrderGoodsListModel *model);
@property (nonatomic, copy) dispatch_block_t LogisticsInfoListCell_Block;
@end

#pragma mark - 商品
@interface LogisticsInfoGoodsListView : UIView

@property (nonatomic, strong) GLPOrderGoodsListModel *model;

@end

NS_ASSUME_NONNULL_END
