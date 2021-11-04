//
//  GLBCompanyTypeModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBCompanyTypeModel : NSObject

@property (nonatomic, assign) NSInteger catId;
@property (nonatomic, copy) NSString *catName;
@property (nonatomic, assign) NSInteger pcatId;
@property (nonatomic, strong) NSArray *son;


@end

NS_ASSUME_NONNULL_END
