//
//  GLPH5ViewController.m
//  DCProject
//
//  Created by bigbing on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPH5ViewController.h"
#import <WebKit/WebKit.h>
#import "TZImagePickerController.h"
#import "GLBRepayListController.h"
#import "GLBStorePageController.h"
#import "GLBGoodsDetailController.h"
#import "GLBAddInfoController.h"
#import "PersonOrderPageController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GLPGoodsDetailsController.h"
#import "CSDemoAccountManager.h"//lj_will_change
#import "TRStorePageVC.h"
#import "DCPayTool.h"
#import "DCUMShareTool.h"

@interface GLPH5ViewController ()
<
TZImagePickerControllerDelegate,
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic,strong) WKUserContentController *userContentController;

@property(nonatomic,strong) UIView *topview;

@property (nonatomic, assign) NSInteger payCount;

@end

@implementation GLPH5ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    NSLog(@" --- %ld ",self.payCount);
    
    //    if ([self.webView.request.URL.absoluteString containsString:@"about:blank"]) {
    //        [self.navigationController popViewControllerAnimated:NO];
    //    }
    
    if ([self.path containsString:@"https://mapi.alipay.com/gateway.do"])
    {
        [self dc_navBarHidden:NO animated:animated];
        [self dc_popBackDisabled:NO];
    }
    else{
        [self dc_navBarHidden:YES animated:animated];
        [self dc_popBackDisabled:YES];
        [self dc_navBarLucency:YES];//解决侧滑显示白色
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO animated:animated];
    
    [self dc_popBackDisabled:NO];
    
    //    NSLog(@"1111");
    //    if ([self.webView.request.URL.absoluteString containsString:@"alipay.com"]) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.wkWebView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kStatusBarHeight)];
    self.topview.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.topview];
    
    NSLog(@"h5加载地址 - %@",_path);
    NSString *url =  [NSString dc_encodingByUTF8WithUrl:_path];
    if ([_path containsString:@"#"]) {
        url = _path;
        
        //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"qipei"];
        //
        //
        //        url = filePath;
    }
    if ([url containsString:@"alipay.com"]) {
        url = _path;
    }
    //      [self.wkWebView  loadFileURL:[NSURL fileURLWithPath:url] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    //    [self.wkWebView loadFileURL:[NSURL URLWithString:url] allowingReadAccessToURL:nil];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5]];
    //    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:url]]];
    // 注册通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResult:) name:DC_AlipayResulkt_NotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayResult:) name:DC_WxPayResulkt_NotificationName object:nil];
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"===didStartProvisionalNavigation");
    [SVProgressHUD show];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"===didCommitNavigation");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"====didFinishNavigation");
    // Disable user selection
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    // Disable callout
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [SVProgressHUD dismiss];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"====didFailProvisionalNavigation");
    [SVProgressHUD dismiss];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"====didReceiveServerRedirectForProvisionalNavigation");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"====decidePolicyForNavigationResponse");
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    NSString *currentHTML = navigationResponse.response.URL.absoluteString;
    if ([currentHTML containsString:@"/geren/store_detail.html"])
    {
        self.topview.backgroundColor = RGB_COLOR(4, 150, 142);
    }
    else if ([currentHTML containsString:@"/geren/sign.html"])
    {
        self.topview.backgroundColor = RGB_COLOR(0, 183, 171);
    }
    else if ([currentHTML containsString:@"/geren/detail.html"])
    {
        self.topview.backgroundColor = RGB_COLOR(253, 79, 0);
    }
    else if ([currentHTML containsString:@"/geren/activity_detail.html"]||[_path containsString:@"/geren/activity.html"])
    {
        self.topview.backgroundColor = RGB_COLOR(253, 44, 11);
    }
    else if ([currentHTML containsString:@"/geren/pay.html"])
    {
        self.topview.backgroundColor = [UIColor whiteColor];
    }
    else if ([currentHTML containsString:@"/geren/my_evaluate.html"])
    {
        self.topview.backgroundColor = [UIColor dc_colorWithHexString:@"#f7f9fa"];
        self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#f7f9fa"];

    }
    else{
        self.topview.backgroundColor = [UIColor whiteColor];
    }
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转//
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"====decidePolicyForNavigationAction：%@",navigationAction.request.URL.absoluteString);
    NSString *reqUrl = navigationAction.request.URL.absoluteString;
    // 支付宝支付
    if ([reqUrl containsString:@"alipay.com"]) {
        __weak GLPH5ViewController* weakSelf = self;
        BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:reqUrl fromScheme:DCAlipay_AppScheme callback:^(NSDictionary *result) {
            // 处理支付结果
            NSLog(@"处理支付结果%@", result);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if ([result[@"resultCode"] integerValue] == 9000) {
                    NSDictionary *dict = @{@"type":@"支付宝支付成功"};//UM统计 自定义搜索关键词事件
                    [MobClick event:UMEventCollection_33 attributes:dict];
                    [[DCAlterTool shareTool] showDoneWithTitle:@"支付成功" message:@"点击确认查看订单" defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
                        //返回到订单列表
                        PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
                        vc.index = 0;
                        UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
                    }];
                }
                else if([result[@"resultCode"] integerValue] == 4000){
                    [SVProgressHUD showErrorWithStatus:@"支付失败，请重新支付"];
                }else if([result[@"resultCode"] integerValue] == 6001){
                    [SVProgressHUD showInfoWithStatus:@"支付已取消，请重新支付"];
                }
            });
        }];
        if (isIntercepted) {
            //不允许跳转时
            decisionHandler(WKNavigationActionPolicyCancel);
        }else{
            //允许跳转
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }else if ([navigationAction.request.URL.absoluteString containsString:@"about:blank"]) {
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        if (navigationAction.request.URL.absoluteString && ![navigationAction.request.URL.absoluteString containsString:DC_H5BaseUrl]) {
            
            [self dc_navBarHidden:NO];
            self.navigationItem.title = @"提示信息";
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem dc_leftItemWithImage:[UIImage imageNamed:@"dc_fanhui_hei"] target:self action:@selector(wuliyBackAction:)];
            
            CGFloat bottomHeight = kStatusBarHeight > 20 ? 34 : 0;
            self.wkWebView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - bottomHeight);
            
        } else {
            
            [self dc_navBarHidden:YES];
            self.navigationItem.leftBarButtonItem = nil;
            
            CGFloat bottomHeight = kStatusBarHeight > 20 ? 34 : 0;
            self.wkWebView.frame = CGRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - bottomHeight);
        }
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc] init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *__nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    //    completionHandler();
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"userContentController：%@，%@",message.name,message.body);
    //    NSLog(@"222:%@",message.frameInfo.request.allHTTPHeaderFields);
    if ([message.name isEqualToString:@"appGoBack"]) {
        [self appGoBack];
    }else if ([message.name isEqualToString:@"appGoMain"]) {
        [self appGoMain];
    }else if ([message.name isEqualToString:@"contactMerchant"]) {
        
    }else if ([message.name isEqualToString:@"uploadImage"]) {
        [self uploadImage:[NSString stringWithFormat:@"%@",message.body]];
    }else if ([message.name isEqualToString:@"toMineOrder"]) {
        [self toMineOrder];
    }else if ([message.name isEqualToString:@"callContacts"]) {
        [self callContacts:[message.body mj_JSONString]];
    }else if ([message.name isEqualToString:@"toPay"]) {
        [self toPay:[message.body mj_JSONString]];
    }else if ([message.name isEqualToString:@"toGoodsDetail"]) {
        [self toGoodsDetail:[message.body mj_JSONString]];
    }else if ([message.name isEqualToString:@"payOrder"]) {
        [self payOrder:[NSString stringWithFormat:@"%@",message.body]];
    }else if ([message.name isEqualToString:@"payWechatOrder"]) {
        NSLog(@"===%@",[message.body class]);
        NSDictionary *dict = [DCHelpTool stringTransformationDictionaryByJsonString:[message.body mj_JSONString]];
        [self payWechatOrder:dict];
    }else if ([message.name isEqualToString:@"personFirmShare"]) {
        NSDictionary *dict = [DCHelpTool stringTransformationDictionaryByJsonString:[message.body mj_JSONString]];
        [self personFirmShare:dict];
    }else if ([message.name isEqualToString:@"personOrderKeFu"]) {
        NSDictionary *dict = [DCHelpTool stringTransformationDictionaryByJsonString:[message.body mj_JSONString]];
        [self personOrderKeFu:dict];
    }else if ([message.name isEqualToString:@"appToLogin"]) {
        [self appToLogin];
    }else if ([message.name isEqualToString:@"tosaveImage"]){
        [self tosaveImage:message.body];
    }else if ([message.name isEqualToString:@"tocopyText"]){
        [self tocopyText:message.body];
    }else if ([message.name isEqualToString:@"goToUserGoodsDetail"]){
        [self goToUserGoodsDetail:message.body];
    }else if ([message.name isEqualToString:@"goToUserShopDetail"]){
        [self goToUserShopDetail:message.body];
    }else if ([message.name isEqualToString:@"setSeeDoctor"]){
        NSLog(@"====setSeeDoctor:%@",message.body);
        [self setSeeDoctor:message.body];
    }
}

- (void)tocopyText:(NSString *)text{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:text];
    [SVProgressHUD showSuccessWithStatus:@"复制成功！"];
}

#pragma mark - 传递token
- (NSString *)appGetUserToken
{
    NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
    if (!token) {
        token = @"";
    }
    return token;
}

#pragma mark - 传递userId
- (NSString *)appGetUserId
{
    NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    if (!userId) {
        userId = @"";
    }
    return userId;
}

#pragma mark - 传递版本号
- (NSString *)appVersionName
{
    NSLog(@"版本号 - %@",APP_VERSION);
    return APP_VERSION;
}

#pragma mark - 自定义返回
- (void)wuliyBackAction:(id)sender
{
    [self appGoBack];
}

#pragma mark -  返回
- (void)appGoBack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        } else {
            if (self.navigationController.childViewControllers.count > 1) {
                if (self.currentIndex != 0 && self.currentIndex > 0) {
                    UIViewController *target = self.navigationController.viewControllers[self.currentIndex];
                    self.currentIndex = 0;
                    if (target) {
                        [self.navigationController popToViewController:target animated:YES];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    return;
                }
                // 普通情况
                [self.navigationController popViewControllerAnimated:YES];
                //[self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    });
}
#pragma mark -  返回根视图
- (void)appGoMain
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}


#pragma mark - 联系卖家 变成了 personOrderKeFu
- (void)contactMerchant:(NSDictionary *)dict
{
    
    
}


#pragma mark - 上传图片
- (void)uploadImage:(NSString *)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [index componentsSeparatedByString:@","];
        if (arr.count >1) {
            [self dc_openImagePickerController:[NSString stringWithFormat:@"%@",[arr firstObject]] type:[NSString stringWithFormat:@"%@",[arr lastObject]]];
        }else{
            [self dc_openImagePickerController:[NSString stringWithFormat:@"%@",[arr firstObject]] type:nil];
        }
        
    });
}


#pragma mark - 跳转到我的订单
- (void)toMineOrder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
        vc.index = 0;
        [self.navigationController pushViewController:vc animated:YES];
    });
}


#pragma mark - 打电话
- (void)callContacts:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[DCHelpTool shareClient] dc_callMobile:string];
    });
}

- (void)goToUserShopDetail:(NSString *)string{
    TRStorePageVC *vc = [[TRStorePageVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.firmId=string;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToUserGoodsDetail:(NSString *)st{
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = [NSString stringWithFormat:@"%@",st];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 个人版企业分享
- (void)personFirmShare:(NSDictionary *)firmdic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *idstr = [NSString stringWithFormat:@"%@",firmdic[@"id"]];
        NSString *imagestr = [NSString stringWithFormat:@"%@",firmdic[@"logo"]];
        NSString *namestr = [NSString stringWithFormat:@"%@",firmdic[@"name"]];
        NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
        NSString *urlStr = [NSString stringWithFormat:@"%@/geren/app_code.html?type=1&id=%@&userId=%@",Person_H5BaseUrl,idstr,userId];
        [[DCUMShareTool shareClient]shareInfoWithImage:imagestr WithTitle:namestr orderNo:@"" joinId:@"" goodsId:idstr content:@"金利达" url:urlStr completion:^(id result, NSError *error) {
            
        }];
        
    });
}
#pragma mark - 去付款
- (void)toPay:(NSString *)string
{
    
}

#pragma mark 去商品明细
- (void)toGoodsDetail:(NSString *)goodsId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GLPGoodsDetailsController*vc = [[GLPGoodsDetailsController alloc] init];
        vc.goodsId=goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    });
}


// 需要登录
- (void)appToLogin
{
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
            [weakSelf.wkWebView reload];
        }];
    });
}


#pragma mark - 传给h5方法
- (void)jsFromString:(NSString *)string
{
    //    [NSString stringWithFormat:@"jsGetBackPhoto('%@')",imageUrl]
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wkWebView evaluateJavaScript:string completionHandler:nil];
    });
}


#pragma mark - 打开图片选择器
- (void)dc_openImagePickerController:(NSString *)index type:(NSString *)type
{
    WEAKSELF;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:[index floatValue]  delegate:self];
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#00B7AB"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if ([photos count] > 0) {
            [weakSelf requestUploadImage:photos index:type];
        }
        
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - 上传图片
- (void)requestUploadImage:(NSArray *)images index:(NSString *)index
{
    
    [SVProgressHUD show];
    WEAKSELF;
    for (int i = 0; i <images.count; i++) {
        
        
        [[DCHttpClient shareClient] personRequestUploadWithPath:@"/common/upload" images:@[images[i]] params:nil progress:^(NSProgress *_Nonnull uploadProgress) {
            
        } sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
            
            [SVProgressHUD dismiss];
            if (responseObject) {
                NSDictionary *dict = [responseObject mj_JSONObject];
                if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) { // 请求成功
                    
                    if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dictionary = dict[@"data"];
                        NSString *imageUrl = dictionary[@"uri"];
                        if (!imageUrl || [imageUrl dc_isNull]) {
                            imageUrl = @"";
                        }
                        
                        if (index && index.length > 0) {
                            
                            [weakSelf jsFromString:[NSString stringWithFormat:@"getGerenSuccess('%@,%@')",imageUrl,index]];
                            
                        } else {
                            
                            [weakSelf jsFromString:[NSString stringWithFormat:@"getGerenSuccess('%@')",imageUrl]];
                        }
                    }
                    
                } else {
                    
                    [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
                }
            }
            
        } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
            
            [SVProgressHUD dismiss];
            NSLog(@"响应失败 - %@",error);
            [[DCAlterTool shareTool] showCancelWithTitle:@"请求失败" message:error.localizedDescription cancelTitle:@"确定"];
        }];
    }
}
#pragma mark -个人版订单详情联系客服
- (void)personOrderKeFu:(NSDictionary *)kefudic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *userID = @"";
        NSString *headimg = @"";
        NSString *title = @"客服";
        //NSString *firmName = @"";
        userID = [NSString stringWithFormat:@"b2c_%@",kefudic[@"id"]];
        title = [NSString stringWithFormat:@"%@",kefudic[@"name"]];
        headimg = [NSString stringWithFormat:@"%@",kefudic[@"logo"]];
        //        firmName = [NSString stringWithFormat:@"%@",kefudic[@"firmName"]];
        
        NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [userDic setValue:userID forKey:@"userId"];
        [userDic setValue:title forKey:@"nickname"];
        [userDic setValue:headimg forKey:@"headImg"];
        [[DCUpdateTool shareClient]updateEaseUser:userDic];
        
        //lj_will_change_end
        WEAKSELF;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
            if ([lgM loginKefuSDK]) {
                NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
                NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
                NSString *chatTitle = title;
                HDQueueIdentityInfo *queueIdentityInfo = nil;
                HDAgentIdentityInfo *agentIdentityInfo = nil;
                queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
                agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
                chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
                hd_dispatch_main_async_safe(^(){
                    [weakSelf hideHud];
                    HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
                    queue ? (chat.queueInfo = queueIdentityInfo) : nil;
                    agent ? (chat.agent = agentIdentityInfo) : nil;
                    chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
                    chat.title = title;
                    chat.sellerFirmName = title;
                    [self.navigationController pushViewController:chat animated:YES];
                });
                
            } else {
                hd_dispatch_main_async_safe(^(){
                    [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
                });
                NSLog(@"登录失败");
            }
        });//完整
        
        //lj_will_change
        //        HDChatViewController *chatController = [[HDChatViewController alloc] initWithConversationChatter:userID conversationType:EMConversationTypeChat];
        //        chatController.title = title;
        //        chatController.sellerFirmName = title;
        //        [self.navigationController pushViewController:chatController animated:YES];
    });
    
}
#pragma mark -保存图片到本地
- (void)tosaveImage:(NSString *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *iamgestr = [image stringByReplacingOccurrencesOfString:@"data:image/jpeg;base64," withString:@""];
        NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:iamgestr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
        UIImageWriteToSavedPhotosAlbum(decodedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [SVProgressHUD showErrorWithStatus:msg];
    }else{
        msg = @"保存图片成功" ;
        [SVProgressHUD showSuccessWithStatus:msg];
    }
    
}
#pragma mark - 订单支付
- (void)payOrder:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GLPH5ViewController *vc = [GLPH5ViewController new];
        vc.path = string;
        [self.navigationController pushViewController:vc animated:NO];
    });
}
#pragma mark - 订单微信支付
- (void)payWechatOrder:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[DCPayTool shareTool] dc_wxpay:dic];
    });
}

#pragma mark - 确定就诊信息
- (void)setSeeDoctor:(NSString *)jsonString{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [DCHelpTool stringTransformationDictionaryByJsonString:[jsonString mj_JSONString]];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if (self.drugBlock) {
                self.drugBlock(dict);
            }
        }
    });
}

#pragma mark - 清除缓存和cookie
- (void)dc_cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除WebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark - load lazy

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
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - bottomHeight) configuration:config];
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
        
        [self.userContentController addScriptMessageHandler:self name:@"appGoBack"];
        [self.userContentController addScriptMessageHandler:self name:@"appGoMain"];
        [self.userContentController addScriptMessageHandler:self name:@"contactMerchant"];
        [self.userContentController addScriptMessageHandler:self name:@"uploadImage"];
        [self.userContentController addScriptMessageHandler:self name:@"toMineOrder"];
        [self.userContentController addScriptMessageHandler:self name:@"callContacts"];
        [self.userContentController addScriptMessageHandler:self name:@"toPay"];
        [self.userContentController addScriptMessageHandler:self name:@"toGoodsDetail"];
        [self.userContentController addScriptMessageHandler:self name:@"payOrder"];
        [self.userContentController addScriptMessageHandler:self name:@"payWechatOrder"];
        [self.userContentController addScriptMessageHandler:self name:@"personFirmShare"];
        [self.userContentController addScriptMessageHandler:self name:@"personOrderKeFu"];
        [self.userContentController addScriptMessageHandler:self name:@"tosaveImage"];
        [self.userContentController addScriptMessageHandler:self name:@"appToLogin"];
        [self.userContentController addScriptMessageHandler:self name:@"tocopyText"];
        [self.userContentController addScriptMessageHandler:self name:@"goToUserGoodsDetail"];
        [self.userContentController addScriptMessageHandler:self name:@"goToUserShopDetail"];
        [self.userContentController addScriptMessageHandler:self name:@"setSeeDoctor"];
        
    }
    return _wkWebView;
}

- (void)reloadWKUserScript{
    //刷新
    NSString *token = [DCObjectManager dc_readUserDataForKey:P_Token_Key];
    if (!token) {
        token = @"";
    }
    NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    if (!userId) {
        userId = @"";
    }
    
    NSDictionary *dict = @{@"token":token,@"userId":userId,@"version":APP_VERSION};
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"document.cookie='p=%@'",[dict mj_JSONString]] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.userContentController addUserScript:cookieScript];
}


#pragma mark - 监听到支付宝支付通知
- (void)alipayResult:(NSNotification *)notification
{
    WEAKSELF;
    NSDictionary *resultDic = notification.userInfo;
    if ([resultDic[@"resultStatus"] integerValue] == 9000) {
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"支付成功" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
            [weakSelf jsFromString:[NSString stringWithFormat:@"gerenPaySucess(%@)",@"支付成功"]];
        }];
        
    }
    else if([resultDic[@"resultStatus"] integerValue] == 4000){
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"支付失败" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
            [weakSelf jsFromString:[NSString stringWithFormat:@"gerenPaySucess(%@)",@"支付失败"]];
        }];
    }else if([resultDic[@"resultStatus"] integerValue] == 6001){
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"取消支付" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
            [weakSelf jsFromString:[NSString stringWithFormat:@"gerenPaySucess(%@)",@"取消支付"]];
        }];
    }
    else{
        [[DCAlterTool shareTool] showDoneWithTitle:resultDic[@"memo"] message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
        }];
    }
}


#pragma mark - 获取微信支付结果通知
- (void)wxpayResult:(NSNotification *)notification{
    NSDictionary *resultDic = notification.userInfo;
    NSString *title = nil;
    if ([resultDic[@"errCode"] integerValue] == 0) {
        title = @"支付成功";
    }else if ([resultDic[@"errCode"] integerValue] == -2) {
        title = @"取消支付";
    }else {
        title = @"支付失败";
    }
    
    WEAKSELF;
    [[DCAlterTool shareTool] showDoneWithTitle:title message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
        // 支付成功
        if ([title isEqualToString:@"支付成功"]) {
            NSLog(@"微信支付成功");
            NSDictionary *dict = @{@"type":@"微信支付成功"};//UM统计 自定义搜索关键词事件
            [MobClick event:UMEventCollection_33 attributes:dict];
            [weakSelf jsFromString:[NSString stringWithFormat:@"gerenPaySucess(%@)",title]];
            //返回到订单列表
            PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
            vc.index = 0;
            UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }];
}


- (void)dealloc
{
    [self dc_cleanCacheAndCookie];
    
    //    [self.webView stopLoading];
    //    self.webView = nil;
    
    [self.userContentController removeScriptMessageHandlerForName:@"appGoBack"];
    [self.userContentController removeScriptMessageHandlerForName:@"appGoMain"];
    [self.userContentController removeScriptMessageHandlerForName:@"contactMerchant"];
    [self.userContentController removeScriptMessageHandlerForName:@"uploadImage"];
    [self.userContentController removeScriptMessageHandlerForName:@"toMineOrder"];
    [self.userContentController removeScriptMessageHandlerForName:@"callContacts"];
    [self.userContentController removeScriptMessageHandlerForName:@"toPay"];
    [self.userContentController removeScriptMessageHandlerForName:@"toGoodsDetail"];
    [self.userContentController removeScriptMessageHandlerForName:@"payOrder"];
    [self.userContentController removeScriptMessageHandlerForName:@"payWechatOrder"];
    
    [self.userContentController removeScriptMessageHandlerForName:@"personFirmShare"];
    [self.userContentController removeScriptMessageHandlerForName:@"personOrderKeFu"];
    [self.userContentController removeScriptMessageHandlerForName:@"tosaveImage"];
    [self.userContentController removeScriptMessageHandlerForName:@"appToLogin"];
    [self.userContentController removeScriptMessageHandlerForName:@"goToUserGoodsDetail"];
    [self.userContentController removeScriptMessageHandlerForName:@"goToUserShopDetail"];
    [self.userContentController removeScriptMessageHandlerForName:@"setSeeDoctor"];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_AlipayResulkt_NotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_WxPayResulkt_NotificationName object:nil];
}

@end
