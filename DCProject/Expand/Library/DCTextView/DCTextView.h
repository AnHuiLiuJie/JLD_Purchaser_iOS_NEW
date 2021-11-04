//
//  DCTextView.h
//  LieShou
//
//  Created by Apple on 2018/8/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCTextView;

@protocol DCTextViewDelegate <NSObject>

/// 需要实时监听textView.text时可以调用代理
- (void)dc_textViewValueChange:(DCTextView *_Nullable)textView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DCTextView : UIView


/// 设置字体
@property (nonatomic, strong) UIFont *font;

/// 设置字体颜色
@property (nonatomic, strong) UIColor *textColor;

/// 设置占位文本
@property (nonatomic , copy) NSString *placeholder;

/// 设置占位文本颜色
@property (nonatomic, strong) UIColor *placeholderColor;

/// 设置最大输入的字数  默认是10000字
@property (nonatomic, assign) NSInteger maxLength;

/// 最大字数提示是否显示  默认NO
@property (nonatomic, assign) BOOL maxWordShow;

/// 内容 可直接给textview赋值
@property (nonatomic , copy) NSString *content;

/// 偏移量 上
@property (nonatomic, assign) CGFloat edgeInsetsTop;

/// 偏移量 左
@property (nonatomic, assign) CGFloat edgeInsetsLeft;

/// 偏移量 下
@property (nonatomic, assign) CGFloat edgeInsetsBottom;

/// 偏移量 右
@property (nonatomic, assign) CGFloat edgeInsetsRight;

/// 是否显示竖线 默认YES
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/// 是否允许输入emoji 默认NO
@property (nonatomic, assign) BOOL allowEmoji;


/// 对外暴露 textView.text
@property (nonatomic , copy , readonly) NSString *text;


/// 代理
@property (nonatomic, assign) id<DCTextViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
