//
//  OrderLogisticsInfoCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "GLPOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderLogisticsInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) GLPOrderDeliverModel *model;

@end

NS_ASSUME_NONNULL_END
