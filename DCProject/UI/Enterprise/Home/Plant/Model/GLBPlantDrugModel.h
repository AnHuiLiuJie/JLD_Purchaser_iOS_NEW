//
//  GLBPlantDrugModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBPlantDrugModel : NSObject

@property (nonatomic, copy) NSString *growerName;
@property (nonatomic, strong) NSArray *varietyImgs;
@property (nonatomic, copy) NSString *varietyName;
@property (nonatomic, copy) NSString *varietySummary;
@property (nonatomic, copy) NSString *plantTime;
@property (nonatomic, copy) NSString *matureTime;
@property (nonatomic, copy) NSString *plantPlace;
@property (nonatomic, assign) NSInteger expectOutput;
@property (nonatomic, assign) NSInteger expectPrice;
@property (nonatomic, assign) NSInteger payRatio;
@property (nonatomic, strong) NSArray *reportUrl;
@property (nonatomic, copy) NSString *varietyInfo;
@property (nonatomic, assign) NSInteger plantId;

@end

NS_ASSUME_NONNULL_END
