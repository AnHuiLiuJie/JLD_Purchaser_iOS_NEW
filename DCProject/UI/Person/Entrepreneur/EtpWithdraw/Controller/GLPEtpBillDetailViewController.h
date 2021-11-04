//
//  GLPEtpBillDetailViewController.h
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "DCBasicViewController.h"
#import "EtpBillDetailCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpBillDetailViewController : DCBasicViewController


@property (strong , nonatomic) NSMutableArray <EtpBillListModel *> *billList;

@property (strong , nonatomic) EtpBillListModel *sectedModel;
@property (assign , nonatomic) NSInteger *sectedIndex;
@property (copy , nonatomic) NSString *billId;

@end

NS_ASSUME_NONNULL_END
