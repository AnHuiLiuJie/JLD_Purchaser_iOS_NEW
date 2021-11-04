//
//  AppDelegate.m
//  DCProject
//
//  Created by bigbing on 2019/3/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+SDK.h"
//#import "NetWorkManagerView.h"
#import "DCTabbarController.h"
#import "GLBGuideController.h"
#import "DCNavigationController.h"
#import "GLBOpenAdvController.h"
#import "GLPTabBarController.h"

#import "DCMD5Tool.h"
#import<CoreTelephony/CTCellularData.h>
/*Add_HX_标识
 *引入文件
 */
#import "AppDelegate+HelpDesk.h"
@interface AppDelegate ()

@property (nonatomic, copy) NSString *mallConfigModel;
//@property (nonatomic, strong) NetWorkManagerView *netWorkview;//网络检测view
@property (nonatomic, strong) GLBOpenAdvController *mianVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    //1.获取网络权限 根绝权限进行人机交互
    if (__IPHONE_10_0) {
        //__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 当前开发环境版本在iOS10.0及以上则编译此部分代码
        [self networkStatus:application didFinishLaunchingWithOptions:launchOptions];
    }else {
        //2.2已经开启网络权限 监听网络状态
        [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
    }//ChargerLAB POWER-Z MF001读
    
    if (TARGET_IPHONE_SIMULATOR) {//模拟器
        [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    // 初始化第三方SDK
    [self initSDKWithOptions:launchOptions];
    
    //启动页停留1秒钟。
    //[NSThread sleepForTimeInterval:1.0];

    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    //创建主视图
    [self createWindowRootWithType:1];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - 全局设置
- (void)initAappearance{
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    // 设置tableviewcell线条颜色
    [UITableView appearance].separatorColor = [UIColor dc_colorWithHexString:@"cccccc"];
    // 设置TabBar样式
    [[UITabBar appearance] setTranslucent:NO];
    
    // 滑动设置
    [UITableView appearance].showsVerticalScrollIndicator = NO;
    [UITableView appearance].showsHorizontalScrollIndicator = NO;
    [UICollectionView appearance].showsVerticalScrollIndicator = NO;
    [UICollectionView appearance].showsHorizontalScrollIndicator = NO;
    [UIScrollView appearance].showsVerticalScrollIndicator = NO;
    [UIScrollView appearance].showsHorizontalScrollIndicator = NO;
}

#pragma mark - 初始化参数设置
- (void)dc_initUserDefault
{
    // 可变 ip
    //    NSString *ipStr = [DCObjectManager dc_readUserDataForKey:DC_IP_Key];
    //    if (!ipStr) {
    //        [DCObjectManager dc_saveUserData:DC_RequestUrl forKey:DC_IP_Key];
    //    }
    
    //    // 可变 h5
    //    NSString *h5Str = [DCObjectManager dc_readUserDataForKey:DC_H5_Key];
    //    if (!h5Str) {
    //        [DCObjectManager dc_saveUserData:DC_H5BaseUrl forKey:DC_H5_Key];
    //    }
    
    // 可变 ip - 个人
    //    NSString *personIpStr = [DCObjectManager dc_readUserDataForKey:DC_PersonIP_Key];
    //    if (!personIpStr) {
    //        [DCObjectManager dc_saveUserData:Person_RequestUrl forKey:DC_PersonIP_Key];
    //    }
    
    //    // 可变 h5 - 个人
    //    NSString *personH5Str = [DCObjectManager dc_readUserDataForKey:DC_PersonH5_Key];
    //    if (!personH5Str) {
    //        [DCObjectManager dc_saveUserData:Person_H5BaseUrl forKey:DC_PersonH5_Key];
    //    }
    
    // 用户类型，默认是企业用户
    NSString *userType = [DCObjectManager dc_readUserDataForKey:DC_UserType_Key];
    if (!userType) {
        [DCObjectManager dc_saveUserData:@(DCUserTypeWithCompany) forKey:DC_UserType_Key];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [self setApplicationIconBadgeNumber];
    //    NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
    //    if (token) {
    [[DCUpdateTool shareClient] requestIsUpdate];
    //    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - 当APP接收到内存警告的时候
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager] cancelAll]; //取消所有下载
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];//立即清除缓存
}

#pragma mark - 指定推送角标数为0
- (void)setApplicationIconBadgeNumber
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}



#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DCProject"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     *The parent directory does not exist, cannot be created, or disallows writing.
                     *The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     *The device is out of space.
                     *The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    if (@available(iOS 10.0, *)) {
        NSManagedObjectContext *context = self.persistentContainer.viewContext;
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    } else {
        // Fallback on earlier versions
    }
}

/*
 CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
 在开发app首次安装提示框的问题是，有一个问题没有注意
 cellularDataRestrictionDidUpdateNotifier的线程是一个默认的全局队列，并不是主线程，我们的弹框是present出来的，导致了app的crash
 */
- (void)networkStatus:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    
    /*
     此函数会在网络权限改变时再次调用
     CTCellularData只能检测蜂窝权限，不能检测WiFi权限。
     一个CTCellularData实例新建时，restrictedState是kCTCellularDataRestrictedStateUnknown，之后在cellularDataRestrictionDidUpdateNotifier里会有一次回调，此时才能获取到正确的权限状态。
     当用户在设置里更改了app的权限时，cellularDataRestrictionDidUpdateNotifier会收到回调，如果要停止监听，必须将cellularDataRestrictionDidUpdateNotifier设置为nil。
     赋值给cellularDataRestrictionDidUpdateNotifier的block并不会自动释放，即便你给一个局部变量的CTCellularData实例设置监听，当权限更改时，还是会收到回调，所以记得将block置nil。
     */
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
            {
                NSLog(@"Restricted");
                //2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self createWindowRootWithType:2];
                });
                break;
            }
            case kCTCellularDataNotRestricted:
                
                NSLog(@"NotRestricted");
                //2.2已经开启网络权限 监听网络状态
                [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
                //                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            case kCTCellularDataRestrictedStateUnknown:
            {
                NSLog(@"Unknown");
                //2.3未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self createWindowRootWithType:2];
                });
                break;
            }
                
            default:
                break;
        }
    };
}

/**
 实时检查当前网络状态
 */
- (void)addReachabilityManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    //这个可以放在需要侦听的页面
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        [self.netWorkview removeFromSuperview];
//        self.netWorkview = nil;
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                if (self.mallConfigModel == nil) {
                    [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                if (self.mallConfigModel == nil) {
                    [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                }
                break;
            }
            default:
                break;
        }
    }];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}

- (void)getInfo_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.mallConfigModel = @"YES";
    // 初始化默认参数设置
    [self dc_initUserDefault];
    
    //创建UI
    [self createWindowRootWithType:3];
    
    //获取占位图
    [[DCPlaceholderTool shareTool] dc_updatePlaceholderImage];
    
    //添加通知
    [self addNotification];
    
    /*Add_HX_标识
     *初始化环信客服SDK，详细内容在AppDelegate+EaseMob.m 文件中
     */
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    NSString *time = [DCObjectManager dc_readUserDataForKey:@"rtime"];
    if (time.length >1) {
        NSString *cureetnt = [DCSpeedy getCurrentTimes];
        NSTimeInterval timer1 = [time doubleValue];
        NSTimeInterval timer2 = [cureetnt doubleValue];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timer1];
        //NSString *dateString1 = [formatter stringFromDate:date];
        
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timer2];
        //NSString *dateString2 = [formatter stringFromDate:date2];
        
        // 日历对象（方便比较两个日期之间的差距）
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit =NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:date2 options:0];
        if (cmps.day>=3) {
            [DCObjectManager dc_removeUserDataForkey:@"goodsId"];
            [DCObjectManager dc_removeUserDataForkey:@"stm"];
            [DCObjectManager dc_removeUserDataForkey:@"utmUserId"];
            [DCObjectManager dc_removeUserDataForkey:@"rtime"];
        }
    }
}

//添加通知
- (void)addNotification
{
    
}

- (void)createWindowRootWithType:(NSInteger)type{
    if (type == 1) {
        // 去掉通知的小图标
        [self setApplicationIconBadgeNumber];
        // 配置全局属性
        [self initAappearance];
        
        
//        if (@available(iOS 15.0, *)) {
//            self.window.rootViewController = [[DCNavigationController alloc] initWithRootViewController:self.mianVC];
//            self.mianVC.isLoadData = YES;
//        }else{
            self.window.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[UIViewController new]];
//        }

    }else if(type == 2){
        self.window.rootViewController = self.mianVC;
        self.mianVC.isLoadData = YES;
        //[self.window makeToast:@"请开启网络权限，才能访问内容"];
//        UIViewController* viewController = [self currentViewController];
//        self.netWorkview.frame = [[[UIApplication sharedApplication] windows] objectAtIndex:0].bounds;
//        [viewController.view addSubview:self.netWorkview];
    }else if(type == 3){
        self.window.rootViewController = self.mianVC;
        self.mianVC.isLoadData = YES;
    }else{
        self.window.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[UIViewController new]];
    }
}

- (GLBOpenAdvController *)mianVC{
    if (!_mianVC) {
        _mianVC = [[GLBOpenAdvController alloc] init];
    }
    return _mianVC;
}

//- (NetWorkManagerView *)netWorkview{
//    if (!_netWorkview) {
//        _netWorkview = [[NetWorkManagerView alloc] init];
//        _netWorkview.isFristLoad = 2;
//    }
//    return _netWorkview;
//}


#pragma mark - 获取当前最外层VC
- (UIViewController*)currentViewController{
    UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return[self findBestViewController:viewController];
}

//递归方法
- (UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    }else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    }else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    }else{
        return vc;
    }
}


@end
