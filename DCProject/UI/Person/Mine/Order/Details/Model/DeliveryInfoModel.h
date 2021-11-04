//
//  DeliveryInfoModel.h
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import "DCBaseModel.h"
#import "GLPOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeliveryInfoModel : DCBaseModel

@property (nonatomic, copy) NSArray *deliveryList;//已发货物流列表
@property (nonatomic, copy) NSString *goodsIds;//已发货商品id集合

//@property (nonatomic, copy) NSArray *notDeliveryList;//未发货发货物流列表 自定义

@end


#pragma mark *************** DeliveryListModel
@interface DeliveryListModel : DCBaseModel

@property (nonatomic, copy) NSString *deliveryId;//发货ID
@property (nonatomic, copy) NSString *ids;//
@property (nonatomic, copy) NSString *logisticsFirmCode;//物流公司编码：0表示非物流公司库中的数据
@property (nonatomic, copy) NSString *logisticsFirmName;//物流公司
@property (nonatomic, copy) NSString *logisticsInfo;//物流信息：JSON格式 转成DeliveryInfoListModel
@property (nonatomic, copy) NSString *logisticsNo;//物流单号
@property (nonatomic, copy) NSString *logisticsState;//物流状态：0-在途，即货物处于运输过程中；1-揽件，货物已由快递公司揽收并且产生了第一条跟踪信息；2-疑难，货物寄送过程出了问题；3-签收，收件人已签收；4-退签，即货物由于用户拒签、超区等原因退回，而且发件人已经签收；5-派件，即快递正在进行同城派件；6-退回，货物正处于退回发件人的途中
@property (nonatomic, copy) NSString *logisticsTime;//logisticsTime
@property (nonatomic, copy) NSArray *orderGoodsList;//GLPOrderGoodsListModel

@end

#pragma mark *************** DeliveryInfoListModel
@interface DeliveryInfoListModel : DCBaseModel

@property (nonatomic, copy) NSString *time;//
@property (nonatomic, copy) NSString *context;//
@property (nonatomic, copy) NSString *ftime;//



@end


NS_ASSUME_NONNULL_END
