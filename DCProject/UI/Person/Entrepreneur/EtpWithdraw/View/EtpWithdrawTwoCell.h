//
//  EtpWithdrawTwoCell.h
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawBillModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpWithdrawTwoCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;


@property (nonatomic, strong) EtpBillListModel *model;
@property (nonatomic, assign) BOOL index_row;

@end

NS_ASSUME_NONNULL_END
