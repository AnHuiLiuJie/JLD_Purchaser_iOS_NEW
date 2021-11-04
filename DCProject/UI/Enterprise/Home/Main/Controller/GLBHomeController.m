//
//  DCHomeController.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBHomeController.h"
#import "DCRefreshTool.h"

#import "GLBPromotionGoodsCell.h"
#import "GLBNormalGoodsCell.h"
#import "GLBHomeCompanyCell.h"
#import "GLBHomeHeadView.h"
#import "GLBHomeNavigationBar.h"

#import "DCNavigationController.h"
#import "GLBPlantPageController.h"
#import "GLBExhibtPageController.h"
#import "GLBNewsListController.h"
#import "GLBTypeGoodsListController.h"
#import "GLBTCMListController.h"
#import "GLBGoodsDetailController.h"
#import "GLBStorePageController.h"
#import "GLBYcjListController.h"
#import "GLBMessageListController.h"
#import "GLBGuideController.h"
#import "GLBSearchPageController.h"
#import "GLBUpdateModel.h"

static NSString *const promotionCellID = @"GLBPromotionGoodsCell";
static NSString *const normalCellID = @"GLBNormalGoodsCell";
static NSString *const companyCellID = @"GLBHomeCompanyCell";

@interface GLBHomeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) GLBHomeNavigationBar *navBar;
@property (nonatomic, strong) GLBHomeHeadView *headView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<GLBAdvModel *> *bannerArray;
@property (nonatomic, strong) NSMutableArray<GLBPromoteModel *> *promoteArray;
@property (nonatomic, strong) NSMutableArray<GLBCompanyModel *> *companyArray;
@property (nonatomic, strong) NSMutableArray<GLBGoodsModel *> *recommendArray;
@property (nonatomic, strong) NSMutableArray<GLBNewsModel *> *newsArray;

@property (nonatomic, assign) NSInteger unReadCount;

@end

@implementation GLBHomeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES];
    
    [self.headView.scrollView adjustWhenControllerViewWillAppera]; // 控制轮播图只滑动一半
    
    
    [self requestUserStatus];
    
    if ([DCObjectManager dc_readUserDataForKey:DC_UserID_Key]) {
        
        [self requestNoReadMessageCount];
        
        /*Add_HX_标识
         *更新环信
         */
        [[DCAPIManager shareManager]dc_requestUserInfoWithSuccess:^(id response) {
        } failture:^(NSError *error) {
        }];
        
    } else {
        
        self.navBar.count = 0;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(kNavBarHeight);
    }];
    
    WEAKSELF
    self.tableView.mj_header = [[DCRefreshTool shareTool] headerDefaultWithBlock:^{
        [weakSelf requestHomeData:YES];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BOOL isNeed = [[DCUpdateTool shareClient] judgeNeedVersionUpdate];
            if (isNeed) {
                if ([DCObjectManager dc_readUserDataForKey:DC_Token_Key]){
                    [[DCUpdateTool shareClient] requestIsUpdate];
                }
            }
    });
    
}



#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.promoteArray.count;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return self.recommendArray.count;
    }
    return section == 1 ? 1 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WEAKSELF;
    if (indexPath.section == 0) {
        
        GLBPromotionGoodsCell *promotionCell = [tableView dequeueReusableCellWithIdentifier:promotionCellID forIndexPath:indexPath];
        promotionCell.goodsModel = self.promoteArray[indexPath.row];
        cell = promotionCell;
        
    } else if (indexPath.section == 1) {
        
        GLBHomeCompanyCell *companyCell = [tableView dequeueReusableCellWithIdentifier:companyCellID forIndexPath:indexPath];
        companyCell.companyArray = self.companyArray;
        companyCell.companyItemBlock = ^(GLBCompanyModel *model) {
            GLBStorePageController *vc = [GLBStorePageController new];
            vc.firmId = model.iD;
            [weakSelf dc_pushNextController:vc];
        };
        cell = companyCell;
        
    } else {
        
        GLBNormalGoodsCell *noramalCell = [tableView dequeueReusableCellWithIdentifier:normalCellID forIndexPath:indexPath];
        noramalCell.goodsModel = self.recommendArray[indexPath.row];
        cell = noramalCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        header.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
        titleLabel.font = [UIFont fontWithName:PFRSemibold size:15];
        [header.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.contentView.left).offset(15);
            make.right.equalTo(header.contentView.right);
            make.centerY.equalTo(header.centerY).offset(10);
        }];
    }
    
    UILabel *titleLabel = header.contentView.subviews.lastObject;
    titleLabel.text = @[@"限时促销",@"推荐药企",@"热销商品"][section];
    
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.batchId = [NSString stringWithFormat:@"%ld",[self.promoteArray[indexPath.row] batchId]];
        vc.goodsId = [self.promoteArray[indexPath.row] goodsId];
        vc.detailType = GLBGoodsDetailTypePromotione;
        vc.promoteModel = self.promoteArray[indexPath.row];
        [self dc_pushNextController:vc];
    }
    
    if (indexPath.section == 2) {
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.detailType = GLBGoodsDetailTypeNormal;
        vc.goodsId = [self.recommendArray[indexPath.row] goodsId];
        [self dc_pushNextController:vc];
    }
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < -20){
        self.navBar.hidden = YES;
    }else{
        self.navBar.hidden = NO;
        
        if (20 < y < kNavBarHeight) {
            self.navBar.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:(y - 20)/kNavBarHeight];
        }
        
        if (y > kNavBarHeight) {
            self.navBar.isTop = YES;
        }else{
            self.navBar.isTop = NO;
        }
    }
}



#pragma mark - action
- (void)dc_headViewItemClick:(NSInteger)index
{
    if (index == 0) {
        [self dc_pushTypeGoodsListController:GLBGoodsTypeRmsx];
    }
    if (index == 1) {
        [self dc_pushNextController:[GLBTCMListController new]];
    }
    if (index == 2) {
        [self dc_pushNextController:[GLBYcjListController new]];
    }
    if (index == 3) {
        [self dc_pushWebController:@"/qiye/ticket.html" params:nil];
    }
    if (index == 4) {
        [self dc_pushTypeGoodsListController:GLBGoodsTypeYhcx];
    }
    if (index == 5) {
        [self dc_pushNextController:[GLBNewsListController new]];
        //[self dc_pushTypeGoodsListController:GLBGoodsTypeYkx];
    }
    if (index == 6) {
        [self dc_pushTypeGoodsListController:GLBGoodsTypeYzb];
    }
    if (index == 7) {
        [self dc_pushTypeGoodsListController:GLBGoodsTypeYjk];
    }
    
    if (index == 8) {
        [self dc_pushNextController:[GLBPlantPageController new]];
    }
    if (index == 9) {
        [self dc_pushNextController:[GLBExhibtPageController new]];
    }
}


- (void)dc_navBarItemClick:(NSInteger)index
{
    if (index == 900) { // 返回
        
        [self dc_backBtnClick];
    }
    
    if (index == 901) { // 消息
        [self dc_pushNextController:[GLBMessageListController new]];
    }
    
    if (index == 902) { // 搜索
        [self dc_pushNextController:[GLBSearchPageController new]];
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


#pragma mark -
- (void)dc_backBtnClick
{
//    if ([DCObjectManager dc_readUserDataForKey:DC_UserID_Key]) { // 已登录状态
//
//        DCAlterView *alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"您确定要退出登录吗？"];
//        [alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
//        [alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
//            DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBGuideController new]];
//        }];
//
//        [DC_KeyWindow addSubview:alterView];
//        [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(DC_KeyWindow);
//        }];
//
//    } else { // 未登录状态
    
        DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBGuideController new]];
//    }
    
}


#pragma mark - 请求首页数据
- (void)requestHomeData:(BOOL)isReload
{
    dispatch_group_t group = dispatch_group_create();
    
    [SVProgressHUD show];
    
    dispatch_group_enter(group);
    [self requeseNewsData:^{
        dispatch_group_leave(group);
    }];
        
    dispatch_group_enter(group);
    [self requestBannerData:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self requesePromoteGoodsData:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self requeseRecommendCompanyData:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self requeseRecommendGoodsData:^{
        dispatch_group_leave(group);
    }];
    
    WEAKSELF;
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        [weakSelf.tableView reloadData];
    });
}


#pragma mark - 请求 banner
- (void)requestBannerData:(dispatch_block_t)block
{
    [self.bannerArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAdvWithCode:@"AD_APP_HOME" success:^(id response) {
        
        if (response && [response count] > 0) {
            [weakSelf.bannerArray addObjectsFromArray:response];
            weakSelf.headView.bannerArray = weakSelf.bannerArray;
        }
        block();
        
    } failture:^(NSError *error) {
         block();
    }];
}


#pragma mark - 请求 促销商品
- (void)requesePromoteGoodsData:(dispatch_block_t)block
{
    [self.promoteArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestHomePromoteWithDataKey:@"RECOMM_APP_01" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.promoteArray addObjectsFromArray:response];
        }
        block();
    } failture:^(NSError *error) {
        block();
    }];
}


#pragma mark - 请求 推荐药企
- (void)requeseRecommendCompanyData:(dispatch_block_t)block
{
    [self.companyArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestHomeCompanyWithDataKey:@"RECOMM_APP_02" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.companyArray addObjectsFromArray:response];
        }
        block();
    } failture:^(NSError *error) {
        block();
    }];
}

#pragma mark - 请求 热销商品
- (void)requeseRecommendGoodsData:(dispatch_block_t)block
{
    [self.recommendArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestHomeGoodsWithDataKey:@"RECOMM_APP_03" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.recommendArray addObjectsFromArray:response];
        }
        block();
    } failture:^(NSError *error) {
        block();
    }];
}

#pragma mark - 请求 新闻资讯
- (void)requeseNewsData:(dispatch_block_t)block
{
    [self.newsArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestHomeNewsWithDataKey:@"RECOMM_APP_04" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.newsArray addObjectsFromArray:response];
            weakSelf.headView.newsArray = weakSelf.newsArray;
        }
        block();
    } failture:^(NSError *error) {
        block();
    }];
}


#pragma mark - 请求 用户状态
- (void)requestUserStatus
{
    if (![DCObjectManager dc_readUserDataForKey:DC_UserID_Key]) {
        return;
    }
    
    [[DCAPIManager shareManager] dc_requestCompanyStatusWithSuccess:^(id response) {
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 未读消息数量
- (void)requestNoReadMessageCount
{
    self.unReadCount = 0;
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestNoReadMessageCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = response;
            
            weakSelf.unReadCount = 0;
            
            NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
            long unreadCount = 0;
            for (HDConversation *conv in hConversations) {
                unreadCount += conv.unreadMessagesCount;
            }
            
            weakSelf.unReadCount += unreadCount;

             if (dict && dict[@"sysMsgCount"]) {
                 NSInteger sysMsgCount = [dict[@"sysMsgCount"] integerValue];
                 
                 weakSelf.unReadCount += sysMsgCount;
             }

            if (dict && dict[@"orderMsgCount"]) {
                NSInteger orderMsgCount = [dict[@"orderMsgCount"] integerValue];
                
                weakSelf.unReadCount += orderMsgCount;
            }
        }
        
        weakSelf.navBar.count = weakSelf.unReadCount;
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 35.0f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:NSClassFromString(promotionCellID) forCellReuseIdentifier:promotionCellID];
        [_tableView registerClass:NSClassFromString(normalCellID) forCellReuseIdentifier:normalCellID];
        [_tableView registerClass:NSClassFromString(companyCellID) forCellReuseIdentifier:companyCellID];
    }
    return _tableView;
}

- (GLBHomeHeadView *)headView{
    if (!_headView) {
        
        CGFloat height = 0.48*kScreenW + 10 + kScreenW / 5 *2 + 10 + 10 + 1 + 32;
        
        WEAKSELF;
        _headView = [[GLBHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, height)];
        _headView.homeHeadViewBlock = ^(NSInteger index) {
            [weakSelf dc_headViewItemClick:index];
        };
        _headView.moreBtnBlock = ^{
            [weakSelf dc_pushNextController:[GLBNewsListController new]];
        };
        _headView.bannerViewBlock = ^(GLBAdvModel *model) {
            [weakSelf dc_pushController:model];
        };
        _headView.newsBlock = ^(GLBNewsModel *model) {
            NSString *params = [NSString stringWithFormat:@"id=%@",[model iD]];
            [weakSelf dc_pushWebController:@"/public/infor_detail.html" params:params];
        };
    }
    return _headView;
}

- (GLBHomeNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLBHomeNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        _navBar.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:0];
        WEAKSELF;
        _navBar.navBarBlock = ^(NSInteger tag) {
            [weakSelf dc_navBarItemClick:tag];
        };
    }
    return _navBar;
}


- (NSMutableArray<GLBAdvModel *> *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray<GLBPromoteModel *> *)promoteArray{
    if (!_promoteArray) {
        _promoteArray = [NSMutableArray array];
    }
    return _promoteArray;
}

- (NSMutableArray<GLBCompanyModel *> *)companyArray{
    if (!_companyArray) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}

- (NSMutableArray<GLBGoodsModel *> *)recommendArray{
    if (!_recommendArray) {
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}

- (NSMutableArray<GLBNewsModel *> *)newsArray{
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}


@end
