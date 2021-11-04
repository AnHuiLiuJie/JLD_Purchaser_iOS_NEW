//
//  AddressModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *addrId; // 收货地址编码
@property (nonatomic, copy) NSString *areaId; // 区域ID
@property (nonatomic, copy) NSString *cellphone; // 手机号码
@property (nonatomic, copy) NSString *isDefault; //是否为默认收货地址。0-否；1-是
@property (nonatomic, copy) NSString *recevier; // 收货人姓名
@property (nonatomic, copy) NSString *streetInfo; // 街道地址
@property (nonatomic, copy) NSString *areaName; // 省市区
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
