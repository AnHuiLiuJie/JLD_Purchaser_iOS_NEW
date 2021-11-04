//
//  GLBZizhiPageController.m
//  DCProject
//
//  Created by bigbing on 2019/8/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBZizhiPageController.h"
#import "GLBZizhiListController.h"

#import "GLBZizhiExchangeController.h"
#import "GLBAddInfoController.h"

#import "DCTextView.h"
#import "WMScrollView+DCPopGesture.h"

@interface GLBZizhiPageController ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) DCTextView *tipTV;

@property (nonatomic, assign) CGFloat height;

@end

@implementation GLBZizhiPageController

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 2;
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
    
    self.navigationItem.title = @"资质认证";
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
    GLBZizhiListController *vc = [GLBZizhiListController new];
    vc.zizhiType = [self.types[index] integerValue];
    vc.height = self.height;
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, CGRectGetMaxY(self.menuView.frame), kScreenW, kScreenH - CGRectGetMaxY(self.menuView.frame));
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavBarHeight + self.height, kScreenW, 32);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
}



#pragma mark - action
- (void)editAction:(id)sender
{
    GLBZizhiExchangeController *vc = [GLBZizhiExchangeController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - lazy load
- (NSArray *)names{
    if (!_names) {
        
        NSString *string = @"待认证资质";
        if (_infoDict && _infoDict[@"qcStateStr"]) {
            string = _infoDict[@"qcStateStr"];
        }
        
        _names = @[@"企业资质",string];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(GLBZizhiTypeCertified),
                   @(GLBZizhiTypeUnverified)];
    }
    return _types;
}


- (UIView *)tipView{
    if (!_tipView) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 105)];
        _tipView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
        line1.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        [_tipView addSubview:line1];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line1.frame), kScreenW - 30, 30)];
        _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#EA504A"];
        _tipLabel.font = PFRFont(14);
        _tipLabel.text = @"*审核不通过原因";
        [_tipView addSubview:_tipLabel];
        
        _tipTV = [[DCTextView alloc] init];
        _tipTV.frame = CGRectMake(10, CGRectGetMaxY(_tipLabel.frame), kScreenW - 20, 60);
        _tipTV.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        _tipTV.font = PFRFont(14);
        _tipTV.userInteractionEnabled = NO;
        [_tipView addSubview:_tipTV];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipTV.frame), kScreenW , 5)];
        line2.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        [_tipView addSubview:line2];
    }
    return _tipView;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#EA504A"];
        _tipLabel.font = PFRFont(14);
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}


- (void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    if (_infoDict && _infoDict[@"applyState"] && [_infoDict[@"applyState"] integerValue] != 1) { // 不是待审核状态
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"变更资质" color:[UIColor dc_colorWithHexString:@"#00B7AB"] font:[UIFont fontWithName:PFR size:13] target:self action:@selector(editAction:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (_infoDict && _infoDict[@"applyState"] && [_infoDict[@"applyState"] integerValue] == 3) { // 审核不通过
        [self.view addSubview:self.tipView];
        self.tipView.hidden = NO;
        self.tipTV.content = [NSString stringWithFormat:@"%@",_infoDict[@"remark"]];
        
        self.height = CGRectGetHeight(_tipView.frame);
    }
    
    if (_infoDict && _infoDict[@"qcStateStr"]) {
        NSString *string = _infoDict[@"qcStateStr"];
        if (!string || [string dc_isNull]) {
            string = @"";
        }
        self.names = @[@"企业资质",string];

        [self reloadData];
    }

}

@end
