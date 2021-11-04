//
//  GLBIntentionModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/14.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBIntentionModel : NSObject

@property (nonatomic, copy) NSString *contactPhone; // 联系电话
@property (nonatomic, copy) NSString *deliveryTime; // 预期提货时间
@property (nonatomic, assign) NSInteger expectOutput; // 预计产量
@property (nonatomic, assign) CGFloat expectPrice; // 预计价格
@property (nonatomic, copy) NSString *growerName; // 种植户名称
@property (nonatomic, copy) NSString *matureTime; // 成熟时间
@property (nonatomic, copy) NSString *orderContact; // 订购联系人
@property (nonatomic, copy) NSString *orderFirmName; // 订购企业
@property (nonatomic, assign) NSInteger orderId; // 订购标识
@property (nonatomic, assign) CGFloat orderPrice; // 意向价格
@property (nonatomic, assign) CGFloat payAmount; // 已付金额
@property (nonatomic, assign) CGFloat payRatio; // 预付款比例
@property (nonatomic, assign) NSInteger plantId; // 品种标识
@property (nonatomic, copy) NSString *plantPlace; // 种植地点
@property (nonatomic, copy) NSString *plantTime; // 种植时间
@property (nonatomic, strong) NSArray *reportUrl; // 检测报告
@property (nonatomic, copy) NSString *reqAmount; // 需求量
@property (nonatomic, assign) NSInteger state; // 状态：0-待确认，1-已确认，2-未通过
@property (nonatomic, strong) NSArray *varietyImgs; // 品种图片
@property (nonatomic, copy) NSString *varietyInfo; // 品种信息
@property (nonatomic, copy) NSString *varietyName; // 品种名称
@property (nonatomic, copy) NSString *varietySummary; // 品种摘要

@end

NS_ASSUME_NONNULL_END
