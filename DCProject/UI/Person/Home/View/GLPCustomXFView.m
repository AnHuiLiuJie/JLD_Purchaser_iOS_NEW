//
//  GLPCustomXFView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/2.
//

#import "GLPCustomXFView.h"

static dispatch_once_t onceToken;
static GLPCustomXFView *_mangerXFView = nil;
static const CGFloat closeBtn_W = 15;
static const CGFloat closeBtn_H = 15;

@implementation GLPCustomXFView

- (instancetype)initWithFrame:(CGRect)frame params:(NSDictionary *)params isCloseBtn:(BOOL)isCloseBtn{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initSubViewsparams:params isCloseBtn:isCloseBtn];
    }
    return self;
}

+ (instancetype)sharedManagerInitWithFrame:(CGRect)frame params:(NSDictionary *)params isCloseBtn:(BOOL)isCloseBtn;
{
    dispatch_once(&onceToken, ^{
        _mangerXFView = [[GLPCustomXFView alloc] initWithFrame:frame params:params isCloseBtn:isCloseBtn];
    });
    return _mangerXFView;
}

- (void)removeSharedManager
{
    /**只有置成0，GCD才会认为它从未执行过。它默认为0。
     这样才能保证下次再次调用sharedManager的时候，再次创建对象。*/
    onceToken = 0;
    _mangerXFView = nil;
}

- (void)initSubViewsparams:(NSDictionary *)params isCloseBtn:(BOOL)isCloseBtn{
    NSMutableArray *dicArr = [NSMutableArray array];
    NSDictionary *dic = params;
    
    NSArray *keyArr = [dic allKeys];
    keyArr = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    for(NSString *str in keyArr){
        NSDictionary *keyDic = [dic objectForKey:str];
        [dicArr addObject:keyDic];
    }
    
    _showImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, closeBtn_H, self.dc_width-closeBtn_W, self.dc_height-closeBtn_H)];
    _showImg.userInteractionEnabled = YES;
    _showImg.backgroundColor = [UIColor clearColor];
    [_showImg setImage:[UIImage imageNamed:[dic objectForKey:@"img"]]];
    //_showImg.layer.cornerRadius = _showImg.dc_height/2;
    //_showImg.layer.masksToBounds = YES;
//    [_showImg setImageWithURL:[NSURL URLWithString:[dicArr firstObject][@"img"]]
//                          placeholder:SD_LoadImg
//                              options:YYWebImageOptionSetImageWithFadeAnimation
//                              manager:[Create_Tool ImageManager]
//                             progress:nil
//                            transform:nil
//                           completion:nil];
    [self addSubview:_showImg];
//    [_showImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//        if (self.tapBlock) {
//            self.tapBlock([dicArr firstObject][@"link"]);
//        }
//    }]];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBackgroundView:)];
    [_showImg addGestureRecognizer:myTap];
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1.5;
    scaleAnimation.repeatCount = HUGE_VALF;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(1.2);
    scaleAnimation.toValue = @(1.2);
    [_showImg.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    
    if (isCloseBtn) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(self.dc_width-closeBtn_W,0, closeBtn_W, closeBtn_H);
        [closeBtn setBackgroundColor:[UIColor clearColor]];
        [closeBtn setImage:[UIImage imageNamed:@"dc_scy_hui"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(xuanfuClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
}

- (void)didTapBackgroundView:(id)sender{
    if (self.tapBlock) {
        NSDictionary *dic = @{@"type":@"",@"url":@"",@"label":@"活动"};
        self.tapBlock(dic);
    }
}

- (void)xuanfuClose
{
//    _closeBlock();
    [self removeFromSuperview];
}

- (void)dealloc{
    NSLog(@"view dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

/**
 {
  items = {
   I0000000000001 = {
    img = "http://bdq.biandanquan.cn/uploads/image/195/0/2020/06/c03736a32e1307ce86b2530ec3f48222.png",
    link = {
     type = 0,
     url = "/six_activity",
     label = "618活动"
    },
    flex = "100"
   }
  },
  bgColor = "#ffbd08"
 }
 */

@end
