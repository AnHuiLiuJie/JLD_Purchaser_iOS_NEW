//
//  PersonWebVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PersonWebVC.h"
#import <WebKit/WebKit.h>

@interface PersonWebVC ()<
WKUIDelegate,
WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic,strong) WKUserContentController *userContentController;

@end

@implementation PersonWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.titleStr;
    
    [self.view addSubview:self.wkWebView];
    [self.wkWebView loadHTMLString:self.urlContent baseURL:nil];
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
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - bottomHeight - kNavBarHeight) configuration:config];
        
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
        
    }
    return _wkWebView;
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
