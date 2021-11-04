//
//  GLPOrderDetailsViewController.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark 订单状态：1-待付款；2-待接单，3-已接单；5-已发货；6-待评价；7-交易关闭；8-已退款【全额退款】
typedef NS_OPTIONS(NSUInteger, BuyGoodsOrderStatus) {
    BuyGoodsOrderStatusPendingPay                 = 1,//待付款 1-已下单，等待买家付款
    BuyGoodsOrderStatusPendingReceive             = 2,//待接单 2-待接单
    BuyGoodsOrderStatusPendingShip                = 3,//已接单 3-已接单，还没发货
    BuyGoodsOrderStatusPendingReceipt             = 5,//待收货 5-卖家已发货，等待买家确认
    BuyGoodsOrderStatusTransactionSuccess         = 6,//交易成功 6-待评价,已经确认收货了
    BuyGoodsOrderStatusTransactionClosed          = 7,//交易关闭 7-交易关闭
    BuyGoodsOrderStatusRefunded                   = 8,//已退款 8-已退款【全额退款】
};

#pragma mark - 退款状态位：0-无退款，1-退款成功，2-退款失败，3-退款中,4-已拒绝
typedef NS_OPTIONS(NSUInteger, BuyGoodsRefundStates) {
    BuyGoodsRefundStatesNo          = 0,//无退款
    BuyGoodsRefundStatesSuccess     = 1,//退款成功
    BuyGoodsRefundStatesFailure     = 2,//退款失败
    BuyGoodsRefundStatesRefunding   = 3,//退款中
    BuyGoodsRefundStatesRefuse      = 4//退款已拒绝
};

@interface GLPOrderDetailsViewController : DCBasicViewController

@property (nonatomic, copy) NSString *orderNo_Str;

@property (nonatomic, assign) NSUInteger orderStatusType;



@property (nonatomic, copy) dispatch_block_t GLPOrderDetailsViewController_block;

@end

NS_ASSUME_NONNULL_END

