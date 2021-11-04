//
//  TRRequestListModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRRequestListModel : NSObject
@property(nonatomic,copy)NSString *sellerFirmName;//卖家企业名称
@property(nonatomic,copy)NSString *sellerFirmId;//卖家企业Id
@property(nonatomic,copy)NSString *mallLogo;//卖家企业logo
@property(nonatomic,strong)NSArray *validActInfoList;//活动商品列表
@property(nonatomic,copy)NSArray *validNoActGoodsList;//非活动商品列表
@property(nonatomic,copy)NSString *mallname;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
