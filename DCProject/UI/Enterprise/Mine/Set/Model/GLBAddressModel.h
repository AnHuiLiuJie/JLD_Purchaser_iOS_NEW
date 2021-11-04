//
//  GLBAddressModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBAddressModel : NSObject

@property (nonatomic, assign) NSInteger addrId;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *streetInfo;
@property (nonatomic, copy) NSString *recevier;
@property (nonatomic, copy) NSString *cellphone;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger isDefault;

@end

NS_ASSUME_NONNULL_END
