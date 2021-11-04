//
//  WMPanGestureRecognizer.m
//  DCProject
//
//  Created by bigbing on 2019/4/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "WMPanGestureRecognizer.h"

@interface WMPanGestureRecognizer () <UIGestureRecognizerDelegate>

@end

@implementation WMPanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"WMScrollView")]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch

{
    
    // 输出点击的view的类名
    
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
        
    }
    
    return  YES;
    
}

@end
