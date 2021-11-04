//
//  GLBAreaModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/6.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBProvinceModel : NSObject

@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *areaFullName;
@property (nonatomic, strong) NSArray *son;

@end


@interface GLBCityModel : NSObject

@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *areaFullName;
@property (nonatomic, strong) NSArray *son;

@end


@interface GLBAreaModel : NSObject

@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *areaFullName;

@end


NS_ASSUME_NONNULL_END
