//
//  GLPDetailRuleController.m
//  DCProject
//
//  Created by LiuMac on 2021/10/9.
//

#import "GLPDetailRuleController.h"
#import <WebKit/WebKit.h>

@interface GLPDetailRuleController ()<WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat head_H;
@property (nonatomic, assign) CGFloat wkWebViewHeight;

@end

@implementation GLPDetailRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    //_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - kScreenH/3, kScreenW, kScreenH/3*2)];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenH/3, kScreenW, kScreenH/3*2)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLabel.text = @"活动规则介绍";
    [_bgView addSubview:_titleLabel];
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImage.image = [UIImage imageNamed:@"logo"];
    [_bgView addSubview:_iconImage];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#8A8989"];
    _subLabel.font = PFRFont(14);
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.text = @"品质优选·便捷物流·全程服务";
    [_bgView addSubview:_subLabel];
    

    [_bgView addSubview:self.webView];
    
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kScreenH/3, 0, 0, 0));
//    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(20);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.titleLabel.left).offset(-5);
        make.size.equalTo(CGSizeMake(18, 20));
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(12);
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom);
        make.top.equalTo(self.subLabel.bottom).offset(10);
    }];
    
    if ([_content_str isEqualToString:@"拼团规则"]) {
        [self.webView loadHTMLString:@"<p></p><p><strong><a style=\"color: rgb(51, 51, 51);\" name=\"question1\"></a>《金利达健康商城》拼团规则</strong></p><p></p><p>1、在活动期间，商城用户可邀请好友参与拼团活动。拼团成功，则双方均可享受拼团价。若拼团失败，用户已支付的款项将会原路退回。</p><p>2、只要邀请成功1名用户拼团并支付成功，即为拼团成功。若多人拼团成功则均可享受拼团价。</p><p>3、单个拼团的有效期为24小时。24小时内可连续邀请好友加入拼团；24小时后无论拼团是否成功，团长均可以重新发起拼团。</p><p>4、如遇库存不足等原因，有可能导致无法拼团或拼团失败，给你带来不便敬请谅解。</p><p>5、本活动最终解释权归金利达健康商城所有。</p><p><br/>" baseURL:nil];
    }else if([_content_str isEqualToString:@"秒杀规则"]){
        [self.webView loadHTMLString:@"<p></p><p><strong><a style=\"color: rgb(51, 51, 51);\" name=\"question1\"></a>《金利达健康商城》拼团规则</strong></p><p></p><p>1、在活动期间，商城用户可邀请好友参与拼团活动。拼团成功，则双方均可享受拼团价。若拼团失败，用户已支付的款项将会原路退回。</p><p>2、只要邀请成功1名用户拼团并支付成功，即为拼团成功。若多人拼团成功则均可享受拼团价。</p><p>3、单个拼团的有效期为24小时。24小时内可连续邀请好友加入拼团；24小时后无论拼团是否成功，团长均可以重新发起拼团。</p><p>4、如遇库存不足等原因，有可能导致无法拼团或拼团失败，给你带来不便敬请谅解。</p><p>5、本活动最终解释权归金利达健康商城所有。</p><p><br/>" baseURL:nil];
    }
}


#pragma mark - set
- (void)setContent_str:(NSString *)content_str{
    _content_str = content_str;
}

#pragma mark - lazy load
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
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '260%'" completionHandler:nil];//
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


@end





