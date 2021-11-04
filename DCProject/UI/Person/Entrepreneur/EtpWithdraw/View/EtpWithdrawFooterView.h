//
//  EtpWithdrawFooterView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EtpWithdrawFooterView : UIView

/* 点击事件传过来 */
@property (nonatomic, copy) void(^etpWithdrawFooterViewClickBlock)(NSString *title);

@end

NS_ASSUME_NONNULL_END
