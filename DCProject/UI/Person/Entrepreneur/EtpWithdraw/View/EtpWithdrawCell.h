//
//  EtpWithdrawCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpWithdrawCell : UITableViewCell

@property (nonatomic, copy) void(^etpWithdrawCellClickBlock)(void);
@property (nonatomic, copy) void(^etpWithdrawAddCellClickBlock)(void);

@property (nonatomic, strong) WithDrawAmountModel *model;

@end

NS_ASSUME_NONNULL_END
