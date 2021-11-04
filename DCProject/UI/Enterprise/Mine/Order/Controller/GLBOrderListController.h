//
//  GLBOrderListController.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBOrderModel.h"

typedef void(^DCOrderBlock)(GLBOrderModel *_Nullable orderModel);

typedef NS_ENUM(NSInteger ,GLBOrderType) {
    GLBOrderTypeAll = 0,       // 全部
    GLBOrderTypeAudit,         // 待审核
    GLBOrderTypePay,           // 待付款
    GLBOrderTypeSend,          // 待发货
    GLBOrderTypeAccept,        // 待接收
    GLBOrderTypeEvaluate       // 待评价
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBOrderListController : DCTabViewController

@property (nonatomic, assign) GLBOrderType orderType;


@property (nonatomic, copy) NSString *sellerFirmName; //


@property (nonatomic, copy) DCOrderBlock orderBlock;

@end

NS_ASSUME_NONNULL_END
