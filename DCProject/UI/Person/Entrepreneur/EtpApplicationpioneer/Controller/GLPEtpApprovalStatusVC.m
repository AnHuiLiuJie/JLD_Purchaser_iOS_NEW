//
//  GLPEtpApprovalStatusVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/15.
//

#import "GLPEtpApprovalStatusVC.h"
#import "AppDelegate.h"
#import "DCAPIManager+PioneerRequest.h"
#import "GLPEtpApplicationVC.h"
@interface GLPEtpApprovalStatusVC ()

@property (nonatomic, assign) BOOL isMove;
@end

@implementation GLPEtpApprovalStatusVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isMove = NO;
    if (self.statusType == EtpApprovalStatusReviewFailure) {
        [self requestLoadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

    self.isMove = YES;
}


- (void)willMoveToParentViewController:(nullable UIViewController *)parent NS_AVAILABLE_IOS(5_0){
    NSLog(@"will 侧滑%@",[parent class]);
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent NS_AVAILABLE_IOS(5_0){
    NSLog(@"did 侧滑 %@",[parent class]);
    if ( self.isMove ) {
        [self backToHomePage];
    }
}


#pragma mark - 请求 申请创业者
- (void)requestLoadData{

    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_viewWithSuccess:^(id response) {
        NSDictionary *userDic = response[@"data"];
        EntrepreneurInfoModel *userInfoModel = [EntrepreneurInfoModel mj_objectWithKeyValues:userDic];
        weakSelf.userInfoModel = userInfoModel;
        if (weakSelf.statusType == EtpApprovalStatusReviewFailure) {
            weakSelf.noPass_lab2.text = weakSelf.userInfoModel.auditRemark;
            weakSelf.status_lab.text = weakSelf.userInfoModel.stateStr;
        }
    } failture:^(NSError *error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpViewUI];
    
    //[self dc_addCustomBackEvent:@selector(backToHomePage)];
}

- (void)setUpViewUI{
    
    //圆角
    [DCSpeedy dc_changeControlCircularWith:_submit_btn AndSetCornerRadius:_submit_btn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    [self.submit_btn addTarget:self action:@selector(sumitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.statusType == EtpApprovalStatusReviewing) {
        self.title = @"资质审核";
        self.status_lab.text = @"审核中";
        self.status_lab.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        self.noPass_lab1.hidden = YES;
        self.noPass_lab2.hidden = YES;
        self.submit_btn.tag = 1;
        [self.submit_btn setTitle:@"确定" forState:UIControlStateNormal];
        self.tell_Y_LayoutConstraint.constant = -40;
    }else{
        self.title = @"申请审核";
        self.status_lab.text = @"审核失败";
        self.status_lab.textColor = [UIColor dc_colorWithHexString:@"#FF655D"];
        [self.status_img setImage:[UIImage imageNamed:@"etp_sh_no"]];
        self.noPass_lab2.text = self.userInfoModel.auditRemark;
        [self.submit_btn setTitle:@"重新申请" forState:UIControlStateNormal];
        self.submit_btn.tag = 2;
        self.tishi_lab.text = @"很遗憾，您提交的资料申请未通过";
    }
}

#pragma mark - 确定 或者重新申请
- (void)sumitBtnAction:(UIButton *)button
{
    if (button.tag == 1) {//确定
        [self.navigationController popViewControllerAnimated:YES];
    }else{//重新申请
        GLPEtpApplicationVC *vc = [[GLPEtpApplicationVC alloc] init];
        vc.userInfoModel = self.userInfoModel;
        [self dc_pushNextController:vc];
    }
}

- (void)backToHomePage
{

    UIWindow *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
    UIViewController *presentedController = nil;

    UIViewController *rootController = [window rootViewController];
    if ([rootController isKindOfClass:[UITabBarController class]]) {
        rootController = [(UITabBarController *)rootController selectedViewController];
    }
    presentedController = rootController;
    //找到所有presented的controller，包括UIViewController和UINavigationController
    NSMutableArray<UIViewController *> *presentedControllerArray = [[NSMutableArray alloc] init];
    while (presentedController.presentedViewController) {
        [presentedControllerArray addObject:presentedController.presentedViewController];
        presentedController = presentedController.presentedViewController;
    }
    if (presentedControllerArray.count > 0) {
        //把所有presented的controller都dismiss掉
        [self dismissControllers:presentedControllerArray topIndex:presentedControllerArray.count - 1 completion:^{
            [self popToRootViewControllerFrom:rootController];
        }];
    } else {
        [self popToRootViewControllerFrom:rootController];
    }
}

- (void)dismissControllers:(NSArray<UIViewController *> *)presentedControllerArray topIndex:(NSInteger)index completion:(void(^)(void))completion
{
    if (index < 0) {
        completion();
    } else {
        [presentedControllerArray[index] dismissViewControllerAnimated:NO completion:^{
            [self dismissControllers:presentedControllerArray topIndex:index - 1 completion:completion];
        }];
    }
}

- (void)popToRootViewControllerFrom:(UIViewController *)fromViewController
{
    //pop to root
    if ([fromViewController isKindOfClass:[UINavigationController class]]) {
        //[(UINavigationController *)fromViewController popViewControllerAnimated:YES];
    }
    if (fromViewController.navigationController) {
        [fromViewController.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - 获取当前最外层VC
- (UIViewController*)currentViewController{
    UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return[self findBestViewController:viewController];
}

//递归方法
- (UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    }else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    }else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    }else{
        return vc;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
