//
//  GLBTCMHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTCMHeadView.h"


@interface GLBTCMHeadView ()


@property (nonatomic, strong) UIButton *preferentBtn;
@property (nonatomic, strong) UIButton *lickBtn;
@property (nonatomic, strong) UIButton *reommendBtn;
@property (nonatomic, strong) UIImageView *titleImage;

@end

@implementation GLBTCMHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.46*kScreenW)];
    _scrollView.placeholderImage = [[DCPlaceholderTool shareTool] dc_placeholderImage];
    _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        // 按钮点击
    };
    [self addSubview:_scrollView];
    
    CGFloat spacing = 2;
    CGFloat itemW = (kScreenW - 10*2 - spacing)/2;
    CGFloat itemH = itemW;
    CGFloat smallH = (itemH - spacing)/2;
    
    _preferentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _preferentBtn.frame = CGRectMake(10, CGRectGetMaxY(self.scrollView.frame) + 13, itemW, itemH);
    [_preferentBtn setBackgroundImage:[UIImage imageNamed:@"jrth_1"] forState:0];
    _preferentBtn.adjustsImageWhenHighlighted = NO;
    _preferentBtn.tag = 100;
//    _preferentBtn.backgroundColor = [UIColor redColor];
    _preferentBtn.contentMode = UIViewContentModeScaleAspectFit;
    _preferentBtn.clipsToBounds = YES;
    [_preferentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_preferentBtn];
    
    _lickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lickBtn.frame = CGRectMake(CGRectGetMaxX(self.preferentBtn.frame) + spacing, CGRectGetMinY(self.preferentBtn.frame), itemW, smallH);
    [_lickBtn setBackgroundImage:[UIImage imageNamed:@"zshy-1"] forState:0];
    _lickBtn.adjustsImageWhenHighlighted = NO;
//    _lickBtn.backgroundColor = [UIColor redColor];
    _lickBtn.tag = 101;
    _lickBtn.contentMode = UIViewContentModeScaleAspectFill;
    _lickBtn.clipsToBounds = YES;
    [_lickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lickBtn];
    
    _reommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reommendBtn.frame = CGRectMake(CGRectGetMinX(self.lickBtn.frame), CGRectGetMaxY(self.lickBtn.frame) + spacing, itemW, smallH);
    [_reommendBtn setBackgroundImage:[UIImage imageNamed:@"jptj_1"] forState:0];
    _reommendBtn.adjustsImageWhenHighlighted = NO;
//    _reommendBtn.backgroundColor = [UIColor redColor];
    _reommendBtn.tag = 102;
    _reommendBtn.contentMode = UIViewContentModeScaleAspectFill;
    _reommendBtn.clipsToBounds = YES;
    [_reommendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reommendBtn];
    
    _titleImage = [[UIImageView alloc] init];
    _titleImage.frame = CGRectMake(0.12*kScreenW, CGRectGetMaxY(self.preferentBtn.frame) + 20, 0.76*kScreenW, 0.16*0.76*kScreenW);
    _titleImage.image = [UIImage imageNamed:@"zyg"];
    [self addSubview:_titleImage];
    
    _textField = [[DCTextField alloc] init];
    _textField.frame = CGRectMake(12, 7, kScreenW - 24, 30);
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"输入商品名称";
    _textField.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _textField.font = PFRFont(14);
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_textField dc_cornerRadius:15];
    [self addSubview:_textField];
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 8, 14, 14)];
    searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [_textField addSubview:searchImage];
}


#pragma mark - action
- (void)btnClick:(UIButton *)button
{
    if (_headViewBlock) {
        _headViewBlock(button.tag);
    }
}


@end
