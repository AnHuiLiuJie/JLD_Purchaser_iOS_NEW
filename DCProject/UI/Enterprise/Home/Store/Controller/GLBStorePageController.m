//
//  GLBStorePageController.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStorePageController.h"

#import "WMPanGestureRecognizer.h"

#import "GLBStoreItemView.h"
#import "GLBStoreDetailHeadView.h"
#import "GLBStoreNavigationBar.h"

#import "GLBStoreHomeController.h"
#import "GLBStoreGoodsController.h"
#import "GLBStoreSendController.h"
#import "GLBStoreEvaluateController.h"
#import "GLBShoppingCarController.h"
#import "GLBSearchPageController.h"
#import "GLBOrderPageController.h"
#import "WMScrollView+DCPopGesture.h"

#import "CSDemoAccountManager.h"//lj_will_change

static CGFloat const kWMMenuViewHeight = 60.0;

#define kWMHeaderViewHeight (kNavBarHeight + 146)

@interface GLBStorePageController ()

@property (nonatomic, strong) GLBStoreItemView *itemView1;
@property (nonatomic, strong) GLBStoreItemView *itemView2;
@property (nonatomic, strong) GLBStoreItemView *itemView3;
@property (nonatomic, strong) GLBStoreItemView *itemView4;
@property (nonatomic, strong) GLBStoreItemView *itemView5;

@property (nonatomic, strong) GLBStoreNavigationBar *navBar;
@property (nonatomic, strong) GLBStoreDetailHeadView *headView;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *icons;

@property (nonatomic, strong) WMPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGFloat viewTop;

@property (nonatomic, strong) GLBStoreModel *detailModel;

@end

@implementation GLBStorePageController

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleDefault;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 5;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        self.progressWidth = 30;
        self.menuView.scrollView.backgroundColor = [UIColor whiteColor];
        self.titleColorSelected = [UIColor clearColor];
        self.titleColorNormal = [UIColor clearColor];
        self.progressColor = [UIColor clearColor];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.navBar];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.height.equalTo(kNavBarHeight);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.height.equalTo(kWMHeaderViewHeight);
    }];
    
    self.itemView1 = [[GLBStoreItemView alloc] initWithFrame:CGRectMake(0, 0, kScreenW/5, kWMMenuViewHeight)];
    self.itemView1.titleLabel.text = @"商家首页";
    self.itemView1.normalImage.image = [UIImage imageNamed:@"dp_sywz"];
    self.itemView1.selectedImage.image = [UIImage imageNamed:@"dp_shsy"];
    self.itemView1.isSelected = YES;
    [self.menuView insertSubview:self.itemView1 atIndex:0];
    
    self.itemView2 = [[GLBStoreItemView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.itemView1.frame), 0, kScreenW/5, kWMMenuViewHeight)];
    self.itemView2.titleLabel.text = @"全部商品";
    self.itemView2.normalImage.image = [UIImage imageNamed:@"dp_qbsp"];
    self.itemView2.countLabel.text = @"0";
    [self.menuView insertSubview:self.itemView2 atIndex:0];
    
    self.itemView3 = [[GLBStoreItemView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.itemView2.frame), 0, kScreenW/5, kWMMenuViewHeight)];
    self.itemView3.titleLabel.text = @"资质/配送";
    self.itemView3.normalImage.image = [UIImage imageNamed:@"dp_ps"];
    self.itemView3.selectedImage.image = [UIImage imageNamed:@"dp_psl"];
    [self.menuView insertSubview:self.itemView3 atIndex:0];
    
    self.itemView4 = [[GLBStoreItemView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.itemView3.frame), 0, kScreenW/5, kWMMenuViewHeight)];
    self.itemView4.titleLabel.text = @"用户评价";
    self.itemView4.normalImage.image = [UIImage imageNamed:@"dp_pj"];
    self.itemView4.countLabel.text = @"0";
    [self.menuView insertSubview:self.itemView4 belowSubview:self.menuView.scrollView];
    
    self.itemView5 = [[GLBStoreItemView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.itemView4.frame), 0, kScreenW/5, kWMMenuViewHeight)];
    self.itemView5.titleLabel.text = @"联系客服";
    self.itemView5.normalImage.image = [UIImage imageNamed:@"dp_kf"];
    self.itemView5.selectedImage.image = [UIImage imageNamed:@"dp_kf"];
   [self.menuView insertSubview:self.itemView5 aboveSubview:self.menuView.scrollView];
    
    self.itemView5.userInteractionEnabled = YES;
    UITapGestureRecognizer *kefuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kefuAction:)];
    [self.itemView5 addGestureRecognizer:kefuTap];
    
    self.panGesture = [[WMPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnView:)];
    [self.view addGestureRecognizer:self.panGesture];
    
    // 注册通知，登录成功刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:DC_LoginSucess_Notification object:nil];
    
    [self dc_requestValue];
}


#pragma mark - 请求
- (void)dc_requestValue
{
    [self reqeustStoreDetail];
    [self reqeustShoppingCarGoodsCount];
}


#pragma mark - 接收到通知
- (void)loginSuccess:(id)sender
{
    [self dc_requestValue];
}


#pragma mark - 手势
- (void)panOnView:(WMPanGestureRecognizer *)recognizer {
    NSLog(@"pannnnnning received..");
    
    CGPoint currentPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = currentPoint;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat targetPoint = velocity.y < 0 ? kNavBarHeight : kNavBarHeight + kWMHeaderViewHeight;
        NSTimeInterval duration = fabs((targetPoint - self.viewTop) / velocity.y);
        
        if (fabs(velocity.y) *1.0 > fabs(targetPoint - self.viewTop)) {
            NSLog(@"velocity: %lf", velocity.y);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewTop = targetPoint;
            } completion:nil];
            
            return;
        }
        
    }
    CGFloat yChange = currentPoint.y - self.lastPoint.y;
    
    self.viewTop += yChange;
    self.lastPoint = currentPoint;
}

// MARK: ChangeViewFrame (Animatable)
- (void)setViewTop:(CGFloat)viewTop {
    _viewTop = viewTop;
    
    if (_viewTop <= kNavBarHeight) {
        _viewTop = kNavBarHeight;
    }
    
    if (_viewTop > kWMHeaderViewHeight) {
        _viewTop = kWMHeaderViewHeight;
    }
    
//    if (_viewTop > kNavBarHeight && _viewTop < kWMHeaderViewHeight) {
//        self.navBar.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB" alpha:1 - ((_viewTop - kNavBarHeight)/kWMHeaderViewHeight)];
//    }
    
    self.headView.frame = ({
        CGRect oriFrame = self.headView.frame;
        oriFrame.origin.y = _viewTop - kWMHeaderViewHeight;
        oriFrame;
    });
    
    if (self.selectIndex == 1) {
        GLBStoreGoodsController *vc = (GLBStoreGoodsController *)self.currentViewController;
        //CGFloat y = CGRectGetMaxY(self.headView.frame) + kWMMenuViewHeight;
        vc.height = 1;
    }
    
    [self forceLayoutSubviews];
}



#pragma mark - 点击客服
- (void)kefuAction:(UITapGestureRecognizer *)tap
{
//    if (![[DCLoginTool shareTool] dc_isLogin]) {
//        [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
//        }];
//        return;
//    }
//
//    NSString *userID = @"";
//    NSString *title = @"客服";
//    NSString *headImg = @"";
//    if (self.detailModel) {
//        title = self.detailModel.storeInfoVO.storeName;
//        userID = [NSString stringWithFormat:@"b2b_%@",self.detailModel.storeInfoVO.suppierUserId];
//        headImg = self.detailModel.storeInfoVO.logoImg;
//
//        NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
//        [userDic setValue:userID forKey:@"userId"];
//        [userDic setValue:title forKey:@"nickname"];
//        [userDic setValue:headImg forKey:@"headImg"];
//
//        [[DCUpdateTool shareClient]updateEaseUser:userDic];
//
//        //lj_will_change_end
//        WEAKSELF;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
//            if ([lgM loginKefuSDK]) {
//                NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
//                NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
//                NSString *chatTitle = @"";
//                HDQueueIdentityInfo *queueIdentityInfo = nil;
//                HDAgentIdentityInfo *agentIdentityInfo = nil;
//                queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
//                agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
//                chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
//                hd_dispatch_main_async_safe(^(){
//                    [weakSelf hideHud];
//                    HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
//                    queue ? (chat.queueInfo = queueIdentityInfo) : nil;
//                    agent ? (chat.agent = agentIdentityInfo) : nil;
//                    chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
//                    [self.navigationController pushViewController:chat animated:YES];
//                });
//
//            } else {
//                hd_dispatch_main_async_safe(^(){
//                    [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
//                });
//                NSLog(@"登录失败");
//            }
//        });//完整
//
//        //lj_will_change
////        HDChatViewController *chatController = [[HDChatViewController alloc] initWithConversationChatter:userID conversationType:EMConversationTypeChat];
////        chatController.title = title;
////        chatController.sellerFirmName = self.detailModel.storeInfoVO.firmName;
////        [self.navigationController pushViewController:chatController animated:YES];
//    }
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 4;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {

    if (index == 0) {
        
        GLBStoreHomeController *vc = [GLBStoreHomeController new];
        if (self.detailModel) {
            vc.storeModel = self.detailModel;
        }
        return vc;
        
    } else if (index == 1) {
        
        GLBStoreGoodsController *vc = [GLBStoreGoodsController new];
        if (self.detailModel) {
            vc.storeModel = self.detailModel;
        }
        //CGFloat y = kWMHeaderViewHeight + kWMMenuViewHeight;
        vc.height = 1;
        return vc;
        
    } else if (index == 2) {
        
        GLBStoreSendController *vc = [GLBStoreSendController new];
        if (self.detailModel) {
            vc.storeModel = self.detailModel;
        }
        return vc;
        
    } else if (index == 3) {
        
        GLBStoreEvaluateController *vc = [GLBStoreEvaluateController new];
        if (self.detailModel) {
            vc.storeModel = self.detailModel;
        }
        return vc;
    }

    return [UIViewController new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, CGRectGetMaxY(self.headView.frame) + kWMMenuViewHeight, kScreenW, kScreenH - kNavBarHeight - kWMMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, CGRectGetMaxY(self.headView.frame), kScreenW, kWMMenuViewHeight);
}


- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    int index = [info[@"index"] intValue];
    if (index == 4) {
        
    }
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    int index = [info[@"index"] intValue];
    if (index == 0) {
        self.itemView1.isSelected = YES;
        self.itemView2.isSelected = NO;
        self.itemView3.isSelected = NO;
        self.itemView4.isSelected = NO;
        self.itemView5.isSelected = NO;
    } else if (index == 1) {
        self.itemView1.isSelected = NO;
        self.itemView2.isSelected = YES;
        self.itemView3.isSelected = NO;
        self.itemView4.isSelected = NO;
        self.itemView5.isSelected = NO;
    } else if (index == 2) {
        self.itemView1.isSelected = NO;
        self.itemView2.isSelected = NO;
        self.itemView3.isSelected = YES;
        self.itemView4.isSelected = NO;
        self.itemView5.isSelected = NO;
    } else if (index == 3) {
        self.itemView1.isSelected = NO;
        self.itemView2.isSelected = NO;
        self.itemView3.isSelected = NO;
        self.itemView4.isSelected = YES;
        self.itemView5.isSelected = NO;
    } else if (index == 4) {
//        self.itemView1.isSelected = NO;
//        self.itemView2.isSelected = NO;
//        self.itemView3.isSelected = NO;
//        self.itemView4.isSelected = NO;
//        self.itemView5.isSelected = YES;
    }
}


#pragma mark - action
- (void)dc_headViewBtnClick:(NSInteger)tag
{
    if (tag == 700) { // 返回
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (tag == 701) {
        
        GLBShoppingCarController *vc = [GLBShoppingCarController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (tag == 702) {
        
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        GLBOrderPageController *vc = [GLBOrderPageController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (tag == 703) {
        
        GLBSearchPageController *vc = [GLBSearchPageController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


#pragma mark - 请求 获取商家详情
- (void)reqeustStoreDetail
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestStoreDetailWithFirmId:_firmId success:^(id response) {
        if (response && [response isKindOfClass:[GLBStoreModel class]]) {
            weakSelf.detailModel = response;
            
            weakSelf.itemView2.countLabel.text = [NSString stringWithFormat:@"%ld",(long)weakSelf.detailModel.storeInfoVO.goodsCount];
            weakSelf.itemView4.countLabel.text = [NSString stringWithFormat:@"%ld",(long)weakSelf.detailModel.storeInfoVO.evalCount];
            
            [weakSelf reloadData];
            [weakSelf reqeustCollectStatus];
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - 请求 查询店铺收藏状态
- (void)reqeustCollectStatus
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCollectStatusWithInfoId:self.detailModel.storeInfoVO.firmId success:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"] && [response[@"data"] isEqualToString:@"2"]) { // 已收藏
                weakSelf.detailModel.isCollected = YES;
            }
        }
        weakSelf.headView.storeModel = weakSelf.detailModel;
    } failture:^(NSError *error) {
        weakSelf.headView.storeModel = weakSelf.detailModel;
    }];
}



#pragma mark - 请求 收藏商品
- (void)reqeustCareCompany
{
    if (!self.detailModel) {
        return;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAddCollectWithInfoId:_detailModel.storeInfoVO.firmId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            weakSelf.detailModel.isCollected = YES;
            weakSelf.headView.storeModel = weakSelf.detailModel;
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - 请求 取消收藏商品
- (void)reqeustCancelCareCompany
{
    if (!self.detailModel) {
        return;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCancelCollectWithInfoId:self.detailModel.storeInfoVO.firmId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"取消关注"];
            weakSelf.detailModel.isCollected = NO;
            weakSelf.headView.storeModel = weakSelf.detailModel;
        }
        
    } failture:^(NSError *_Nullable error) {
        
    }];
}


#pragma mark - 请求 购物车商品数量
- (void)reqeustShoppingCarGoodsCount
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestShoppingCarGoodsCountWithSuccess:^(id response) {
        if (response) {
            weakSelf.navBar.count = [response integerValue];
        }
    } failture:^(NSError *_Nullable error) {
        
    }];
}


#pragma mark - lazy load
- (GLBStoreDetailHeadView *)headView{
    if (!_headView) {
        WEAKSELF;
        _headView = [[GLBStoreDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kWMHeaderViewHeight)];
        _headView.careBtnBlock = ^{
            if (weakSelf.detailModel) {
                if (weakSelf.detailModel.isCollected) { // 已收藏 - 取消操作
                    [weakSelf reqeustCancelCareCompany];
                } else { // 未收藏 - 收藏操作
                    [weakSelf reqeustCareCompany];
                }
            }
        };
    }
    return _headView;
}

- (GLBStoreNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLBStoreNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _navBar.successBlock = ^(NSInteger tag) {
            [weakSelf dc_headViewBtnClick:tag];
        };
        
    }
    return _navBar;
}

- (NSArray *)names{
    if (!_names) {
        _names = @[@"商家首页",@"全部商品",@"资质/配送",@"用户评价",@"联系客服"];
    }
    return _names;
}


#pragma mark -
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_LoginSucess_Notification object:nil];
}

@end
