//
//  NSMutableArray+WeakReferences.m //https://blog.csdn.net/zhang522802884/article/details/76728902

//  DCProject
//
//  Created by LiuMac on 2021/6/4.
//

#import "NSMutableArray+WeakReferences.h"

@implementation NSMutableArray (WeakReferences)

+ (id)mutableArrayUsingWeakReferences {

    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {

    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // Cast of C pointer type 'CFMutableArrayRef' (aka 'struct __CFArray *') to Objective-C pointer type 'id' requires a bridged cast
    return (id)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
    // return (id)(CFArrayCreateMutable(0, capacity, &callbacks));
}


@end
