//
//  TRStorePageVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRCouponCentrePageVC.h"
#import "TRCouponCentreStoreVC.h"
#import "TRCouponCentreGoodsVC.h"
#import "TRCouponCentrePlatformVC.h"
#import "CouponsListVC.h"
#import "WMScrollView+DCPopGesture.h"

static CGFloat const kWMMenuViewHeight = 40;
@interface TRCouponCentrePageVC ()
@property (nonatomic, strong) NSArray *names;

@end

@implementation TRCouponCentrePageVC
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 18;
        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 3;
        self.progressWidth = kScreenW / 3;
        self.menuView.backgroundColor = [UIColor whiteColor];
        self.titleColorSelected = RGB_COLOR(0, 188, 177);
        self.titleColorNormal = RGB_COLOR(51, 51, 51);
        self.progressColor = RGB_COLOR(0, 188, 177);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"领券中心";
    self.menuView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我的卡券" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
}

- (void)rightClick
{
    CouponsListVC *vc = [[CouponsListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.names.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
   
    if (index == 0) {
        TRCouponCentreStoreVC *vc = [[TRCouponCentreStoreVC alloc] init];
        return vc;
        
    } else if (index == 1) {
        
        TRCouponCentreGoodsVC *vc = [TRCouponCentreGoodsVC new];
        return vc;
        
    } else if (index == 2) {
        
        TRCouponCentrePlatformVC *vc = [TRCouponCentrePlatformVC new];
        return vc;
        
    }
    return [UIViewController new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavBarHeight, kScreenW, kWMMenuViewHeight);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    
    
}
- (NSArray *)names{
    if (!_names) {
        _names = @[@"店铺券",@"商品券",@"平台券"];
    }
    return _names;
}
@end
