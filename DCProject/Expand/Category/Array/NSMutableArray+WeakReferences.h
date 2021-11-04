//
//  NSMutableArray+WeakReferences.h
//  DCProject
//
//  Created by LiuMac on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (WeakReferences)

+ (id)mutableArrayUsingWeakReferences;

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;

@end

NS_ASSUME_NONNULL_END
