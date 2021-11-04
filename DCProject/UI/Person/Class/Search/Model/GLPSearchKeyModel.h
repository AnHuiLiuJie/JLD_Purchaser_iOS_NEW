//
//  GLPSearchKeyModel.h
//  DCProject
//
//  Created by Apple on 2021/3/22.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLPSearchKeyTagModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPSearchKeyModel : NSObject

@property (nonatomic,copy) NSString *key;
@property (nonatomic,strong) NSArray *tag;

@end

@interface GLPSearchKeyTagModel : NSObject

@property (nonatomic,copy) NSString *tse;
@property (nonatomic,copy) NSString *tsh;

@end

NS_ASSUME_NONNULL_END

