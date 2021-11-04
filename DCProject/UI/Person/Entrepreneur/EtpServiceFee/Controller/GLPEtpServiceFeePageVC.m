//
//  GLPEtpServiceFeePageVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "GLPEtpServiceFeePageVC.h"
#import "GLPEtpServiceFeeListVC.h"
#import "EtpServiceFeeSearchView.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLPEtpServiceFeePageVC ()

@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, assign) CGFloat listView_h;

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) PSFSearchConditionModel *model;


@end

static CGFloat const topView_H = 32;
static CGFloat const searchView_H = 40;


@implementation GLPEtpServiceFeePageVC

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
    
    self.navigationItem.title = @"服务费明细";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_rightItemWithImage:[UIImage imageNamed:@"dc_ss_hei"] target:self action:@selector(searchItemClick:)];
    
    self.topBgView.hidden = NO;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dc_fanhui_hei"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick1)];
}

- (UIView *)topBgView
{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, searchView_H)];
        _topBgView.backgroundColor = [UIColor whiteColor];
        [self.view insertSubview:_topBgView belowSubview:self.menuView];
        
        UIView *_topSearchView = [[UIView alloc] init];
        _topSearchView.backgroundColor = [UIColor dc_colorWithHexString:@"#FAFAFA"];
        _topSearchView.layer.cornerRadius = 16;
        [_topSearchView.layer masksToBounds];
//        _topSearchView.frame = CGRectMake(8, (searchView_H-30)/2, kScreenW-16, 30);
        [_topBgView addSubview:_topSearchView];
        
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"商品名称、订单编号、订单时间、客源类型……" forState:0];
        [_searchButton setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:0];
        _searchButton.titleLabel.font = [UIFont fontWithName:PFR size:11];
        [_searchButton setImage:[UIImage imageNamed:@"dc_ss_hei"] forState:0];
        [_searchButton adjustsImageWhenHighlighted];
        _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 *10, 0, 0);
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _searchButton.frame = CGRectMake(0, 0, _topSearchView.dc_width, _topSearchView.dc_height);
        [_topSearchView addSubview:_searchButton];
        
        [_topSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(self.topBgView.left)setOffset:8];
            [make.right.mas_equalTo(self.topBgView.right)setOffset:-8];
            make.height.mas_equalTo(@(32));
            make.centerY.mas_equalTo(self.topBgView);
        }];
        
        [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topSearchView);
            make.top.mas_equalTo(_topSearchView);
            make.height.mas_equalTo(_topSearchView);
            [make.right.mas_equalTo(_topSearchView)setOffset:-2*10];
        }];
    }
    return _topBgView;
}

#pragma makr - 搜索
- (void)searchButtonClick
{
    EtpServiceFeeSearchView *view = [[EtpServiceFeeSearchView alloc] init];
    view.frame = self.view.bounds;
    view.model = self.model;
    WEAKSELF;
    view.etpServiceFeeSearchViewAction_Block = ^(PSFSearchConditionModel *_Nonnull model) {
        weakSelf.model = model;
        [self getSearchTitileStr];
        NSDictionary *dataDic = [NSDictionary dictionaryWithObject:model forKey:@"info"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GLPEtpServiceFeeListVCNotification" object:nil userInfo:dataDic];
    };
    [self.view addSubview:view];
}

- (void)getSearchTitileStr
{
    NSString *title = [NSString stringWithFormat:@"%@",self.model.goodsName];
    if (self.model.orderNo.length !=0 ) {
        if (title.length == 0) {
            title = [NSString stringWithFormat:@"%@",self.model.orderNo];
        }else
            title = [NSString stringWithFormat:@"%@、%@",title,self.model.orderNo];

    }
    if (self.model.startTime.length !=0 ) {
        if (title.length == 0) {
            title = [NSString stringWithFormat:@"%@ %@",self.model.startTime,self.model.endTime];
        }else
            title = [NSString stringWithFormat:@"%@、%@ %@",title,self.model.startTime,self.model.endTime];
    }
    if (self.model.level.length !=0 ) {
        NSString *levelStr = @"";
        if ([self.model.level isEqualToString:@"1"]) {
            levelStr = @"我的客源";
        }else if([self.model.level isEqualToString:@"2"]){
            levelStr = @"二级客源";
        }else if([self.model.level isEqualToString:@"3"]){
            levelStr = @"三级客源";
        }
        
        if (title.length == 0) {
            title = [NSString stringWithFormat:@"%@",levelStr];
        }else
            title = [NSString stringWithFormat:@"%@、%@",title,levelStr];
    }
    if (title.length == 0) {
        [self.searchButton setTitle:@"商品名称、订单编号、订单时间、客源类型……" forState:0];
        [self.searchButton setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:0];
    }else{
        [self.searchButton setTitle:title forState:0];
        [self.searchButton setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    }

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
    GLPEtpServiceFeeListVC *vc = [GLPEtpServiceFeeListVC new];
    vc.model = self.model;
    vc.customerType = [self.types[index] integerValue];
    vc.view_H = _listView_h;
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    _listView_h = kScreenH - kNavBarHeight - topView_H-searchView_H-LJ_TabbarSafeBottomMargin;
    return CGRectMake(0, kNavBarHeight + topView_H+searchView_H, kScreenW, _listView_h);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavBarHeight+searchView_H, kScreenW, topView_H);
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
        _names = @[@"全部",@"待结算",@"已结算",@"无效服务费"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(EtpServiceFeeTypeAll),
                   @(EtpServiceFeeTypeWait),
                   @(EtpServiceFeeTypeEnd),
                   @(EtpServiceFeeTypeInvalid)];
    }
    return _types;
}

- (PSFSearchConditionModel *)model{
    if (!_model) {
        _model = [[PSFSearchConditionModel alloc] init];
        _model.orderNo = @"";
        _model.goodsName = @"";
        _model.startTime = @"";
        _model.endTime = @"";
        _model.level = @"";
        _model.state = @"";
    }
    return _model;
}

//EtpServiceFeeTypeAll = 0,       // 全部
//EtpServiceFeeTypeWait,           // 待结算
//EtpServiceFeeTypeEnd,          // 已结算
//EtpServiceFeeTypeInvalid,          // 无效服务费

@end
