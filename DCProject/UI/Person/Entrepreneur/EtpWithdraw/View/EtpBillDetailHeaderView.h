//
//  EtpBillDetailHeaderView.h
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawBillModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpBillDetailHeaderView : UIView


@property (nonatomic, copy) void(^EtpBillDetailHeaderViewClickBlock)(void);

@property (strong , nonatomic) EtpBillListModel *model;

@end

NS_ASSUME_NONNULL_END
