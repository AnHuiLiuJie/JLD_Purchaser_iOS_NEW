//
//  DCExamineImageView.m
//  DCProject
//
//  Created by LiuMac on 2021/5/11.
//

#import "DCExamineImageView.h"
#import <WebKit/WebKit.h>
#import "DCAPIManager+PioneerRequest.h"


@interface DCExamineImageView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DCExamineImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [RGB_COLOR(0, 0, 0) colorWithAlphaComponent:0.4f];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];;
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    [self addSubview:_bgView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_imageView];
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(templateSingleTapAction:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.left).offset(8);
        make.right.equalTo(self.right).offset(-8);
        make.height.equalTo(340);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView).insets(UIEdgeInsetsMake(20, 8, 20, 8));
    }];
    
}

#pragma mark - 点击手势
- (void)templateSingleTapAction:(UIGestureRecognizer *)gestureRecognizer{
    [self dismissWithAnimation:YES];
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark set
- (void)setFrimId:(NSString *)frimId{
    _frimId = frimId;
    [self requestFrimeInfo];
}
#pragma mark - 请求 查看药师资格
- (void)requestFrimeInfo
{
    
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_common_customer_pharmacistWithFrimId:self.frimId success:^(id response) {
        NSDictionary *userDic = response[@"data"];
        NSString *imageUrl = [userDic objectForKey:@"certificatePic"];
        //weakSelf.bgView.backgroundColor = [RGB_COLOR(255, 255, 255) colorWithAlphaComponent:0.7f];;
        [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];

    } failture:^(NSError *error) {
        
    }];
}



//#pragma mark - 弹出视图方法
//- (void)showWithAnimation:(BOOL)animation {
//    //1. 获取当前应用的主窗口
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    [keyWindow addSubview:self];
//    if (animation) {
//        // 动画前初始位置
//        CGRect rect = self.bgView.frame;
//        rect.origin.y = SCREEN_HEIGHT;
//        self.bgView.frame = rect;
//        // 浮现动画
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect rect = self.bgView.frame;
//            rect.origin.y -= SCREEN_HEIGHT + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
//            self.bgView.frame = rect;
//        }];
//    }
//}
//

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
//    _bgView.backgroundColor = [UIColor clearColor];;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.bgView.frame;
        //rect.origin.y -= kScreenH + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
        rect.origin.y += kScreenH + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        //!_did_removeView_Block ? : _did_removeView_Block();
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
