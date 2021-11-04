//
//  KFOrderListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
#import "OrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KFOrderListCell : UITableViewCell

@property (nonatomic,strong) OrderListModel *model;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;//订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;//订单时间
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;//商品图
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLab;//商品标题
@property (weak, nonatomic) IBOutlet UILabel *payableAmountLab;//订单总金额
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;//订单状态


@end

NS_ASSUME_NONNULL_END
