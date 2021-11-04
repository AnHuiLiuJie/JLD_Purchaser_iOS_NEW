//
//  UIViewController+DH.m
//  DCProject
//
//  Created by Apple on 2019/10/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "UIViewController+DH.h"

@implementation UIViewController (DH)

+ (void)load {
    Method originAddObserverMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, @selector(dh_presentViewController:animated:completion:));
    method_exchangeImplementations(originAddObserverMethod, swizzledAddObserverMethod);
}

- (void)dh_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        [self dh_presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        // Fallback on earlier versions
        [self dh_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end
