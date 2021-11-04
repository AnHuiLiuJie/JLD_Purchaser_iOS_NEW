//
//  GLBCollectModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBCollectModel : NSObject

@property (nonatomic, assign) NSInteger collectionId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *wholePrice;
@property (nonatomic, copy) NSString *zeroPrice;
@property (nonatomic, assign) NSInteger suppierFirmId;
@property (nonatomic, copy) NSString *suppierFirmName;
@property (nonatomic, copy) NSString *manufactory;
@property (nonatomic, assign) NSInteger saleType;
@property (nonatomic, copy) NSString *saleTypeCN;

@end

NS_ASSUME_NONNULL_END
