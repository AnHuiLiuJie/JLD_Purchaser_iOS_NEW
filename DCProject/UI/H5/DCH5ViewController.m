//
//  DCH5ViewController.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCH5ViewController.h"
#import <WebKit/WebKit.h>
#import "TZImagePickerController.h"
#import "GLBRepayListController.h"
#import "GLBStorePageController.h"
#import "GLBGoodsDetailController.h"
#import "GLBAddInfoController.h"
#import "GLBOrderPageController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CSDemoAccountManager.h"//lj_will_change
#import "DCPayTool.h"

@interface DCH5ViewController ()
<
TZImagePickerControllerDelegate,
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler>


@property (nonatomic, assign) BOOL isReload;

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic,strong) WKUserContentController *userContentController;

@end

@implementation DCH5ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.path containsString:@"https://mapi.alipay.com/gateway.do"])
    {
        [self dc_navBarHidden:NO];
        [self dc_popBackDisabled:NO];
    }
    else{
        [self dc_navBarHidden:YES];
        [self dc_popBackDisabled:YES];
    }
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
    [self dc_popBackDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.wkWebView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSLog(@"h5加载地址 - %@",_path);
    NSString *url = [NSString dc_encodingByUTF8WithUrl:_path];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5]];
    
//    NSString *string = @"https://mapi.alipay.com/gateway.do?_input_charset=utf-8&sign=a7eed790c6340437c79ff294ecd448aa&_input_charset=utf-8&extra_common_param=1909051851154002&total_fee=0.01&subject=金利达药品交易网药品采购&sign_type=MD5&service=alipay.wap.create.direct.pay.by.user&notify_url=http://flj19850821.imwork.net/alipay_notice.do&partner=2088601292925442&seller_email=tianfang@123ypw.com&anti_phishing_key=KPwlgP9khVnTZ4crEg==&out_trade_no=20190926160234376000&payment_type=1&return_url=http://flj19850821.imwork.net/alipay_notice.do";
//    string = [NSString dc_encodingByUTF8WithUrl:string];
//
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5]];
    
    
    // 注册通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResult:) name:DC_AlipayResulkt_NotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayResult:) name:DC_WxPayResulkt_NotificationName object:nil];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"===didStartProvisionalNavigation");
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
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"====decidePolicyForNavigationAction");
    NSLog(@"%@",navigationAction.request.URL.absoluteString);

    // 支付宝支付
    if ([navigationAction.request.URL.absoluteString containsString:@"alipay.com"]) {
        
        //            self.payCount ++;
        
        WEAKSELF;
        BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:navigationAction.request.URL.absoluteString fromScheme:DCAlipay_AppScheme callback:^(NSDictionary *result) {
            // 处理支付结果
            NSLog(@"处理支付结果%@", result);
            // isProcessUrlPay 代表 支付宝已经处理该URL
            //              if ([result[@"isProcessUrlPay"] boolValue]) {
            //                  // returnUrl 代表 第三方App需要跳转的成功页URL
            //                  NSString *urlStr = result[@"returnUrl"];
            //               [[DCPayTool shareTool] dc_alipay:urlStr];
            //              }
            //              else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if ([result[@"resultCode"] integerValue] == 9000) {
                    
                    [[DCAlterTool shareTool] showDoneWithTitle:@"支付成功" message:@"点击确认查看订单" defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
                        //返回到订单列表
                        GLBOrderPageController *vc = [GLBOrderPageController new];
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
            
            
            ////              }
        }];
        if (isIntercepted) {
           //return NO;
        }
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
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
    completionHandler();
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"1111：name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    NSLog(@"222:%@",message.frameInfo.request.allHTTPHeaderFields);
    if ([message.name isEqualToString:@"appGetUserToken"]) {
//        [self ToLoginMethod];
    }else if ([message.name isEqualToString:@"appGetUserId"]) {
//        [self AlipayMethod:message.body];
    }else if ([message.name isEqualToString:@"appVersionName"]) {
//        if ([message.body isKindOfClass:[NSDictionary class]]) {
//            [self WechatMethod:[DHAppConfig dictionaryTransformationJsonStringByDictionary:message.body]];
//        }else{
//            [self WechatMethod:message.body];
//        }
    }else if ([message.name isEqualToString:@"appGoBack"]) {
        [self appGoBack];
    }else if ([message.name isEqualToString:@"appGoMain"]) {
        [self appGoMain];
    }else if ([message.name isEqualToString:@"contactMerchant"]) {
        NSDictionary *dict = [DCHelpTool stringTransformationDictionaryByJsonString:[message.body mj_JSONString]];
        [self contactMerchant:dict];
    }else if ([message.name isEqualToString:@"uploadImage"]) {
        [self uploadImage];
    }else if ([message.name isEqualToString:@"toUseCoupon"]) {
        [self toUseCoupon:[message.body mj_JSONString]];
    }else if ([message.name isEqualToString:@"toMinePayment"]) {
        [self toMinePayment];
    }else if ([message.name isEqualToString:@"toCertification"]) {
        [self toCertification];
    }else if ([message.name isEqualToString:@"toMineOrder"]) {
        [self toMineOrder];
    }else if ([message.name isEqualToString:@"callContacts"]) {
        [self callContacts:[message.body mj_JSONString]];
    }else if ([message.name isEqualToString:@"payOrder"]) {
        [self payOrder:[message.body mj_JSONString]];
    }else if ([message.name isEqualToString:@"payWechatOrder"]) {
        NSLog(@"===%@",[message.body class]);
        NSDictionary *dict = [DCHelpTool stringTransformationDictionaryByJsonString:[message.body mj_JSONString]];
        [self payWechatOrder:dict];
    }else if ([message.name isEqualToString:@"appToLogin"]) {
        [self appToLogin];
    }
}


#pragma mark - 传递token
- (NSString *)appGetUserToken
{
    NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
    if (!token) {
        token = @"";
    }
    return token;
}

#pragma mark - 传递userId
- (NSString *)appGetUserId
{
    NSString *userId = [DCObjectManager dc_readUserDataForKey:DC_UserID_Key];
    if (!userId) {
        userId = @"";
    }
    return userId;
}


#pragma mark - 传递版本号
- (NSString *)appVersionName
{
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
                
                [self.navigationController popViewControllerAnimated:YES];
                
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
#pragma mark -  资质认证
- (void)toCertification
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        GLBAddInfoController *vc = [GLBAddInfoController new];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

#pragma mark - 联系卖家
- (void)contactMerchant:(NSDictionary *)dict
{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        if (!dict || [dict count] == 0) {
//            return ;
//        }
//        
////        NSDictionary *dict = [string mj_JSONObject];
//        NSString *headimg = @"";
//        NSString *userID = @"";
//        NSString *title = @"客服";
//        NSString *firmName = @"";
//        if (dict) {
//            title = dict[@"name"];
//            userID = [NSString stringWithFormat:@"b2b_%@",dict[@"id"]];
//            headimg = [NSString stringWithFormat:@"%@",dict[@"logo"]];
//            firmName = [NSString stringWithFormat:@"%@",dict[@"firmName"]];
//            
//            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
//            [userDic setValue:userID forKey:@"userId"];
//            [userDic setValue:title forKey:@"nickname"];
//            [userDic setValue:headimg forKey:@"headImg"];
//            
//            //lj_will_change_end
//            WEAKSELF;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
//                if ([lgM loginKefuSDK]) {
//                    NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
//                    NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
//                    NSString *chatTitle = title;
//                    HDQueueIdentityInfo *queueIdentityInfo = nil;
//                    HDAgentIdentityInfo *agentIdentityInfo = nil;
//                    queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
//                    agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
//                    chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
//                    hd_dispatch_main_async_safe(^(){
//                        [weakSelf hideHud];
//                        HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
//                        queue ? (chat.queueInfo = queueIdentityInfo) : nil;
//                        agent ? (chat.agent = agentIdentityInfo) : nil;
//                        chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
//                        chat.title = title;
//                        chat.sellerFirmName = dict[@"name"];
//                        [self.navigationController pushViewController:chat animated:YES];
//                    });
//                   
//                } else {
//                    hd_dispatch_main_async_safe(^(){
//                        [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
//                    });
//                    NSLog(@"登录失败");
//                }
//            });//完整
//        }
//       
//    });
    
}


#pragma mark - 上传图片
- (void)uploadImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dc_openImagePickerController];
    });
}


#pragma mark - 去使用优惠券
- (void)toUseCoupon:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        {"type":"1","suppierFirmId":"110000000013509","batchId":"","goodsId":""}
        NSDictionary *dict = [string mj_JSONObject];
        if (dict && dict[@"type"]) {
            if ([dict[@"type"] isEqualToString:@"1"]) { // 店铺
                
                if (dict[@"suppierFirmId"]) {
                    GLBStorePageController *vc = [GLBStorePageController new];
                    vc.firmId = dict[@"suppierFirmId"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } else if ([dict[@"type"] isEqualToString:@"2"]) { // 商品
                
                if (dict[@"goodsId"]) {
                    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
                    vc.batchId = dict[@"batchId"];
                    vc.goodsId = dict[@"goodsId"];
                    vc.detailType = GLBGoodsDetailTypePromotione;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    });
}


#pragma mark - 去我的账期还款
- (void)toMinePayment
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GLBRepayListController *vc = [GLBRepayListController new];
        [self.navigationController pushViewController:vc animated:YES];
    });
}


#pragma mark - 跳转到我的订单
- (void)toMineOrder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GLBOrderPageController *vc = [GLBOrderPageController new];
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


#pragma mark - 订单支付
- (void)payOrder:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DCH5ViewController *vc = [DCH5ViewController new];
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
- (void)dc_openImagePickerController
{
    WEAKSELF;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#00B7AB"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if ([photos count] > 0) {
            [weakSelf requestUploadImage:photos];
        }
        
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - 上传图片
- (void)requestUploadImage:(NSArray *)images
{
    [SVProgressHUD show];
    WEAKSELF;
    [[DCHttpClient shareClient] requestUploadWithPath:@"/common/upload" images:images params:nil progress:^(NSProgress *_Nonnull uploadProgress) {
        
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
                    
                    [weakSelf jsFromString:[NSString stringWithFormat:@"getUploadSuccess('%@')",imageUrl]];
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


#pragma mark - 监听到支付宝支付通知
- (void)alipayResult:(NSNotification *)notification
{
    WEAKSELF;
    NSDictionary *resultDic = notification.userInfo;
   if ([resultDic[@"resultStatus"] integerValue] == 9000) {
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"支付成功" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
           [weakSelf jsFromString:[NSString stringWithFormat:@"getPaySuccess(%@)",@"支付成功"]];
        }];
        
    }
    else if([resultDic[@"resultStatus"] integerValue] == 4000){
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"支付失败" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
                  
                  [weakSelf jsFromString:[NSString stringWithFormat:@"getPaySuccess(%@)",@"支付失败"]];
               }];
    }else if([resultDic[@"resultStatus"] integerValue] == 6001){
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"取消支付" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
                 
                  [weakSelf jsFromString:[NSString stringWithFormat:@"getPaySuccess(%@)",@"取消支付"]];
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
            [weakSelf jsFromString:[NSString stringWithFormat:@"getPaySuccess()"]];
            //返回到订单列表
                                 GLBOrderPageController *vc = [GLBOrderPageController new];
                                 vc.index = 0;
                                 UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
                                 [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }];
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
        [self.userContentController addScriptMessageHandler:self name:@"toUseCoupon"];
        [self.userContentController addScriptMessageHandler:self name:@"toMinePayment"];
        [self.userContentController addScriptMessageHandler:self name:@"toCertification"];
        [self.userContentController addScriptMessageHandler:self name:@"toMineOrder"];
        [self.userContentController addScriptMessageHandler:self name:@"callContacts"];
        [self.userContentController addScriptMessageHandler:self name:@"payOrder"];
        [self.userContentController addScriptMessageHandler:self name:@"payWechatOrder"];
        [self.userContentController addScriptMessageHandler:self name:@"appToLogin"];
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


- (void)dealloc
{
    [self dc_cleanCacheAndCookie];
    
    //这里需要注意，前面增加过的方法一定要remove掉。
    [self.userContentController removeScriptMessageHandlerForName:@"appGoBack"];
    [self.userContentController removeScriptMessageHandlerForName:@"appGoMain"];
    [self.userContentController removeScriptMessageHandlerForName:@"contactMerchant"];
    [self.userContentController removeScriptMessageHandlerForName:@"uploadImage"];
    [self.userContentController removeScriptMessageHandlerForName:@"toUseCoupon"];
    [self.userContentController removeScriptMessageHandlerForName:@"toMinePayment"];
    [self.userContentController removeScriptMessageHandlerForName:@"toCertification"];
    [self.userContentController removeScriptMessageHandlerForName:@"toMineOrder"];
    [self.userContentController removeScriptMessageHandlerForName:@"callContacts"];
    [self.userContentController removeScriptMessageHandlerForName:@"payOrder"];
    [self.userContentController removeScriptMessageHandlerForName:@"appToLogin"];
    [self.userContentController removeScriptMessageHandlerForName:@"payWechatOrder"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_AlipayResulkt_NotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_WxPayResulkt_NotificationName object:nil];
}


@end
