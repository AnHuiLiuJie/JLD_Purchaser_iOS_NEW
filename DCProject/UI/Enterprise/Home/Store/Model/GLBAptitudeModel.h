//
//  GLBAptitudeModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBAptitudeModel : NSObject

@property (nonatomic, copy) NSString *expireDate;
@property (nonatomic, copy) NSString *qcCode;
@property (nonatomic, assign) NSInteger qcId;
@property (nonatomic, copy) NSString *qcName;
@property (nonatomic, copy) NSString *qcNum;
@property (nonatomic, copy) NSString *qcPic;
@property (nonatomic, copy) NSString *qcPicSmall;

@end

NS_ASSUME_NONNULL_END
