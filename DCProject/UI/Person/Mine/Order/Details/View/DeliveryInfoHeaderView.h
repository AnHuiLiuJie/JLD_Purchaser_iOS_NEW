//
//  DeliveryInfoHeaderView.h
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import <UIKit/UIKit.h>
#import "DeliveryInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeliveryInfoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *logisticsFirmName;
@property (weak, nonatomic) IBOutlet UILabel *logisticsNo;
@property (weak, nonatomic) IBOutlet UIButton *replicateBtn;

@property (nonatomic, strong) DeliveryListModel *model;

@end

NS_ASSUME_NONNULL_END
