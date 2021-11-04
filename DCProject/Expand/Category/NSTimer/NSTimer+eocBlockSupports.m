//
//  NSTimer+eocBlockSupports.m
//  DCProject
//
//  Created by LiuMac on 2021/8/19.
//

#import "NSTimer+eocBlockSupports.h"

@implementation NSTimer (eocBlockSupports)

+ (NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)(void)) block repeats:(BOOL)repeat{
    return  [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(startTimer:) userInfo:[block copy] repeats:repeat];
}
//定时器所执行的方法
+ (void)startTimer:(NSTimer *)timer{
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
