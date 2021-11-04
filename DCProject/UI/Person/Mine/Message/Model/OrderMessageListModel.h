//
//  OrderMessageListModel.h
//  DCProject
//
//  Created by LiuMac on 2021/6/28.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderMessageListModel : DCBaseModel

@property (nonatomic, copy) NSString *hasRead;//阅读标识
@property (nonatomic, copy) NSString *msgContent;//消息内容
@property (nonatomic, copy) NSString *msgId;//消息ID
@property (nonatomic, copy) NSString *msgInfoId;//消息信息ID
@property (nonatomic, copy) NSString *msgType;//消息类型：0-系统消息，1-订单消息，2-资质消息，3-活动消息
@property (nonatomic, copy) NSString *createTime;//发送时间

@property (nonatomic, copy) NSString *goodsId;//产品id
@property (nonatomic, copy) NSString *batchId; // 批次ID
@end

NS_ASSUME_NONNULL_END
