//
//  GLBPlantPeopleModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBPlantPeopleModel : NSObject

@property (nonatomic, assign) NSInteger growerId;
@property (nonatomic, copy) NSString *growerName;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *planRange;
@property (nonatomic, copy) NSString *license;
@property (nonatomic, copy) NSString *introduce;

@end

NS_ASSUME_NONNULL_END
