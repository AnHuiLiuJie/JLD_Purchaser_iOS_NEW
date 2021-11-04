//
//  GLBPackageModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBPackageModel : NSObject

@property (nonatomic, copy) NSString *specs; // 规格
@property (nonatomic, copy) NSString *valueCount; // 该规格的数量

@end

NS_ASSUME_NONNULL_END
