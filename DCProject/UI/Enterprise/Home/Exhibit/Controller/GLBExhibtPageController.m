//
//  GLBExhibtPageController.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBExhibtPageController.h"
#import "SDCycleScrollView.h"

#import "GLBExhibitCompanyController.h"
#import "GLBExhibitGoodsController.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLBExhibtPageController ()

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSArray *types;

@property (nonatomic, strong) GLBExhibitModel *exhibitModel;

@end

@implementation GLBExhibtPageController

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 3;
        self.progressWidth = 30;
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
    
    self.navigationItem.title = @"平台展会";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headImage];
    
//    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 36)];
//    self.image.backgroundColor = [UIColor whiteColor];
//    [self.view insertSubview:self.image belowSubview:self.menuView];
    
    if (_iD) {
        [self requestZhanhuiInfo];
    } else {
        [self requestDrugExhibt];
    }
    
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    if (self.exhibitModel && [self.exhibitModel.expoType isEqualToString:@"1"]) { // 企业展会
        return self.names.count;
    } else if (self.exhibitModel && [self.exhibitModel.expoType isEqualToString:@"2"]) {
        return 1;
    }
    return 0;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (self.exhibitModel && [self.exhibitModel.expoType isEqualToString:@"1"]) { // 企业展会
        GLBExhibitCompanyController *vc = [GLBExhibitCompanyController new];
        vc.infoModel = self.exhibitModel.infoList[index];
        return vc;
    } else if (self.exhibitModel && [self.exhibitModel.expoType isEqualToString:@"2"]) {
        GLBExhibitGoodsController *vc = [GLBExhibitGoodsController new];
        vc.exhibitModel = self.exhibitModel;
        return  vc;
    }
    
    return [UIViewController new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (self.exhibitModel && [self.exhibitModel.expoType isEqualToString:@"1"]) { // 企业展会
        return self.names[index];
    }
    return @"";
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, CGRectGetMaxY(self.menuView.frame), kScreenW, kScreenH - CGRectGetMaxY(self.menuView.frame));
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    if (self.exhibitModel && [self.exhibitModel.expoType isEqualToString:@"1"]) { // 企业展会
        return CGRectMake(0, kNavBarHeight + CGRectGetHeight(self.headImage.frame), kScreenW, 36);
    }
    
    return CGRectMake(0, kNavBarHeight + CGRectGetHeight(self.headImage.frame), kScreenW, 0);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
}


#pragma mark - 请求 药交会
- (void)requestDrugExhibt
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDrugExhibitSuccess:^(id response) {
        if (response && [response isKindOfClass:[GLBExhibitModel class]]) {
            weakSelf.exhibitModel = response;
            
            [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:weakSelf.exhibitModel.expoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            
            [weakSelf.names removeAllObjects];
            if (weakSelf.exhibitModel.infoList.count > 0) {
                for (int i=0; i<weakSelf.exhibitModel.infoList.count; i++) {
                    GLBExhibitInfoModel *infoModel = weakSelf.exhibitModel.infoList[i];
                    [weakSelf.names addObject: infoModel.typeName];
                }
            }
            
            [weakSelf reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 展会信息
- (void)requestZhanhuiInfo
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestExhibitListWithID:_iD success:^(id response) {
        if (response && [response isKindOfClass:[GLBExhibitModel class]]) {
            weakSelf.exhibitModel = response;
            
            [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:weakSelf.exhibitModel.expoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            
            [weakSelf.names removeAllObjects];
            if (weakSelf.exhibitModel.infoList.count > 0) {
                for (int i=0; i<weakSelf.exhibitModel.infoList.count; i++) {
                    GLBExhibitInfoModel *infoModel = weakSelf.exhibitModel.infoList[i];
                    [weakSelf.names addObject: infoModel.typeName];
                }
            }
            
            [weakSelf reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}



#pragma mark - lazy load
- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 0.4*kScreenW)];
    }
    return _headImage;
}

- (NSMutableArray *)names{
    if (!_names) {
        _names = [NSMutableArray array];
    }
    return _names;
}


@end
