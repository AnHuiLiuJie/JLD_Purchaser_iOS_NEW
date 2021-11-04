//
//  GLPSpikeListPageVC.m
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "GLPSpikeListPageVC.h"
#import "GLPSpikeHomeListVC.h"
#import "GLPSpikeHomeTopToolView.h"
#import "EtpRuleDescriptionView.h"
@interface GLPSpikeListPageVC ()

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, assign) CGFloat listView_h;
@property(nonatomic,strong) NSMutableArray *tabArray;
@property (nonatomic, strong) GLPSpikeHomeTopToolView *topToolView;

@end

static CGFloat const topView_H = 0;

@implementation GLPSpikeListPageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleLightContent];
    [self dc_navBarHidden:YES animated:animated];
    [self setUpNavTopView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dc_navBarHidden:NO animated:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 设置消息栏样式
- (void)dc_statusBarStyle:(UIStatusBarStyle)style
{
    [UIApplication sharedApplication].statusBarStyle = style;
}

- (void)dc_navBarHidden:(BOOL)isHidden animated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:isHidden animated:animated];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    self.topToolView.hidden = NO;
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#8736E2"];
}


#pragma mark - Intial

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
    NSInteger num = 2;
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
//    WEAKSELF;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectIndex = self.index;
    self.navigationItem.title = @"秒杀";
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
    GLPSpikeHomeListVC *vc = [GLPSpikeHomeListVC new];
    vc.goodsType = index == 0 ? 1 : 2;
    WEAKSELF;
    vc.GLPSpikeHomeListVC_switchBlock = ^(int goodsType) {
        weakSelf.selectIndex = weakSelf.index = (goodsType-1);
        [weakSelf reloadData];
    };
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSString *title = self.tabArray[index];
    return title;
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
- (void)searchItemClick:(id)sender{
    
}

#pragma mark - lazy load
- (NSMutableArray *)tabArray{
    if (!_tabArray) {
        _tabArray = [NSMutableArray arrayWithArray:@[@"本期秒杀",@"下期预告"]];
    }
    return _tabArray;;
}

- (GLPSpikeHomeTopToolView *)topToolView{
    if (!_topToolView) {
        _topToolView = [[GLPSpikeHomeTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _topToolView.leftItemClickBlock = ^{ //点击了左侧
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        _topToolView.rightItemClickBlock = ^{
            NSLog(@"分享");
            UIImage *image = [weakSelf makeImageWithView:weakSelf.view withSize:CGSizeMake(kScreenW, kScreenW*4/5)];
            NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
            NSString *string = [NSString stringWithFormat:@"/geren/app_code.html?userId=%@",userId];            [[DCUMShareTool shareClient] shareInfoWithTitle:@"药批发、药采购，就上金利达！" content:@"金利达-秒杀" url:string image:image pathUrl:@"/pages/drug/seckill"];
            
//            [[DCUMShareTool shareClient]shareInfoWithImage:@"" WithTitle:@"" orderNo:@"" joinId:@"" goodsId:@"" content:@"金利达" url:[NSString stringWithFormat:@""] completion:^(id result, NSError *error) {
//            }];
        };
        
        [self.view addSubview:_topToolView];
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#8736E2"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#8736E2"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0.5,0.0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
        gradientLayer2.endPoint = CGPointMake(0.5,1.0);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = CGRectMake(0, 0, kScreenW, kNavBarHeight);
        [self.topToolView.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
    }
    return _topToolView;
}


#pragma mark 生成image
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
