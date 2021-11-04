//
//  GLPMineController.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMineController.h"

#import "GLPMineHeadView.h"
#import "GLPMineOrderCell.h"
#import "GLPMineOtherCell.h"

#import "GLPUserInfoController.h"
#import "GLPSetController.h"
#import "FeedBackVC.h"
#import "CouponsListVC.h"
#import "GLPAddressListVC.h"
#import "PrescriptionVC.h"
#import "PersonOrderPageController.h"
#import "AuthenticationVC.h"
#import "GLPMessageListVC.h"
#import "FocusStoreListVC.h"
#import "GLPMineCollectController.h"
#import "GLPMineSeeController.h"
#import "TRCouponCentrePageVC.h"
#import "CurrentVersionVC.h"
#import "GLPGroupBuyHomeListVC.h"
#import "GLPEntrepreneurCenterVC.h"
#import "GLPPatientListViewController.h"
#import "PersonReturnOrderPageController.h"
#define kHeadViewHeight 110+108*kScreenW/375+kScreenW/4*0.8

static NSString *const orderCellID = @"GLPMineOrderCell";
static NSString *const otherCellID = @"GLPMineOtherCell";

@interface GLPMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) GLPMineHeadView *headView;
@property (nonatomic, strong) DCAlterView *alterView;
/* headView */
@property (strong , nonatomic)UIView *allHeadView;
@property(nonatomic,strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSDictionary *personDic;
@property(nonatomic,strong)NSDictionary *orderDic;
@property(nonatomic,assign)BOOL isUp;
@property(nonatomic,assign)BOOL isDown;
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,assign)BOOL isFirstLoad;

@property (nonatomic,assign) NSInteger yaoqingType;//0-普通用户【进入申请界面】，1-创业者【正常推广】，2-创业者【待审核】，3-创业者【审核不通过】，4-创业者【禁用】，5-服务商员工【不可推广】

@end

@implementation GLPMineController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    [self dc_navBarHidden:YES animated:animated];
    [self dc_navBarLucency:YES];//解决侧滑显示白色
    [self getPersonData];

    [self getnum];
    
    [self requestNoReadMsgCount];
    [self getOrderNum];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO animated:animated];
}

- (void)getOrderNum
{
    [[DCAPIManager shareManager] person_getorderNumsuccess:^(id response) {
        self.orderDic=response[@"data"];
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isUp = YES;
    self.isDown = NO;
    self.isFirst = YES;
    self.yaoqingType = 0;
    [self.view addSubview:self.headImage];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    
    //initWithFrame:CGRectMake(0, kHeadViewHeight+kStatusBarHeight-38-26*kScreenW/375, kScreenW, 300) style:UITableViewStyleGrouped
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.bottom).offset(-26*kScreenW/375-38);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self.allHeadView addSubview:self.topView];
    self.tableView.tableHeaderView=self.allHeadView;
}

- (void)getPersonData
{
    WEAKSELF;
    [[DCAPIManager shareManager]person_requestPersonDataWithisShowHUD:!_isFirstLoad Success:^(id response) {
        NSDictionary *dic = response[@"data"];
        weakSelf.headView.personDic = dic;
        weakSelf.personDic = dic;
        NSString *extendType = dic[@"extendType"] ?  dic[@"extendType"] : @"0";
        weakSelf.yaoqingType = [extendType integerValue];
    } failture:^(NSError *error) {
        
    }];
    _isFirstLoad = YES;
}

- (void)getnum
{
    [[DCAPIManager shareManager]person_requestPersonNumWithSuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        self.headView.numDic = dic;
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WEAKSELF;
    if (indexPath.section == 0) {
        
        GLPMineOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:orderCellID forIndexPath:indexPath];
        orderCell.dic = self.orderDic;
        orderCell.orderCellBlock = ^(NSInteger tag) {
            BOOL isRefund = NO;
            int index = 0;
            if (tag == 306) {//退款售后
                //[weakSelf dc_pushPersonWebController:@"/geren/sale_list.html" params:nil];                //return;
                isRefund = YES;
                PersonReturnOrderPageController *pageVC = [[PersonReturnOrderPageController alloc] init];
                pageVC.index = index;
                [self dc_pushNextController:pageVC];
            }else{
                index = (int)(tag - 301);
                PersonOrderPageController *pageVC = [[PersonOrderPageController alloc] initWithIsRefund:isRefund];//我的订单
                pageVC.index = index;
                pageVC.isPopView = YES;
                [self dc_pushNextController:pageVC];
            }

        };
        cell = orderCell;
        
    } else {
        
        GLPMineOtherCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherCellID forIndexPath:indexPath];
        otherCell.indexPath = indexPath;
        otherCell.otherCellBlock = ^(NSInteger tag) {
            if (tag==201)
            {
                //意见反馈
                FeedBackVC *vc = [FeedBackVC new];
                [weakSelf dc_pushNextController:vc];
            }
            else if (tag==202)
            {
                //当前版本
                CurrentVersionVC *vc = [[CurrentVersionVC alloc] init];
                 [self dc_pushNextController:vc];
            }
            else  if (tag == 203) {
                //设置
                GLPSetController *vc = [GLPSetController new];
                vc.phone = [NSString stringWithFormat:@"%@",weakSelf.personDic[@"cellphone"]];
                [weakSelf dc_pushNextController:vc];
            }
            else  if (tag == 200) {
                //关于我们
                  [weakSelf dc_pushPersonWebController:@"/public/about_us.html" params:nil];
            }
            else if(tag == 99){
                //我的拼团
                GLPGroupBuyHomeListVC *vc = [[GLPGroupBuyHomeListVC alloc] init];
                vc.showType = 2;
                [weakSelf dc_pushNextController:vc];
            }
            else if (tag == 100)
            {
                //优惠券
                CouponsListVC *vc = [[CouponsListVC alloc] init];
                [weakSelf dc_pushNextController:vc];
            }
            else if (tag == 101)
            {
                //地址
                GLPAddressListVC *vc = [[GLPAddressListVC alloc] init];
                [weakSelf dc_pushNextController:vc];
            }
            else if (tag == 102)
            {
                //我的处方
                PrescriptionVC *vc = [[PrescriptionVC alloc] init];
                [self dc_pushNextController:vc];
            }
            else if (tag==103)
            {
                //我的评价
                [weakSelf dc_pushPersonWebController:@"/geren/my_evaluate.html" params:nil];
            }else if (tag == 104)
            {
                //分享
                [weakSelf dc_pushPersonWebController:@"/geren/share/#/share2" params:nil];
            }else if (tag == 105)
            {
                //用药人列表
                GLPPatientListViewController *vc = [[GLPPatientListViewController alloc] init];
                [self dc_pushNextController:vc];
                //[weakSelf dc_pushPersonWebController:@"/geren/medicineMan.html" params:nil];
                //[weakSelf.navigationController pushViewController:[DrugUsersVC new] animated:YES];
            }else if (tag == 106)
            {
                if (weakSelf.yaoqingType == 0) {//0-普通用户【进入申请界面】
                    
                    GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];
                    vc.userInfoModel = nil;
                    [weakSelf dc_pushNextController:vc];
                }else if (weakSelf.yaoqingType == 1) {//1-创业者【正常推广】
                    
                    GLPEntrepreneurCenterVC *vc = [GLPEntrepreneurCenterVC new];
                    [weakSelf dc_pushNextController:vc];
                }else if (weakSelf.yaoqingType == 2 ) {//2-创业者【待审核】
                    
                    GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
                    vc.statusType = EtpApprovalStatusReviewing;
                    [self dc_pushNextController:vc];
                }else{//3-创业者【审核不通过】，4-创业者【禁用】，5-服务商员工【不可推广】
                    GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
                    vc.statusType = EtpApprovalStatusReviewFailure;
                    [self dc_pushNextController:vc];
                }
            }
           
        };
        cell = otherCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//lj_change_约束
        return 10-5+10+30+10+(kScreenW - 14*2)/5+20;
    }else if (indexPath.section == 1){
        return 10-5+10+30+10+(kScreenW - 14*2)/5*2+20 + 10;
    }else
        return 10-5+10+30+10+(kScreenW - 14*2)/5+20;
        //return UITableViewAutomaticDimension;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    
    if (y>0)
    {
        if (self.isFirst==YES)
        {
            //NSLog(@"isFirst y>0--:%f",y);
            [self.headView removeFromSuperview];
            [self.topView removeFromSuperview];
            [self.allHeadView addSubview:self.headView];
            [self.allHeadView addSubview:self.topView];
            [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self.allHeadView);
                make.height.equalTo(26*kScreenW/375);
            }];
            self.tableView.tableHeaderView = self.allHeadView ;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.left.bottom.right.equalTo(self.view);
            }];
            self.isUp=NO;
            self.isDown = YES;
        }
        else{
            if (self.isUp==YES)
            {
                //NSLog(@"isUp y>0--:%f",y);
                [self.headView removeFromSuperview];
                [self.topView removeFromSuperview];
                self.allHeadView.frame = CGRectMake(0, 0, kScreenW, kHeadViewHeight-38+kStatusBarHeight);
                [self.allHeadView addSubview:self.headView];
                //self.topView.frame = CGRectMake(0, kHeadViewHeight+kStatusBarHeight-38-26*kScreenW/375, kScreenW, 26*kScreenW/375);
                self.tableView.tableHeaderView=self.allHeadView ;
                [self.allHeadView addSubview:self.topView];
                [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(self.allHeadView);
                    make.height.equalTo(26*kScreenW/375);
                }];

                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view);
                    make.left.bottom.right.equalTo(self.view);
                }];
                self.isUp=NO;
                self.isDown = YES;
            }
        }
    }
    else{
        if (self.isDown==YES && y==0)
        {
            //NSLog(@"y<0--:%f",y);
            [self.headView removeFromSuperview];
            [self.topView removeFromSuperview];
            [self.view addSubview:self.headView];
            self.allHeadView.frame = CGRectMake(0, 0, kScreenW, 26*kScreenW/375);
            [self.allHeadView addSubview:self.topView];
            [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self.allHeadView);
                make.height.equalTo(26*kScreenW/375);
            }];
            self.tableView.tableHeaderView=self.allHeadView;
            [self.view bringSubviewToFront:self.tableView];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                CGFloat totalOffset = kHeadViewHeight+kStatusBarHeight-38-26*kScreenW/375;
                make.top.equalTo(self.view).offset(totalOffset);
                make.left.bottom.right.equalTo(self.view);
            }];
            self.isDown = NO;
            self.isUp=YES;
            self.isFirst = NO;
        }
    }
}

#pragma mark - action
- (void)dc_headBtnClick:(NSInteger)tag
{
    if (tag == 201) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_logoutWithPerson];
            return;
        }
        
        if (![DC_KeyWindow.subviews.lastObject isKindOfClass:[DCAlterView class]]) {
            [DC_KeyWindow addSubview:self.alterView];
            [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(DC_KeyWindow);
            }];
        }
    }
    if (tag == 202) {//消息
        GLPMessageListVC *vc = [GLPMessageListVC new];
        [self dc_pushNextController:vc];
    }
    if (tag == 203) { // 设置
        GLPSetController *vc = [GLPSetController new];
        vc.phone = [NSString stringWithFormat:@"%@",self.personDic[@"cellphone"]];
        [self dc_pushNextController:vc];
    }
    if (tag == 204) { // 签到
        [self dc_pushPersonWebController:@"/geren/sign.html" params:nil];
    }
    if (tag == 209) { // 个人资料
        GLPUserInfoController *vc = [GLPUserInfoController new];
        [self dc_pushNextController:vc];
    }
    if (tag == 205) { //收藏夹
        [self dc_pushNextController:[GLPMineCollectController new]];
    }
    if (tag==206)
    {//关注店铺
        FocusStoreListVC *vc = [FocusStoreListVC new];
        [self dc_pushNextController:vc];
    }
    if (tag == 208) { // 足迹
        [self dc_pushNextController:[GLPMineSeeController new]];
    }
    if(tag==207)
    {
        //积分
        [self dc_pushPersonWebController:@"/geren/my_integral.html" params:nil];
    }
}

#pragma mark - 请求 获取未读消息数量
- (void)requestNoReadMsgCount
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestNoReadMsgCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"]) {
                NSInteger count = [response[@"data"] integerValue];
                weakSelf.headView.count = count;
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - lazy load
- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kStatusBarHeight+kHeadViewHeight)];
        _headImage.image = [UIImage imageNamed:@"gerenzhongxbg"];
        //_headImage.contentMode = UIViewContentModeScaleAspectFill;
        //_headImage.clipsToBounds = YES;
    }
    return _headImage;
}

- (GLPMineHeadView *)headView{
    if (!_headView) {
        _headView = [[GLPMineHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kHeadViewHeight)];
        //        _headView.layer.borderWidth = 1;
        //        _headView.layer.borderColor = [UIColor greenColor].CGColor;
        WEAKSELF;
        _headView.headViewBlock = ^(NSInteger tag) {
            [weakSelf dc_headBtnClick:tag];
        };
        _headView.authenBlock = ^{
            NSString *idState = [NSString stringWithFormat:@"%@",weakSelf.personDic[@"idState"]];
            AuthenticationVC *vc = [[AuthenticationVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.statuStr = idState;
            vc.modifyTimeParam = [NSString stringWithFormat:@"%@",weakSelf.personDic[@"modifyTime"]];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _headView.couponBlock = ^{
            TRCouponCentrePageVC *vc = [[TRCouponCentrePageVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, kScreenW, 26*kScreenW/375+1);
        _topView.backgroundColor = [UIColor clearColor];
        UIImageView *hxImageV = [[UIImageView alloc]init];
        hxImageV.frame = _topView.frame;
        hxImageV.image = [UIImage imageNamed:@"tr_hux"];
        [_topView addSubview:hxImageV];
//        _topView.layer.borderWidth = 1;
//        _topView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _topView;
}

- (UIView *)allHeadView{
    if (!_allHeadView) {
        _allHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 26*kScreenW/375)];
        _allHeadView.clipsToBounds = YES;
//        _allHeadView.layer.borderWidth = 1;
//        _allHeadView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _allHeadView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];//initWithFrame:CGRectMake(0, kHeadViewHeight+kStatusBarHeight-38-26*kScreenW/375, kScreenW, 300) style:UITableViewStyleGrouped
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
        [_tableView registerClass:NSClassFromString(orderCellID) forCellReuseIdentifier:orderCellID];
        [_tableView registerClass:NSClassFromString(otherCellID) forCellReuseIdentifier:otherCellID];
    }
    return _tableView;
}

- (DCAlterView *)alterView{
    if (!_alterView) {
        _alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"切换企业版需要退出当前账号重新登录,是否切换？"];
        [_alterView addActionWithTitle:@"我再想想" type:DCAlterTypeCancel halderBlock:nil];
        [_alterView addActionWithTitle:@"确认" color:[UIColor dc_colorWithHexString:@"#00D3B7"] type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            
            [[DCAPIManager shareManager] person_requestLogoutWithSuccess:^(id response) {
                
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                               
                           } seq:0];
                [JPUSHService deleteTags:[NSSet setWithObject:@"jld_person"] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    
                } seq:0];
                [[DCLoginTool shareTool] dc_logoutWithPerson];
                
            } failture:^(NSError *_Nullable error) {
    }];
        }];
    }
    return _alterView;
}

@end
