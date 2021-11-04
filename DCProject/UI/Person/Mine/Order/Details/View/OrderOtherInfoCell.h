//
//  OrderOtherInfoCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "GLPOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderOtherInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *jiantouView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pay_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLab;
@property (weak, nonatomic) IBOutlet UIView *payBgView;
@property (weak, nonatomic) IBOutlet UIView *logisticsBgView;
@property (weak, nonatomic) IBOutlet UILabel *logisticsTimeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logistics_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *sellerRemarkLab;


@property (nonatomic, strong) GLPOrderDetailModel *model;

@end

NS_ASSUME_NONNULL_END
