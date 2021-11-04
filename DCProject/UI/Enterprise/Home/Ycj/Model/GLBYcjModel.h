//
//  GLBYcjModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 药采集详情
@interface GLBYcjModel : NSObject

@property (nonatomic, assign) NSInteger actNum;
@property (nonatomic, copy) NSString *actTitle;
@property (nonatomic, copy) NSString *actImg;
@property (nonatomic, copy) NSString *requireStartDate;
@property (nonatomic, copy) NSString *requireEndDate;
@property (nonatomic, copy) NSString *sendGoodsStartDate;
@property (nonatomic, copy) NSString *sendGoodsEndDate;
@property (nonatomic, copy) NSString *buyStartTime;
@property (nonatomic, copy) NSString *buyEndTime;
@property (nonatomic, copy) NSString *ruleRemark;
@property (nonatomic, copy) NSString *yicIsEnd;//活动是否过期：1-未过期；2-已过期
@property (nonatomic, strong) NSArray *goods;

@end


#pragma mark - 商品详情
@interface GLBYcjGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *packingSpec;
@property (nonatomic, copy) NSString *manufactory;
@property (nonatomic, assign) NSInteger pkgPackingNum; // 件装量
@property (nonatomic, assign) NSInteger buyAmount; // 已购买数量
@property (nonatomic, copy) NSString *chargeUnit;  // 单位
@property (nonatomic, strong) NSArray *roles; 

@property (nonatomic, copy) NSString *price; // 原价


@end


#pragma mark - 返现规则
@interface GLBYcjRolesModel : NSObject

@property (nonatomic, assign) NSInteger buyMinAmount; // 购买最小值
@property (nonatomic, assign) NSInteger buyMaxAmount; // 购买最大值
@property (nonatomic, assign) NSInteger returnRatio; // 返现比例
@property (nonatomic, assign) CGFloat returnAmount;// 返现金额


#pragma mark - 自定义属性
@property (nonatomic, copy) NSString *chargeUnit;  // 单位

@end

NS_ASSUME_NONNULL_END




