//
//  GLBUpdateModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/6.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBUpdateModel : NSObject

@property (nonatomic, copy) NSString *isForced; // 是否强制更新：1-是；2-否
@property (nonatomic, copy) NSString *need2Update; // 当前使用版本是否需要更新：1-是；2-否
@property (nonatomic, copy) NSString *uri; // 更新地址

@end

NS_ASSUME_NONNULL_END
