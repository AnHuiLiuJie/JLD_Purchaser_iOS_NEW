//
//  EtpServiceFeeListCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "PioneerServiceFeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EtpServiceFeeListCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

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
@property(nonatomic,strong) PSFOrderListModel *orderModel;
@end

NS_ASSUME_NONNULL_END
