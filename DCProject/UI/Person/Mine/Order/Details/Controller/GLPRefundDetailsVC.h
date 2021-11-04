//
//  GLPRefundDetailsVC.h
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "DCBasicViewController.h"
#import "RefundDetailsListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPRefundDetailsVC : DCBasicViewController

@property (nonatomic, copy) NSString *orderGoodsIdStr;
@property (nonatomic, copy) NSString *orderNoStr;

@property (nonatomic, strong) GLPOrderDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
