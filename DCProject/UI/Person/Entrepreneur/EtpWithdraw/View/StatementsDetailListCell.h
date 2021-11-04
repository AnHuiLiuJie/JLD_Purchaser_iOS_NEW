//
//  StatementsDetailListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawBillModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StatementsDetailListCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *starusImg;
@property (weak, nonatomic) IBOutlet UILabel *settleStateLab;

//待结算 #E6F5FF
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *customerTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *receiveLab;


@property(nonatomic,strong) NSMutableArray *couponArray;
@property(nonatomic,strong) EtpOrderPageListModel *orderModel;

@end

NS_ASSUME_NONNULL_END
