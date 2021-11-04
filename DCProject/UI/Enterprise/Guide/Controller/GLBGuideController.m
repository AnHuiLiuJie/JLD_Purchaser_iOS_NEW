//
//  GLBGuideController.m
//  DCProject
//
//  Created by bigbing on 2019/7/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGuideController.h"

#import "GLBGuideBannerCell.h"
#import "GLBGuideItmeCell.h"
#import "GLBGuideInfoCell.h"
#import "GLBGuideIPCell.h"
#import "GLBGuideH5Cell.h"
#import "GLBGuidePersonIPCell.h"

#import "DCLoginController.h"
#import "GLBAddInfoController.h"
#import "GLBTypeGoodsListController.h"
#import "GLBNewsListController.h"
#import "GLBMessageListController.h"
#import "GLBYcjListController.h"
#import "GLBExhibtPageController.h"
#import "GLBPlantPageController.h"
#import "GLBTCMListController.h"
#import "DCTabbarController.h"
#import "GLBGoodsDetailController.h"
#import "GLBStorePageController.h"
#import "GLBExhibtPageController.h"
#import "GLPLoginController.h"
#import "GLPTabBarController.h"
#import "GLBSelectAreaController.h"

#import "GLBAdvModel.h"

//#import "STPickerSingle.h"
#import "ShowOneBigPicVC.h"

#import "DCNavigationController.h"
#import "GLBOpenTypeController.h"

static NSString *const bannerCellID = @"GLBGuideBannerCell";
static NSString *const itemCellID = @"GLBGuideItmeCell";
static NSString *const infoCellID = @"GLBGuideInfoCell";
static NSString *const ipCellID = @"GLBGuideIPCell";
static NSString *const h5CellID = @"GLBGuideH5Cell";
static NSString *const psersonIpCellID = @"GLBGuidePersonIPCell";

@interface GLBGuideController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UIButton *exchangeBtn;

@property (nonatomic, strong) NSMutableArray<GLBAdvModel *> *bannerArray;

@end

@implementation GLBGuideController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    GLBGuideBannerCell *bannerCell = (GLBGuideBannerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [bannerCell.scrollView adjustWhenControllerViewWillAppera];
    
    [self dc_navBarLucency:YES];
    
    if (@available(iOS 13.0, *)) {
        [self dc_statusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        [self dc_statusBarStyle:UIStatusBarStyleLightContent];
    }
    [self dc_navBarTitleWithFont:[UIFont fontWithName:PFR size:18] color:[UIColor whiteColor]];
    
    [[DCUpdateTool shareClient] requestIsUpdate];
    
    [self dc_showLoginBtn];
    
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    if (![DCObjectManager dc_readUserDataForKey:DC_UserID_Key]) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dc_leftItemWithImage:[UIImage imageNamed:@"dc_arrow_left_white"] target:self action:@selector(backItemAAAAA:)];
    } else {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dc_leftItemWithImage:[UIImage imageNamed:@"dc_placeholder_bg"] target:self action:@selector(backItemBBBB:)];
    }
}


- (void)backItemAAAAA:(id)sender
{
    DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBOpenTypeController new]];
}

- (void)backItemBBBB:(id)sender
{
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarLucency:NO];
    if (@available(iOS 13.0, *)) {
        [self dc_statusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        [self dc_statusBarStyle:UIStatusBarStyleDefault];
    }
    //    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    [self dc_navBarTitleWithFont:[UIFont fontWithName:PFR size:18] color:[UIColor dc_colorWithHexString:@"#333333"]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"金利达药品交易网";
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.exchangeBtn];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tableView];
    
    [self requestBannerData];
    
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerLogin:) name:DC_RegisterLogin_Notification object:nil];
    
    // 无地区数据。缓存
    if (![DCObjectManager dc_readUserDataForKey:DC_AreaData_Key]) {
        [[GLBSelectAreaController shareInstance] dc_getAllAreaData];
    }
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        GLBGuideBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:bannerCellID forIndexPath:indexPath];
        bannerCell.scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            [weakSelf dc_pushController:weakSelf.bannerArray[currentIndex]];
        };
        cell = bannerCell;
        
    } else if (indexPath.section == 1) {
        
        GLBGuideItmeCell *itemCell = [tableView dequeueReusableCellWithIdentifier:itemCellID forIndexPath:indexPath];
        itemCell.itemCellBlock = ^(NSInteger tag) {
            [weakSelf itemBtnClick:tag];
        };
        cell = itemCell;
        
    } else if (indexPath.section == 2){
        
        GLBGuideInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellID forIndexPath:indexPath];
        infoCell.infoCellBlock = ^{
            ShowOneBigPicVC *vc = [[ShowOneBigPicVC alloc] init];
            vc.modalPresentationStyle=UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        };
        cell = infoCell;
        
    }
    //       else if (indexPath.section == 3){
    //
    //        GLBGuideIPCell *ipCell = [tableView dequeueReusableCellWithIdentifier:ipCellID forIndexPath:indexPath];
    //        ipCell.reloadBlock = ^{
    //
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    //                [weakSelf.tableView reloadData];
    //            });
    //
    //        };
    //        cell = ipCell;
    //
    //    } else if (indexPath.section == 4){
    //
    ////        GLBGuideH5Cell *h5Cell = [tableView dequeueReusableCellWithIdentifier:h5CellID forIndexPath:indexPath];
    ////        h5Cell.reloadBlock = ^{
    ////
    ////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    ////                [SVProgressHUD showSuccessWithStatus:@"请求成功"];
    ////                [weakSelf.tableView reloadData];
    ////            });
    ////
    ////        };
    ////        cell = h5Cell;
    //
    //        GLBGuidePersonIPCell *personIpCell = [tableView dequeueReusableCellWithIdentifier:psersonIpCellID forIndexPath:indexPath];
    //        personIpCell.reloadBlock = ^{
    //
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    //                [weakSelf.tableView reloadData];
    //            });
    //
    //        };
    //        cell = personIpCell;
    //
    //    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

//#pragma mark - 创建性别选择器
//- (void)createSTPickerSingleWithTitle:(NSString *)title datas:(NSArray *)datas
//{
//    if ([DC_KeyWindow.subviews.lastObject isKindOfClass:[STPickerSingle class]]) {
//        return;
//    }
//    STPickerSingle *single = [[STPickerSingle alloc] init];
//    [single setArrayData:[datas mutableCopy]];
//    [single setTitle:title];
//    single.font = [UIFont fontWithName:PFR size:14];
//    single.titleColor = [UIColor dc_colorWithHexString:@"#3D444D"];
//    single.widthPickerComponent = kScreenW;
//    single.heightPickerComponent = 35;
//    [single setContentMode:STPickerContentModeBottom];
//    [single setDelegate:self];
//    [single show];
//}


//#pragma mark - <STPickerSingleDelegate>
//- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
//{
//    if (![_exchangeBtn.titleLabel.text isEqualToString:selectedTitle]) {
//
//        if (![DCObjectManager dc_readUserDataForKey:DC_UserID_Key] && ![DCObjectManager dc_readUserDataForKey:P_UserID_Key]) {
//
//            [self dc_exchangeUserType:selectedTitle];
//
//        } else {
//
//            WEAKSELF;
//            DCAlterView *alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"切换用户类型后，已登录的状态将被清空，确定要切换用户？"];
//            [alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
//            [alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
//                [weakSelf dc_exchangeUserType:selectedTitle];
//            }];
//
//            [DC_KeyWindow addSubview:alterView];
//            [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(DC_KeyWindow);
//            }];
//
//        }
//    }
//
//}


//#pragma mark - 切换用户类型
//- (void)dc_exchangeUserType:(NSString *)selectedTitle
//{
//    // 清空登录状态
//    [[DCLoginTool shareTool] dc_removeLoginDataWithCompany];
//    
//    [_exchangeBtn setTitle:selectedTitle forState:0];
//    
//    if ([selectedTitle isEqualToString:@"企业版"]) {
//        [DCObjectManager dc_saveUserData:@(DCUserTypeWithCompany) forKey:DC_UserType_Key];
//    } else if ([selectedTitle isEqualToString:@"个人版"]) {
//        [DCObjectManager dc_saveUserData:@(DCUserTypeWithPerson) forKey:DC_UserType_Key];
//    }
//    
//    [self dc_showLoginBtn];
//}


#pragma mark - 登录按钮显示与隐藏
- (void)dc_showLoginBtn
{
    self.navigationItem.rightBarButtonItem = nil;
    
    NSInteger userType = [[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue];
    if (userType == DCUserTypeWithCompany) { // 企业版
        
        if ([DCObjectManager dc_readUserDataForKey:DC_UserID_Key]) { // 已登录
            
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_rightItemWithImage:[UIImage imageNamed:@"wd_mine"] target:self action:@selector(mineAction:)];
            
        } else { // 未登录
            
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"登录" color:[UIColor whiteColor] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(loginAction:)];
            
        }
        
    } else if (userType == DCUserTypeWithPerson) { // 个人版
        
        if ([DCObjectManager dc_readUserDataForKey:P_UserID_Key]) { // 已登录
            
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_rightItemWithImage:[UIImage imageNamed:@"wd_mine"] target:self action:@selector(mineAction:)];
            
        } else { // 未登录
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"登录" color:[UIColor whiteColor] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(loginAction:)];
        }
    }
}


#pragma mark - action
- (void)loginAction:(id)sender
{
    NSInteger userType = [[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue];
    if (userType == DCUserTypeWithCompany) {
        
        [self dc_pushNextController:[DCLoginController new]];
        
    } else if (userType == DCUserTypeWithPerson) {
        
        [self dc_pushNextController:[GLPLoginController new]];
    }
}

- (void)mineAction:(id)sender
{
    NSInteger userType = [[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue];
    if (userType == DCUserTypeWithCompany) {
        
        DCTabbarController *vc = [[DCTabbarController alloc] init];
        vc.selectedIndex = 3;
        DC_KeyWindow.rootViewController = vc;
        
    } else if (userType == DCUserTypeWithPerson) {
        
        GLPTabBarController *vc = [[GLPTabBarController alloc] init];
        vc.selectedIndex = 3;
        DC_KeyWindow.rootViewController = vc;
    }
}

//- (void)exchangeBtnClick:(UIButton *)button
//{
//    [self createSTPickerSingleWithTitle:@"请选择用户类型" datas:@[@"企业版",@"个人版"]];
//}

- (void)itemBtnClick:(NSInteger)tag
{
    if (tag == 0) { // 药健康
        [self dc_pushTypeGoodsListController:GLBGoodsTypeYjk];
    }
    //    if (tag == 0) { //药控消
    //        [self dc_pushTypeGoodsListController:GLBGoodsTypeYkx];
    //    }
    if (tag == 1) { // 药招标
        [self dc_pushTypeGoodsListController:GLBGoodsTypeYzb];
    }
    if (tag == 2) { // 药采购
        DC_KeyWindow.rootViewController = [[DCTabbarController alloc] init];
    }
    if (tag == 3) { // 药资讯
        [self dc_pushNextController:[GLBNewsListController new]];
    }
    if (tag == 4) { // 药消息
        [self dc_pushNextController:[GLBMessageListController new]];
    }
    if (tag == 5) { // 药集采
        [self dc_pushNextController:[GLBYcjListController new]];
    }
    if (tag == 6) { // 药交会
        [self dc_pushNextController:[GLBExhibtPageController new]];
    }
    if (tag == 7) { // 药种植
        [self dc_pushNextController:[GLBPlantPageController new]];
    }
    if (tag == 8) { // 中草药
        [self dc_pushNextController:[GLBTCMListController new]];
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


#pragma mark - push
- (void)dc_pushTypeGoodsListController:(GLBGoodsType)type
{
    GLBTypeGoodsListController *vc = [GLBTypeGoodsListController new];
    vc.goodsType = type;
    if (type == GLBGoodsTypeRmsx) {
        vc.entrance = @"3";
        vc.catIds = @"11,12,16,26,14,15,25,24";
    } else if (type == GLBGoodsTypeYhcx) {
        vc.entrance = @"4";
        vc.isPromotion = @"1";
        vc.catIds = @"11,12,16,26,14,15,25,24";
    } else if (type == GLBGoodsTypeYkx) {
        vc.entrance = @"1";
        vc.catIds = @"11,12,16,26";
    } else if (type == GLBGoodsTypeYzb) {
        vc.entrance = @"2";
        vc.catIds = @"11,12,16,26";
    } else if (type == GLBGoodsTypeYjk) {
        vc.entrance = @"0";
        vc.catIds = @"13,23,15,24,25";
    }
    [self dc_pushNextController:vc];
}



#pragma mark - 获取通知 注册成功 -> 登录
- (void)registerLogin:(NSNotification *)sender
{
    NSDictionary *params = sender.userInfo;
    
    NSString *userName = params[@"loginName"];
    NSString *password = params[@"firmLoginPwd"];
    
    [self requestLogin:userName password:password];
}


#pragma mark - 请求banner
- (void)requestBannerData
{
    [self.bannerArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAdvWithCode:@"AD_APP_GUIDE" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.bannerArray addObjectsFromArray:response];
            
            NSMutableArray *imgurlArray = [NSMutableArray array];
            for (int i =0; i<weakSelf.bannerArray.count; i++) {
                [imgurlArray addObject:[weakSelf.bannerArray[i] adContent]];
            }
            GLBGuideBannerCell *bannerCell = (GLBGuideBannerCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            bannerCell.scrollView.imageURLStringsGroup = nil;
            bannerCell.scrollView.imageURLStringsGroup = imgurlArray;
            
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 登录
- (void)requestLogin:(NSString *)userName password:(NSString *)password
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestPsdLoginWithLoginName:userName loginPwd:password userType:@"1" success:^(id response) {
        if (response) {
            
            GLBAddInfoController *vc = [GLBAddInfoController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 8*2, kScreenH - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 8.0f;
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:NSClassFromString(bannerCellID) forCellReuseIdentifier:bannerCellID];
        [_tableView registerClass:NSClassFromString(itemCellID) forCellReuseIdentifier:itemCellID];
        [_tableView registerClass:NSClassFromString(infoCellID) forCellReuseIdentifier:infoCellID];
        [_tableView registerClass:NSClassFromString(ipCellID) forCellReuseIdentifier:ipCellID];
        [_tableView registerClass:NSClassFromString(h5CellID) forCellReuseIdentifier:h5CellID];
        [_tableView registerClass:NSClassFromString(psersonIpCellID) forCellReuseIdentifier:psersonIpCellID];
    }
    return _tableView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.6*kScreenW)];
        _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#5FCFC5"];
    }
    return _bgView;
}

//- (UIButton *)exchangeBtn{
//    if (!_exchangeBtn) {
//        
//        NSString *title = @"";
//        NSInteger type = [[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue];
//        if (type == DCUserTypeWithCompany) {
//            title = @"企业版";
//        } else if (type == DCUserTypeWithPerson) {
//            title = @"个人版";
//        }
//        
//        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_exchangeBtn setTitle:title forState:0];
//        [_exchangeBtn setTitleColor:[UIColor whiteColor] forState:0];
//        _exchangeBtn.adjustsImageWhenHighlighted = NO;
//        _exchangeBtn.titleLabel.font = PFRFont(14);
//        [_exchangeBtn setImage:[UIImage imageNamed:@"guidedown"] forState:0];
//        [_exchangeBtn setImage:[UIImage imageNamed:@"guidedown"] forState:UIControlStateSelected];
//        [_exchangeBtn addTarget:self action:@selector(exchangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _exchangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _exchangeBtn.bounds = CGRectMake(0, 0, 100, 35);
//        [_exchangeBtn dc_buttonIconRightWithSpacing:10];
//    }
//    return _exchangeBtn;
//}


- (NSMutableArray<GLBAdvModel *> *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}


#pragma mark - delloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_RegisterLogin_Notification object:nil];
}

@end
