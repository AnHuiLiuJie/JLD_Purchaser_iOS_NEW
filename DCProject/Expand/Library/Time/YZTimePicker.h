//
//  YZTimePicker.h
//  YZTimePicker
//
//  Created by cuimingwei on 16/9/21.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class YZTimePicker;


@protocol YZTimePickerDelegate <NSObject>

@optional

- (void)toobarDonBtnHaveClick:(YZTimePicker *)pickView date:(NSDate *)date;

@end

@interface YZTimePicker : UIView

@property(nonatomic,weak) id<YZTimePickerDelegate> delegate;
@property (nonatomic, strong) UIView *bottomView;

//只显示一定时间范围内的 年月日
- (void)setPickerWithMyDate:(NSDate *)myDate startDate:(NSDate *)startDate endDate:(NSDate *)endDate Title:(NSString *)title;

@property (nonatomic, copy) dispatch_block_t removeViewBlock;

/**
 * 移除本控件
 */
- (void)remove;
/**
 *显示本控件
 */
- (void)show;
/**
 *设置PickView的颜色
 */
- (void)setPickViewColer:(UIColor *)color;


@end
