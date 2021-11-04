//
//  GLPEtpCustomerSourcePageVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "GLPEtpCustomerSourcePageVC.h"
#import "GLPEtpCustomerSourceListVC.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLPEtpCustomerSourcePageVC ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;

@end

static CGFloat const topView_H = 32;


@implementation GLPEtpCustomerSourcePageVC

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.pageAnimatable = YES;
//        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / self.names.count;
        self.progressWidth = 30;
        self.menuView.scrollView.backgroundColor = [UIColor whiteColor];
        self.titleColorSelected = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        self.titleColorNormal = [UIColor dc_colorWithHexString:@"#333333"];
        self.progressColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        self.menuView.showTopLine = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectIndex = self.index;
    
    self.navigationItem.title = @"我的客源";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_rightItemWithImage:[UIImage imageNamed:@"dc_ss_hei"] target:self action:@selector(searchItemClick:)];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, topView_H)];
    self.image.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.image belowSubview:self.menuView];
    self.navigationItem.leftBarButtonItem= nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dc_fanhui_hei"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick1)];
}

- (void)backClick1
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.names.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    GLPEtpCustomerSourceListVC *vc = [GLPEtpCustomerSourceListVC new];
    vc.customerType = [self.types[index] integerValue];
    return vc;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, kNavBarHeight + topView_H, kScreenW, kScreenH - kNavBarHeight - topView_H);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavBarHeight, kScreenW, topView_H);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
}
#pragma mark - action
- (void)searchItemClick:(id)sender
{
    
}
#pragma mark - lazy load
- (NSArray *)names{
    if (!_names) {
        _names = @[@"我的客源",@"二级客源",@"三级客源"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(EtpCustomerSourceAll),
                   @(EtpCustomerSourceOne),
                   @(EtpCustomerSourceTwo)];
    }
    return _types;
}

//EtpCustomerSourceAll = 0,       // 我的客源
//EtpCustomerSourceOne,           // 二级客源
//EtpCustomerSourceTwo,          // 三级客源

@end
