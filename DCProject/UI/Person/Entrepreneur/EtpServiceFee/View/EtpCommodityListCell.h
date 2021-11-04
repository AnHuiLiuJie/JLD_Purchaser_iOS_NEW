//
//  EtpCommodityListCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "PioneerServiceFeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EtpCommodityListCell : UITableViewCell


@property(nonatomic,strong) PSFGoodsListModel *goodsModel;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *manufactoryLab;
@property (weak, nonatomic) IBOutlet UILabel *buyNumLab;
@property (weak, nonatomic) IBOutlet UILabel *extendUserAmountLab;

@end

NS_ASSUME_NONNULL_END
