//
//  EtpRuleDescriptionView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "EtpRuleDescriptionView.h"
#import "DCAPIManager+PioneerRequest.h"
#import <WebKit/WebKit.h>


@interface EtpRuleDescriptionView ()<WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *tishiLab;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat head_H;
@property (nonatomic, assign) CGFloat wkWebViewHeight;
@end

@implementation EtpRuleDescriptionView

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
    _contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [RGB_COLOR(0, 0, 0) colorWithAlphaComponent:0.5f];
    [self addSubview:_contentView];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    [_contentView addSubview:_bgView];
    
    _tishiLab = [[UILabel alloc] init];
    _tishiLab.text = @"规则说明";
    _tishiLab.textColor = [UIColor whiteColor];
    _tishiLab.textAlignment = NSTextAlignmentCenter;
    _tishiLab.font = [UIFont fontWithName:PFR size:16];
    _tishiLab.backgroundColor = [UIColor dc_colorWithHexString:@"#FEC855"];
    [_bgView addSubview:_tishiLab];
    
    [_bgView addSubview:self.webView];
    
//    _webView.layer.borderColor = [UIColor redColor].CGColor;
//    _webView.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(templateSingleTapAction:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.left).offset(20);
        make.right.equalTo(self.contentView.right).offset(-20);
        make.height.equalTo(300);
    }];

    [_tishiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView.top);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(5);
        make.right.equalTo(self.bgView.right).offset(-8);
        make.top.equalTo(self.tishiLab.bottom).offset(5);
        make.bottom.equalTo(self.bgView.bottom).offset(-8);
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
- (void)setTitile_str:(NSString *)titile_str{
    _titile_str = titile_str;
    
    _tishiLab.text = _titile_str;
    
    CGFloat title_w = [DCSpeedy getWidthWithText:_tishiLab.text height:_tishiLab.dc_height font:[UIFont fontWithName:PFR size:16]];
    _tishiLab.bounds = CGRectMake(0, 0, title_w+20, 30);
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(400);
    }];
             
    [_tishiLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(title_w+20, 30));
    }];
    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:self.tishiLab byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft size:CGSizeMake(8, 8)];
}

- (void)setShowType:(EtpRuleDescriptionViewType)showType{
    _showType = showType;
    
    [self requestLoadData];
}

- (void)setContent_str:(NSString *)content_str{
    _content_str = content_str;
    if ([content_str isEqualToString:@"拼团规则"]) {
        [self.webView loadHTMLString:@"<p></p><p><strong><a style=\"color: rgb(51, 51, 51);\" name=\"question1\"></a>《金利达健康商城》拼团规则</strong></p><p></p><p>1、在活动期间，商城用户可邀请好友参与拼团活动。拼团成功，则双方均可享受拼团价。若拼团失败，用户已支付的款项将会原路退回。</p><p>2、只要邀请成功1名用户拼团并支付成功，即为拼团成功。若多人拼团成功则均可享受拼团价。</p><p>3、单个拼团的有效期为24小时。24小时内可连续邀请好友加入拼团；24小时后无论拼团是否成功，团长均可以重新发起拼团。</p><p>4、如遇库存不足等原因，有可能导致无法拼团或拼团失败，给你带来不便敬请谅解。</p><p>5、本活动最终解释权归金利达健康商城所有。</p><p><br/>" baseURL:nil];
    }else if([content_str isEqualToString:@"秒杀规则"]){
        [self.webView loadHTMLString:@"<p></p><p><strong><a style=\"color: rgb(51, 51, 51);\" name=\"question1\"></a>《金利达健康商城》拼团规则</strong></p><p></p><p>1、在活动期间，商城用户可邀请好友参与拼团活动。拼团成功，则双方均可享受拼团价。若拼团失败，用户已支付的款项将会原路退回。</p><p>2、只要邀请成功1名用户拼团并支付成功，即为拼团成功。若多人拼团成功则均可享受拼团价。</p><p>3、单个拼团的有效期为24小时。24小时内可连续邀请好友加入拼团；24小时后无论拼团是否成功，团长均可以重新发起拼团。</p><p>4、如遇库存不足等原因，有可能导致无法拼团或拼团失败，给你带来不便敬请谅解。</p><p>5、本活动最终解释权归金利达健康商城所有。</p><p><br/>" baseURL:nil];
    }
}

#pragma mark - 请求 规则
- (void)requestLoadData{
    WEAKSELF;
    if (_showType == EtpRuleDescriptionViewTypeWithdraw) {
        [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_rule_withdrawWithSuccess:^(id response) {
            NSDictionary *userDic = response[@"data"];
            [weakSelf.webView loadHTMLString:userDic[@"content"] baseURL:nil];
        } failture:^(NSError *error) {
            
        }];
    }else if(_showType == EtpRuleDescriptionViewTypeGrade){
        [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_rule_gradeWithSuccess:^(id response) {
            NSDictionary *userDic = response[@"data"];
            [weakSelf.webView loadHTMLString:userDic[@"content"] baseURL:nil];
        } failture:^(NSError *error) {
            
        }];
    }else if(_showType == EtpRuleDescriptionViewTypeAgreement){
        [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_rule_agreementWithSuccess:^(id response) {
            NSDictionary *userDic = response[@"data"];
            [weakSelf.webView loadHTMLString:userDic[@"content"] baseURL:nil];
        } failture:^(NSError *error) {
            
        }];
    }else if(_showType == EtpRuleDescriptionViewTypeActivity){
        [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_rule_activityWithSuccess:^(id response) {
            NSDictionary *userDic = response[@"data"];
            [weakSelf.webView loadHTMLString:userDic[@"content"] baseURL:nil];
        } failture:^(NSError *error) {
            
        }];
    }else if(_showType == EtpRuleDescriptionViewTypeTaxAmount){
        [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_rule_tax_ruleWithSuccess:^(id response) {
            NSDictionary *userDic = response[@"data"];
            [weakSelf.webView loadHTMLString:userDic[@"content"] baseURL:nil];
        } failture:^(NSError *error) {
            
        }];
    }

}

#pragma mark -webView
- (WKWebView *)webView{
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 5;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        config.userContentController = [[WKUserContentController alloc] init];
        config.processPool = [[WKProcessPool alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        self.webView.scrollView.bounces = YES;
    }
    return _webView;
}

#pragma mark -webView delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //禁止用户选择
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.activeElement.blur();" completionHandler:nil];
    //适当增大字体大小
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'" completionHandler:nil];//
    /*居中*/
//    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.verticalAlign = 'middle';" completionHandler:nil];
    
    //width=device-width,
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"seedweet"]) {
        [self handleCustomAction:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)handleCustomAction:(NSURL *)URL
{
    NSArray *params = [URL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
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
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.bgView.frame;
        //rect.origin.y -= kScreenH + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
        rect.origin.y += kScreenH + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
        self.bgView.frame = rect;
        self.contentView.alpha = 0;
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
