//
//  HWTFCursorView.m
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//

#import "HWTFCursorView.h"

@interface HWTFCursorView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) CGFloat itemMargin;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UIControl *maskView;

@property (nonatomic, strong) NSMutableArray<HWCursorLabel *> *labels;

@property (nonatomic, strong) NSMutableArray<UIView *> *lines;
@property (nonatomic, strong) NSMutableArray<UIView *> *boxs;

@property (nonatomic, weak) HWCursorLabel *currentLabel;

@end



@implementation HWTFCursorView

#pragma mark - 初始化
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin
{
    if (self = [super init]) {
        
        self.itemCount = count;
        self.itemMargin = margin;
        
        [self configTextField];
    }
    return self;
}

- (void)configTextField
{
    self.backgroundColor = [UIColor whiteColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];
    
    self.labels = @[].mutableCopy;
    self.lines = @[].mutableCopy;
    self.boxs = @[].mutableCopy;

    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = [UIColor clearColor];
    textField.backgroundColor = [UIColor clearColor];
    textField.tintColor= [UIColor clearColor];//光标
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    [textField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    textField.delegate = self;

    // 小技巧：这个属性为YES，可以强制使用系统的数字键盘，缺点是重新输入时，会清空之前的内容
    // clearsOnBeginEditing 属性并不适用于 secureTextEntry = YES 时
    // textField.secureTextEntry = YES;
    
    [_bgView addSubview:textField];
    self.textField = textField;
    [self.textField becomeFirstResponder];
    
    // 小技巧：通过textField上层覆盖一个maskView，可以去掉textField的长按事件
    UIButton *maskView = [UIButton new];
    maskView.backgroundColor = [UIColor clearColor];
    [maskView addTarget:self action:@selector(clickMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    [_bgView addSubview:maskView];
    self.maskView = maskView;
    
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        HWCursorLabel *label = [HWCursorLabel new];
        label.keyboardType = UIKeyboardTypeNumberPad;
        label.enabled = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor dc_colorWithHexString:@"#666666"];
        label.secureTextEntry = YES;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
        [_bgView addSubview:label];
        [self.labels addObject:label];
    }
    
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
//        UIView *line = [UIView new];
//        line.backgroundColor = [UIColor purpleColor];
//        [self addSubview:line];
//        [self.lines addObject:line];
        
        UIView *box = [UIView new];
        box.backgroundColor = [UIColor clearColor];
        [self.textField addSubview:box];
        [self.boxs addObject:box];
        box.layer.borderColor = [UIColor dc_colorWithHexString:@"#999999"].CGColor;//方框颜色
        box.layer.borderWidth = 1;
        box.layer.cornerRadius = 0.5;
        //[self.textField sendSubviewToBack:box];
    }
    
    [self cursor];
}

#pragma mark - set
- (void)setIsResetView:(BOOL)isResetView{
    _isResetView = isResetView;
    if (_isResetView) {
        [_bgView removeFromSuperview];
        [self configTextField];
        [self.textField becomeFirstResponder];
        [self layoutIfNeeded];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    
    if (self.labels.count != self.itemCount) return;
    
    CGFloat temp = self.bounds.size.width - (self.itemMargin * (self.itemCount - 1))-10;
    CGFloat w = temp / self.itemCount;
    CGFloat x = 0;
    
    for (NSInteger i = 0; i < self.labels.count; i++)
    {
        x = i * (w + self.itemMargin);
        
        UITextField *label = self.labels[i];
        label.frame = CGRectMake(x, 5, self.bounds.size.height - 10, self.bounds.size.height - 10);
        
        UIView *line = self.lines[i];
        line.frame = CGRectMake(x, self.bounds.size.height - 10, w, 1);
        
        UIView *box = self.boxs[i];
        box.frame = CGRectMake(x, 5, self.bounds.size.height - 10, self.bounds.size.height - 10);
    }
    
    self.textField.frame = self.bounds;
    self.maskView.frame = self.bounds;
    

}

#pragma mark - 编辑改变
- (void)tfEditingChanged:(UITextField *)textField
{
    if (textField.text.length > self.itemCount) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.itemCount)];
    }
    
    for (int i = 0; i < self.itemCount; i++)
    {
        UITextField *label = [self.labels objectAtIndex:i];
        
        if (i < textField.text.length) {
            label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        } else {
            label.text = nil;
        }
    }
    
    [self cursor];
    
    // 输入完毕后，自动隐藏键盘
    if (textField.text.length >= self.itemCount) {
        [self.currentLabel stopAnimating];
        [textField resignFirstResponder];
        !_HWTFCursorView_InputComplete_block ? : _HWTFCursorView_InputComplete_block(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    !_HWTFCursorView_InputComplete_block ? : _HWTFCursorView_InputComplete_block(aTextfield.text);
    return YES;
}


- (void)clickMaskView
{
    [self.textField becomeFirstResponder];
    [self cursor];
}

- (BOOL)endEditing:(BOOL)force
{
    [self.textField endEditing:force];
    [self.currentLabel stopAnimating];
    return [super endEditing:force];
}

#pragma mark - 处理光标
- (void)cursor
{
    [self.currentLabel stopAnimating];
    
    NSInteger index = self.code.length;
    if (index < 0) index = 0;
    if (index >= self.labels.count) index = self.labels.count - 1;
    
    HWCursorLabel *label = [self.labels objectAtIndex:index];
    
    [label startAnimating];
    self.currentLabel = label;
}

- (NSString *)code
{
    return self.textField.text;
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

@end



// ------------------------------------------------------------------------
// -----------------------------HWCursorLabel------------------------------
// ------------------------------------------------------------------------

@implementation HWCursorLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView
{
    UIView *cursorView = [[UIView alloc] init];
    cursorView.backgroundColor = [UIColor blueColor];//光标颜色
    cursorView.alpha = 0;
    [self addSubview:cursorView];
    _cursorView = cursorView;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = 30;
    CGFloat w = 2;
    CGFloat x = self.bounds.size.width * 0.5;
    CGFloat y = self.bounds.size.height * 0.5;
    self.cursorView.frame = CGRectMake(0, 0, w, h);
    self.cursorView.center = CGPointMake(x, y);
}

- (void)startAnimating
{
    if (self.text.length > 0) return;
    
    CABasicAnimation *oa = [CABasicAnimation animationWithKeyPath:@"opacity"];
    oa.fromValue = [NSNumber numberWithFloat:0];
    oa.toValue = [NSNumber numberWithFloat:1];
    oa.duration = 1;
    oa.repeatCount = MAXFLOAT;
    oa.removedOnCompletion = NO;
    oa.fillMode = kCAFillModeForwards;
    oa.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.cursorView.layer addAnimation:oa forKey:@"opacity"];
}

- (void)stopAnimating
{
    [self.cursorView.layer removeAnimationForKey:@"opacity"];
}
@end
