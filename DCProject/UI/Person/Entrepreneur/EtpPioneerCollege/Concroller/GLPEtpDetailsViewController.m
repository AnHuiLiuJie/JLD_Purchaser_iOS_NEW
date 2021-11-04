//
//  GLPEtpDetailsViewController.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "GLPEtpDetailsViewController.h"
#import <WebKit/WebKit.h>
/*View*/
#import "EtpPioneerWebHeaderView.h"
#import "DCAPIManager+PioneerRequest.h"

@interface GLPEtpDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) EtpPioneerWebHeaderView *headerView;

@property (nonatomic, assign) CGFloat head_H;
@property (nonatomic, assign) CGFloat wkWebViewHeight;

@property (nonatomic, strong) PioneerCollegeListModel *model;

@end

static NSString *const DetailsWebViewControllerID = @"DetailsWebViewController";

@implementation GLPEtpDetailsViewController

#pragma mark - 请求 服务资讯详情
- (void)requestLoadData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_news_contentWithCurrentNewsID:self.newsId success:^(id response) {
        NSDictionary *dic = response[@"data"];
        PioneerCollegeListModel *model = [PioneerCollegeListModel mj_objectWithKeyValues:dic];
        weakSelf.model = model;

        CGFloat title_H = [DCSpeedy getLabelHeightWithText:model.newsTitle width:kScreenW-16 font:[UIFont fontWithName:PFRMedium size:14]];
        if (title_H>40) {
            title_H = 40;
        }
        CGRect newFrame = weakSelf.headerView.frame;
        newFrame.size.height = title_H + 30;
        weakSelf.headerView.frame = newFrame;
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView setTableHeaderView:weakSelf.headerView];
        [weakSelf.tableView endUpdates];
        
        NSString *newContent = [weakSelf getCenterContentStr:weakSelf.model.newsContent];
        [weakSelf.webView loadHTMLString:newContent baseURL:nil];
        weakSelf.headerView.model = model;
        
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self requestLoadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _head_H = 30+20;
    
    self.title = @"创业学院";
    
    self.webView.backgroundColor = [UIColor whiteColor];

    [self setUpViewUI];
    
}

- (NSString *)getCenterContentStr:(NSString *)content{
    NSString *newStr = [NSString stringWithFormat:@"<html> \n"
            "<head> \n"
            "<style type=\"text/css\"> \n"
            "body {font-size:15px;}\n"
            "</style> \n"
            "</head> \n"
            "<body>"
            "<script type='text/javascript'>"
            "window.onload = function(){\n"
            "var $img = document.getElementsByTagName('img');\n"
            "for(var p in  $img){\n"
               " $img[p].style.width = '100%%';\n"
                "$img[p].style.height ='auto'\n"
            "}\n"
            "}"
            "</script>%@"
            "</body>"
    "</html>",content];
    return newStr;
}

#pragma mark - UI
- (void)setUpViewUI
{
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - UITableView  UITableViewDataSource 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"DetailsWebViewControllerID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        self.webView.tag = 1314;
        [cell.contentView addSubview:self.webView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WKWebView *webview = [cell.contentView viewWithTag:1314];
    webview.frame = CGRectMake(8, 0, cell.dc_width-12, cell.dc_height);
    return cell;
}

#pragma mark - UITableViewDelegate 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-_head_H;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - 初始化 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
//        _tableView.layer.borderWidth = 1;
//        _tableView.layer.borderColor = [UIColor redColor].CGColor;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(EtpPioneerWebHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[EtpPioneerWebHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenW, _head_H);
    }
    return _headerView;
}

#pragma mark -webView
- (WKWebView *)webView{
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        config = [WKWebViewConfiguration new];
        WKUserContentController *userController = [WKUserContentController new];
        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width-20, initial-scale=1,user-scalable=no\">' );";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userController addUserScript:script];
        config.userContentController = userController;
        
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

@end
