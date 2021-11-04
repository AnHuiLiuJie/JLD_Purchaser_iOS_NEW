//
//  DCTextView.m
//  LieShou
//
//  Created by Apple on 2018/8/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "DCTextView.h"
#import "NSString+Emoji.h"

@interface DCTextView ()

/// 输入框
@property (nonatomic, strong) UITextView *textView;
/// 占位文本
@property (nonatomic, strong) UILabel *placeholderLabel;
/// 字数提示
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation DCTextView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDefault];
        [self setUpUI];
    }
    return self;
}


#pragma mark - 参数设置默认值
- (void)initDefault
{
    _font = [UIFont fontWithName:PFR size:15];
    _textColor = [UIColor dc_colorWithHexString:@"#06121E"];
    _placeholderColor = [UIColor dc_colorWithHexString:@"#BDC4CE"];
    _maxLength = 10000;
    _maxWordShow = NO;
    _edgeInsetsTop = 7;
    _edgeInsetsLeft = 4;
    _edgeInsetsBottom = 4;
    _edgeInsetsRight = 4;
    _showsVerticalScrollIndicator = YES;
    _allowEmoji = NO;
}

#pragma mark - 创建UI
- (void)setUpUI
{
    [self addSubview:self.tipLabel];
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.textView];
    [self layoutSubviews];
  
    // 监听文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}


#pragma mark - 监听占位文字改变
- (void)textDidChange
{
    UITextRange *selectedRange = self.textView.markedTextRange;
    UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        if (self.textView.text.length > 0) {
            
            if (!_allowEmoji) {
                // 过滤emoji表情
                self.textView.text = [self.textView.text dc_noEmoji];
            }
            
        }
        
        // 去掉超过最大长度的字符串
        if (self.textView.text.length > _maxLength) {
            self.textView.text = [self.textView.text substringToIndex:_maxLength];
        }
        
        self.tipLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.textView.text.length,(long)_maxLength];

    }else { //有高亮文字
        //do nothing
    }
    
    // 占位文字现在是还是隐藏
    self.placeholderLabel.hidden = self.textView.hasText;
    // 赋值text
    self.text = self.textView.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dc_textViewValueChange:)]) {
        [self.delegate dc_textViewValueChange:self];
    }
}

#pragma mark - 添加约束
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGFloat edgeInsetsLeft = _edgeInsetsLeft;
    __block CGFloat edgeInsetsRight = _edgeInsetsRight;
    __block CGFloat insetsTop = _edgeInsetsTop;
    __block CGFloat edgeInsetsBottom = _edgeInsetsBottom;
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.right.equalTo(self.right).offset(-5);
        make.bottom.equalTo(self.bottom).offset(-5);
        make.height.equalTo(15);
    }];
    
    [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.right).offset(-edgeInsetsRight);
        make.top.equalTo(self.top).offset(insetsTop);
        make.left.equalTo(self.left).offset(edgeInsetsLeft + 4);
    }];

    if (_maxWordShow) {
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.left).offset(edgeInsetsLeft);
            make.right.equalTo(self.right).offset(-edgeInsetsRight);
            make.top.equalTo(self.top).offset(insetsTop - 7);
            make.bottom.equalTo(self.tipLabel.top);
        }];
    }else{
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.left).offset(edgeInsetsLeft);
            make.right.equalTo(self.right).offset(-edgeInsetsRight);
            make.top.equalTo(self.top).offset(insetsTop - 7);
            make.bottom.equalTo(self.bottom).offset(-edgeInsetsBottom);
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 重写setter方法
- (void)setFont:(UIFont *)font
{
    _font = font;
    
    self.textView.font = _font;
    self.placeholderLabel.font = _font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    self.textView.textColor = _textColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = _placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = _placeholderColor;
}

- (void)setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
    
    self.tipLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_maxLength];
}

- (void)setMaxWordShow:(BOOL)maxWordShow
{
    _maxWordShow = maxWordShow;
    
    self.tipLabel.hidden = !_maxWordShow;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    
    self.textView.showsVerticalScrollIndicator = _showsVerticalScrollIndicator;
}

- (void)setEdgeInsetsTop:(CGFloat)edgeInsetsTop
{
    _edgeInsetsTop = edgeInsetsTop;
    [self layoutIfNeeded];
}

- (void)setEdgeInsetsLeft:(CGFloat)edgeInsetsLeft
{
    _edgeInsetsLeft = edgeInsetsLeft;
    [self layoutIfNeeded];
}

- (void)setEdgeInsetsBottom:(CGFloat)edgeInsetsBottom
{
    _edgeInsetsBottom = edgeInsetsBottom;
    [self layoutIfNeeded];
}

- (void)setEdgeInsetsRight:(CGFloat)edgeInsetsRight
{
    _edgeInsetsRight = edgeInsetsRight;
    [self layoutIfNeeded];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    self.textView.text = _content;
    self.text = self.textView.text;
    
    // 占位文字现在是还是隐藏
    self.placeholderLabel.hidden = self.textView.hasText;
    
    [self layoutIfNeeded];
}

- (void)setAllowEmoji:(BOOL)allowEmoji
{
    _allowEmoji = allowEmoji;
}


#pragma mark - lazy load
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.alwaysBounceVertical = YES;
        _textView.font = _font;
        _textView.textColor = _textColor;
        _textView.showsVerticalScrollIndicator = _showsVerticalScrollIndicator;
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = _font;
        _placeholderLabel.textColor = _placeholderColor;
    }
    return _placeholderLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#cccccc"];
        _tipLabel.font = PFRFont(12);
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.hidden = !_maxWordShow;
    }
    return _tipLabel;
}



#pragma mark - 手写setter方法 给text属性赋值
- (void)setText:(NSString *)text
{
    if (text) {
        _text = text;
    }
}


@end
