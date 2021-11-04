//
//  YBIBLayoutDirectionManager.h
//  YBImageBrowserDemo
//
//  Created by 杨波 on 2018/8/27.
//  Copyright © 2018年 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YBImageBrowserLayoutDirection) {
    // Unknown layout direction.
    YBImageBrowserLayoutDirectionUnknown,
    // Layout is vertical direction.
    YBImageBrowserLayoutDirectionVertical,
    // Layout is horizontal direction.
    YBImageBrowserLayoutDirectionHorizontal
};

@interface YBIBLayoutDirectionManager : NSObject

- (void)startObserve;

@property (nonatomic, copy) void(^layoutDirectionChangedBlock)(YBImageBrowserLayoutDirection);

+ (YBImageBrowserLayoutDirection)getLayoutDirectionByStatusBar;

@end
NS_ASSUME_NONNULL_END
