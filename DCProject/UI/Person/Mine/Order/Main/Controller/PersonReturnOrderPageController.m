//
//  GLBOrderPageController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PersonReturnOrderPageController.h"
#import "GLPTabBarController.h"
#import "PersonReturnOrderListController.h"
#import "EtpServiceFeeSearchView.h"
#import "WMScrollView+DCPopGesture.h"

@interface PersonReturnOrderPageController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, assign) CGFloat listView_h;
@property (nonatomic, strong) PSFSearchConditionModel *model;

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTF;


@end

static CGFloat const topView_H = 35;
static CGFloat const searchView_H = 32;

@implementation PersonReturnOrderPageController


- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        //self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 5.5;
        self.progressWidth = 24;
        self.menuView.scrollView.backgroundColor = [UIColor whiteColor];
        self.titleColorSelected = [UIColor dc_colorWithHexString:@"#00B7AB"];
        self.titleColorNormal = [UIColor dc_colorWithHexString:@"#333333"];
        self.progressColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        self.menuView.showTopLine = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectIndex = self.index;
    self.navigationItem.title = @"退款售后";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.topBgView.hidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dc_fanhui_hei"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick1)];
    
}

- (void)backClick1{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.names.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    PersonReturnOrderListController *vc = [PersonReturnOrderListController new];
    vc.view_H = _listView_h;
    vc.orderNo_str = self.orderNo_str;
    vc.orderType = [self.types[index] integerValue];
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    [self sendNotification:self.searchTF.text];
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

// 同时响应拖动和滑动手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        return NO;
//    }
//    return YES;
//
//}


#pragma mark - lazy load
- (NSArray *)names{
    if (!_names) {
        _names = @[@"全部",@"退款中",@"已退款",@"已拒绝",@"失败"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(GLPOrderTypeRefundStatesAll),
                   @(GLPOrderTypeRefundStatesRefunding),
                   @(GLPOrderTypeRefundStatesSuccess),
                   @(GLPOrderTypeRefundStatesRefuse),
                   @(GLPOrderTypeRefundStatesFailure)];
    }
    return _types;
}

- (UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, searchView_H)];
        _topBgView.backgroundColor = [UIColor whiteColor];
        [self.view insertSubview:_topBgView belowSubview:self.menuView];
        
        self.searchView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, searchView_H)];
        self.searchView.backgroundColor = [UIColor whiteColor];
        self.searchView.layer.masksToBounds = YES;
        self.searchView.layer.cornerRadius = 15;
        [_topBgView addSubview:self.searchView];
        UIImageView *searchImageV = [[UIImageView alloc] init];
        searchImageV.center = CGPointMake(22, 15);
        searchImageV.bounds = CGRectMake(0, 0, 14, 14);
        searchImageV.image = [UIImage imageNamed:@"dc_ss_hei"];
        [self.searchView addSubview:searchImageV];
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(44, 5, self.searchView.frame.size.width-48 , 20)];
        _searchTF.placeholder = @"搜索订单号、商品名称、店铺名.....";
        _searchTF.font = [UIFont systemFontOfSize:12];
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
        [self.searchView addSubview:_searchTF];
        
        [DCSpeedy dc_changeControlCircularWith:self.searchView AndSetCornerRadius:self.searchView.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];
    }
    return _topBgView;
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{//OperationDoneCenterAction
    [self sendNotification:textField.text];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
        [self sendNotification:textField.text];
}

- (void)sendNotification:(NSString *)text{
    PSFSearchConditionModel *model = [[PSFSearchConditionModel alloc] init];
    model.searchName = text;
    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:model forKey:@"info"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLPEtpServiceFeeListVCTwoNotification" object:nil userInfo:dataDic];
    [_searchTF resignFirstResponder];
}

#pragma makr - 搜索
- (void)searchButtonClick
{
//    EtpServiceFeeSearchView *view = [[EtpServiceFeeSearchView alloc] init];
//    view.frame = CGRectMake(0, kNavBarHeight, kScreenW, self.view.dc_height-kNavBarHeight);
//    view.showType = 1;
//    view.model = self.model;
//    WEAKSELF;
//    view.etpServiceFeeSearchViewAction_Block = ^(PSFSearchConditionModel *_Nonnull model) {
//        weakSelf.model = model;
//        [self getSearchTitileStr];
//        NSDictionary *dataDic = [NSDictionary dictionaryWithObject:model forKey:@"info"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GLPEtpServiceFeeListVCTwoNotification" object:nil userInfo:dataDic];
//    };
//    [self.view addSubview:view];
}


- (PSFSearchConditionModel *)model{
    if (!_model) {
        _model = [[PSFSearchConditionModel alloc] init];
        _model.orderNo = @"";
        _model.goodsName = @"";
        _model.startTime = @"";
        _model.endTime = @"";
        _model.searchName = @"";
        _model.state = @"";
    }
    return _model;
}

@end
