
#import <UIKit/UIKit.h>
#import "WXSTransitionManager.h"
#import "WXSTransitionProperty.h"
#import "WXSPercentDrivenInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^WXSTransitionBlock)(WXSTransitionProperty *transition);

@interface UIViewController (WXSTransition) <UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>


- (void)wxs_presentViewController:(UIViewController *)viewControllerToPresent animationType:(WXSTransitionAnimationType )animationType completion:(void (^)(void))completion;
- (void)wxs_presentViewController:(UIViewController *)viewControllerToPresent makeTransition:(WXSTransitionBlock)transitionBlock;
- (void)wxs_presentViewController:(UIViewController *)viewControllerToPresent makeTransition:(WXSTransitionBlock)transitionBlock completion:(void (^)(void))completion;


@end

NS_ASSUME_NONNULL_END
