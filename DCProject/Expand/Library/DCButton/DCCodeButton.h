//
//  DCCodeButton.h
//  Demo
//
//  Created by Apple on 2018/8/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class DCCodeButton;

@protocol DCCodeButtonDelegate <NSObject>

- (void)dc_sendBtnClick:(DCCodeButton *)button;

@end

@interface DCCodeButton : UIButton

/// 时间秒数  默认是 60s
@property (nonatomic, assign) int defaultSecond;

/// 代理
@property (nonatomic, assign) id<DCCodeButtonDelegate>delegate;

/// 开始读秒
- (void)startTimeGo;

@end

NS_ASSUME_NONNULL_END
