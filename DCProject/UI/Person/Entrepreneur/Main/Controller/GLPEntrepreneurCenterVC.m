//
//  GLPEntrepreneurCenterVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import "GLPEntrepreneurCenterVC.h"

#import "GLPEtpCenterHeaderView.h"
#import "GLPEtpCenterFooterView.h"
#import "DCGridItem.h"
#import "GLPEtpCenterBannerCell.h"
#import "GLPEtpCenterFunctionalCell.h"
#import "GLPEtpCenterRebateCell.h"
#import "GLPEtpCenterTopToolView.h"
#import "GLPEtpUserInfoController.h"
#import "GLPEtpRecordController.h"
#import "GLPEtpWithdrawController.h"
#import "GLPEtpStatisticsController.h"
#import "GLPEtpServiceFeePageVC.h"
#import "GLPEtpWithdrawalsRecordVC.h"
#import "GLPEtpCustomerSourcePageVC.h"
#import "GLPEtpInviteCustomerVC.h"
#import "GLPEtpPioneerCollegePageVC.h"
#import "DCAPIManager+PioneerRequest.h"
#import "EntrepreneurInfoModel.h"
#import "EtpRuleDescriptionView.h"
#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + kNavBarHeight*2)
#define IMAGE_HEIGHT (CGFloat)(YYISiPhoneX?(240):(220))
#define SLIDE_HEIGHT (CGFloat)(YYISiPhoneX?(150):(130))


typedef void(^etprepreneurCenterb2c_pioneer_reportBlock)(EntrepreneurReportModel *model);
typedef void(^etprepreneurCenterb2c_pioneer_viewBlock)(EntrepreneurInfoModel *model);


@interface GLPEntrepreneurCenterVC ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

/* headerView */
@property (nonatomic, strong) GLPEtpCenterHeaderView *headerView;
/* footerView */
@property (nonatomic, strong) GLPEtpCenterFooterView *footerView;
/* 头部背景图片 */
@property (nonatomic, strong) UIImageView *headerBgImageView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 顶部Nva */
@property (strong , nonatomic) GLPEtpCenterTopToolView *topToolView;
/* 服务数据1 */
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *stateItem;
@property (strong , nonatomic)NSMutableArray<FHXSingleTrendModel *> *listArray;


@property (strong , nonatomic) EntrepreneurInfoModel *userInfoModel;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, copy) NSString *dayStr;

@end



static NSString *const GLPEtpCenterBannerCellID = @"GLPEtpCenterBannerCell";
static NSString *const GLPEtpCenterFunctionalCellID = @"GLPEtpCenterFunctionalCell";
static NSString *const GLPEtpCenterRebateCellID = @"GLPEtpCenterRebateCell";

@implementation GLPEntrepreneurCenterVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_navBarHidden:YES animated:animated];
    [self setUpNavTopView];
    if (!_isFirstLoad) {
        [self requestLoadData];
        _isFirstLoad = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

//    [self dc_statusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dc_navBarHidden:NO animated:animated];
    
//    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    [self dc_navBarBackGroundcolor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dc_statusBarStyle:UIStatusBarStyleDefault];

    //self.title = @"创业者中心";
    self.title = @"";
    self.userInfoModel = nil;
    
    [self setUpBase];
    [self setUpHeaderCenterView];
    [self setUpFooterCenterView];
    
    self.dayStr = @"7";
}

#pragma mark - 请求 申请创业者
- (void)requestLoadData{

    WEAKSELF;

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_viewWithSuccess:^(id response) {
        NSDictionary *userDic = response[@"data"];
        EntrepreneurInfoModel *userInfoModel = [EntrepreneurInfoModel mj_objectWithKeyValues:userDic];
        weakSelf.userInfoModel = userInfoModel;
        //[weakSelf updataViewUI];
        //[weakSelf jumpEntrepreneurPoster];
        dispatch_group_leave(group);
    } failture:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_reportWithDays:self.dayStr success:^(id response) {
        NSDictionary *userDic = response[@"data"];
        EntrepreneurReportModel *userInfoModel = [EntrepreneurReportModel mj_objectWithKeyValues:userDic];
        [weakSelf getNeedFormDataArray:userInfoModel];
        dispatch_group_leave(group);
        //[weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        dispatch_group_leave(group);
    }];
     
     dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf updataViewUI];
             [weakSelf jumpEntrepreneurPoster];
             [weakSelf.tableView reloadData];
         });
     });

}

- (void)getNeedFormDataArray:(EntrepreneurReportModel *)data
{
    [self.listArray removeAllObjects];
    NSMutableArray *listArr = [[NSMutableArray alloc] init];
    NSArray *array1 = [data.days componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    NSArray *array2 = [data.amounts componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    for (int i = 0; i<array1.count-1; i++) {
        FHXSingleTrendModel *model = [[FHXSingleTrendModel alloc] init];
        model.x = array1[i];
        model.y = array2[i];
        [listArr addObject:model];
    }
    
    self.listArray = [listArr mutableCopy];
    
}

- (void)updataViewUI{
    self.userInfoModel.userName.length > 0 ? (_headerView.memberLab.text = self.userInfoModel.userName) : (_headerView.memberLab.text = @"***");
    
    _headerView.allServiceLab.text = self.userInfoModel.totalServiceFee;
    _headerView.availableLab.text = self.userInfoModel.withdrawServiceFee;
    
    
    [_headerView.gradeImg sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.pioneerLevelIcon] placeholderImage:[UIImage imageNamed:@"etp_center_grade"]];

}

#pragma mark - initialize
- (void)setUpBase
{
    _stateItem = [DCGridItem mj_objectArrayWithFilename:@"MyServiceFlow.plist"];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    self.topToolView.hidden = NO;
}

#pragma mark - 初始化头部
- (void)setUpHeaderCenterView{
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerBgImageView.frame = self.headerView.bounds;
    [self.headerView insertSubview:self.headerBgImageView atIndex:0]; //将背景图片放到最底层
    
    WEAKSELF;
    self.headerView.headerViewClickBlock = ^(NSInteger tag) {
        if (tag == 1) {//头像 个人资料
            if (self.userInfoModel.userId != nil) {
                GLPEtpUserInfoController *vc = [GLPEtpUserInfoController new];
                vc.userInfoModel = weakSelf.userInfoModel;
                [weakSelf dc_pushNextController:vc];
            }
        }else if(tag == 2){//记录
            GLPEtpRecordController *vc = [GLPEtpRecordController new];
            [weakSelf dc_pushNextController:vc];
        }else if(tag == 3){//提现
            weakSelf.isFirstLoad = NO;
            GLPEtpWithdrawController *vc = [GLPEtpWithdrawController new];
            [weakSelf dc_pushNextController:vc];
        }else if(tag == 4){//登记规则
            EtpRuleDescriptionView *view = [[EtpRuleDescriptionView alloc] init];
            view.showType = EtpRuleDescriptionViewTypeGrade;
            view.titile_str = @"等级规则";
            view.frame = DC_KEYWINDOW.bounds;
            [DC_KEYWINDOW addSubview:view];
        }
    };

}

#pragma mark - setUpFooterCenterView
- (void)setUpFooterCenterView{
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cusCell = [UITableViewCell new];
    if (indexPath.section == 0) {
        GLPEtpCenterBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPEtpCenterBannerCellID forIndexPath:indexPath];
        cusCell = cell;
    }else if(indexPath.section == 1){
        GLPEtpCenterFunctionalCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPEtpCenterFunctionalCellID forIndexPath:indexPath];
        cell.serviceItemArray = [NSMutableArray arrayWithArray:_stateItem];
        WEAKSELF;
        cell.stateItemItemClickBlock = ^(NSString *_Nonnull title) {
            NSLog(@"第二CELL点击了 %@",title);
            [weakSelf stateItemClickAction:title];
        };
        cusCell = cell;
    }else if (indexPath.section == 2){
        GLPEtpCenterRebateCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPEtpCenterRebateCellID forIndexPath:indexPath];
        cell.title = @"";
        cell.unitStr = @"元";
        cell.type = 3;
        cell.dataArray = self.listArray;
        WEAKSELF;
        cell.GLPEtpCenterRebateCell_block = ^(NSInteger btnTag) {
            if (btnTag == 1) {//7tian
                self.dayStr = @"7";
            }else{
                self.dayStr = @"30";
            }
            
            [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_reportWithDays:self.dayStr success:^(id response) {
                NSDictionary *userDic = response[@"data"];
                EntrepreneurReportModel *userInfoModel = [EntrepreneurReportModel mj_objectWithKeyValues:userDic];
                [weakSelf getNeedFormDataArray:userInfoModel];
                [weakSelf.tableView reloadData];
            } failture:^(NSError *error) {
            }];
        };
        cusCell = cell;
    }
    cusCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cusCell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];//创业者申请
//        vc.userInfoModel = self.userInfoModel;
//        [self dc_pushNextController:vc];
        GLPEtpPioneerCollegePageVC *vc = [GLPEtpPioneerCollegePageVC new];
        vc.index = 0;
        [self dc_pushNextController:vc];
    }
}

- (void)jumpEntrepreneurPoster{
//    if (self.userInfoModel != nil && self.userInfoModel.userId.length == 0) {
//        [[DCAlterTool shareTool] showCustomWithTitle:@"创业者申请" message:@"您目前尚未申请成为创业者" customTitle1:@"前往申请" handler1:^(UIAlertAction *_Nonnull action) {
//            GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];//创业者申请
//            vc.userInfoModel = self.userInfoModel;
//            [self dc_pushNextController:vc];
//        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    }else{
//        if (self.userInfoModel == nil) {
//            GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];//创业者申请
//            vc.userInfoModel = self.userInfoModel;
//            [self dc_pushNextController:vc];
//        }
//    }
    
    if (self.userInfoModel == nil) {
        GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];//创业者申请
        vc.userInfoModel = self.userInfoModel;
        [self dc_pushNextController:vc];
    }else{
        if (self.userInfoModel.userId.length == 0) {
            [[DCAlterTool shareTool] showCustomWithTitle:@"创业者申请" message:@"您目前尚未申请成为创业者" customTitle1:@"前往申请" handler1:^(UIAlertAction *_Nonnull action) {
                GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];//创业者申请
                vc.userInfoModel = self.userInfoModel;
                [self dc_pushNextController:vc];
            } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            if ([self.userInfoModel.state integerValue] == 2) {
                GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
                vc.statusType = EtpApprovalStatusReviewing;
                [self dc_pushNextController:vc];
            }else if ([self.userInfoModel.state integerValue] == 3) {
                GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
                vc.statusType = EtpApprovalStatusReviewFailure;
                [self dc_pushNextController:vc];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 1){
        CGFloat count = self.stateItem.count;
        CGFloat h = ceil(count/3) *85;
        if (isPhone6below) {
            h = ceil(count/3) *75;
        }
        return  h + 20;
    }else if (indexPath.section == 2){
        return 250;
    }
    return 0;
}

- (void)stateItemClickAction:(NSString *)title{
    if ([title isEqualToString:@"数据统计"]) {
        GLPEtpStatisticsController *vc = [GLPEtpStatisticsController new];
        [self dc_pushNextController:vc];
    }else if([title isEqualToString:@"服务费明细"]){
        GLPEtpServiceFeePageVC *vc = [GLPEtpServiceFeePageVC new];
        [self dc_pushNextController:vc];
    }else if([title isEqualToString:@"提现记录"]){
        GLPEtpWithdrawalsRecordVC *vc = [GLPEtpWithdrawalsRecordVC new];
        [self dc_pushNextController:vc];
    }else if([title isEqualToString:@"我的客源"]){
        GLPEtpCustomerSourcePageVC *vc = [GLPEtpCustomerSourcePageVC new];
        vc.index = 0;
        [self dc_pushNextController:vc];
    }else if([title isEqualToString:@"邀请客源"]){
        GLPEtpInviteCustomerVC *vc = [GLPEtpInviteCustomerVC new];
        [self dc_pushNextController:vc];
    }else if([title isEqualToString:@"创客学院"]){
        GLPEtpPioneerCollegePageVC *vc = [GLPEtpPioneerCollegePageVC new];
        vc.index = 0;
        [self dc_pushNextController:vc];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat topH = kNavBarHeight;
    
    NSLog(@"offsetY--%f",offsetY);
    if (offsetY < 0) {
        if (offsetY > -topH) {
            CGFloat alpha = (offsetY + topH) / topH;
            [self.topToolView wr_setBackgroundAlpha:alpha];
        }else{
            [self.topToolView wr_setBackgroundAlpha:0];
            self.topToolView.backgroundColor = [UIColor clearColor];
        }
    }else if (offsetY == 0) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.topToolView wr_setBackgroundAlpha:1];
            self.topToolView.backgroundColor = [UIColor clearColor];
        }];
    }else{
        [self.topToolView wr_setBackgroundAlpha:1];
        if (offsetY > SLIDE_HEIGHT - topH) {
            self.topToolView.backgroundColor = RGB_COLOR(24, 143, 246);
        }else{
            CGFloat alpha = (offsetY -SLIDE_HEIGHT + topH*2) / topH;
            if (alpha < 0 ) {
                return;
            }
            //[self.topToolView wr_setBackgroundAlpha:alpha];
            self.topToolView.backgroundColor = RGBA_COLOR(24, 143, 246,alpha);
        }
    }
    
    //图片高度
    CGFloat imageHeight = self.headerView.dc_height;
    //图片宽度
    CGFloat imageWidth = kScreenW;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        self.headerBgImageView.frame = CGRectMake(-(imageWidth *f - imageWidth) *0.5, imageOffsetY, imageWidth *f, totalOffset);
        
        self.headerBgImageView.frame = CGRectMake(0, imageOffsetY, imageWidth, totalOffset);
    }
}

#pragma mark - LazyLoad -
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0,0, kScreenW, kScreenH-LJ_TabbarSafeBottomMargin);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[GLPEtpCenterBannerCell class] forCellReuseIdentifier:GLPEtpCenterBannerCellID];
        [_tableView registerClass:[GLPEtpCenterFunctionalCell class] forCellReuseIdentifier:GLPEtpCenterFunctionalCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPEtpCenterRebateCell class]) bundle:nil] forCellReuseIdentifier:GLPEtpCenterRebateCellID];
    }
    return _tableView;
}

- (UIImageView *)headerBgImageView{
    if (!_headerBgImageView) {
        _headerBgImageView = [[UIImageView alloc] init];
        [_headerBgImageView setImage:[UIImage imageNamed:@"etp_center_bg"]];
        [_headerBgImageView setBackgroundColor:[UIColor clearColor]];
        [_headerBgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headerBgImageView setClipsToBounds:YES];
    }
    return _headerBgImageView;
}

- (GLPEtpCenterHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [GLPEtpCenterHeaderView dc_viewFromXib];
        _headerView.frame = CGRectMake(0, 0, kScreenW, IMAGE_HEIGHT);

    }
    return _headerView;
}

- (GLPEtpCenterFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[GLPEtpCenterFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, kScreenW, 5);
    }
    return _footerView;
}

- (NSMutableArray<DCGridItem *> *)stateItem
{
    if (!_stateItem) {
        _stateItem = [NSMutableArray array];
    }
    return _stateItem;
}

- (NSMutableArray<FHXSingleTrendModel *> *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
        
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//        FHXSingleTrendModel *model = [[FHXSingleTrendModel alloc]init];
//        model.x = @"24";
//        model.y = @"20";
//        [array addObject:model];
//
//        FHXSingleTrendModel *model1 = [[FHXSingleTrendModel alloc]init];
//        model1.x = @"23";
//        model1.y = @"0";
//        [array addObject:model1];
//
//        FHXSingleTrendModel *model2 = [[FHXSingleTrendModel alloc]init];
//        model2.x = @"22";
//        model2.y = @"17.1";
//        [array addObject:model2];
//
//        FHXSingleTrendModel *model3 = [[FHXSingleTrendModel alloc]init];
//        model3.x = @"21";
//        model3.y = @"240";
//        [array addObject:model3];
//
//        FHXSingleTrendModel *model4 = [[FHXSingleTrendModel alloc]init];
//        model4.x = @"20";
//        model4.y = @"67.82";
//        [array addObject:model4];
//
//        FHXSingleTrendModel *model5 = [[FHXSingleTrendModel alloc]init];
//        model5.x = @"19";
//        model5.y = @"390";
//        [array addObject:model5];
//
//        FHXSingleTrendModel *model6 = [[FHXSingleTrendModel alloc]init];
//        model6.x = @"18";
//        model6.y = @"2";
//        [array addObject:model6];
//
//        _listArray = array;
    }
    return _listArray;
}

- (GLPEtpCenterTopToolView *)topToolView{
    if (!_topToolView) {
        _topToolView = [[GLPEtpCenterTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _topToolView.leftItemClickBlock = ^{ //点击了左侧
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        [self.view addSubview:_topToolView];
    }
    return _topToolView;
}

#pragma mark - Dealloc
- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
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
