//
//  GLPOrderAdvisoryPageVC.m
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import "GLPOrderAdvisoryPageVC.h"
#import "GLPOrderAdvisoryListVC.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLPOrderAdvisoryPageVC ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;

@end

static CGFloat const topView_H = 36;

@implementation GLPOrderAdvisoryPageVC

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
        self.titleColorSelected = [UIColor dc_colorWithHexString:@"#FF9900"];
        self.titleColorNormal = [UIColor dc_colorWithHexString:@"#333333"];
        self.progressColor = [UIColor dc_colorWithHexString:@"#FF9900"];
        self.menuView.showTopLine = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectIndex = self.index;
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
    GLPOrderAdvisoryListVC *vc = [GLPOrderAdvisoryListVC new];
    vc.viewFrame = CGRectMake(self.viewFrame.origin.x, self.viewFrame.origin.y, self.viewFrame.size.width, self.viewFrame.size.height-topView_H);
    vc.sellerFirmName = self.sellerFirmName;
    vc.customerType = [self.types[index] integerValue];
    
    WEAKSELF;
    vc.GLPOrderAdvisoryListVCBlock = ^(NSDictionary *_Nonnull commodityInfo) {
        !weakSelf.GLPOrderAdvisoryPageVCBlock ? : weakSelf.GLPOrderAdvisoryPageVCBlock(commodityInfo);
    };
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
        _names = @[@"我的订单",@"我的浏览",@"我的收藏",@"购物车"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(OrderAdvisoryListTypeOrder),
                   @(OrderAdvisoryListType1),
                   @(OrderAdvisoryListType2),
                   @(OrderAdvisoryListType3)];
    }
    return _types;
}

//- (void)setViewFrame:(CGRect)viewFrame{
//    _viewFrame = viewFrame;
//    self.view.frame = viewFrame;
//}

@end
