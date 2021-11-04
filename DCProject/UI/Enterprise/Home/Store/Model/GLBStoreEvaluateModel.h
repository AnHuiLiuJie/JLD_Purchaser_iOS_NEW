//
//  GLBStoreEvaluateModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreEvaluateModel : NSObject

@property (nonatomic, copy) NSString *evalTime; // 评价时间
@property (nonatomic, copy) NSString *purchaser; // 采购商名称
@property (nonatomic, assign) NSInteger star; // 评分:1-1星；2-2星；3-3星；4-4星；5-5星 .

@end

NS_ASSUME_NONNULL_END
