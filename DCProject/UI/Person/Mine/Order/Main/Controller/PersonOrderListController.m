//
//  GLBOrderListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PersonOrderListController.h"
#import "OrderListCell.h"
#import "OrderListModel.h"
#import "CSDemoAccountManager.h"
#import "DCNoDataView.h"
#import "PioneerServiceFeeModel.h"
#import "GLPOrderDetailsViewController.h"
#import "DCAPIManager+PioneerRequest.h"
#import "GLPRequestRefundVC.h"
#import "GLPToPayViewController.h"
#import "GLPAddEvaluationVC.h"

static NSString *const OrderListCellID = @"OrderListCell";

@interface PersonOrderListController ()
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int allpage;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,strong) PSFSearchConditionModel *searchModel;

@property(nonatomic,strong) OrderListModel *detailModel;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

static NSString *const lxmj_btnTitle = @"联系卖家";

@implementation PersonOrderListController

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
    NSString *orderState = @"";
    NSString *evalState = @"";
    NSString *refundState = @"";
    if (self.orderType==GLPOrderTypeAll) {
        orderState = @"";
        evalState = @"";
    }
    else if (self.orderType==GLPOrderTypePay)
    {
        orderState = @"1";
        evalState = @"";
    }
    else if (self.orderType==GLPOrderTypeSend)
    {
        orderState = @"3";
        evalState = @"";
    }
    else if (self.orderType==GLPOrderTypeAccept)
    {
        orderState = @"5";
        evalState = @"";
    }
    else if (self.orderType==GLPOrderTypeEvaluate)
    {
        orderState = @"6";
        evalState = @"11";
    }else{
        if (self.orderType==GLPOrderTypeRefundStatesAll)
        {
            refundState = @"0";
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
    }
    
    NSString *sellerFirmName = self.sellerFirmName ? self.sellerFirmName : @"";
    NSString *orderNo = self.orderNo_str ? self.orderNo_str : @"";
    NSString *startDate = self.searchModel.startTime ? self.searchModel.startTime: @"";
    NSString *endDate = self.searchModel.endTime ? self.searchModel.endTime: @"";
    NSString *goodsName = self.searchModel.goodsName ? self.searchModel.goodsName: @"";
    NSString *searchName = self.searchModel.searchName ? self.searchModel.searchName: @"";
    WEAKSELF;
    [[DCAPIManager shareManager]person_getOrderListWithbuyerDelState:@"" currentPage:[NSString stringWithFormat:@"%d",self.page] endDate:endDate evalState:evalState orderNo:orderNo orderState:orderState refundState:refundState sellerFirmName:sellerFirmName startDate:startDate searchName:searchName goodsName:goodsName success:^(id response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        NSArray *listArr = [OrderListModel mj_objectArrayWithKeyValuesArray:arr];
        for (OrderListModel *listModel in listArr) {
            NSArray *list = [OredrGoodsModel mj_objectArrayWithKeyValuesArray:listModel.orderGoodsList];
            listModel.orderGoodsList = list;
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
//    NSString *CellIdentifier = [NSString stringWithFormat:@"OrderListCellID%ld%ld", (long)[indexPath section], (long)[indexPath row]];
//    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
//    if (cell == nil) {
//        cell = (OrderListCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"OrderListCell" owner:self options:nil]  lastObject];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.orderType == GLPOrderTypeRefundStatesAll || self.orderType == GLPOrderTypeRefundStatesSuccess || self.orderType == GLPOrderTypeRefundStatesFailure || self.orderType == GLPOrderTypeRefundStatesRefunding || self.orderType == GLPOrderTypeRefundStatesRefuse ) {
        cell.isRefund = YES;
    }else
        cell.isRefund = NO;

    if (self.listArray.count > 0) {
        OrderListModel *listmodel = self.listArray[indexPath.section];
        cell.model = listmodel;
    }
    WEAKSELF;
    cell.OrderListCell_block = ^(NSString * _Nonnull title, OrderListModel * _Nonnull clickModel) {
        weakSelf.detailModel = clickModel;
        [weakSelf clickBottomViewButton:title];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.listArray.count > 0) {
        OrderListModel *listmodel = self.listArray[indexPath.section];
        NSArray *arr = listmodel.orderGoodsList;
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
    OrderListModel *model = self.listArray[indexPath.section];
    self.detailModel = model;
    GLPOrderDetailsViewController *vc = [[GLPOrderDetailsViewController alloc] init];
    vc.orderNo_Str = model.orderNo;
    WEAKSELF;
    vc.GLPOrderDetailsViewController_block = ^{
        weakSelf.isFirstLoad = NO;
    };
    [self dc_pushNextController:vc];
}

//#warning 进入web的订单详情，上线前要修改
- (void)clickBottomViewButton:(NSString *)title{
    WEAKSELF;
    if ([title isEqualToString:@"客服"]) {
        [self contactCustomerService];
    }else if([title isEqualToString:@"取消订单"]){
        GLPRequestRefundVC *vc = [[GLPRequestRefundVC alloc] init];
        vc.showType = 1;
        vc.modifyTimeParamStr = self.detailModel.modifyTime;
        vc.orderNoStr = self.detailModel.orderNo;
        vc.GLPRequestRefundVC_Block = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self dc_pushNextController:vc];
    }else if([title isEqualToString:@"付款"]){
        GLPToPayViewController *vc = [[GLPToPayViewController alloc] init];
        vc.orderNoStr = self.detailModel.orderNo;
        vc.isNeedBackOrder = NO;
        vc.firmIdStr = self.detailModel.sellerFirmId;
        [weakSelf dc_pushNextController:vc];
        //NSString *paramStr = [NSString stringWithFormat:@"orderNo=%@",self.detailModel.orderNo];
        //[self dc_pushPersonWebToPayController:@"/geren/pay.html" params:paramStr targetIndex:0];
    }else if([title isEqualToString:@"催单"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定需要催单" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [weakSelf requestRemindOrder];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"删除订单"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定删除订单" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [weakSelf requestDeleteOrder];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"延期收货"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定延期收货？" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [weakSelf requestAplyDlayRecvGoods];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"确认收货"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确认收货？" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [weakSelf requestRecvGoods];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"评价"]){
        self.isFirstLoad = NO;
        GLPAddEvaluationVC *vc = [[GLPAddEvaluationVC alloc] init];
        vc.orderNoStr = self.detailModel.orderNo;
        [self dc_pushNextController:vc];
        
//        NSString *params = [NSString stringWithFormat:@"orderNo=%@",self.detailModel.orderNo];
//        [self dc_pushPersonWebController:@"/geren/evaluate_geren.html" params:params];
    }else if([title isEqualToString:@"取消退款"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定取消退款？" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [weakSelf requestCancelRefund];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"申请售后"]){
        [self dc_pushPersonWebController:@"/geren/sale_list.html" params:nil];
    }else if([title isEqualToString:@"退款"]){
        GLPRequestRefundVC *vc = [[GLPRequestRefundVC alloc] init];
        vc.showType = 2;
        vc.orderNoStr = self.detailModel.orderNo;
        vc.GLPRequestRefundVC_Block = ^{
            //[weakSelf.tableView.mj_header beginRefreshing];
            [weakSelf.listArray removeAllObjects];
            [weakSelf getlistData];
        };
        [self dc_pushNextController:vc];
    }
}

#pragma mark ##################################### 功能 #######################################
#pragma mark -确认收货
- (void)requestRecvGoods{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_recvGoodsWithOrderNo:self.detailModel.orderNo modifyTimeParam:self.detailModel.modifyTime success:^(id  _Nullable response) {
        [[DCAlterTool shareTool] showDoneWithTitle:@"收货成功！" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark -延期收货
- (void)requestAplyDlayRecvGoods{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_aplyDlayRecvGoodsWithOrderNo:self.detailModel.orderNo modifyTimeParam:self.detailModel.modifyTime success:^(id  _Nullable response) {
        [[DCAlterTool shareTool] showDoneWithTitle:@"延期成功！" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.listArray removeAllObjects];
            [weakSelf getlistData];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - 催单
- (void)requestRemindOrder{
    //WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_remindWithOrderNo:self.detailModel.orderNo success:^(id  _Nullable response) {
        [[DCAlterTool shareTool] showDoneWithTitle:@"已成功催单" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 删除订单
- (void)requestDeleteOrder{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_deleteOrderWithOrderNo:self.detailModel.orderNo modifyTimeParam:self.detailModel.modifyTime success:^(id  _Nullable response) {
        [[DCAlterTool shareTool] showDoneWithTitle:@"您已成功删除该订单！" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

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
    
    OrderListModel *model1 = self.detailModel;
    orderNo = model1.orderNo;
    price = model1.payableAmount;
    order_title = [NSString stringWithFormat:@"订单号:%@",orderNo];
    NSArray *arr = [OredrGoodsModel mj_objectArrayWithKeyValuesArray:model1.orderGoodsList];
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
