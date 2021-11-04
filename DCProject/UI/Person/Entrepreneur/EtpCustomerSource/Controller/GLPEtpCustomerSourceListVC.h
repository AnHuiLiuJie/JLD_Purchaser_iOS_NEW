//
//  GLPEtpCustomerSourceListVC.h
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "DCBasicViewController.h"

typedef NS_ENUM(NSInteger ,EtpCustomerSource) {
    EtpCustomerSourceAll = 1,       // 我的客源
    EtpCustomerSourceOne = 2,           // 二级客源
    EtpCustomerSourceTwo = 3,          // 三级客源

};

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpCustomerSourceListVC : DCBasicViewController

@property (nonatomic, assign) EtpCustomerSource customerType;

@end

NS_ASSUME_NONNULL_END
