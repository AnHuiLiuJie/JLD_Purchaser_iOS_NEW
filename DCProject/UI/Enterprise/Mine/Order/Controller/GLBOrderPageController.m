//
//  GLBOrderPageController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOrderPageController.h"

#import "GLBOrderListController.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLBOrderPageController ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;

@end

@implementation GLBOrderPageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
//        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 5.5;
        self.progressWidth = 24;
        self.menuView.scrollView.backgroundColor = [UIColor whiteColor];
        self.titleColorSelected = [UIColor dc_colorWithHexString:@"#00B7AB"];
        self.titleColorNormal = [UIColor dc_colorWithHexString:@"#333333"];
        self.progressColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectIndex = self.index;
//        [self reloadData];
    });
    
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 32)];
    self.image.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.image belowSubview:self.menuView];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.names.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    WEAKSELF;
    GLBOrderListController *vc = [GLBOrderListController new];
    vc.orderType = [self.types[index] integerValue];
    vc.sellerFirmName = self.sellerFirmName;
    vc.orderBlock = ^(GLBOrderModel *orderModel) {
        
        DCChatGoodsModel *model = [DCChatGoodsModel new];
        model.type = @"2";
        model.orderNo = [NSString stringWithFormat:@"%ld",orderModel.orderNo];
        model.goodsCount = [NSString stringWithFormat:@"%ld",(long)orderModel.goodsCount];
        model.totalPrice = [NSString stringWithFormat:@"%.2f",orderModel.paymentAmount];
        model.goodsImage = @"";
        model.sendType = @"2";
        
        if (weakSelf.successBlock) {
            weakSelf.successBlock(model);
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0, CGRectGetMaxY(self.menuView.frame), kScreenW, kScreenH - CGRectGetMaxY(self.menuView.frame));
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavBarHeight, kScreenW, 32);
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
        _names = @[@"全部",@"待审核",@"待付款",@"待发货",@"待验收",@"待评价"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(GLBOrderTypeAll),
                   @(GLBOrderTypeAudit),
                   @(GLBOrderTypePay),
                   @(GLBOrderTypeSend),
                   @(GLBOrderTypeAccept),
                   @(GLBOrderTypeEvaluate)];
    }
    return _types;
}

@end
