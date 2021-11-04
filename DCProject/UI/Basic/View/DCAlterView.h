//
//  DCAlterView.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DCAlterBtnClickBlock)(UIButton *__nullable button);

typedef NS_ENUM(NSInteger , DCAlterType) {
    DCAlterTypeCancel = 0, // 取消
    DCAlterTypeDone,       // 确定
};

NS_ASSUME_NONNULL_BEGIN

@interface DCAlterView : UIView


#pragma mark - 初始化
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;


#pragma mark - 添加点击事件
- (void)addActionWithTitle:(NSString *)title type:(DCAlterType)type halderBlock:(DCAlterBtnClickBlock __nullable)halderBlock;


#pragma mark - 添加点击事件 带颜色
- (void)addActionWithTitle:(NSString *)title color:(UIColor *)color type:(DCAlterType)type halderBlock:(DCAlterBtnClickBlock)halderBlock;


#pragma mark -


@end

NS_ASSUME_NONNULL_END
