//
//  UIViewController+DH.h
//  DCProject
//
//  Created by Apple on 2019/10/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (DH)

- (void)dh_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
