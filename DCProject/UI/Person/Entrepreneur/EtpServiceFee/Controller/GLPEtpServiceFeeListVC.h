//
//  GLPEtpServiceFeeListVC.h
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "DCBasicViewController.h"
#import "EtpServiceFeeListCell.h"


typedef NS_ENUM(NSInteger ,EtpServiceFeeType) {
    EtpServiceFeeTypeAll = 0,       // 全部
    EtpServiceFeeTypeWait,           // 待结算
    EtpServiceFeeTypeEnd,          // 已结算
    EtpServiceFeeTypeInvalid,          // 无效服务费
};

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpServiceFeeListVC : DCBasicViewController

@property (nonatomic, assign) EtpServiceFeeType customerType;
@property (nonatomic, assign) CGFloat view_H;

@property (nonatomic, strong) PSFSearchConditionModel *model;


@end

NS_ASSUME_NONNULL_END
