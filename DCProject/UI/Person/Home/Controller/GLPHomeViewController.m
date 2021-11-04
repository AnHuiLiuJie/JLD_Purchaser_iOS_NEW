//
//  GLPHomeViewController.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeViewController.h"
#import "DCRefreshTool.h"

#import "GLPHomeNavigationBar.h"
#import "GLPHomeHeadView.h"
#import "GLPHomeActivityCell.h"
//#import "GLPHomeSeasonCell.h"//活动专区
#import "GLPHomeTypeCell.h"
//#import "GLPHomeHotCell.h"//热销榜
#import "GLPHomeClassCell.h"
#import "GLPHomeRecommendCell.h"
#import "ConpvBg.h"
#import "GLPGoodsDetailsController.h"//详情
#import "TRStorePageVC.h"
#import "GLPSearchGoodsController.h"
#import "GLPClassController.h"
#import "TRHotCommdityVC.h"
#import "TRCouponCentrePageVC.h"
#import "GLBGuideController.h"
#import "DCNavigationController.h"
#import "GLPMessageListVC.h"
#import "HomeRecommListVC.h"
#import "HomeHotListVC.h"
#import "DCUMShareTool.h"
#import "JPFPSStatus.h"
#import "GLPEntrepreneurCenterVC.h"
#import "GLPEtpEventInvitationVC.h"
#import "GLPActivityAreaListVC.h"
#import "GLPHomeSpikeCell.h"
#import "GLPHomeGroupBuyCell.h"
#import "GLPSpikeListPageVC.h"
#import "GLPGroupBuyHomeListVC.h"
typedef void(^GLPRecommendBlock)(GLPHomeDataModel *dataModel);
typedef void(^GLPRecommendNewBlock)(GLPHomeNewDataModel *dataModel);
typedef void(^back_block)(id response);

static NSString *const activityCellID = @"GLPHomeActivityCell";
static NSString *const GLPHomeGroupBuyCellID = @"GLPHomeGroupBuyCell";
static NSString *const GLPHomeSpikeCellID = @"GLPHomeSpikeCell";
static NSString *const typeCellID = @"GLPHomeTypeCell";
static NSString *const classCellID = @"GLPHomeClassCell";
static NSString *const recommendCellID = @"GLPHomeRecommendCell";


@interface GLPHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) GLPCustomXFView *xfView;//活动悬浮

@property (nonatomic, strong) GLPHomeNavigationBar *navBar;
@property (nonatomic, strong) GLPHomeHeadView *headView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<GLPAdModel *> *bannerArray; // banner
@property (nonatomic, strong) GLPHomeNewDataModel *homeModel; // 首页数据
@property (nonatomic, strong) GLPHomeDataModel *activityModel; // 活动
@property (nonatomic, strong) GLPHomeDataModel *seasonModel; // 季节
@property (nonatomic, strong) GLPHomeDataModel *hotModel; // 热销榜

@property (nonatomic, strong) NSMutableArray<GLPHomeDataModel *> *floorList; // 楼层数据
//@property (nonatomic, strong) GLPHomeDataModel *floorModel1; // 推荐1
//@property (nonatomic, strong) GLPHomeDataModel *floorModel2; // 推荐2
//@property (nonatomic, strong) GLPHomeDataModel *floorModel3; // 推荐3
//@property (nonatomic, strong) GLPHomeDataModel *floorModel4; // 推荐4
@property (nonatomic, strong) GLPHomeDataModel *recommendModel; // 热点推荐
@property (nonatomic,strong)  ConpvBg *contBg ;

@property (nonatomic) CGRect xfViewFrame;
@property (nonatomic,assign) NSInteger extendType;//0-普通用户【进入申请界面】，1-创业者【正常推广】，2-创业者【待审核】，3-创业者【审核不通过】，4-创业者【禁用】，5-服务商员工【不可推广】

@property (nonatomic,assign) BOOL isFirstLoad;

@end

@implementation GLPHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dc_navBarHidden:YES animated:animated];
    [self dc_navBarLucency:YES];//解决侧滑显示白色
    [self.headView.scrollView adjustWhenControllerViewWillAppera];
    
    if (!_isFirstLoad) {
        _isFirstLoad = YES;
    }
    
    [self requestNoReadMsgCount_Block:^(id response) {
    }];
    
    /*Add_HX_标识
     *更新环信
     */
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestPersonDataWithisShowHUD:NO Success:^(id response) {
        NSDictionary *dic = response[@"data"];
        NSString *extendType = dic[@"extendType"] ?  dic[@"extendType"] : @"0";
        weakSelf.extendType = [extendType integerValue];
        if (weakSelf.extendType == 1) {
            [weakSelf.xfView.showImg setImage:[UIImage imageNamed:@"dc_activity_yes"]];
        }else
            [weakSelf.xfView.showImg setImage:[UIImage imageNamed:@"dc_activity_no"]];
        
    } failture:^(NSError *error) {
    }];
    
    CGFloat y = self.tableView.contentOffset.y;
    if (y > kNavBarHeight) {
        [self dc_statusBarStyle:UIStatusBarStyleDefault];
    }else{
        [self dc_statusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.xfView.hidden = NO;
    self.xfView.frame = self.xfViewFrame;
    WEAKSELF;
    [_xfView setTapBlock:^(NSDictionary *_Nonnull linkDic) {
        //点击事件
        [weakSelf yaoqingBtnMethod];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO animated:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    
    self.xfViewFrame = self.xfView.frame;
    self.xfView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#if defined(DEBUG)||defined(_DEBUG) //仅仅在模拟器上跑测试会显示FPS
    [[JPFPSStatus sharedInstance] open];
#endif
    WEAKSELF;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    _headView.bannerViewBlock = ^(NSInteger selectindex) {
        GLPAdModel *model = weakSelf.bannerArray[selectindex];
        NSString *type = [NSString stringWithFormat:@"%@",model.infoType];
        NSString *infoid = [NSString stringWithFormat:@"%@",model.infoId];
        [weakSelf headViewBannerView:[type integerValue] withInfoId:infoid title:model.adTitle];
    };
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top);
        make.right.equalTo(self.view.right);
        make.height.equalTo(kNavBarHeight);
    }];
    
    self.extendType = 0;
    
    _contBg = [[ConpvBg alloc] init];
//    self.tableView.mj_header = [[DCRefreshTool shareTool] headerDefaultWithBlock:^{
//        [weakSelf requestHomeData:YES isShowHUD:NO];
//    }];
    [self loadNewData];
    
    [_contBg resh];//请求优惠卷
    
    [[DCUpdateTool shareClient] requestIsUpdate];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL isNeed = [[DCUpdateTool shareClient] judgeNeedVersionUpdate];
        if (isNeed) {
            if ([DCObjectManager dc_readUserDataForKey:P_Token_Key]){
            }
        }
    });
}

- (void)headViewBannerView:(NSInteger)type withInfoId:(NSString *)infoId title:(NSString *)title{
    if (type == 1){
        //商品
        [self dc_pushGoodsDetailsController:infoId];
    }else if (type == 2){
        //店铺
        TRStorePageVC *vc = [[TRStorePageVC alloc] init];
        vc.firmId = infoId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 3){
        //不跳转
    }else if (type == 4){
        //公益活动
    }else if (type == 5){
        //拼团列表
        GLPGroupBuyHomeListVC *vc = [[GLPGroupBuyHomeListVC alloc] init];
        vc.showType = 1;
        [self dc_pushNextController:vc];
    }else if (type == 6){
        //秒杀列表
        GLPSpikeListPageVC *vc = [[GLPSpikeListPageVC alloc] init];
        vc.index = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 7){
        //优惠券列表
        [self dc_pushNextController:[TRCouponCentrePageVC new]];
    }else if (type == 8){
        //热销产品跳转到热销产品列表
        HomeHotListVC *vc = [[HomeHotListVC alloc]init];
        //vc.title = title;//@"热销榜";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 9){
        //活动产品，跳转到活动产品列表
        HomeRecommListVC *vc = [[HomeRecommListVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        //vc.titleStr = title;//@"活动产品";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}

- (void)loadNewData{
    [self requestHomeData:YES isShowHUD:NO];
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5+self.floorList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (self.activityModel.dataList.count == 0) {
            return 0;
        }
    }else if(section == 2){
        if (self.homeModel.seckillList.count == 0) {
            return 0;
        }
    }else if(section == 3){
        if (self.homeModel.collageList.count == 0) {
            return 0;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//lj_change_约束
        return 20+75+20;//7DC09A
    }else if (indexPath.section >= 4 && indexPath.section < (4+self.floorList.count)){
        CGFloat bigHeight = (kScreenW - 14*2 - 12*2 - 7)/2;
        CGFloat smallHeight = (kScreenW - 14*2 - 12*2 - 7*3)/4;
        return 10+20+23+20+bigHeight+7+smallHeight;
    }else if (indexPath.section == 4+self.floorList.count){
        CGFloat hight_all = 0;
        if (self.floorList.count > 0) {
            hight_all = -50;
        }
        CGFloat kItemW =  (kScreenW - 14*2 - 10)/2;
        for (int i=0; i<self.recommendModel.dataList.count; i++) {
            if (i%2 == 0) {
                CGFloat height = kItemW + 10 + 5 + 5 + 5  + 25 + 10;
                
                GLPHomeDataListModel *listModel = self.recommendModel.dataList[i];
                GLPHomeDataGoodsModel *goodsModel = listModel.goodsVo;
                
                if (!goodsModel || (![goodsModel.isImport isEqualToString:@"1"] && ![goodsModel.isPromotion isEqualToString:@"1"] && ![goodsModel.isGroup isEqualToString:@"1"])) {
                    
                } else {
                    height += 20;
                }
                
                if (goodsModel && goodsModel.packingSpec.length > 0) {
                    height += 17;
                }
                
                NSString *title = @"";
                if (listModel && listModel.subTitle && listModel.subTitle.length > 0) {
                    title = listModel.subTitle;
                }
                if (title.length == 0) {
                    title = listModel.infoTitle;
                }
                
                CGFloat titleHeight = [title boundingRectWithSize:CGSizeMake(kItemW - 16, 42) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:15]} context:nil].size.height;
                height += titleHeight;

                hight_all = height+hight_all;
            }
        }
        return hight_all + 0.54*kScreenW;
    }
    else
        return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.section == 0) {
        GLPHomeTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:typeCellID forIndexPath:indexPath];
        typeCell.typeCellBlock = ^(NSInteger tag) {
            [weakSelf dc_typeCellBtnClick:tag];
        };
        cell = typeCell;
    } else if (indexPath.section == 1) {
        GLPHomeActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:activityCellID forIndexPath:indexPath];
        if (self.activityModel) {
            activityCell.activityModel = self.activityModel;
        }
        activityCell.activityblock = ^(GLPHomeDataListModel *_Nonnull listmodel) {
            NSString *type = [NSString stringWithFormat:@"%ld",(long)listmodel.infoType];
            NSString *infoid = [NSString stringWithFormat:@"%@",listmodel.infoId];
            if ([type isEqualToString:@"1"])
            {
                [weakSelf headViewBannerView:2 withInfoId:infoid title:listmodel.infoTitle];
            }
            else if ([type isEqualToString:@"2"])
            {
                [weakSelf dc_pushGoodsDetailsController:infoid];
            }
            else if ([type isEqualToString:@"3"])
            {
                [weakSelf dc_pushPersonWebController:@"/geren/activity_detail.html" params:[NSString stringWithFormat:@"id=%@",infoid]];
            }
            else if ([type isEqualToString:@"4"])
            {
                [weakSelf dc_pushGoodsDetailsController:infoid];
            }
        };
        activityCell.backgroundColor = RGB_COLOR(250, 250, 250);
        cell = activityCell;
        
    } else if (indexPath.section == 2) {//秒杀
        GLPHomeSpikeCell *spikeCell = [tableView dequeueReusableCellWithIdentifier:GLPHomeSpikeCellID forIndexPath:indexPath];
        if (self.homeModel.seckillList.count > 0) {
            spikeCell.spikeList = self.homeModel.seckillList;
        }
        spikeCell.GLPHomeSpikeCell_moreBlock = ^{
            [weakSelf headViewBannerView:6 withInfoId:@"" title:@""];
        };
        spikeCell.GLPHomeSpikeCell_clickGoodsBlock = ^(DCSeckillListModel * _Nonnull model) {
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId = model.goodsId;
            vc.batchId = model.batchId;
            [weakSelf dc_pushNextController:vc];
        };
        cell = spikeCell;
    } else if (indexPath.section == 3) {//团购
        GLPHomeGroupBuyCell *groupBuyCell = [tableView dequeueReusableCellWithIdentifier:GLPHomeGroupBuyCellID forIndexPath:indexPath];
        if (self.homeModel.collageList.count > 0) {
            groupBuyCell.collageList = self.homeModel.collageList;
        }
        groupBuyCell.GLPHomeGroupBuyCell_moreBlock = ^{
            [weakSelf headViewBannerView:5 withInfoId:@"" title:@""];
        };
        groupBuyCell.GLPHomeGroupBuyCell_clickGoodsBlock = ^(DCCollageListModel * _Nonnull model) {
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId = model.goodsId;
            vc.batchId = model.batchId;
            [weakSelf dc_pushNextController:vc];
        };
        cell = groupBuyCell;
    } else if (indexPath.section >= 4 && indexPath.section < (4+self.floorList.count)) {
        NSLog(@"AAAindexPath.section %ld",indexPath.section);
        GLPHomeClassCell *classCell ;
        classCell = [tableView dequeueReusableCellWithIdentifier:classCellID forIndexPath:indexPath];
        classCell.arte = NO;
        GLPHomeDataModel *floorModel = self.floorList[indexPath.section-4];
        [classCell setValueWithDataModel:floorModel indexPath:indexPath];
        classCell.viewBlock = ^(NSInteger tag) {
            NSArray *arr = floorModel.dataList;
            GLPHomeDataListModel *listModel = arr[tag-100];
            NSString *type = [NSString stringWithFormat:@"%ld",(long)listModel.infoType];
            NSString *infoid = [NSString stringWithFormat:@"%@",listModel.infoId];
            if ([type isEqualToString:@"1"])
            {
                [weakSelf headViewBannerView:2 withInfoId:infoid title:listModel.infoTitle];
            }
            else if ([type isEqualToString:@"2"])
            {
                [weakSelf dc_pushGoodsDetailsController:infoid];
            }
            else if ([type isEqualToString:@"3"])
            {
                [weakSelf dc_pushPersonWebController:@"/geren/activity_detail.html" params:[NSString stringWithFormat:@"id=%@",infoid]];
            }
            else if ([type isEqualToString:@"4"])
            {
                [weakSelf dc_pushGoodsDetailsController:infoid];
            }
        };
        
        cell = classCell;
        
    } else if (indexPath.section == (4+self.floorList.count)) {
        NSLog(@"indexPath.section %ld",indexPath.section);
        GLPHomeRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:recommendCellID forIndexPath:indexPath];
//        if (self.recommendModel) {
            recommendCell.recommendModel = self.recommendModel;
//        }
        recommendCell.recomblock = ^(GLPHomeDataListModel *_Nonnull recommendModel) {
            [weakSelf dc_pushGoodsDetailsController:recommendModel.infoId];
        };
        cell = recommendCell;
    }
    
    return cell;
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat topH = kNavBarHeight;
    
    if (offsetY < 0) {
        if (offsetY > -topH) {
            CGFloat alpha = (offsetY + topH -10) / topH;
            NSLog(@"-->%f ----%f",alpha,offsetY);
            [self.navBar wr_setBackgroundAlpha:alpha];
            if (offsetY < -20) {
                [self dc_statusBarStyle:UIStatusBarStyleDefault];
            }else
                [self dc_statusBarStyle:UIStatusBarStyleLightContent];
            
        }else{
            [self.navBar wr_setBackgroundAlpha:0];
            self.navBar.backgroundColor = [UIColor clearColor];
        }
    }else if (offsetY == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.navBar wr_setBackgroundAlpha:1];
            self.navBar.backgroundColor = [UIColor clearColor];
            [self dc_statusBarStyle:UIStatusBarStyleLightContent];
        }];
    }else{
        [self.navBar wr_setBackgroundAlpha:1];
        if (20 < offsetY < kNavBarHeight) {
            self.navBar.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:(offsetY - 20)/kNavBarHeight];
        }
        
        if (offsetY > kNavBarHeight) {
            self.navBar.isTop = YES;
            [self dc_statusBarStyle:UIStatusBarStyleDefault];
        }else{
            self.navBar.isTop = NO;
            [self dc_statusBarStyle:UIStatusBarStyleLightContent];
        }
    }
}


#pragma mark - action
- (void)dc_navBarItemClick:(NSInteger)tag
{
    if (tag == 900) { // 返回
        //DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewC   ontroller:[GLBGuideController new]];
        
        DCAlterView *alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"您确定要退出登录吗？"];
        [alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            [[DCAPIManager shareManager] person_requestLogoutWithSuccess:^(id response) {
                [[DCLoginTool shareTool] dc_logoutWithPerson];
            } failture:^(NSError *_Nullable error) {
            }];
        }];
        
        [DC_KeyWindow addSubview:alterView];
        [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
    
    if (tag == 901) { // 消息
        GLPMessageListVC *vc = [GLPMessageListVC new];
        [self dc_pushNextController:vc];
    }
    
    if (tag == 902) { // 搜索
        [self dc_pushNextController:[GLPSearchGoodsController new]];
    }
    
    if (tag == 903) { // 分享
        UIImage *image = [self makeImageWithView:self.view withSize:CGSizeMake(kScreenW, kScreenW*4/5)];
        
        NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
        NSString *string = [NSString stringWithFormat:@"/geren/app_code.html?userId=%@",userId];
        [[DCUMShareTool shareClient] shareInfoWithTitle:@"药批发、药采购，就上金利达！" content:@"金利达" url:[NSString stringWithFormat:@"%@%@",Person_H5BaseUrl,string] image:image pathUrl:@""];
    }
}

#pragma mark 生成image
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)dc_typeCellBtnClick:(NSInteger)tag
{
    if (tag == 300) { // 热销商品
        [self dc_pushNextController:[TRHotCommdityVC new]];
    }
    if (tag == 301) { // 商品分类
        self.tabBarController.selectedIndex =1;
    }
    if (tag == 302) { // 领券中心
        [self dc_pushNextController:[TRCouponCentrePageVC new]];
    }
    if (tag == 303) { // 活动专区
        //[self dc_pushPersonWebController:@"/geren/activity.html" params:nil];
        GLPActivityAreaListVC *vc = [[GLPActivityAreaListVC alloc] init];
        [self dc_pushNextController:vc];
    }
}


#pragma mark - 跳转详情
- (void)dc_pushGoodsDetailsController:(NSString *)goodsId
{
    GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
    vc.goodsId = goodsId;
    [self dc_pushNextController:vc];
}

#pragma mark - 请求 刷新

- (void)requestHomeData:(BOOL)isReload isShowHUD:(BOOL)isShow
{
    
    //    1.首页活动推荐位:ACT_ZONE_INDEX
    //    2.首页【季节用药】推荐位：SEASON_ZONE_INDEX
    //    3.首页【热销榜】推荐位:HOTSALES_ZONE_INDEX
    //    4.首页【楼层1】推荐位：FLOOR1_ZONE_INDEX
    //    5.首页【楼层2】推荐位:FLOOR2_ZONE_INDEX
    //    6.首页【楼层3】推荐位：FLOOR3_ZONE_INDEX
    //    7.首页【楼层4】推荐位:FLOOR4_ZONE_INDEX
    //    8.首页【热点推荐】推荐位：HOT_REC_ZONE_INDEX
    isShow ? ([SVProgressHUD show]) :  1;
    //double date_s = CFAbsoluteTimeGetCurrent();
    
    // banner图
    [self requestHomeBanner];
    
    WEAKSELF;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [weakSelf requestMainAllListTypeWithBlock:^(GLPHomeNewDataModel *dataModel) {
        weakSelf.activityModel = dataModel.midAd;
        weakSelf.seasonModel = dataModel.season;
        weakSelf.hotModel = dataModel.hotSales;
        weakSelf.floorList = [dataModel.floorData mutableCopy];
        weakSelf.recommendModel = dataModel.hotRec;
        NSArray *collageList = [DCCollageListModel mj_objectArrayWithKeyValuesArray:dataModel.collageList];
        dataModel.collageList = collageList;
        NSArray *seckillList = [DCSeckillListModel mj_objectArrayWithKeyValuesArray:dataModel.seckillList];
        dataModel.seckillList = seckillList;
        
        weakSelf.homeModel = dataModel;
        //        double date_current2 = CFAbsoluteTimeGetCurrent() - date_s;
        //        NSLog(@"主数据  restorePhoneNumListDate Time: %f ms",date_current2 *1000);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        //        double date_current = CFAbsoluteTimeGetCurrent() - date_s;
        //        NSLog(@"首页请求时间  restorePhoneNumListDate Time: %f ms",date_current *1000);
        [weakSelf.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
    
}



#pragma mark - 请求 banner数据
- (void)requestHomeBanner
{
    [self.bannerArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestAdvWithAdCode:@"APP_AD_HOME" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.bannerArray addObjectsFromArray:response];
        }
        
        weakSelf.headView.bannerArray = weakSelf.bannerArray;
    } failture:^(NSError *error) {
    }];
}

#pragma mark - 请求 首页主页面几个(中间广告位,季节数据,热销数据 4个楼层 热点推荐)合集
- (void)requestMainAllListTypeWithBlock:(GLPRecommendNewBlock)block
{
    //WEAKSELF;
    [[DCAPIManager shareManager] person_requestHomeMainAllListWithsuccess:^(id response) {
        NSLog(@"response:%@",response);
        GLPHomeNewDataModel *dataModel = nil;
        if (response && [response isKindOfClass:[GLPHomeNewDataModel class]]) {
            dataModel = (GLPHomeNewDataModel *)response;
        }
        block(dataModel);
    } failture:^(NSError *error) {
        block(nil);
    }];
}

#pragma mark - 请求 获取未读消息数量
- (void)requestNoReadMsgCount_Block:(back_block)block
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestNoReadMsgCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"]) {
                NSInteger count = [response[@"data"] integerValue];
                weakSelf.navBar.count = count;
            }
        }
        block(nil);
    } failture:^(NSError *error) {
        block(nil);
    }];
}


#pragma mark - lazy load
- (GLPHomeNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLPHomeNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        _navBar.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:0];
        WEAKSELF;
        _navBar.navBarBlock = ^(NSInteger tag) {
            [weakSelf dc_navBarItemClick:tag];
        };
    }
    return _navBar;
}

- (GLPHomeHeadView *)headView{
    if (!_headView) {
        _headView = [[GLPHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight + 13 + 0.4*kScreenW)];
    }
    return _headView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor =RGB_COLOR(248, 248, 248);
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        [_tableView registerClass:NSClassFromString(activityCellID) forCellReuseIdentifier:activityCellID];
        [_tableView registerClass:NSClassFromString(typeCellID) forCellReuseIdentifier:typeCellID];
        [_tableView registerClass:NSClassFromString(GLPHomeGroupBuyCellID) forCellReuseIdentifier:GLPHomeGroupBuyCellID];
        [_tableView registerClass:NSClassFromString(GLPHomeSpikeCellID) forCellReuseIdentifier:GLPHomeSpikeCellID];
        [_tableView registerClass:NSClassFromString(classCellID) forCellReuseIdentifier:classCellID];
        [_tableView registerClass:NSClassFromString(classCellID) forCellReuseIdentifier:@"class_KKKK_CellID"];
        [_tableView registerClass:NSClassFromString(recommendCellID) forCellReuseIdentifier:recommendCellID];
        
    }
    return _tableView;
}

- (NSMutableArray<GLPAdModel *> *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray<GLPHomeDataModel *> *)floorList{
    if (!_floorList) {
        _floorList = [[NSMutableArray alloc] init];
    }
    return  _floorList;;
}

- (void)yaoqingBtnMethod{
    //用户推广类型：0-普通用户【进入申请界面】，1-创业者【正常推广】，2-创业者【待审核】，3-创业者【审核不通过】，4-创业者【禁用】，5-服务商员工【不可推广】
    if (self.extendType == 0) {
        
        GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];//创业者申请
        vc.userInfoModel = nil;
        [self dc_pushNextController:vc];
    }else if (self.extendType == 1) {
        
        GLPEtpEventInvitationVC *vc = [GLPEtpEventInvitationVC new];
        //        vc.mytestBlock = ^(NSError *_Nonnull error) {
        //            NSLog(@"测试_Nullable _Nonnull %@",error);
        //        };
        [self dc_pushNextController:vc];
    }else if (self.extendType == 2 ) {
        
        GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
        vc.statusType = EtpApprovalStatusReviewing;
        [self dc_pushNextController:vc];
    }else{
        GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
        vc.statusType = EtpApprovalStatusReviewFailure;
        [self dc_pushNextController:vc];
    }
}

#pragma mark - 悬浮按钮
- (void)changePostion:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.xfView];
    
    CGFloat width = self.view.bounds.size.width;
    
    CGFloat height = self.view.bounds.size.height-0;//kTabBarHeight
    
    CGRect originalFrame = self.xfView.frame;
    
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    
    self.xfView.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self.xfView];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.xfView.userInteractionEnabled = NO;
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
    } else {
        
        CGRect frame = self.xfView.frame;
        
        //是否越界
        
        BOOL isOver = NO;
        
        if (frame.origin.x < 0) {
            
            frame.origin.x = 0;
            
            isOver = YES;
            
        } else if (frame.origin.x+frame.size.width > width) {
            
            frame.origin.x = width - frame.size.width;
            
            isOver = YES;
            
        }
        if (frame.origin.y < 0) {
            
            frame.origin.y = 0;
            
            isOver = YES;
            
        } else if (frame.origin.y+frame.size.height > height) {
            
            frame.origin.y = height - frame.size.height;
            
            isOver = YES;
            
        }
        if (isOver) {
            
        }
        else
        {
            if (self.xfView.center.x>width/2.0) {
                
                frame.origin.x = width - frame.size.width;
            }
            else
            {
                frame.origin.x = 0;
            }
            
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.xfView.frame = frame;
        }];
        self.xfView.userInteractionEnabled = YES;
    }
}

- (GLPCustomXFView *)xfView {
    if (!_xfView) {
        CGFloat width = 65;
        CGFloat height = 65;
        NSDictionary *dic = @{@"items":@"",@"img":@"dc_activity_no",@"bgColor":@"#ffbd08"};//home_yqhy
        _xfViewFrame = CGRectMake(kScreenW-width, kScreenH/2, width, height);
        _xfView = [GLPCustomXFView sharedManagerInitWithFrame:_xfViewFrame params:dic isCloseBtn:NO];//-kTabBarHeight-height
        
        _xfView.tag = xfViewTag;
        //[_xfView initSubViewsparams:dic isCloseBtn:NO];
        
        __block typeof(self) bself = self;
        [_xfView setCloseBlock:^{
            bself.xfView.hidden = YES;
        }];
        
        [DC_KeyWindow addSubview:_xfView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [_xfView addGestureRecognizer:pan];
        
    }
    return _xfView;
}


- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

@end


/**
 - (void)requestHomeData:(BOOL)isReload isShowHUD:(BOOL)isShow
 {
 dispatch_group_t group = dispatch_group_create();
 
 isShow ? ([SVProgressHUD show]) :  1;
 double date_s = CFAbsoluteTimeGetCurrent();
 
 WEAKSELF;
 if (isReload) {
 
 
 // banner图
 //[self requestHomeBanner];
 
 // 活动
 dispatch_group_enter(group);
 [self requestRecommendInfoWithCode:@"ACT_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 dispatch_group_leave(group);
 weakSelf.activityModel = dataModel;
 }];
 
 // 季节用药
 dispatch_group_enter(group);
 [self requestRecommendInfoWithCode:@"SEASON_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 dispatch_group_leave(group);
 weakSelf.seasonModel = dataModel;
 }];
 
 // 热销榜
 dispatch_group_enter(group);
 [self requestRecommendInfoWithCode:@"HOTSALES_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 dispatch_group_leave(group);
 weakSelf.hotModel = dataModel;
 }];
 
 // 楼层1
 dispatch_group_enter(group);
 [self requestRecommendInfoWithCode:@"FLOOR1_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 dispatch_group_leave(group);
 weakSelf.floorModel1 = dataModel;
 }];
 
 // 楼层2
 dispatch_group_enter(group);
 [self requestRecommendInfoWithCode:@"FLOOR2_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 dispatch_group_leave(group);
 weakSelf.floorModel2 = dataModel;
 }];
 
 // 楼层3
 dispatch_group_enter(group);
 [self requestRecommendInfoWithCode:@"FLOOR3_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 dispatch_group_leave(group);
 weakSelf.floorModel3 = dataModel;
 }];
 
 // 楼层4
 dispatch_group_enter(group);
 [self requestRecommendInfoWithCode:@"FLOOR4_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 dispatch_group_leave(group);
 weakSelf.floorModel4 = dataModel;
 }];
 
 // 热点推荐
 //dispatch_group_enter(group);
 //[self requestRecommendInfoWithCode:@"HOT_REC_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 //dispatch_group_leave(group);
 //weakSelf.recommendModel = dataModel;
 //}];
 
 // 邀请好友
 dispatch_group_enter(group);
 [self requestRecommendTypeWithBlock:^{
 dispatch_group_leave(group);
 }];
 
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.002 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [self requestHomeBanner];
 double date_current2 = CFAbsoluteTimeGetCurrent() - date_s;
 NSLog(@"轮播图  restorePhoneNumListDate Time: %f ms",date_current2 *1000);
 });
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.003 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [weakSelf requestRecommendInfoWithCode:@"HOT_REC_ZONE_INDEX" block:^(GLPHomeDataModel *dataModel) {
 weakSelf.recommendModel = dataModel;
 [weakSelf.tableView reloadData];
 double date_current2 = CFAbsoluteTimeGetCurrent() - date_s;
 NSLog(@"热点推荐  restorePhoneNumListDate Time: %f ms",date_current2 *1000);
 }];
 });
 }
 
 dispatch_group_notify(group, dispatch_get_main_queue(), ^{
 [weakSelf.tableView.mj_header endRefreshing];
 [weakSelf.tableView.mj_footer endRefreshing];
 [SVProgressHUD dismiss];
 
 double date_current = CFAbsoluteTimeGetCurrent() - date_s;
 NSLog(@"首页请求时间  restorePhoneNumListDate Time: %f ms",date_current *1000);
 //[weakSelf.tableView reloadData];
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [weakSelf.tableView reloadData];
 });
 });
 
 
 }
 
 } else if (indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7) {
 
 GLPHomeClassCell *classCell ;
 if (indexPath.section == 7) {
 classCell = [tableView dequeueReusableCellWithIdentifier:@"class_KKKK_CellID" forIndexPath:indexPath];
 classCell.arte = YES;
 }else{
 classCell = [tableView dequeueReusableCellWithIdentifier:classCellID forIndexPath:indexPath];
 classCell.arte = NO;
 }
 if (indexPath.section == 4 && self.floorModel1) {
 [classCell setValueWithDataModel:self.floorModel1 indexPath:indexPath];
 classCell.viewBlock = ^(NSInteger tag) {
 NSArray *arr = self.floorModel1.dataList;
 GLPHomeDataListModel *listModel = arr[tag-100];
 NSString *type = [NSString stringWithFormat:@"%ld",(long)listModel.infoType];
 NSString *infoid = [NSString stringWithFormat:@"%@",listModel.infoId];
 if ([type isEqualToString:@"1"])
 {
 TRStorePageVC *vc = [[TRStorePageVC alloc] init];
 vc.firmId = infoid;
 [self.navigationController pushViewController:vc animated:YES];
 }
 else if ([type isEqualToString:@"2"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 else if ([type isEqualToString:@"3"])
 {
 [self dc_pushPersonWebController:@"/geren/activity_detail.html" params:[NSString stringWithFormat:@"id=%@",infoid]];
 }
 else if ([type isEqualToString:@"4"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 };
 } else if (indexPath.section == 5 && self.floorModel2) {
 [classCell setValueWithDataModel:self.floorModel2 indexPath:indexPath];
 classCell.viewBlock = ^(NSInteger tag) {
 NSArray *arr = self.floorModel2.dataList;
 GLPHomeDataListModel *listModel = arr[tag-100];
 NSString *type = [NSString stringWithFormat:@"%ld",(long)listModel.infoType];
 NSString *infoid = [NSString stringWithFormat:@"%@",listModel.infoId];
 if ([type isEqualToString:@"1"])
 {
 TRStorePageVC *vc = [[TRStorePageVC alloc] init];
 vc.firmId = infoid;
 [self.navigationController pushViewController:vc animated:YES];
 }
 else if ([type isEqualToString:@"2"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 else if ([type isEqualToString:@"3"])
 {
 [self dc_pushPersonWebController:@"/geren/activity_detail.html" params:[NSString stringWithFormat:@"id=%@",infoid]];
 }
 else if ([type isEqualToString:@"4"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 };
 } else if (indexPath.section == 6 && self.floorModel3) {
 [classCell setValueWithDataModel:self.floorModel3 indexPath:indexPath];
 classCell.viewBlock = ^(NSInteger tag) {
 NSArray *arr = self.floorModel3.dataList;
 GLPHomeDataListModel *listModel = arr[tag-100];
 NSString *type = [NSString stringWithFormat:@"%ld",(long)listModel.infoType];
 NSString *infoid = [NSString stringWithFormat:@"%@",listModel.infoId];
 if ([type isEqualToString:@"1"])
 {
 TRStorePageVC *vc = [[TRStorePageVC alloc] init];
 vc.firmId = infoid;
 [self.navigationController pushViewController:vc animated:YES];
 }
 else if ([type isEqualToString:@"2"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 else if ([type isEqualToString:@"3"])
 {
 [self dc_pushPersonWebController:@"/geren/activity_detail.html" params:[NSString stringWithFormat:@"id=%@",infoid]];
 }
 else if ([type isEqualToString:@"4"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 };
 } else if (indexPath.section == 7 && self.floorModel4) {
 [classCell setValueWithDataModel:self.floorModel4 indexPath:indexPath];
 classCell.viewBlock = ^(NSInteger tag) {
 NSArray *arr = self.floorModel4.dataList;
 GLPHomeDataListModel *listModel = arr[tag-100];
 NSString *type = [NSString stringWithFormat:@"%ld",(long)listModel.infoType];
 NSString *infoid = [NSString stringWithFormat:@"%@",listModel.infoId];
 if ([type isEqualToString:@"1"])
 {
 TRStorePageVC *vc = [[TRStorePageVC alloc] init];
 vc.firmId = infoid;
 [self.navigationController pushViewController:vc animated:YES];
 }
 else if ([type isEqualToString:@"2"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 else if ([type isEqualToString:@"3"])
 {
 [self dc_pushPersonWebController:@"/geren/activity_detail.html" params:[NSString stringWithFormat:@"id=%@",infoid]];
 }
 else if ([type isEqualToString:@"4"])
 {
 [weakSelf dc_pushGoodsDetailsController:infoid];
 }
 };
 }
 cell = classCell;
 
 }
 
 #pragma mark - 请求 邀请
 - (void)requestRecommendTypeWithBlock:(dispatch_block_t)block
 {
 WEAKSELF;//
 [[DCAPIManager shareManager] person_requestHomeRecommendTypeSuccess:^(id response) {
 NSLog(@"response:%@",response);
 if ([response[@"code"] integerValue] == 200) {
 if ([response[@"data"] integerValue] == 0) {
 weakSelf.extendType = [response[@"data"] integerValue];
 if (weakSelf.extendType != 5) {
 weakSelf.xfView.hidden = NO;
 }
 }
 }
 block();
 } failture:^(NSError *error) {
 block();
 }];
 }
 
 #pragma mark - 请求 首页推荐信息
 - (void)requestRecommendInfoWithCode:(NSString *)code block:(GLPRecommendBlock)block
 {
 WEAKSELF;
 [[DCAPIManager shareManager] person_requestHomeRecommendWithZoneCode:code type:@"1" success:^(id response) {
 
 GLPHomeDataModel *dataModel = nil;
 if (response && [response isKindOfClass:[GLPHomeDataModel class]]) {
 dataModel = (GLPHomeDataModel *)response;
 }
 block(dataModel);
 
 } failture:^(NSError *error) {
 
 block(nil);
 }];
 }
 */
