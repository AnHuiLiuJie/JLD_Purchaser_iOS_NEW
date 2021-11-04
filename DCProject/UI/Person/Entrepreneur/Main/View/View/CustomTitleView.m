//
//  CustomTitleView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/25.
//

#import "CustomTitleView.h"

@interface CustomTitleView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *titleBtn_One;

@property (nonatomic, strong) UIButton *titleBtn_Two;


@end

@implementation CustomTitleView

- (instancetype)initWithFrame:(CGRect)frame{//1
    if (self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        
        //圆角
        [DCSpeedy dc_changeControlCircularWith:self AndSetCornerRadius:self.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#4CB6FF"] canMasksToBounds:YES];
        
        [self setupViewUI];
    }
    return self;
}

- (void)setupViewUI
{
    _selectedIndex = 0;
//    _titleBtn_One = [UIButton buttonWithType:UIButtonTypeCustom];
//    _titleBtn_One.frame = CGRectMake(0, 1, self.width/2, self.height-2);
//    _titleBtn_One.backgroundColor = [UIColor whiteColor];
//    [_titleBtn_One setTitleColor:DefaultNavigationBarColor forState:UIControlStateNormal];
//    [_titleBtn_One setTitle:@"普通发送" forState:UIControlStateNormal];
//    [_titleBtn_One.titleLabel setFont:[UIFont fontWithName:PFR size:16]];
//    [_titleBtn_One addTarget:self action:@selector(title_action:) forControlEvents:UIControlEventTouchUpInside];
//    //TODO:uiview 单边圆角或者单边框
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_titleBtn_One.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(_titleBtn_One.frame.size.height/2,_titleBtn_One.frame.size.height/2)];//圆角大小
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _titleBtn_One.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _titleBtn_One.layer.mask = maskLayer;
//    [self addSubview:_titleBtn_One];
//
//    _titleBtn_Two = [UIButton buttonWithType:UIButtonTypeCustom];
//    _titleBtn_Two.frame = CGRectMake(self.width/2, 1, self.width/2, self.height-2);
//    _titleBtn_Two.backgroundColor = DefaultNavigationBarColor;
//    [_titleBtn_Two setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_titleBtn_Two setTitle:@"三方代发" forState:UIControlStateNormal];
//    [_titleBtn_Two.titleLabel setFont:[UIFont fontWithName:PFR size:16]];
//    [_titleBtn_Two addTarget:self action:@selector(title_action:) forControlEvents:UIControlEventTouchUpInside];
//    //TODO:uiview 单边圆角或者单边框
//    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_titleBtn_Two.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(_titleBtn_Two.frame.size.height/2,_titleBtn_Two.frame.size.height/2)];//圆角大小
//    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
//    maskLayer2.frame = _titleBtn_Two.bounds;
//    maskLayer2.path = maskPath2.CGPath;
//    _titleBtn_Two.layer.mask = maskLayer2;
//    [self addSubview:_titleBtn_Two];
}

//- (void)title_action:(UIButton *)button
//{
//    NSInteger index = 1;
//    if ([button isEqual:_titleBtn_One]) {
//        _titleBtn_One.backgroundColor = [UIColor whiteColor];
//        [_titleBtn_One setTitleColor:DefaultNavigationBarColor forState:UIControlStateNormal];
//        _titleBtn_Two.backgroundColor = DefaultNavigationBarColor;
//        [_titleBtn_Two setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        !_TitileButtonClickBlock ? : _TitileButtonClickBlock(1);
//
//    }else{
//        index = 2;
//        _titleBtn_One.backgroundColor = DefaultNavigationBarColor;
//        [_titleBtn_One setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _titleBtn_Two.backgroundColor = [UIColor whiteColor];
//        [_titleBtn_Two setTitleColor:DefaultNavigationBarColor forState:UIControlStateNormal];
//        !_TitileButtonClickBlock ? : _TitileButtonClickBlock(2);
//    }
//
////    if (self.delegate && [self.delegate respondsToSelector:@selector(TitileButtonClickButtonAction:)]) {
////        [self.delegate TitileButtonClickButtonAction:index];
////    }
//}

#pragma mark - 数据初始化
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

- (void)setAccountArray:(NSMutableArray *)accountArray{
    _accountArray = accountArray;
    
    [DCSpeedy dc_changeControlCircularWith:self AndSetCornerRadius:self.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#4CB6FF"] canMasksToBounds:YES];
    
    CGFloat line_w = (_accountArray.count -1)*1;
    CGFloat width = (self.dc_width-line_w)/_accountArray.count;
    CGFloat w = 1;
    CGFloat height = self.dc_height-2;
    
    for (int i = 0; i<_accountArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_accountArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dc_colorWithHexString:@"#4CB6FF"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.frame = CGRectMake(i*(width+w),1, width, height);
        button.backgroundColor = [UIColor dc_colorWithHexString:@"#4CB6FF"];
        [button.titleLabel setFont:[UIFont fontWithName:PFR size:16]];
        button.tag = 300+i;
        [button addTarget:self action:@selector(title_action:) forControlEvents:UIControlEventTouchUpInside];

//        if (i != 0) {
//            UIView *line = [[UIView alloc] init];
//            line.backgroundColor = [UIColor dc_colorWithHexString:@"#4CB6FF"];
//            line.frame = CGRectMake(i*(width+w)-1,1, 1, height);
//            [self addSubview:line];
//        }
        
        button.selected = NO;
        button.backgroundColor = [UIColor whiteColor];
        if (_selectedIndex == i) {
            button.selected = YES;
            button.backgroundColor = [UIColor dc_colorWithHexString:@"#4CB6FF"];
        }
    
        if (i==0) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(button.frame.size.height/2,button.frame.size.height/2)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = button.bounds;
            maskLayer.path = maskPath.CGPath;
            button.layer.mask = maskLayer;
        }else if (i==_accountArray.count-1){
            UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(button.frame.size.height/2,button.frame.size.height/2)];//圆角大小
            CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
            maskLayer2.frame = button.bounds;
            maskLayer2.path = maskPath2.CGPath;
            button.layer.mask = maskLayer2;
        }
    
        [self addSubview:button];
    }
}

- (void)title_action:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - 300+1;
    button.selected = !button.selected;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]){
            UIButton *index_btn = (UIButton*)obj;
            if (tag == index_btn.tag){
                index_btn.selected = YES;
                index_btn.backgroundColor = [UIColor dc_colorWithHexString:@"#4CB6FF"];
            }else{
                index_btn.selected = NO;
                index_btn.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    !_TitileButtonClickBlock ? : _TitileButtonClickBlock(index);
    
//    NSInteger index = 1;
//    if (button) {
//        _titleBtn_One.backgroundColor = [UIColor whiteColor];
//        [_titleBtn_One setTitleColor:DefaultNavigationBarColor forState:UIControlStateNormal];
//        _titleBtn_Two.backgroundColor = DefaultNavigationBarColor;
//        [_titleBtn_Two setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        !_TitileButtonClickBlock ? : _TitileButtonClickBlock(1);
//
//    }else{
//        index = 2;
//        _titleBtn_One.backgroundColor = DefaultNavigationBarColor;
//        [_titleBtn_One setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _titleBtn_Two.backgroundColor = [UIColor whiteColor];
//        [_titleBtn_Two setTitleColor:DefaultNavigationBarColor forState:UIControlStateNormal];
//        !_TitileButtonClickBlock ? : _TitileButtonClickBlock(2);
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
