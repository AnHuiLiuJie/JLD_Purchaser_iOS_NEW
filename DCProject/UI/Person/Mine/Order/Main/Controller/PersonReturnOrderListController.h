//
//  GLBOrderListController.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "OrderListModel.h"

typedef NS_ENUM(NSInteger ,GLBOrderType) {
    GLPOrderTypeAll = 0,       // 全部
    GLPOrderTypePay,           // 待付款
    GLPOrderTypeSend,          // 待发货
    GLPOrderTypeAccept,        // 待接收
    GLPOrderTypeEvaluate,       // 待评价
    GLPOrderTypeRefundStatesAll,       // 0-全部有退款订单
    GLPOrderTypeRefundStatesSuccess,     //= 1,//退款成功
    GLPOrderTypeRefundStatesFailure,    // = 2,//退款失败
    GLPOrderTypeRefundStatesRefunding,   //= 3,//退款中
    GLPOrderTypeRefundStatesRefuse,      //= 4//退款已拒绝
};

NS_ASSUME_NONNULL_BEGIN

@interface PersonReturnOrderListController : DCTabViewController

@property (nonatomic, assign) GLBOrderType orderType;

@property (nonatomic, copy) NSString *sellerFirmName; // 店铺名称
@property (nonatomic, copy) NSString *orderNo_str; // 订单号
@property (nonatomic, assign) CGFloat view_H;
@property (nonatomic, assign) BOOL isRefund;//YES 退款/售后  NO我的订单

@end

NS_ASSUME_NONNULL_END
