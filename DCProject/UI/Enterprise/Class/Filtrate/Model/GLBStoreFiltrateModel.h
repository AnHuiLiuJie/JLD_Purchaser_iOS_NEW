//
//  GLBStoreListModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreFiltrateModel : NSObject

@property (nonatomic, copy) NSString *suppierFirmId; // 供应商ID
@property (nonatomic, copy) NSString *suppierFirmName; // 供应商名称
@property (nonatomic, assign) NSInteger valueCount; // 数量
@end

NS_ASSUME_NONNULL_END
