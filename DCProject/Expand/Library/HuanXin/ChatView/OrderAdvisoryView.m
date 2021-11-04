//
//  OrderAdvisoryView.m
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import "OrderAdvisoryView.h"
#import "GLPOrderAdvisoryPageVC.h"

@interface OrderAdvisoryView ()

@property (strong, nonatomic)  UIView *bgView;
@property (nonatomic,strong) GLPOrderAdvisoryPageVC *filterView;
@property (nonatomic,strong) DCChatGoodsModel *goodsModel;
@property (nonatomic,strong) UIView *topView;

@end


static CGFloat const kPickerHeight = 416;
static CGFloat const kTopViewH = 30;

@implementation OrderAdvisoryView

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

#pragma mark - LazyLaod
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, self.dc_height-kPickerHeight-LJ_TabbarSafeBottomMargin, self.dc_width, kPickerHeight+LJ_TabbarSafeBottomMargin);
        [self addSubview:_bgView];

        _bgView.backgroundColor = [UIColor whiteColor];
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(5, _bgView.dc_height/2)];
    }
    return _bgView;
}

- (GLPOrderAdvisoryPageVC *)filterView{
    if (!_filterView) {
        _filterView = [[GLPOrderAdvisoryPageVC alloc] init];
//        _filterView.view.layer.borderColor = [UIColor blueColor].CGColor;
//        _filterView.view.layer.borderWidth = 1;
        _filterView.viewFrame = CGRectMake(0, 0, kScreenW, _bgView.dc_height-kTopViewH);
        _filterView.view.frame = CGRectMake(0, -kNavBarHeight+kTopViewH, kScreenW, _bgView.dc_height+kNavBarHeight-kTopViewH);
    }
    return _filterView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, kScreenW, kTopViewH);
        
        UILabel *_textLabel = [[UILabel alloc] init];
        _textLabel.text = @"请选择您要咨询的内容";
        _textLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _textLabel.font = [UIFont fontWithName:PFR size:12];
        _textLabel.frame = CGRectMake(10, 5, _topView.dc_width-40, 20);
        [_topView addSubview:_textLabel];

        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(_bgView.dc_width-44, 0, 30, 30)];
        [backButton setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back_action) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backButton];
        
        UIView *line_x = [[UIView alloc] init];
        line_x.frame = CGRectMake(0, 30, _bgView.dc_width, 1);
        line_x.backgroundColor = [UIColor dc_colorWithHexString:@"#ECECEC"];
        [_topView addSubview:line_x];
//        _topView.layer.borderColor = [UIColor greenColor].CGColor;
//        _topView.layer.borderWidth = 1;
    }
    return _topView;
}

#pragma mark - action

- (void)back_action
{
    [self dismissWithAnimation:YES];
}

- (void)templateSingleTapAction:(id)sender
{
    [self back_action];
}

#pragma mark - Show
+ (void)lj_showSildBarViewControllerModel:(nullable DCChatGoodsModel *)filterModel{
    OrderAdvisoryView *obj = [[OrderAdvisoryView alloc] initWithFrame:CGRectMake(0, kScreenH-kPickerHeight-LJ_TabbarSafeBottomMargin, kScreenW, kPickerHeight+LJ_TabbarSafeBottomMargin) filterModel:filterModel];
    [DC_KEYWINDOW addSubview:obj];
}

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame filterModel:(nullable DCChatGoodsModel *)filterModel{
    if (self = [super initWithFrame:frame]) {
        DCChatGoodsModel *model = [[DCChatGoodsModel alloc] init];
        model = filterModel;
        self.goodsModel = [model copy];
        [self setUpBaseSetting];
    }
    return self;
}

#pragma mark - 初始化设置
- (void)setUpBaseSetting
{
    self.backgroundColor = [RGB_COLOR(0, 0, 0) colorWithAlphaComponent:0.5f];

    self.bgView.hidden = NO;

    [self showWithAnimation:YES];
    
    self.filterView.sellerFirmName = self.goodsModel.goodsName;
    [self.bgView addSubview:self.filterView.view];
    [self.bgView addSubview:self.topView];
    
    WEAKSELF;
    self.filterView.GLPOrderAdvisoryPageVCBlock = ^(NSDictionary *_Nonnull commodityInfo) {
        !weakSelf.OrderAdvisoryViewBlock ? : weakSelf.OrderAdvisoryViewBlock(commodityInfo);
        [weakSelf back_action];
    };
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(templateSingleTapAction:)];
//    [self addGestureRecognizer:tapGesture];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.bgView.frame;
        rect.origin.y = kScreenH;
        self.bgView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.bgView.frame;
            rect.origin.y -= kPickerHeight + LJ_TabbarSafeBottomMargin;
            self.bgView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y += kPickerHeight + LJ_TabbarSafeBottomMargin;
        self.bgView.frame = rect;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}

#pragma mark - 移除SubViews
- (void)removeAllSubviews{
    
    if (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
