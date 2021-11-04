//
//  NSTimer+eocBlockSupports.h
//  DCProject
//
//  Created by LiuMac on 2021/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (eocBlockSupports)

+(NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)(void)) block repeats:(BOOL)repeat;

@end

NS_ASSUME_NONNULL_END
