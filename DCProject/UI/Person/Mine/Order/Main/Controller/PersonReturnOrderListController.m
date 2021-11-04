//
//  GLBOrderListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PersonReturnOrderListController.h"
#import "OrderListCell.h"
#import "OrderListModel.h"
#import "CSDemoAccountManager.h"
#import "DCNoDataView.h"
#import "PioneerServiceFeeModel.h"
#import "GLPOrderDetailsViewController.h"
#import "DCAPIManager+PioneerRequest.h"
#import "GLPRequestRefundVC.h"

static NSString *const OrderListCellID = @"OrderListCell";

@interface PersonReturnOrderListController ()
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int allpage;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,strong) PSFSearchConditionModel *searchModel;

@property(nonatomic,strong) ReturnOrderListModel *detailModel;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

static NSString *const lxmj_btnTitle = @"联系卖家";

@implementation PersonReturnOrderListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    [self dc_navBarBackGroundcolor:[UIColor whiteColor]];
    [self dc_navBarTitleWithFont:[UIFont fontWithName:PFRMedium size:17] color:[UIColor dc_colorWithHexString:@"#333333"]];
    if (!_isFirstLoad) {
        [self.listArray removeAllObjects];
        [self getlistData];
        _isFirstLoad = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.orderType == GLPOrderTypeRefundStatesAll || self.orderType == GLPOrderTypeRefundStatesSuccess || self.orderType == GLPOrderTypeRefundStatesFailure || self.orderType == GLPOrderTypeRefundStatesRefunding || self.orderType == GLPOrderTypeRefundStatesRefuse ) {
        self.isRefund = YES;
    }else
        self.isRefund = NO;
    
    [self setUpTableView];
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.listArray removeAllObjects];
        self.tableView.tableFooterView = nil;
        [self getlistData];
    }];
    self.isFirstLoad = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page=self.page+1;
        if (self.page>self.allpage)
        {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
            footView.backgroundColor = RGB_COLOR(247, 247, 247);
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 20)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = RGB_COLOR(51, 51, 51);
            lab.font = [UIFont systemFontOfSize:14];
            lab.text = @"已经到底了";
            [footView addSubview:lab];
            self.tableView.tableFooterView = footView;
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        self.tableView.tableFooterView = nil;
        [self getlistData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"GLPEtpServiceFeeListVCTwoNotification" object:nil];
}

- (void)receiveNotification:(NSNotification *)infoNotification {
    self.page = 1;
    NSDictionary *dic = [infoNotification userInfo];
    PSFSearchConditionModel *model = [dic objectForKey:@"info"];
    self.searchModel.orderNo = model.orderNo;
    self.searchModel.goodsName = model.goodsName;
    self.searchModel.startTime = model.startTime;
    self.searchModel.endTime = model.endTime;
    self.searchModel.searchName = model.searchName;
    [self.tableView.mj_header beginRefreshing];
}

- (void)getlistData
{
    NSString *refundState = @"";
    if (self.orderType==GLPOrderTypeRefundStatesAll)
    {
        refundState = @"";
    }else if (self.orderType==GLPOrderTypeRefundStatesSuccess)
    {
        refundState = @"1";
    }else if (self.orderType==GLPOrderTypeRefundStatesFailure)
    {
        refundState = @"2";
    }else if (self.orderType==GLPOrderTypeRefundStatesRefunding)
    {
        refundState = @"3";
    }else if (self.orderType==GLPOrderTypeRefundStatesRefuse)
    {
        refundState = @"4";
    }
    NSString *orderNo = self.orderNo_str ? self.orderNo_str : @"";
    NSString *searchName = self.searchModel.searchName ? self.searchModel.searchName: @"";
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_order_manage_returnListWithCurrentPage:[NSString stringWithFormat:@"%d",self.page] refundState:refundState orderNo:orderNo searchName:searchName success:^(id  _Nullable response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        
        NSArray *listArr = [ReturnOrderListModel mj_objectArrayWithKeyValuesArray:arr];
        for (ReturnOrderListModel *listModel in listArr) {
            NSArray *list = [OredrGoodsModel mj_objectArrayWithKeyValuesArray:listModel.retrunGoodsVO];
            listModel.retrunGoodsVO = list;
        }
        weakSelf.listArray = [listArr mutableCopy];
        
        [weakSelf.tableView reloadData];
        if (weakSelf.listArray.count>0)
        {
            weakSelf.noorderDataView.hidden = YES;
        }
        else{
            weakSelf.noorderDataView.hidden = NO;
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListCellID forIndexPath:indexPath];
    if (cell==nil){
        cell = [[OrderListCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.isRefund = self.isRefund;
    if (self.listArray.count > 0) {
        ReturnOrderListModel *listmodel = self.listArray[indexPath.section];
        cell.returnModel = listmodel;
    }
    WEAKSELF;
    cell.OrderListCell_Block = ^(NSString * _Nonnull title, ReturnOrderListModel * _Nonnull clickModel) {
        weakSelf.detailModel = clickModel;
        [weakSelf clickBottomViewButton:title];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.listArray.count > 0) {
        ReturnOrderListModel *listmodel = self.listArray[indexPath.section];
        NSArray *arr = listmodel.retrunGoodsVO;
        return (84+8)*arr.count+134;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReturnOrderListModel *model = self.listArray[indexPath.section];
    self.detailModel = model;
    GLPOrderDetailsViewController *vc = [[GLPOrderDetailsViewController alloc] init];
    vc.orderNo_Str = model.orderNo;
    WEAKSELF;
    vc.GLPOrderDetailsViewController_block = ^{
        weakSelf.isFirstLoad = NO;
    };
    [self dc_pushNextController:vc];
}

- (void)clickBottomViewButton:(NSString *)title{
    WEAKSELF;
    if ([title isEqualToString:@"客服"]) {
        [self contactCustomerService];
    }else if([title isEqualToString:@"取消退款"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定取消退款？" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [weakSelf requestCancelRefund];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }
}

#pragma mark ##################################### 功能 #######################################
#pragma mark 取消退款申请
- (void)requestCancelRefund{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_cancelReturnApplyWithOrderNo:self.detailModel.orderNo success:^(id  _Nullable response) {
        [[DCAlterTool shareTool] showDoneWithTitle:@"取消成功" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            //[weakSelf.tableView.mj_header beginRefreshing];
            [weakSelf.listArray removeAllObjects];
            [weakSelf getlistData];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}


//NSString *params = [NSString stringWithFormat:@"id=%@",self.detailModel.orderNo];
//[self dc_pushPersonWebController:@"/geren/detail.html" params:params];
#pragma mark 联系客服contactCustomerService
- (void)contactCustomerService
{
    NSString *goodsName = @"";
    NSString *order_title = @"";
    NSString *price = @"";
    NSString *desc = @"";
    NSString *goodsImage = @"";
    NSString *item_url = @"";
    NSString *orderNo = @"";
    NSString *img_url = @"";
    
    ReturnOrderListModel *model1 = self.detailModel;
    orderNo = model1.orderNo;
    price = model1.payableAmount;
    order_title = [NSString stringWithFormat:@"订单号:%@",orderNo];
    NSArray *arr = [OredrGoodsModel mj_objectArrayWithKeyValuesArray:model1.retrunGoodsVO];
    OredrGoodsModel *fristModel = arr.count > 0  ?  arr[0] : nil;
    goodsName = fristModel.goodsTitle;
    desc = fristModel.packingSpec;
    goodsImage = img_url = fristModel.goodsImg;
    item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/mallcenter/order/orderList.shtml?orderNo=%@",model1.orderNo];
    NSDictionary *dic = @{@"goodsName":goodsName,@"img_url":img_url,@"order_title":order_title,@"price":price,@"desc":desc,@"orderNo":orderNo,@"item_url":item_url,@"goodsImage":goodsImage};
    
    //lj_will_change_end
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
        if ([lgM loginKefuSDK]) {
            NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
            NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
            NSString *chatTitle = @"";
            HDQueueIdentityInfo *queueIdentityInfo = nil;
            HDAgentIdentityInfo *agentIdentityInfo = nil;
            queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
            agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
            chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
            hd_dispatch_main_async_safe(^(){
                [weakSelf hideHud];
                HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
                queue ? (chat.queueInfo = queueIdentityInfo) : nil;
                agent ? (chat.agent = agentIdentityInfo) : nil;
                chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
                chat.title = model1.sellerFirmName;;
                chat.goodsModel = [DCChatGoodsModel mj_objectWithKeyValues:dic];
                chat.sellerFirmName = model1.sellerFirmName;;
                [self.navigationController pushViewController:chat animated:YES];
            });
            
        } else {
            hd_dispatch_main_async_safe(^(){
                [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
            });
            NSLog(@"登录失败");
        }
    });//完整
}

#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0,0, self.view.dc_width, _view_H-5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 84.f;

    [self.tableView registerNib:[UINib nibWithNibName:OrderListCellID bundle:nil] forCellReuseIdentifier:OrderListCellID];
}

- (PSFSearchConditionModel *)searchModel{
    if (!_searchModel) {
        _searchModel = [[PSFSearchConditionModel alloc] init];
    }
    return _searchModel;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0,0, self.view.dc_width, _view_H) image:[UIImage imageNamed:@"p_dindan"] button:nil tip:@"您还没有订单哦！快去下单吧～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}


@end
