//
//  EtpBankCardListCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import <UIKit/UIKit.h>
#import "EtpWithdrawModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EtpBankCardListCell : UITableViewCell

@property (nonatomic, strong) EtpBankCardListModel *model;

@property (nonatomic, assign) BOOL isSlected;

//@property (nonatomic, copy) dispatch_block_t slectedBtnClick_block;
@property (nonatomic, copy) void(^slectedBtnClick_block)(UIButton *);

@property (nonatomic, copy) dispatch_block_t editBtnClick_block;

@end

NS_ASSUME_NONNULL_END
