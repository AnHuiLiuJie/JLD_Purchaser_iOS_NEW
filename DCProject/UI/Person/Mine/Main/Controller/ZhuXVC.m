//
//  ZhuXVC.m C02FL0XAQ05N
//  DCProject 6.0嘻uoQtXlb4JRS， https://m.tb.cn/h.4Aglwbg?sm=ae3fdd  绿联typec拓展坞苹果电脑扩展usb分线器hdmi转接头网线接口适用华为笔记本p40手机ipad配件macbook pro转换器
//
//  Created by 刘德山 on 2020/11/6.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "ZhuXVC.h"
#import <WebKit/WebKit.h>
#import "GLPXiaohuController.h"
@interface ZhuXVC ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic,strong) WKUserContentController *userContentController;

@end

@implementation ZhuXVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注销账户";
    [self.view addSubview:self.wkWebView];
    [[DCHttpClient shareClient] requestWithPath:@"/appconfig/agreement3" params:nil httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        //NSDictionary *dict = [responseObject mj_JSONObject];
        [self.wkWebView loadHTMLString:responseObject[@"data"][@"content"] baseURL:nil];
        
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        
    }];
    
}
-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        self.userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        if (@available(iOS 10.0, *)) {
            config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        } else {
            // Fallback on earlier versions
        }
        config.userContentController = self.userContentController;
        config.processPool = [[WKProcessPool alloc] init];
        
        [self reloadWKUserScript];
        
        CGFloat bottomHeight = kStatusBarHeight > 20 ? 34 : 0;
        //        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kStatusBarHeight - bottomHeight - kNavBarHeight) configuration:config];
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - bottomHeight - kNavBarHeight-120) configuration:config];
        
        //记得实现对应协议,不然方法不会实现.
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate =self;
        
        //滑动返回看这里
        _wkWebView.allowsBackForwardNavigationGestures = NO;
        
        //加载网页url
        //        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        
        //加载本地Html
        //            NSString *path = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"html"];
        //            [self.webView loadFileURL:[NSURL fileURLWithPath:path] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        // **************** 此处划重点 **************** //
        //添加注入js方法, oc与js端对应实现
        //                    [self.userContentController addScriptMessageHandler:self name:@"showMessage"];
        //        [self.userContentController addScriptMessageHandler:self name:@"appGetUserToken"];
        //        [self.userContentController addScriptMessageHandler:self name:@"appGetUserId"];
        //        [self.userContentController addScriptMessageHandler:self name:@"appVersionName"];
        UIButton *bt4 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [bt4 setTitle:@"同意注销" forState:0];
        [bt4 setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
        bt4.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        bt4.layer.cornerRadius = 21;
        bt4.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [self.view addSubview:bt4];
        [bt4 mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.centerX.offset(0);
            make.height.offset(42);
            make.left.offset(40);
            make.right.offset(-40);
            make.bottom.offset(-15-bottomHeight);
        }];
        [bt4 addTarget:self action:@selector(djgd) forControlEvents:(UIControlEventTouchUpInside)];
        UILabel *la11 = [[UILabel alloc] init];
        la11.text = @"《金利达账户注销须知》";
        la11.numberOfLines = 0;
        la11.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        la11.textColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [self.view addSubview:la11];
        la11.textAlignment = NSTextAlignmentCenter;
        [la11 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bt4.mas_top).offset(-6);
            make.centerX.offset(0);
            make.width.offset(250);
        }];
        UILabel *la10 = [[UILabel alloc] init];
        la10.text = @"点击同意注销按钮，即表示您已经阅读并同意";
        la10.numberOfLines = 0;
        la10.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
        la10.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        [self.view addSubview:la10];
        la10.textAlignment = NSTextAlignmentCenter;
        [la10 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(la11.mas_top).offset(-6);
            make.centerX.offset(0);
        }];
    }
    return _wkWebView;
}

- (void)djgd{
    GLPXiaohuController *vc = [GLPXiaohuController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadWKUserScript{
    //刷新
    NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
    if (!token) {
        token = @"";
    }
    NSString *userId = [DCObjectManager dc_readUserDataForKey:DC_UserID_Key];
    if (!userId) {
        userId = @"";
    }
    NSDictionary *dict = @{@"token":token,@"userId":userId,@"version":APP_VERSION};
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"document.cookie='p=%@'",[dict mj_JSONString]] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.userContentController addUserScript:cookieScript];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
