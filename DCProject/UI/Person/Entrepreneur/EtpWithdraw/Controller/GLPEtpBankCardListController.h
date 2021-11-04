//
//  GLPEtpBankCardListController.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class EtpBankCardListModel;
@interface GLPEtpBankCardListController : DCBasicViewController


@property (strong , nonatomic) EtpBankCardListModel *selctedModel;
@property (strong , nonatomic) NSMutableArray <EtpBankCardListModel *> *dataList;


@property (nonatomic, copy) void(^GLPEtpBankCardListController_back_block)(EtpBankCardListModel *model);

@end

NS_ASSUME_NONNULL_END
