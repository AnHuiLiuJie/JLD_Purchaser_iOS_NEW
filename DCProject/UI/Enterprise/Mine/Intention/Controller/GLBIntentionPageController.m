//
//  GLBIntentionPageController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBIntentionPageController.h"

#import "GLBIntentionListController.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLBIntentionPageController ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;

@end

@implementation GLBIntentionPageController

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 4;
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
    
    self.navigationItem.title = @"订购意向";
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
    GLBIntentionListController *vc = [GLBIntentionListController new];
    vc.intentionType = [self.types[index] integerValue];
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, CGRectGetMaxY(self.menuView.frame), kScreenW, kScreenH - CGRectGetMaxY(self.menuView.frame));
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavBarHeight, kScreenW, 36);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
}





#pragma mark - lazy load
- (NSArray *)names{
    if (!_names) {
        _names = @[@"全部",@"待确认",@"已确认",@"未通过"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(GLBIntenTionTypeAll),
                   @(GLBIntenTionTypeWait),
                   @(GLBIntenTionTypeConfirm),
                   @(GLBIntenTionTypeUnpass)];
    }
    return _types;
}
@end
