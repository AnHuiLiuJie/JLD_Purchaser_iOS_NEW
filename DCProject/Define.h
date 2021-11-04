//
//  Define.h
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#ifndef Define_h
#define Define_h


/// 获取应用版本号
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
/// 获取应用build号
#define APP_BUILD [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
/// 获取设备的UUID
#define DIV_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
/// 获取应用的名称
#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
/// 获取应用的bundle ID
#define APP_BUNDELID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]


/// 颜色RGB
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

/// 屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
/// 屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width
/// tabbar高度
#define kTabBarHeight (kStatusBarHeight > 20 ? 83 : 49)
/// 导航栏高度
#define kNavBarHeight (kStatusBarHeight > 20 ? 88 : 64)
/// 消息栏高度 Status bar height.
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
// Tabbar safe bottom margin.
#define LJ_TabbarSafeBottomMargin    (CGFloat)(YYISiPhoneX?(34):(0))

/// 设备型号判断判
#define iPhoneX (kScreenH == 812) // X 、XS
#define iPhoneXR (kScreenH == 896) // XR 、XSMax
#define iPhone6p (kScreenH == 736) // 6p 、6sp 、7p、8p
#define iPhone6 (kScreenH == 667) // 6 、6s 、7 、8
#define iPhone5 (kScreenH == 568) // 5、5s
#define iPhone4s (kScreenH == 480)
#define YYISiPhoneX [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f
#define isPhone6below  (([[UIScreen mainScreen] bounds].size.height <=  667.0f)?(YES):(NO))
// 等比例适配系数
#define kScaleFit (YYISiPhoneX ? ((kScreenW < kScreenH) ? kScreenW / 375.0f : kScreenW / 667.0f) : 1.0f)

/**
 *toast提示
 */
#define Toast_Position [NSValue valueWithCGPoint:CGPointMake(kScreenW / 2, self.view.height - LJ_TabbarSafeBottomMargin - 30)]
#define Toast_During 1.5f

/// 弱引用
#define WEAKSELF __weak typeof(self) weakSelf = self;


/// AppDelegate
#define DC_Appdelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
/// sharedApplication
#define DC_Application [UIApplication sharedApplication]
/// 主Window
#define DC_KeyWindow [UIApplication sharedApplication].keyWindow//[[[UIApplication sharedApplication] windows] objectAtIndex:0]
#define DC_KEYWINDOW  [[[UIApplication sharedApplication] windows] objectAtIndex:0]


/// 平方字体
#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"
#define PFRSemibold @"PingFangSC-Semibold"
#define PFRMedium @"PingFangSC-Medium"
#define PFRLight @"PingFangSC-Light"

#define PFRFont(_size) [UIFont fontWithName:PFR size:(_size)];
// 导航栏标题字体
#define DCWNavigationTitleFont [UIFont fontWithName:PFRMedium size:18];

/// 输出中文
#define DC_Printf(responseObject,string) NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(responseObject) options:NSJSONWritingPrettyPrinted error:nil];\
NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];\
NSLog(@"(string) - %@",jsonStr);


// 打开网页
#define DC_CanOpenUrl(_url) [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_url]]
#define DC_OpenUrl(_url) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]]


/// 打印log
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


/// 系统版本号
#define VER_IPHONE_9_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define VER_IPHONE_10_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0
#define VER_IPHONE_11_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0
#define VER_IPHONE_12_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0
#define VER_IPHONE_13_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0


// 0 测试  1 线上
#define versionFlag 0

#if versionFlag == 1
//采购版根地址
#define DC_RequestUrl @"https://apis.123ypw.com"
#define DC_ImageUrl @""
#define DC_H5BaseUrl @"https://apis.123ypw.com/jld202007/web"
//个人版根地址
#define Person_RequestUrl @"https://apism.123ypw.com"
#define Person_ImageUrl @""
#define Person_H5BaseUrl @"https://apis.123ypw.com/jld202007/web"
// 环信  appkey
#define DCEMAppKey @"1118190826010529#jinlida"
#else
//采购版根地址
#define DC_RequestUrl @"http://qu1nf6vkbf.52http.tech"
//#define DC_RequestUrl @"http://wzgk4us5du.52http.net"
#define DC_ImageUrl @""
#define DC_H5BaseUrl @"http://192.168.0.15:8089/jld202007/web"//@"http://www.fangfujie.cn/jld_202007/web"
//个人版根地址
#define Person_RequestUrl @"http://qu1nf6vkbf.52http.tech/b2c"
//#define Person_RequestUrl @"http://192.168.0.205:8086/b2c"//峰哥
//#define Person_RequestUrl @"http://zlbmda1.nat.ipyingshe.com/b2c"//新余
#define Person_ImageUrl @""
#define Person_H5BaseUrl @"http://192.168.0.15:8089/jld202007/web"//
//#define Person_H5BaseUrl @"http://zlbmda1.nat.ipyingshe.com/jld202007/web"//新余

// 环信  appkey
#define DCEMAppKey @"1118190826010529#jinlida-test"
#endif


// APP Store下载地址 重要/要确定是正确的
#define DCShareDownloadUrl @"https://itunes.apple.com/app/id1482534636?mt=8"


// 接口加密的key值
#define DC_Encrypt_Key @"A5F114BA5F0F0CDB91498A8D0D9BD1F4"
#define DC_IV_Key @"jld_aes_code_inf"

#pragma mark - 第三方SDK、Key值
// 高德地图
#define DCAmap_AppKey @""

// 激光推送
#define DCJPush_AppKey @"e73b630a3e62434884f7555e"
#define DCJPush_Secret @"f1e07d3581780a908ee910aa"

// 腾讯Bugly
#define DCBugly_AppiD @"c6423f5dc0"

// 友盟
#define DCUM_AppKey @"5d9d4fbb570df339fa00022d"
/**
* 友盟自定义事件集
*/
#define UMEventCollection_1 @"search_Keyword_iOS" //搜索关键字事件
#define UMEventCollection_2 @"share_app_iOS" //分享app或商品

#define UMEventCollection_31 @"glp_orderwill_iOS" // type 1准备下单创建订单
#define UMEventCollection_32 @"glp_ordering_iOS" // type 2已下单待付款
#define UMEventCollection_33 @"glp_orderend_iOS" // type 3付款成功

#define UMEventCollection_4 @"glp_register_app_iOS" //注册事件
#define UMEventCollection_5 @"glp_login_app_iOS" //登录事件

// 微信
#define DCWX_AppKey @"wxeff4453988d29e10"
#define WX_APP_UniversalLink @"https://www.123ypw.com/app/navtive/Purchase/"//Universal Links(包括完整路径)+随机字符串(例如: abc)
#define DCWX_AppSecret @"37ba373d50d39ed037b53b83734a66df"//@"ffaf030aea9dff84236e4d399ebc9c5b"

// 支付宝
#define DCAlipay_AppScheme @"com.jld.Purchase"

// 腾讯
#define DCQQ_AppKey @"101795831"
#define DCQQ_APP_UniversalLink @"https://www.123ypw.com/qq_conn/101795831"
#define DCQQ_AppSecret @"2d07eb31324e3b647b1076319eb03dc4"

// 新浪微博
#define DCSina_AppKey @""
#define DCSina_AppSecret @""

// 加解密字符串key值
#define DCEncryptKey @"DCEncryptKey"


// 环信  推送证书名
#ifdef DEBUG
#define DCEMApnsCertName @"PurchasePUSH_DEV"
#else
#define DCEMApnsCertName @"PurchasePUSH_PRO"
#endif


#endif /* Define_h */
