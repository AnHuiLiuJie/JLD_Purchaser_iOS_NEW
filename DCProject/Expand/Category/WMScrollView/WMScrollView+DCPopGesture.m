//
//  WMScrollView+DCPopGesture.m
//  DCProject
//
//  Created by LiuMac on 2021/5/28.
//

#import "WMScrollView+DCPopGesture.h"



static void swizzle(Class class, SEL original, SEL new) {
    Method originalMethod = class_getInstanceMethod(class, original);
    Method newMethod = class_getInstanceMethod(class, new);
    if (class_addMethod(class, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, new, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}


@implementation WMScrollView (DCPopGesture)

- (BOOL)yx_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")])
        {
            return true;
        }
    }
    return false;
}

+ (void)load {
    
    SEL swizzledSelector = @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    SEL swizzledSelector2 = @selector(yx_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);

    swizzle(self, swizzledSelector, swizzledSelector2);
}

@end




