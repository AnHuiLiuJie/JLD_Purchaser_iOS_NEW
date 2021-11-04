//
//  GLPGoodsAddressModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLPGoodsAddressExpressModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsAddressModel : NSObject

@property (nonatomic, copy) NSString *addrId; // 收货地址编码
@property (nonatomic, copy) NSString *areaId; // 区域ID
@property (nonatomic, copy) NSString *cellphone; // 手机号码
@property (nonatomic, copy) NSString *isDefault; //是否为默认收货地址。0-否；1-是
@property (nonatomic, copy) NSString *recevier; // 收货人姓名
@property (nonatomic, copy) NSString *streetInfo; // 街道地址
@property (nonatomic, copy) NSString *areaName; // 省市区

@property (nonatomic, copy) NSArray *expressList;  //运费 自定义的 GLPGoodsAddressExpressModel

@end


#pragma mark - 运费
@interface GLPGoodsAddressExpressModel : NSObject

@property (nonatomic, copy) NSString *sellerFirmId; //卖家企业id
@property (nonatomic, copy) NSString *freight; // 运费

@end

NS_ASSUME_NONNULL_END
