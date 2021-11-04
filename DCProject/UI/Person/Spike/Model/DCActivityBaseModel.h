//
//  DCActivityBaseModel.h
//  DCProject
//
//  Created by LiuMac on 2021/9/16.
//

#import "DCBaseModel.h"
@class DCSeckillListModel;
@class DCCollageListModel;
NS_ASSUME_NONNULL_BEGIN

@interface DCActivityBaseModel : DCBaseModel

@property (nonatomic, copy) NSString *batchId;//批次ID
@property (nonatomic, copy) NSString *buyNum;//购买数量
@property (nonatomic, copy) NSString *chargeUnit;//计价单位
@property (nonatomic, copy) NSString *endTime;//结束时间
@property (nonatomic, copy) NSString *startTime;//开始时间
@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsName;//商品名称
@property (nonatomic, copy) NSString *goodsNum;//商品数量(参与拼团商品数量)
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *price;//秒杀价格(价格)
@property (nonatomic, copy) NSString *sellPrice;//商城售价
@property (nonatomic, copy) NSString *goodsTitle;

@end


#pragma mark -----------秒杀列表 -----------------
@interface DCSeckillListModel : DCActivityBaseModel

@property (nonatomic, copy) NSString *isSellOut;//是否售完，0-未售完，1-已售完
@property (nonatomic, copy) NSString *isSubscribe;//是否订阅：0-未订阅，1-已订阅
@property (nonatomic, copy) NSString *seckillId;//秒杀ID

@end



#pragma mark -----------拼团列表 -----------------
@interface DCCollageListModel : DCActivityBaseModel

@property (nonatomic, copy) NSString *collageId;//主键ID
@property (nonatomic, copy) NSString *collageState;//状态：0-未开始，1-进行中，2-已结束 3-库存不
@property (nonatomic, copy) NSString *title;//标题

@end

#pragma mark -----------我的拼团列表 -----------------
@interface DCMyCollageListModel : DCCollageListModel

@property (nonatomic, copy) NSString *buyPrice;//购买价格
@property (nonatomic, copy) NSString *joinId;//参与id
@property (nonatomic, copy) NSString *sourceJoinId;//
@property (nonatomic, copy) NSString *joinNum;//参与数量
@property (nonatomic, copy) NSString *joinState;//参与状态：0-等待参与，1-成功，2-失败，3-等待付款
@property (nonatomic, copy) NSString *joinTime;//参团时间
@property (nonatomic, copy) NSString *joinType;//参与类型：1-发起，2-参与
@property (nonatomic, copy) NSString *joinUserCount;//参团人数
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *sellerFirmId;// 卖家企业ID

@end


NS_ASSUME_NONNULL_END
