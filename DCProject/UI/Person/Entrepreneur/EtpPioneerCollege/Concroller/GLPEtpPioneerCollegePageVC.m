//
//  GLPEtpPioneerCollegePageVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "GLPEtpPioneerCollegePageVC.h"
#import "NewsInformationModel.h"
#import "GLPEtpPioneerCollegeListVC.h"
#import "DCAPIManager+PioneerRequest.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLPEtpPioneerCollegePageVC ()

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, assign) CGFloat listView_h;
@property(nonatomic,strong) NSMutableArray *tabArray;

@end

static CGFloat const topView_H = 32;

@implementation GLPEtpPioneerCollegePageVC

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)updataViewUI
{
    self.titleFontName = PFR;
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.pageAnimatable = YES;
//        self.automaticallyCalculatesItemWidths = YES;
    NSInteger num = 5;
    self.tabArray.count > num ? num :(num = self.tabArray.count);
    self.menuItemWidth = kScreenW / num;
    self.progressWidth = 30;
    self.menuView.scrollView.backgroundColor = [UIColor whiteColor];
    self.titleColorSelected = [UIColor dc_colorWithHexString:DC_AppThemeColor];
    self.titleColorNormal = [UIColor dc_colorWithHexString:@"#333333"];
    self.progressColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
    self.menuView.showTopLine = NO;
}

#pragma mark - 请求 Tab页
- (void)requestLoadData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_news_tabWithSsuccess:^(id response) {
        NSArray *arr = response[@"data"];
        NSArray *arr1 = [NewsInformationModel mj_objectArrayWithKeyValuesArray:arr];
        [weakSelf.tabArray addObjectsFromArray:arr1];
        [self updataViewUI];
        [self reloadData];
    } failture:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectIndex = self.index;
    self.navigationItem.title = @"创业学院";
    self.view.backgroundColor = [UIColor whiteColor];
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, topView_H)];
    self.image.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.image belowSubview:self.menuView];
    self.navigationItem.leftBarButtonItem= nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dc_fanhui_hei"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick1)];
    
    [self requestLoadData];
}

- (void)backClick1
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.tabArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    GLPEtpPioneerCollegeListVC *vc = [GLPEtpPioneerCollegeListVC new];
    NewsInformationModel *model = self.tabArray[index];
    vc.catIdStr = model.tabId;
    vc.view_H = _listView_h;
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NewsInformationModel *model = self.tabArray[index];

    return model.tabName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    _listView_h = kScreenH - kNavBarHeight - topView_H-LJ_TabbarSafeBottomMargin;
    return CGRectMake(0, kNavBarHeight + topView_H, kScreenW, _listView_h);
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
- (NSMutableArray *)tabArray{
    if (!_tabArray) {
        _tabArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tabArray;;
}
/**
 资讯
 热榜
 推荐
 健康
 医疗
 */


@end
