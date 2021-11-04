//
//  CaptchaView.m
//  captcha_oc
//
//  Created by kean_qi on 2020/5/23.
//  Copyright © 2020 kean_qi. All rights reserved.
//

#import "CaptchaView.h"
#import "NSString+AES256.h"
#import "ESConfig.h"

#define BaseImageViewWidth 310.0
#define BaseImageViewHeight 155.0
#define ImageScale 155.0/310.0       //小图47/155
#define ResultViewHeight 40.0 //错误提示view
#define TopHeight 45.0
#define BottomHeight 50.0
#define SliderBgColor [UIColor colorWithRed: 212/255 green: 212/255 blue: 212/255 alpha:1.0]


@interface CaptchaView()
@property (nonatomic, strong) CaptchaRepModel *captchaModle;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *baseImageView;
@property (nonatomic, strong) UIImageView *sliderImageView;
@property (nonatomic, strong) UIButton *refreshButton;

//底部view
@property (nonatomic, strong) UIView *bottomView;
//滑块view
@property (nonatomic, strong) UIView *sliderView;
//滑块左边线条view
@property (nonatomic, strong) UIView *borderView;
//底部标题
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIImageView *sliderImg;


@property (nonatomic, assign) CGFloat puzzleThumbOffsetX;
@property (nonatomic, assign) CGFloat lastPointX;

@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) NSMutableArray *tapViewList;
@property (nonatomic, assign) CGFloat ImageHeight;

@end


@implementation CaptchaView

+ (void)showWithType:(CaptchaType)type CompleteBlock:(void(^)(NSString *result))completeBlock{
    CaptchaView *captchaView = [[CaptchaView alloc]initWithFrame:[[UIScreen mainScreen] bounds] Type:type];
    captchaView.completeBlock = completeBlock;
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:captchaView];
}

- (instancetype)initWithFrame:(CGRect)frame Type:(CaptchaType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentType = type;
        self.lastPointX = 0;
        self.tapViewList = [NSMutableArray array];
        
        [self setBaseView];
        [self requestData];

    }
    return self;
}

-(void) setBaseView{
    UIView *shadowView = [[UIView alloc]initWithFrame:self.bounds];
    shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [self addSubview:shadowView];
    [shadowView addSubview:self.contentView];
    [self.contentView addSubview:self.topView];
}

//滑动验证码
- (void)setPuzzleView{
    [self.contentView addSubview:self.baseImageView];
    [self.baseImageView addSubview:self.sliderImageView];
    self.baseImageView.dc_y = CGRectGetMaxY(self.topView.frame) + 20;
    
    UIImage *baseImg = [self base64ConvertImageWithImgStr:_captchaModle.originalImageBase64];
    self.baseImageView.layer.masksToBounds = YES;
    
    self.baseImageView.dc_width = self.contentView.dc_width-20;
    self.ImageHeight = self.baseImageView.dc_width * ImageScale;

//    self.baseImageView.dc_width = baseImg.size.width == 0 ?  self.contentView.dc_width-20 : baseImg.size.width;
//    self.ImageHeight = baseImg.size.height == 0 ?  (self.contentView.dc_width-20)*ImageScale : baseImg.size.height;
    
    self.baseImageView.dc_height = self.ImageHeight;
    self.baseImageView.image = baseImg;
    self.baseImageView.dc_centerX = self.topView.dc_centerX;

    UIImage *puzzleImg = [self base64ConvertImageWithImgStr:self.captchaModle.jigsawImageBase64];
    //self.sliderImageView.frame = CGRectMake(0, 0, puzzleImg.size.width, puzzleImg.size.height);
    self.sliderImageView.frame = CGRectMake(0, 0, self.baseImageView.dc_width*47/310, self.ImageHeight);
    self.sliderImageView.image = puzzleImg;
    
    [self.contentView addSubview:self.bottomView];
//    _contentView.layer.borderWidth = 1;
//    _contentView.layer.borderColor = [UIColor redColor].CGColor;
    
    self.bottomView.frame = CGRectMake(CGRectGetMinX(self.baseImageView.frame), CGRectGetMaxY(self.baseImageView.frame) + 20, self.baseImageView.frame.size.width, BottomHeight);

    self.bottomLabel.text = @"   向右滑动完成拼图";
    [self.bottomView addSubview:self.bottomLabel];
    self.bottomLabel.frame = self.bottomView.bounds;
    self.puzzleThumbOffsetX = 0.1;
    self.sliderView.frame = CGRectMake(self.puzzleThumbOffsetX, 0, BottomHeight, BottomHeight);
    self.borderView.frame = CGRectMake(0, 0, CGRectGetMidX(self.sliderView.frame), BottomHeight);
    self.sliderImg.frame = CGRectMake(-2, 0, self.sliderView.dc_width+2, self.sliderView.dc_height+2);
    [self.sliderView dc_cornerRadius:self.sliderView.dc_height/2];
    
    [self.bottomView dc_cornerRadius:self.bottomView.dc_height/2];
    
    [self.bottomView addSubview:self.borderView];
    [self.bottomView addSubview:self.sliderView];
    [self.sliderView addSubview:self.sliderImg];

    [self setPuzzleCapchaResult:normalState];
    
    self.sliderView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *brightnessPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidThumbView:)];
    [self.sliderView addGestureRecognizer:brightnessPanRecognizer];
    [self.baseImageView insertSubview:self.resultView atIndex:0];

}

-(void)setCaptchaType{
    switch (self.currentType) {
        case puzzle: //滑动验证码
            [self.baseImageView removeFromSuperview];
            [self.bottomView removeFromSuperview];
            [self setPuzzleView];
            break;
        case clickword: //点选验证码
            self.tapViewList = [NSMutableArray array];
            [self.baseImageView removeFromSuperview];
            self.baseImageView= nil;
            [self.bottomView removeFromSuperview];
            //[self setClickwordView];
            break;
        default:
            break;
    }
}

#pragma mark - quest
-(void)requestData{
    if(self.currentType == clickword){
        //[self setClickwordCapchaResult:progressState];
    }
    
    NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
    NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    if (token.length == 0) {
        token = [[DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key];
    }
    if (userId.length == 0) {
        userId = [[DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key];
    }
    //第一次不需要任何值

    WEAKSELF;
    [SVProgressHUD show];
    [[DCAPIManager shareManager] dc_request_b2c_common_captcha_getWithDic:@{@"token":token,@"userId":userId} Success:^(id  _Nullable response) {
        CaptchaRepModel *captchaRepModel = [CaptchaRepModel mj_objectWithKeyValues:response];
        NSString *pointStr = [DH_EncryptAndDecrypt decryptWithContent:captchaRepModel.point key:DC_Encrypt_Key];
        captchaRepModel.point = pointStr;
        weakSelf.captchaModle = captchaRepModel;
        //第一次请求，如果请求头不存在token，创建token，客户端需存储token！第二次请求，客户端请求需要将token放入头中
        [DCObjectManager dc_saveUserData:weakSelf.captchaModle.token forKey:P_TemporaryToken_Key];
        [DCObjectManager dc_saveUserData:weakSelf.captchaModle.userId forKey:P_TemporaryUserID_Key];
        [weakSelf setCaptchaType];
        [SVProgressHUD dismiss];
    } failture:^(NSError * _Nullable error) {
        weakSelf.captchaModle = [[CaptchaRepModel alloc]init];
        [weakSelf setCaptchaType];
        [SVProgressHUD dismiss];
    }];
}

- (void)requestDataPointJson:(NSString*)pointJson Token:(NSString*)captchaToken PointStr:(NSString*)pointStr{
    if (captchaToken==nil || pointJson==nil || pointStr == nil) {
        [self showResultWithSuccess:NO SuccessStr:@""];
        return;
    }
    
    NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
    NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    if (token.length == 0) {
        token = [[DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryToken_Key];
    }
    if (userId.length == 0) {
        userId = [[DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key] length] == 0 ? @"" : [DCObjectManager dc_readUserDataForKey:P_TemporaryUserID_Key];
    }
    ////第一次不需要任何值
    //token或者userId为空这里应该提示重新 滑动验证码获取 return;
    
    NSString *pointJsonStr = [DH_EncryptAndDecrypt encryptWithContent:pointJson key:DC_Encrypt_Key];
    NSString *captchaTokenStr = [DH_EncryptAndDecrypt encryptWithContent:captchaToken key:DC_Encrypt_Key];
    
    NSDictionary *patameters = @{
        @"points":pointJsonStr,
        @"captchaToken":captchaTokenStr,
        @"token":token,
        @"userId":userId
    };
    
    [[DCAPIManager shareManager] dc_request_b2c_common_captcha_checkWithDic:patameters Success:^(id  _Nullable response) {
        CaptchaCheckModel *checkModel = [CaptchaCheckModel mj_objectWithKeyValues:response];
        if ([checkModel.success boolValue]) {
            NSString *successStr = [NSString stringWithFormat:@"%@---%@",captchaToken, pointStr];
            if(self.captchaModle.secretKey.length > 0){
                successStr = [successStr aes256_encrypt:successStr AESKey:self.captchaModle.secretKey];
            }
            [self showResultWithSuccess:YES SuccessStr:successStr];
        }else{
            [self showResultWithSuccess:NO SuccessStr:@""];
        }
    } failture:^(NSError * _Nullable error) {
        [self showResultWithSuccess:NO SuccessStr:@""];
    }];
}

#pragma mark - set
//滑动验证码
- (void)setPuzzleCapchaResult:(CaptchaResult)resultType{
    self.capchaResult = resultType;
    switch (self.capchaResult) {
        case normalState:{
            //self.borderView.layer.borderColor = [UIColor grayColor].CGColor;
            //self.sliderView.layer.borderColor = [UIColor grayColor].CGColor;
            //self.sliderView.backgroundColor = [UIColor whiteColor];
            //self.bottomLabel.hidden = false;
            //self.sliderImg.text = @">";
            break;
        }
        case progressState:{
            //self.borderView.layer.borderColor = [UIColor dc_colorWithHexString:@"337AB7" alpha:1].CGColor;
            //self.sliderView.layer.borderColor = [UIColor dc_colorWithHexString:@"337AB7" alpha:1].CGColor;
            //self.sliderView.backgroundColor = [UIColor dc_colorWithHexString:@"337AB7" alpha:1];
            //self.bottomLabel.hidden = true;
           //self.sliderImg.text = @">";
            break;
        }
        case successState:{
            //self.borderView.layer.borderColor = [UIColor dc_colorWithHexString:@"4cae4c" alpha:1].CGColor;
            //self.sliderView.layer.borderColor = [UIColor dc_colorWithHexString:@"4cae4c" alpha:1].CGColor;
            //self.sliderView.backgroundColor = [UIColor dc_colorWithHexString:@"4cae4c" alpha:1];
            //self.bottomLabel.hidden = true;
            //self.sliderImg.text = @"✓";
            break;
        }
        case failureState:{
            //self.borderView.layer.borderColor = [UIColor dc_colorWithHexString:@"d9534f" alpha:1].CGColor;
            //self.sliderView.layer.borderColor = [UIColor dc_colorWithHexString:@"d9534f" alpha:1].CGColor;
            //self.sliderView.backgroundColor = [UIColor dc_colorWithHexString:@"d9534f" alpha:1];
            //self.bottomLabel.hidden = true;
            //self.sliderImg.text = @"✕";
            break;
        }
        default:
            break;
    }
}

#pragma mark - action
- (void)close {
    [self removeFromSuperview];
}

//滑动验证码
-(void)slidThumbView:(UIPanGestureRecognizer*)gestureRecognizer {
    [self setPuzzleCapchaResult:progressState];

    CGPoint point = [gestureRecognizer translationInView:self.sliderView];
    if (CGRectGetMaxX(self.sliderView.frame) < self.bottomView.bounds.size.width && CGRectGetMinX(self.sliderView.frame) > 0 && point.x < self.bottomView.bounds.size.width && point.x>0) {
        self.sliderView.transform = CGAffineTransformMakeTranslation(point.x, 0);
        self.borderView.frame = CGRectMake(0, 0, CGRectGetMidX(self.sliderView.frame), BottomHeight);
        self.sliderImageView.transform = CGAffineTransformMakeTranslation(point.x, 0);
    }

    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self checkResult:point];
    }
}

//tapGesture
-(void)tapGesture:(UITapGestureRecognizer*)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.baseImageView];
    NSLog(@"tapGesture %lf", point.x);
    
    if(self.captchaModle.wordList.count > 0 && self.tapViewList.count < self.captchaModle.wordList.count){
        NSDictionary *dic = @{
            @"x": @(point.x),
            @"y": @(point.y)
        };
        [self.tapViewList addObject:dic];
        UILabel *tapLabel = [[UILabel alloc]init];
        CGFloat tapSize = 20;
        tapLabel.frame = CGRectMake(point.x - tapSize*0.5, point.y - tapSize*0.5, tapSize, tapSize);
        tapLabel.backgroundColor = [UIColor dc_colorWithHexString:@"4cae4c" alpha:1];
        tapLabel.textColor = [UIColor whiteColor];
        tapLabel.text = [NSString stringWithFormat:@"%ld",self.tapViewList.count];
        tapLabel.textAlignment = NSTextAlignmentCenter;
        tapLabel.layer.cornerRadius = tapSize*0.5;
        tapLabel.layer.masksToBounds = YES;
        [self.baseImageView addSubview:tapLabel];
    }
    if(self.captchaModle.wordList.count > 0 && self.tapViewList.count == self.captchaModle.wordList.count){
        [self checkResult:point];
    }
}

- (void)checkResult:(CGPoint)point {
    switch (self.currentType) {
        case puzzle: {
            CGFloat x = point.x*310/self.baseImageView.dc_width;
            NSLog(@"point： %f",x);
            NSDictionary *dic = @{@"x": @(x), @"y": self.captchaModle.point};
            NSString *pointEncode = [ESConfig jsonEncode:dic];
            NSLog(@"序列化： %@",pointEncode);
            NSString *pointJson = pointEncode;
            if(self.captchaModle.secretKey.length > 0){
                pointJson = [pointEncode aes256_encrypt:pointEncode AESKey:self.captchaModle.secretKey];
            }
            
            NSLog(@"加密： %@",pointJson);

            [self requestDataPointJson:pointJson Token:self.captchaModle.captchaToken PointStr:pointEncode];
            break;
        }
        case clickword:{
            NSLog(@"%@",self.tapViewList);
            NSString *pointEncode = [ESConfig jsonEncode:self.tapViewList];
            NSString *pointJson = pointEncode;
            if(self.captchaModle.secretKey.length > 0){
                pointJson = [pointEncode aes256_encrypt:pointEncode AESKey:self.captchaModle.secretKey];
            }
            [self requestDataPointJson:pointJson Token:self.captchaModle.captchaToken PointStr:pointEncode];
            break;
        }
            
        default:
            break;
    }
}

- (void)showResultWithSuccess:(BOOL)success SuccessStr:(NSString*)successStr{
    switch (self.currentType) {
        case puzzle: {
            if (success) {
                [self setPuzzleCapchaResult:successState];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.completeBlock != nil) {
                        self.completeBlock(successStr);
                    }
                    [self close];
                });
                
            } else {
                [self setPuzzleCapchaResult:failureState];
                [UIView animateWithDuration:0.25/2 animations:^{
                    self.resultView.transform = CGAffineTransformMakeTranslation(0, -ResultViewHeight);

                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.5/2 delay:0.75/2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.resultView.transform =CGAffineTransformIdentity;
                    } completion:nil];
                }];
                [UIView animateWithDuration:0.75/2 animations:^{
                    self.sliderView.transform = CGAffineTransformIdentity;
                    self.sliderImageView.transform = CGAffineTransformIdentity;
                    self.borderView.layer.frame = CGRectMake(0, 0, CGRectGetMinX(self.sliderView.frame), BottomHeight);
                } completion:^(BOOL finished) {
                    [self setPuzzleCapchaResult:normalState];
                    [self requestData];
                }];
            }
           break;
        }
        case clickword:{
            if (success) {
                //[self setClickwordCapchaResult:successState];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.completeBlock != nil) {
                        self.completeBlock(successStr);
                    }
                    [self close];
                });
            }else {
                //[self setClickwordCapchaResult:failureState];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self requestData];
                });
            }

            break;
        }
        default:
            break;
    }
}

#pragma mark - getter
- (UIView*)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.frame = CGRectMake(0, 0, self.bounds.size.width * 0.9, kScreenW*0.90-20);//kScreenW
        _contentView.center = self.center;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIView*)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.frame = CGRectMake(0, 0, self.bounds.size.width * 0.9, TopHeight);
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, TopHeight - 10)];
        titleLable.text = @"完成拼图验证";
        titleLable.textColor = [UIColor grayColor];
        titleLable.textColor = [UIColor dc_colorWithHexString:@"#787878"];
        titleLable.font = [UIFont fontWithName:PFR size:16];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(self.bounds.size.width*0.9 - 40, 0, TopHeight-5, TopHeight-5);
        [closeButton setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, TopHeight-1, self.bounds.size.width * 0.9 - 20, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        
        self.refreshButton.frame  = CGRectMake(self.bounds.size.width*0.9-110,  5, 90, TopHeight - 5);
        [_topView addSubview:_refreshButton];
        
        [_topView addSubview:titleLable];
        [_topView addSubview:closeButton];
        [_topView addSubview:lineView];
    }
    return _topView;
}


- (UIImageView*)baseImageView{
    if (!_baseImageView) {
        _baseImageView = [[UIImageView alloc]init];
        _baseImageView.frame = CGRectMake(0, 0, self.contentView.dc_width-20, (self.contentView.dc_width-20)*ImageScale);
        _baseImageView.dc_centerX = self.dc_centerX;
        _baseImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _baseImageView;
}

- (UIImageView*)sliderImageView{
    if (!_sliderImageView) {
        _sliderImageView = [[UIImageView alloc]init];
    }
    return _sliderImageView;
}


- (UIView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor dc_colorWithHexString:@"#f6faff"];
        _bottomView.layer.borderWidth = 0.5;
        _bottomView.layer.borderColor = [UIColor dc_colorWithHexString:@"#6ac0f8"].CGColor;
    }
    return _bottomView;
}

- (UIView*)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc]init];
        _sliderView.backgroundColor = [UIColor dc_colorWithHexString:@"#f3f3f3"];
    }
    return _sliderView;
}

- (UIView*)borderView{
    if (!_borderView) {
        _borderView = [[UIView alloc]init];
        _borderView.backgroundColor = [UIColor dc_colorWithHexString:@"#6ac0f8"];
    }
    return _borderView;
}

- (UILabel*)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.textColor = [[UIColor dc_colorWithHexString:@"#50aff4"] colorWithAlphaComponent:1.0];
        _bottomLabel.font = [UIFont fontWithName:PFRMedium size:16];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

- (UIImageView*)sliderImg{
    if (!_sliderImg) {
        _sliderImg = [[UIImageView alloc]init];
        _sliderImg.backgroundColor = [UIColor clearColor];
        _sliderImg.image = [UIImage imageNamed:@"d_slide_btnImg"];
        //  不规则图片显示
        _sliderImg.contentMode =  UIViewContentModeScaleAspectFill;
        _sliderImg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _sliderImg.clipsToBounds  = YES;
        
    }
    return _sliderImg;
}

- (UIButton*)refreshButton{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setTitle:@"换一换" forState:UIControlStateNormal];
        [_refreshButton setTitleColor:[UIColor dc_colorWithHexString:@"#2b64c4"] forState:UIControlStateNormal];
        _refreshButton.titleLabel.font = [UIFont fontWithName:PFR size:14];
        [_refreshButton setImage:[UIImage imageNamed:@"dc_refresh"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (UIView*)resultView{
    if (!_resultView) {
        _resultView = [[UIView alloc]init];
        _resultView.frame = CGRectMake(0, self.ImageHeight, _baseImageView.dc_width, ResultViewHeight);
        //_resultView.frame = CGRectMake(0, BaseImageViewHeight, _baseImageView.dc_width, ResultViewHeight);
        _resultView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, _baseImageView.dc_width, ResultViewHeight)];
        label.text = @"验证失败: 再试一下吧~";
        label.textColor = [UIColor redColor];
        [_resultView addSubview:label];
    }
    return _resultView;
}


- (UIImage *)base64ConvertImageWithImgStr:(NSString *)base64Str {
    NSString *decryptString = [DH_EncryptAndDecrypt decryptWithContent:base64Str key:DC_Encrypt_Key];
    if (decryptString==nil) return nil;
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:decryptString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //base64字符串有图片前缀（前缀类似：data:image/jpeg;base64,xxxxxxx）转image：
//    NSURL *baseImageUrl = [NSURL URLWithString:base64Str];
//    NSData *imageData = [NSData dataWithContentsOfURL:baseImageUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;;
}
@end
