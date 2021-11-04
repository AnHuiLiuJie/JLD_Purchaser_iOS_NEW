//
//  DCCodeButton.m
//  Demo
//
//  Created by Apple on 2018/8/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "DCCodeButton.h"

@interface DCCodeButton ()
{
    NSTimer *_timer; // 计时器
    int _second;      // 读秒数
}

@end


@implementation DCCodeButton

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initParams];
        
        [self setTitle:@"获取验证码" forState:0];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

#pragma mark - 初始化参数
- (void)initParams
{
    _defaultSecond = 120;
    _second = _defaultSecond;
}


#pragma mark - 按钮点击事件
- (void)buttonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_sendBtnClick:)]) {
        [self.delegate dc_sendBtnClick:self];
    }
}


#pragma mark - 开始读秒
- (void)startTimeGo
{
    if (_defaultSecond == 0) {
        _defaultSecond = 120;
    }
    _second = _defaultSecond;
    
    if (!_timer) {
        self.enabled = NO;
        [self setTitle:[NSString stringWithFormat:@"%d s",_second] forState:UIControlStateDisabled];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGO:) userInfo:nil repeats:YES];
    }
    
}

#pragma mark - 定时器
- (void)timeGO:(id)sender
{
    _second --;
    
    if (_second > 0) {
        
        [self setTitle:[NSString stringWithFormat:@"%d s",_second] forState:UIControlStateDisabled];
        
    } else {
        
        [_timer invalidate];
        _timer = nil;
        
        self.enabled = YES;
        [self setTitle:@"获取验证码" forState:0];
    }
}


- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    
    _second = _defaultSecond;
}

#pragma mark - 重写setter方法
- (void)setDefaultSecond:(int)defaultSecond
{
    _defaultSecond = defaultSecond;
    
    _second = _defaultSecond;
}

@end
