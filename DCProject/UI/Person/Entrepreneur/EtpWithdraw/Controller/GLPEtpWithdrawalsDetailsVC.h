//
//  GLPEtpWithdrawalsDetailsVC.h
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "DCBasicViewController.h"
#import "EtpWithdrawalsDetailsCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpWithdrawalsDetailsVC : DCBasicViewController

@property (nonatomic, copy) NSString *withdrawId;

@property (nonatomic, strong) EtpWithdrawalsListModel *model;


@end

NS_ASSUME_NONNULL_END
