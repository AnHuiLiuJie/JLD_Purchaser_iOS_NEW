//
//  EtpBillDetailCell.h
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "PioneerServiceFeeModel.h"
#import "EtpWithdrawBillModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpBillDetailCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) EtpOrderListModel *orderModel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property (strong , nonatomic) NSMutableArray <EtpOrderPageListModel *> *couponArray;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLab;

@property (nonatomic, copy) void(^EtpBillDetailCell_Block)(EtpOrderPageListModel *model);


@end

NS_ASSUME_NONNULL_END
