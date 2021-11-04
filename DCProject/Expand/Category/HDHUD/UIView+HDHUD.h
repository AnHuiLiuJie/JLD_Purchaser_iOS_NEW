//
//  UIView+HDHUD.h
//  DCProject
//
//  Created by LiuMac on 2021/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HDHUD)

- (void)showHudInView:(UIView *)view duration:(NSTimeInterval)duration;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint duration:(NSTimeInterval)duration;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end

NS_ASSUME_NONNULL_END
