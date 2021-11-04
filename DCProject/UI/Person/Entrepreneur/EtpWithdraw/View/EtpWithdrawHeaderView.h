//
//  EtpWithdrawHeaderView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpWithdrawHeaderView : UIView

/* 点击事件传过来 */
@property (nonatomic, copy) void(^etpWithdrawHeaderViewClickBlock)(NSString *title);

//@property (nonatomic, copy) void(^etpWithdrawHeaderBottomViewClickBlock)(NSString *title);


@property (strong , nonatomic ) EtpBankCardListModel *model;

@end

NS_ASSUME_NONNULL_END
