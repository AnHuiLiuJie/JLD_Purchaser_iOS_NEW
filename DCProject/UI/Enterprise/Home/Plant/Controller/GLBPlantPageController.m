//
//  GLBPlantPageController.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBPlantPageController.h"
#import "GLBPlantListController.h"
#import "DCTextField.h"
#import "SDCycleScrollView.h"
#import "GLBAdvModel.h"

#import "GLBGoodsDetailController.h"
#import "GLBStorePageController.h"
#import "GLBExhibtPageController.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLBPlantPageController ()<UITextFieldDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) DCTextField *searchTF;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;

@property (nonatomic, strong) NSMutableArray<GLBAdvModel *> *bannerArray;

@end

@implementation GLBPlantPageController

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 2;
        self.progressWidth = 13;
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
    
    self.navigationItem.title = @"药种植";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchImage];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kScreenW, 32)];
    self.image.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.image belowSubview:self.menuView];
    
    [self requestBannerData];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.names.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    GLBPlantListController *vc = [GLBPlantListController new];
    vc.plantType = [self.types[index] integerValue];
    vc.searchText = self.searchTF.text;
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, kNavBarHeight + CGRectGetHeight(self.bannerView.frame) + 32, kScreenW, kScreenH - kNavBarHeight - CGRectGetHeight(self.bannerView.frame) - 32);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kScreenW, 32);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self reloadData];
    return YES;
}


#pragma mark - aciton
- (void)dc_pushController:(GLBAdvModel *)model
{
    if ([model.adType isEqualToString:@"1"]) { // 商品广告
        
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.goodsId = model.adInfoId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([model.adType isEqualToString:@"2"]) { //企业广告
        
        GLBStorePageController *vc = [GLBStorePageController new];
        vc.firmId = model.adInfoId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([model.adType isEqualToString:@"3"]) { //资讯广告
        
//        NSString *params = [NSString stringWithFormat:@"id=%@",model.adInfoId];
//        [self dc_pushWebController:@"/public/infor_detail.html" params:params];
        
    } else if ([model.adType isEqualToString:@"4"]) { //展会广告
        
        GLBExhibtPageController *vc = [GLBExhibtPageController new];
        vc.iD = model.adInfoId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        if (DC_CanOpenUrl(model.adLinkUrl)) {
            DC_OpenUrl(model.adLinkUrl);
        }
    }
}


#pragma mark - 请求 banner图数据
- (void)requestBannerData
{
    [self.bannerArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAdvWithCode:@"AD_APP_PLANT" success:^(id response) {
        if (response && [response count]>0) {
            [weakSelf.bannerArray addObjectsFromArray:response];
            
            NSMutableArray *imgurlArray = [NSMutableArray array];
            [weakSelf.bannerArray enumerateObjectsUsingBlock:^(GLBAdvModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSString *imageUrl = obj.adContent;
                [imgurlArray addObject:imageUrl];
            }];
            
            weakSelf.bannerView.imageURLStringsGroup = nil;
            weakSelf.bannerView.imageURLStringsGroup = imgurlArray;
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - lazy load
- (SDCycleScrollView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 0.4*kScreenW)];
        _bannerView.placeholderImage = [[DCPlaceholderTool shareTool] dc_placeholderImage];
        WEAKSELF;
        _bannerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            [weakSelf dc_pushController:weakSelf.bannerArray[currentIndex]];
        };
    }
    return _bannerView;
}

- (DCTextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[DCTextField alloc] initWithFrame:CGRectMake(15, kNavBarHeight + 9, kScreenW - 30, 30)];
        _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
        [_searchTF dc_cornerRadius:15];
        _searchTF.placeholder = @"输入种植户名称";
        _searchTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        _searchTF.font = PFRFont(14);
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTF;
}

- (UIImageView *)searchImage{
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 13, kNavBarHeight + 9 + 8,14, 14)];
        _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    }
    return _searchImage;
}

- (NSArray *)names{
    if (!_names) {
        _names = @[@"种植户",@"原药品种植"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(GLBPlantTypeZzh),
                   @(GLBPlantTypeZzyp)];
    }
    return _types;
}


- (NSMutableArray<GLBAdvModel *> *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

@end
