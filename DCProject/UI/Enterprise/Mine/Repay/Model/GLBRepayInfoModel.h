//
//  GLBRepayInfoModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayInfoModel : NSObject

@property (nonatomic, assign) CGFloat accountPeriodLimit; // 可用授信额度
@property (nonatomic, assign) NSInteger paymentTerm; // 还款期限
@property (nonatomic, assign) NSInteger periodState; // 状态：0-采购双方未建立账期关系，1-您已申请账期支付交易授权，请耐心等待，2-您账期支付交易授权已被供应商停用，请联系供应商 ，3-正常

@end

NS_ASSUME_NONNULL_END
