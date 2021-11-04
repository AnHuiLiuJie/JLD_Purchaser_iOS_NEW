//
//  ArrivalNoticeModel.h
//  DCProject
//
//  Created by LiuMac on 2021/7/7.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArrivalNoticeModel : DCBaseModel

@property (nonatomic, copy) NSString *buyerCellphone;//买家手机号
@property (nonatomic, copy) NSString *buyerUserId;//用户ID
@property (nonatomic, copy) NSString *expectTime;//期望时间：1-1个月，2-2个月，3-3个月，6-6个月，12-1年，15-15天 .
@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *isSms;//是否短信通知：0-否，1-是 .
@property (nonatomic, copy) NSString *noticeEndDate;//通知截止日期
@property (nonatomic, copy) NSString *serialId;//货号流水ID，非医药商品使用此字段
@property (nonatomic, copy) NSString *iD;//ID

@end

NS_ASSUME_NONNULL_END
