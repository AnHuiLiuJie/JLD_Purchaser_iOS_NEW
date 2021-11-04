//
//  GLPRequestRefundVC.h
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPRequestRefundVC : DCBasicViewController

@property (nonatomic, copy) NSString *orderNoStr;
@property (nonatomic, copy) dispatch_block_t GLPRequestRefundVC_Block;

@property (nonatomic, assign) NSInteger showType;//1-取消订单原因，2-退款原因

@property (nonatomic, copy) NSString *modifyTimeParamStr;//取消订单需要

@end

NS_ASSUME_NONNULL_END
