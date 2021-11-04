//
//  GLBRecordModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBRecordModel : NSObject

@property (nonatomic, copy) NSString *orderTime; // 下单时间
@property (nonatomic, copy) NSString *purchaserFirmName; // 采购商企业名称
@property (nonatomic, copy) NSString *purchaserFirmPhone; // 采购商企业联系电话
@property (nonatomic, assign) NSInteger quantity; // 采购数量

@end

NS_ASSUME_NONNULL_END
