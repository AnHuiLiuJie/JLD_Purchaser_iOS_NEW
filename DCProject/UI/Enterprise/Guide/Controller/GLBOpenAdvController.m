//
//  GLBOpenAdvController.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOpenAdvController.h"
#import "GLBAdvModel.h"

#import "DCTabbarController.h"
//#import "GLBGuideController.h"
#import "GLBOpenTypeController.h"
#import "DCNavigationController.h"
#import "GLPLoginController.h"
#import "GLBAddInfoController.h"
#import "GLPTabBarController.h"
#import "GLBGoodsDetailController.h"
#import "GLBStorePageController.h"
#import "GLBExhibtPageController.h"

#import "DCProtocolView.h"
#import "CSDemoAccountManager.h"
@interface GLBOpenAdvController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *launchImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UILabel *skipLabel;

@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) DCProtocolView *protocolView;

@end

@implementation GLBOpenAdvController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dc_navBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.view addSubview:self.launchImage];
}

- (void)setIsLoadData:(BOOL)isLoadData{
    _isLoadData = isLoadData;
    
    if (_isLoadData) {
        [self setViewUI];
    }
}

- (void)setViewUI{
    if (versionFlag == 0) {
        [self openBtnClick:nil];//为了测试方便不用跳出广告
        return;
    }
    
    if (![DCObjectManager dc_readUserDataForKey:DC_IsFirstOpen_Key]) {
        [self.view addSubview:self.protocolView];
        self.protocolView.showType = @"YES";
    } else {
        
        BOOL isNeed = [self judgeNeedVersionUpdate];//一天只跳出一次
        if (!isNeed) {
            [self openBtnClick:nil];
            return;
        }
        
        [self performSelector:@selector(loadadClick) withObject:nil afterDelay:0.0f];
    }
}

- (DCProtocolView *)protocolView{
    if (!_protocolView) {
        WEAKSELF;
        _protocolView = [[DCProtocolView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _protocolView.agreeBlock = ^{
            [DCObjectManager dc_saveUserData:@"111" forKey:DC_IsFirstOpen_Key];
            [weakSelf loadadClick];
        };
        _protocolView.protocolBlock = ^(NSString *_Nullable apiStr) {
            NSString *params = [NSString stringWithFormat:@"api=%@",apiStr];
            [weakSelf dc_pushWebController:@"/public/agree.html" params:params];
        };
    }
    return _protocolView;
}

- (void)loadadClick
{
    NSArray *array = [DCObjectManager dc_getObjectByFileName:DC_OpenAdv_Key];
    if (array) {
       [self.dataArray removeAllObjects];
       [self.dataArray addObjectsFromArray:array];
    }

    if ([self.dataArray count] > 0) {
//       [self.launchImage removeFromSuperview];
       [self.view addSubview:self.scrollView];
       [self.view addSubview:self.skipLabel];
       [self.view addSubview:self.openBtn];
       
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipLabelClick:)];
       [self.skipLabel addGestureRecognizer:tap];
       
       self.scrollView.contentSize = CGSizeMake(kScreenW *self.dataArray.count, kScreenH);
       
       if (self.dataArray.count > 0) {
           _openBtn.hidden = YES;
       } else {
           _openBtn.hidden = NO;
       }
       
       for (int i=0; i<self.dataArray.count; i++) {
           
           GLBAdvModel *advModel = self.dataArray[i];
           
           UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, kScreenH)];
           image.contentMode = UIViewContentModeScaleToFill;
           image.clipsToBounds = YES;
           image.tag = i+70000;
           [self.scrollView addSubview:image];
           
           [image sd_setImageWithURL:[NSURL URLWithString:advModel.adContent] placeholderImage:nil];
           
           UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapClick:)];
           [image addGestureRecognizer:imageTap];
       }
       
       self.second = 5;
       [_timer invalidate];
       _timer = nil;
       _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo:) userInfo:nil repeats:YES];
       [self setSecondTime];
       
    } else {
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self openBtnClick:nil];
       });
    }

    [self requestOpenAdv];
}

//每天进行一次版本判断
- (BOOL)judgeNeedVersionUpdate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取年-月-日
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *currentDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"DC_CurrentDate_key2"];
    if ([currentDate isEqualToString:dateString]) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"DC_CurrentDate_key2"];
    return YES;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = x/kScreenW;
    if (index == self.dataArray.count - 1) {
        _openBtn.hidden = NO;
    } else {
        _openBtn.hidden = YES;
    }
}



#pragma mark - action
- (void)openBtnClick:(UIButton *)button
{
    
    [_timer invalidate];
    _timer = nil;
//    NSString *Share = [DCObjectManager dc_readUserDataForKey:@"Share"];
//    if ([Share isEqualToString:@"1"])
//    {
//        [DCObjectManager dc_removeUserDataForkey:@"Share"];
//        return;
//    }
    NSInteger userType = [[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue];
    if (userType == DCUserTypeWithCompany) {
        
        if ([DCObjectManager dc_readUserDataForKey:DC_UserID_Key]) {
            
            DCTabbarController *tabbarVC = [[DCTabbarController alloc] init];
            DC_KeyWindow.rootViewController = tabbarVC;
//            [CSDemoAccountManager shareLoginManager].homeVC1 = tabbarVC;
//            [CSDemoAccountManager shareLoginManager].homeVC = nil;
        } else {
            DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBOpenTypeController new]];
        }
        
    } else if (userType == DCUserTypeWithPerson) {
        
        if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]) {
            
            GLPTabBarController *tabbarVC = [[GLPTabBarController alloc] init];
            DC_KeyWindow.rootViewController = tabbarVC;
//            [CSDemoAccountManager shareLoginManager].homeVC = tabbarVC;
//            [CSDemoAccountManager shareLoginManager].homeVC1 = nil;
            
            //DC_KeyWindow.rootViewController = [[GLPTabBarController alloc] init];
        } else {
            DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBOpenTypeController new]];
        }
    }
}

- (void)skipLabelClick:(id)sender
{
    [self openBtnClick:nil];
}

- (void)imageTapClick:(UITapGestureRecognizer *)sender
{
    UIImageView *image = (UIImageView *)sender.view;
    NSInteger index = image.tag - 70000;
    
    GLBAdvModel *advModel = self.dataArray[index];
    [self dc_pushController:advModel];
}


#pragma mark -
- (void)timeGo:(NSTimer *)sender
{
    self.second --;
    [self setSecondTime];
    
    if (self.second == 0) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)setSecondTime
{
    if (self.second > 0) {
        _skipLabel.userInteractionEnabled = YES;
        _skipLabel.text = [NSString stringWithFormat:@"%lds\n跳过",self.second];
    } else {
        _skipLabel.userInteractionEnabled = YES;
        _skipLabel.text = [NSString stringWithFormat:@"跳过"];
        
        [self openBtnClick:nil];
    }
}


#pragma mark - aciton
- (void)dc_pushController:(GLBAdvModel *)model
{
    if ([model.adType isEqualToString:@"1"]) { // 商品广告
        
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.goodsId = model.adInfoId;
        [self dc_pushNextController:vc];
        
    } else if ([model.adType isEqualToString:@"2"]) { //企业广告
        
        GLBStorePageController *vc = [GLBStorePageController new];
        vc.firmId = model.adInfoId;
        [self dc_pushNextController:vc];
        
    } else if ([model.adType isEqualToString:@"3"]) { //资讯广告
        
        NSString *params = [NSString stringWithFormat:@"id=%@",model.adInfoId];
        [self dc_pushWebController:@"/public/infor_detail.html" params:params];
        
    } else if ([model.adType isEqualToString:@"4"]) { //展会广告
        
        GLBExhibtPageController *vc = [GLBExhibtPageController new];
        vc.iD = model.adInfoId;
        [self dc_pushNextController:vc];
        
    } else {
        
        if (DC_CanOpenUrl(model.adLinkUrl)) {
            DC_OpenUrl(model.adLinkUrl);
        }
    }
}


#pragma mark - 请求 开屏广告
- (void)requestOpenAdv
{
    [[DCAPIManager shareManager] dc_requestAdvWithCode:@"AD_APP_LOAD" success:^(id response) {
        NSMutableArray *dataArray = [NSMutableArray array];
        if (response && [response count] > 0) {
            [dataArray addObjectsFromArray:response];
        }
        
        if ([dataArray count] > 0) {
            [DCObjectManager dc_saveObject:dataArray byFileName:DC_OpenAdv_Key];
        } else {
            [DCObjectManager dc_removeFileByFileName:DC_OpenAdv_Key];
        }
        
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - lazy load
- (UIImageView *)launchImage{
    if (!_launchImage) {
        _launchImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _launchImage.contentMode = UIViewContentModeScaleAspectFill;
        _launchImage.clipsToBounds = YES;
        _launchImage.image = [UIImage dc_getLaunchImage];
    }
    return _launchImage;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openBtn.frame = CGRectMake((kScreenW - 100)/2, kScreenH - 100, 100, 40);
        _openBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [_openBtn setTitle:@"立即体验" forState:0];
        [_openBtn setTitleColor:[UIColor whiteColor] forState:0];
        _openBtn.titleLabel.font = PFRFont(15);
        [_openBtn dc_cornerRadius:10];
        [_openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _openBtn.hidden = YES;
    }
    return _openBtn;
}

- (UILabel *)skipLabel{
    if (!_skipLabel) {
        _skipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 60, kStatusBarHeight, 40, 40)];
        _skipLabel.backgroundColor = RGB_COLOR(233, 235,232);
        [_skipLabel dc_cornerRadius:20];
        _skipLabel.numberOfLines = 2;
        _skipLabel.font = PFRFont(14);
        _skipLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        _skipLabel.textAlignment = NSTextAlignmentCenter;
        _skipLabel.userInteractionEnabled = YES;
        _skipLabel.layer.borderWidth = 1;
        _skipLabel.layer.borderColor = RGB_COLOR(64, 202, 176).CGColor;

    }
    return _skipLabel;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)dealloc {
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
    [_timer invalidate];
    _timer = nil;
}

@end
