//
//  GLPOrderDetailsViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "GLPOrderDetailsViewController.h"
#import "TRStorePageVC.h"
#import "GLPGoodsDetailsController.h"
#import "GLPOrderDetailModel.h"
#import "OrderDetailsTopToolView.h"
#import "OrderDetailsHeaderView.h"
#import "GLPEtpCenterFooterView.h"

#import "OrderLogisticsInfoCell.h"
#import "DeliveryAddressInfoCell.h"
#import "OrderGoodsInfoCell.h"
#import "OrderOtherInfoCell.h"
#import "OrderMyPrescriptionCell.h"

#import "DCAPIManager+PioneerRequest.h"
#import "GLPRefundDetailsVC.h"
#import "LogisticsInformationVC.h"
#import "GLPRequestRefundVC.h"
#import "DCAPIManager+PioneerRequest.h"
#import "CSDemoAccountManager.h"
#import "GLPMessageListVC.h"
#import "DeliveryInformationVC.h"
#import "GLPToPayViewController.h"
#import "GLPAddEvaluationVC.h"
#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + kNavBarHeight*2)
#define IMAGE_HEIGHT (CGFloat)(100+kNavBarHeight)
#define SLIDE_HEIGHT (CGFloat)(IMAGE_HEIGHT+10)



@interface GLPOrderDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

/* headerView */
@property (nonatomic, strong) OrderDetailsHeaderView *headerView;
/* footerView */
@property (nonatomic, strong) GLPEtpCenterFooterView *footerView;
/* 头部背景图片 */
@property (nonatomic, strong) UIImageView *headerBgImageView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 顶部Nva */
@property (strong , nonatomic) OrderDetailsTopToolView *topToolView;
/* 服务数据1 */

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL isNeedChange;

@property (nonatomic, strong) NSMutableArray *bottomArr;

@property (nonatomic, strong) GLPOrderDetailModel *detailModel;
@property (nonatomic, strong) PrescriptionDetailsModel *preModel;
@end

static CGFloat kBottomView_H = 60;
static CGFloat kBtnHight = 33;
static NSInteger kBtnNum = 4;

static NSString *const OrderLogisticsInfoCellID = @"OrderLogisticsInfoCell";
static NSString *const DeliveryAddressInfoCellID = @"DeliveryAddressInfoCell";
static NSString *const OrderGoodsInfoCellID = @"OrderGoodsInfoCell";
static NSString *const OrderOtherInfoCellID = @"OrderOtherInfoCell";
static NSString *const OrderMyPrescriptionCellID = @"OrderMyPrescriptionCell";

@implementation GLPOrderDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleLightContent];
    [self dc_navBarHidden:YES animated:animated];
    [self setUpNavTopView];
    if (!_isFirstLoad) {
        [self requestLoadData];
        _isFirstLoad = YES;
    }
    [self requestNoReadMsgCount];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dc_navBarHidden:NO animated:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
    //[self dc_navBarBackGroundcolor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dc_statusBarStyle:UIStatusBarStyleDefault];

    //self.title = @"订单详情";
    self.title = @"";
    
    [self setUpBase];
    [self setUpHeaderCenterView];
    [self setUpFooterCenterView];
    
}

#pragma mark - 请求 申请创业者
- (void)requestLoadData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_detailWithOrderNo:self.orderNo_Str success:^(id  _Nullable response) {
        GLPOrderDetailModel *orderModel = [GLPOrderDetailModel mj_objectWithKeyValues:response[@"data"]];
        
        NSArray *orderGoodsList = [GLPOrderGoodsListModel mj_objectArrayWithKeyValuesArray:orderModel.orderGoodsList];
        orderModel.orderGoodsList = [orderGoodsList mutableCopy];
        
        GLPOrderDeliveryBeanModel *orderDeliveryBean = [GLPOrderDeliveryBeanModel mj_objectWithKeyValues:orderModel.orderDeliveryBean];
        orderModel.orderDeliveryBean = orderDeliveryBean;
        
        GLPOrderDeliverModel *deliver = [GLPOrderDeliverModel mj_objectWithKeyValues:orderModel.deliver];
        orderModel.deliver = deliver;

        NSArray *orderReturnApplyList = [GLPOrderReturnApplyListModel mj_objectArrayWithKeyValuesArray:orderModel.orderReturnApplyList];
        orderModel.orderReturnApplyList = orderReturnApplyList;
        
        weakSelf.detailModel = orderModel;
        [weakSelf updataViewUI];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

- (void)updataViewUI{
    if (![self.detailModel.rpState isEqualToString:@"0"]) {
        WEAKSELF;
        [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_onlineDetailWithOrderNo:self.orderNo_Str success:^(id  _Nullable response) {
            PrescriptionDetailsModel *model =  [PrescriptionDetailsModel mj_objectWithKeyValues:response[@"data"]];
            
            MedicalPersListModel *drugUser = [MedicalPersListModel mj_objectWithKeyValues:model.drugUser];
            model.drugUser = drugUser;
            
            weakSelf.preModel = model;
            
            [weakSelf.tableView reloadData];
            
        } failture:^(NSError * _Nullable error) {
            
        }];
    }
    
    [self getDifferentOrderStatesData];
    [self.tableView reloadData];
}

- (void)getDifferentOrderStatesData{
    [self.bottomArr removeAllObjects];
    NSString *statusImg = @"dc_order_dfk";
    NSString *description = @"";
    NSString *orderStateStr = self.detailModel.orderStateStr;
    //订单状态：1-待付款；2-待接单，3-已接单；5-已发货；6-待评价；7-交易关闭；8-已退款【全额退款】
    NSString *orderState = [NSString stringWithFormat:@"%@",self.detailModel.orderState];
    //退款状态位：0-无退款，1-退款成功，2-退款失败，3-退款中,4-已拒绝
    NSString *refundState = [NSString stringWithFormat:@"%@",self.detailModel.refundState];
    if ([orderState isEqualToString:@"1"]) {
        self.orderStatusType = BuyGoodsOrderStatusPendingPay;
        [self.bottomArr addObjectsFromArray:@[@"客服",@"取消订单",@"付款"]];
        statusImg = @"dc_order_dfk";
        NSString *lastTime = [NSString stringWithFormat:@"%@",[DCSpeedy getTotalTimeWithStartTime:[DCSpeedy getNowTimeTimesForm:@"yyyy-MM-dd HH:mm:ss"] endTime:self.detailModel.oprEtime]];
        description = [NSString stringWithFormat:@"剩余%@自动关闭",lastTime];
    }else if([orderState isEqualToString:@"2"]){
        self.orderStatusType = BuyGoodsOrderStatusPendingReceive;
        statusImg = @"dc_order_djd";
        if([refundState isEqualToString:@"1"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else if([refundState isEqualToString:@"2"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else if([refundState isEqualToString:@"3"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单",@"取消退款"]];
        }else if([refundState isEqualToString:@"4"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else{
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单",@"退款"]];
        }
    }else if([orderState isEqualToString:@"3"]){
        self.orderStatusType = BuyGoodsOrderStatusPendingShip;
        statusImg = @"dc_order_dfh";
        description = @"买家正准备发货";
        if([refundState isEqualToString:@"1"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else if([refundState isEqualToString:@"2"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else if([refundState isEqualToString:@"3"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单",@"取消退款"]];
        }else if([refundState isEqualToString:@"4"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else{
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单",@"退款"]];
        }
    }else if([orderState isEqualToString:@"5"]){
        self.orderStatusType = BuyGoodsOrderStatusPendingReceipt;
        statusImg = @"dc_order_dsh";
        description = [NSString stringWithFormat:@"请尽快确认收货\n收货截止日期：%@",self.detailModel.oprEtime];
        if([refundState isEqualToString:@"1"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"确认收货"]];
        }else if([refundState isEqualToString:@"2"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"确认收货"]];
        }else if([refundState isEqualToString:@"3"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"取消退款"]];//@"确认收货"
        }else if([refundState isEqualToString:@"4"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"确认收货"]];
        }else{
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"退款",@"确认收货"]];
        }
        if ([self.detailModel.oprState isEqualToString:@"10"]) {
            [self.bottomArr removeObject:@"延期收货"];
        }
    }else if([orderState isEqualToString:@"6"]){
        self.orderStatusType = BuyGoodsOrderStatusTransactionSuccess;
        [self.bottomArr addObjectsFromArray:@[@"客服",@"评价"]];
        statusImg = @"dc_order_jycg";
        NSString *evalState = [NSString stringWithFormat:@"%@",self.detailModel.evalState];
        if ([evalState isEqualToString:@"21"] || [evalState isEqualToString:@"22"]){
            orderStateStr = @"已评价";
            [self.bottomArr removeObject:@"评价"];
        }else{
            orderStateStr = @"待评价";
        }
    }else if([orderState isEqualToString:@"7"]){
        self.orderStatusType = BuyGoodsOrderStatusTransactionClosed;
        [self.bottomArr addObjectsFromArray:@[@"客服",@"删除订单"]];
        statusImg = @"dc_order_jygb";
    }else if([orderState isEqualToString:@"8"]){
;       self.orderStatusType = BuyGoodsOrderStatusRefunded;
        [self.bottomArr addObjectsFromArray:@[@"客服"]];
        statusImg = @"dc_order_tkcg";
        
        if ([self.detailModel.refundState isEqualToString:@"0"]) {
            
        }else {
            orderStateStr = self.detailModel.refundStateStr;
            [self.bottomArr removeAllObjects];

            if([refundState isEqualToString:@"1"]){
                [self.bottomArr addObjectsFromArray:@[@"客服"]];
                statusImg = @"dc_order_tkcg";
            }else if([refundState isEqualToString:@"2"]){
                [self.bottomArr addObjectsFromArray:@[@"客服"]];
                statusImg = @"dc_order_tksb";
            }else if([refundState isEqualToString:@"3"]){
                [self.bottomArr addObjectsFromArray:@[@"客服",@"取消退款"]];
                statusImg = @"dc_order_tkz";
            }else if([refundState isEqualToString:@"4"]){
                [self.bottomArr addObjectsFromArray:@[@"客服"]];
                statusImg = @"dc_order_tksb";
            }
            description = self.detailModel.refundStateTs;
        }
    }else{////这里要注意

    }
    
    //拼团商品不可以退款
    if ([self.detailModel.orderType isEqualToString:@"4"] && ![self.detailModel.joinState isEqualToString:@"1"]) {
        [self.bottomArr removeObject:@"退款"];
    }
    
    [self.headerView.statusImg setImage:[UIImage imageNamed:statusImg]];
    self.headerView.statusLab.text = orderStateStr;
    self.headerView.descriptionLab.text = description;
    [self changeBottomView:self.bottomArr];
}

#pragma mark - initialize
- (void)setUpBase
{
    self.orderStatusType = BuyGoodsOrderStatusPendingPay;
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    self.topToolView.hidden = NO;
    WEAKSELF;
    _topToolView.rightItemClickBlock = ^{
        GLPMessageListVC *vc = [GLPMessageListVC new];
        [weakSelf dc_pushNextController:vc];
    };
}

#pragma mark - 初始化头部
- (void)setUpHeaderCenterView{
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerBgImageView.frame = self.headerView.bounds;
    [self.headerView insertSubview:self.headerBgImageView atIndex:0]; //将背景图片放到最底层
    
}

#pragma mark - setUpFooterCenterView
- (void)setUpFooterCenterView{
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if ([self.detailModel.deliver.isSeparate isEqualToString:@"0"]) {
            return 0;
        }
        if (self.detailModel.deliver == nil) {
            return 0;
        }
    }
    if (section == 4) {
        NSInteger sectionNum = 1;
        if ([self.detailModel.rpState isEqualToString:@"0"]) {
            return 0;
        }else{
            if (self.preModel.billDesc.length > 0) {
                sectionNum = sectionNum + 1;
            }
            if (self.preModel.supUrl.length > 0) {
                sectionNum = sectionNum + 1;
            }
            return sectionNum;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cusCell = [UITableViewCell new];
    WEAKSELF;
    if (indexPath.section == 0) {
        OrderLogisticsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderLogisticsInfoCellID forIndexPath:indexPath];
        if (self.detailModel.deliver != nil) {
            cell.model = self.detailModel.deliver;
        }
        cusCell = cell;
    }else if(indexPath.section == 1){
        DeliveryAddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:DeliveryAddressInfoCellID forIndexPath:indexPath];
        if (self.detailModel != nil) {
            cell.model = self.detailModel;
        }
        cusCell = cell;
    }else if (indexPath.section == 2){
        OrderGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderGoodsInfoCellID forIndexPath:indexPath];
        if (self.detailModel != nil) {
            cell.model = self.detailModel;
        }
        cell.OrderGoodsInfoCell_block = ^(GLPOrderGoodsListModel * _Nonnull model) {
            GLPRefundDetailsVC *vc = [[GLPRefundDetailsVC alloc] init];
            vc.orderGoodsIdStr = model.orderGoodsId;
            vc.detailModel = self.detailModel;
            [weakSelf dc_pushNextController:vc];
        };
        cell.OrderGoodsInfoCell_Block = ^{
            TRStorePageVC *vc = [[TRStorePageVC alloc] init];
            vc.firmId = weakSelf.detailModel.sellerFirmId;
            [weakSelf dc_pushNextController:vc];
        };
        cell.OrderGoodsInfoIndexCell_block = ^(GLPOrderGoodsListModel * _Nonnull model) {
            GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
            vc.goodsId = [NSString stringWithFormat:@"%@",model.goodsId];
            vc.batchId = model.batchId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cusCell = cell;
    }else if (indexPath.section == 3){
        OrderOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderOtherInfoCellID forIndexPath:indexPath];
        if (self.detailModel != nil) {
            cell.model = self.detailModel;
        }
        cusCell = cell;
    }else if (indexPath.section == 4){
        OrderMyPrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderMyPrescriptionCellID forIndexPath:indexPath];
        if (self.preModel != nil) {
            if (indexPath.row == 0) {
                cell.showType = 0;
            }else if(indexPath.row == 1){
                if (self.preModel.billDesc.length > 0 ) {
                    cell.showType = 1;
                }else
                    cell.showType = 2;
            }else{
                cell.showType = 2;
            }
            cell.model = self.preModel;
        }
        cell.OrderMyPrescriptionCell_block = ^(NSString * _Nonnull imageUrl) {
            
        };
        cusCell = cell;
    }
    cusCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cusCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }else{
        return 10.0f;
    }
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([self.detailModel.deliver.isSeparate isEqualToString:@"1"]) {//分开
            LogisticsInformationVC *vc = [[LogisticsInformationVC alloc] init];
            vc.orderNoStr = self.detailModel.orderNo;
            vc.allGoodsArr = self.detailModel.orderGoodsList;
            [self dc_pushNextController:vc];
        }else{
            DeliveryInformationVC *vc = [[DeliveryInformationVC alloc] init];
            vc.orderNoStr = self.detailModel.orderNo;
            [self dc_pushNextController:vc];
        }
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat topH = kNavBarHeight;
    
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
            self.topToolView.backgroundColor = RGB_COLOR(253, 79, 0);
        }else{
            CGFloat alpha = (offsetY -SLIDE_HEIGHT + topH*2) / topH;
            if (alpha < 0 ) {
                return;
            }
            //[self.topToolView wr_setBackgroundAlpha:alpha];
            self.topToolView.backgroundColor = RGBA_COLOR(253, 79, 0,1);//alpha
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
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kBottomView_H-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderLogisticsInfoCell class]) bundle:nil] forCellReuseIdentifier:OrderLogisticsInfoCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DeliveryAddressInfoCell class]) bundle:nil] forCellReuseIdentifier:DeliveryAddressInfoCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderGoodsInfoCell class]) bundle:nil] forCellReuseIdentifier:OrderGoodsInfoCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderOtherInfoCell class]) bundle:nil] forCellReuseIdentifier:OrderOtherInfoCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderMyPrescriptionCell class]) bundle:nil] forCellReuseIdentifier:OrderMyPrescriptionCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), kScreenW, kBottomView_H);
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        
        CGFloat spacing = 10.0f;
        CGFloat itemW = (kScreenW-spacing*5)/4;
        //NSInteger num = self.bottomArr.count;
        //CGFloat leftX = kScreenW -(num+1)*spacing-num*itemW;
        CGFloat itemH = kBtnHight;
        CGFloat index = 0;
        NSArray *allTitle = @[@"客服1",@"客服2",@"客服3",@"客服4"];
        for (NSString *str in allTitle) {
            NSString *title = [NSString stringWithFormat:@"%@",str];
            UIFont *font = [UIFont fontWithName:PFR size:15];
            UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            subBtn.backgroundColor = [UIColor whiteColor];
            subBtn.titleLabel.font = font;
            [subBtn setTitle:title forState:UIControlStateNormal];
            [subBtn setTitleColor:[UIColor dc_colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [subBtn setTitleColor:[UIColor dc_colorWithHexString:@"#14D7C7"] forState:UIControlStateSelected];
            subBtn.tag = index;

            [subBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:subBtn];
            
            [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_bottomView).offset(spacing+(spacing+itemW)*index);
                make.centerY.equalTo(_bottomView).offset(0);
                make.size.equalTo(CGSizeMake(itemW, itemH));
            }];
            subBtn.selected = NO;
            subBtn.hidden = YES;
            [DCSpeedy dc_changeControlCircularWith:subBtn AndSetCornerRadius:itemH/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#666666"] canMasksToBounds:YES];
            index++;
        }
    }
    return _bottomView;
}

- (UIImageView *)headerBgImageView{
    if (!_headerBgImageView) {
        _headerBgImageView = [[UIImageView alloc] init];
        //[_headerBgImageView setImage:[UIImage imageNamed:@"dc_order_tbg"]];
        //[_headerBgImageView setBackgroundColor:[UIColor clearColor]];
        [_headerBgImageView setBackgroundColor:[UIColor dc_colorWithHexString:@"#FD4F00"]];
        [_headerBgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headerBgImageView setClipsToBounds:YES];
    }
    return _headerBgImageView;
}

- (OrderDetailsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [OrderDetailsHeaderView dc_viewFromXib];
        _headerView.frame = CGRectMake(0, 0, kScreenW, IMAGE_HEIGHT);

    }
    return _headerView;
}

- (GLPEtpCenterFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[GLPEtpCenterFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, kScreenW, 5);
    }
    return _footerView;
}

- (OrderDetailsTopToolView *)topToolView{
    if (!_topToolView) {
        _topToolView = [[OrderDetailsTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _topToolView.leftItemClickBlock = ^{ //点击了左侧
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        [self.view addSubview:_topToolView];
    }
    return _topToolView;
}

- (NSMutableArray *)bottomArr{
    if (!_bottomArr) {
        _bottomArr = [[NSMutableArray alloc] init];
    }
    return _bottomArr;
}

- (void)changeBottomView:(NSArray *)array{
    NSInteger num = array.count;
    NSInteger differNum = kBtnNum - num;
    NSInteger index = 0;
    //BOOL isShow = NO;
    for (UIView *btn in self.bottomView.subviews) {
        UIButton *subBtn = (UIButton *)btn;
        NSInteger tag = subBtn.tag;
        if (tag >= differNum ) {
            subBtn.hidden = NO;
            [subBtn setTitle:array[index] forState:UIControlStateNormal];
            index++;
        }
        NSString *title = subBtn.titleLabel.text;
        if ([title isEqualToString:@"删除订单"] || [title isEqualToString:@"付款"] || [title isEqualToString:@"确认收货"] || [title isEqualToString:@"评价"] || [title isEqualToString:@"取消退款"] ) {
            subBtn.selected = YES;
            [DCSpeedy dc_changeControlCircularWith:subBtn AndSetCornerRadius:kBtnHight/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#14D7C7"] canMasksToBounds:YES];
        }else{
            subBtn.selected = NO;
            [DCSpeedy dc_changeControlCircularWith:subBtn AndSetCornerRadius:kBtnHight/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#666666"] canMasksToBounds:YES];
        }
    }
}

- (void)confirmBtnAction:(UIButton *)button{
    WEAKSELF;
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"客服"]) {
        [self contactCustomerService];
    }else if([title isEqualToString:@"取消订单"]){
        GLPRequestRefundVC *vc = [[GLPRequestRefundVC alloc] init];
        vc.showType = 1;
        vc.modifyTimeParamStr = self.detailModel.modifyTime;
        vc.orderNoStr = self.detailModel.orderNo;
        vc.GLPRequestRefundVC_Block = ^{
            weakSelf.isFirstLoad = NO;
            !weakSelf.GLPOrderDetailsViewController_block ? : weakSelf.GLPOrderDetailsViewController_block();
        };
        [self dc_pushNextController:vc];
    }else if([title isEqualToString:@"付款"]){
        GLPToPayViewController *vc = [[GLPToPayViewController alloc] init];
        vc.orderNoStr = self.detailModel.orderNo;
        vc.isNeedBackOrder = YES;
        vc.firmIdStr = self.detailModel.sellerFirmId;
        [weakSelf dc_pushNextController:vc];
        //NSString *paramStr = [NSString stringWithFormat:@"orderNo=%@",self.detailModel.orderNo];
        //[self dc_pushPersonWebToPayController:@"/geren/pay.html" params:paramStr targetIndex:0];
    }else if([title isEqualToString:@"催单"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定需要催单" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [self requestRemindOrder];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"删除订单"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定删除订单" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [self requestDeleteOrder];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"延期收货"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定延期收货？" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [self requestAplyDlayRecvGoods];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"确认收货"]){
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确认收货？" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [self requestRecvGoods];
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
            [self requestCancelRefund];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else if([title isEqualToString:@"申请售后"]){
        [self dc_pushPersonWebController:@"/geren/sale_list.html" params:nil];
    }else if([title isEqualToString:@"退款"]){
        GLPRequestRefundVC *vc = [[GLPRequestRefundVC alloc] init];
        vc.showType = 2;
        vc.orderNoStr = self.detailModel.orderNo;
        vc.GLPRequestRefundVC_Block = ^{
            weakSelf.isFirstLoad = NO;
            !weakSelf.GLPOrderDetailsViewController_block ? : weakSelf.GLPOrderDetailsViewController_block();
        };
        [self dc_pushNextController:vc];
    }
}

#pragma mark ##################################### 功能 #######################################
#pragma mark -确认收货
- (void)requestRecvGoods{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_recvGoodsWithOrderNo:self.detailModel.orderNo modifyTimeParam:self.detailModel.modifyTime success:^(id  _Nullable response) {
        !weakSelf.GLPOrderDetailsViewController_block ? : weakSelf.GLPOrderDetailsViewController_block();
        [[DCAlterTool shareTool] showDoneWithTitle:@"收货成功！" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf requestLoadData];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark -延期收货
- (void)requestAplyDlayRecvGoods{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_aplyDlayRecvGoodsWithOrderNo:self.detailModel.orderNo modifyTimeParam:self.detailModel.modifyTime success:^(id  _Nullable response) {
        !weakSelf.GLPOrderDetailsViewController_block ? : weakSelf.GLPOrderDetailsViewController_block();
        [[DCAlterTool shareTool] showDoneWithTitle:@"延期成功！" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf requestLoadData];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - 催单
- (void)requestRemindOrder{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_remindWithOrderNo:self.detailModel.orderNo success:^(id  _Nullable response) {
        !weakSelf.GLPOrderDetailsViewController_block ? : weakSelf.GLPOrderDetailsViewController_block();
        [[DCAlterTool shareTool] showDoneWithTitle:@"已成功催单" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark 删除订单
- (void)requestDeleteOrder{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_deleteOrderWithOrderNo:self.detailModel.orderNo modifyTimeParam:self.detailModel.modifyTime success:^(id  _Nullable response) {
        !weakSelf.GLPOrderDetailsViewController_block ? : weakSelf.GLPOrderDetailsViewController_block();
        [[DCAlterTool shareTool] showDoneWithTitle:@"您已成功删除该订单！" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark 取消退款申请
- (void)requestCancelRefund{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_cancelReturnApplyWithOrderNo:self.detailModel.orderNo success:^(id  _Nullable response) {
        !weakSelf.GLPOrderDetailsViewController_block ? : weakSelf.GLPOrderDetailsViewController_block();
        [[DCAlterTool shareTool] showDoneWithTitle:@"取消成功" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf requestLoadData];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark 联系客服
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
    
    orderNo = self.detailModel.orderNo;
    order_title = [NSString stringWithFormat:@"订单号:%@",orderNo];
    price = self.detailModel.payableAmount;
    NSArray *arr = self.detailModel.orderGoodsList;
    GLPOrderGoodsListModel *fristModel = arr.count > 0  ?  arr[0] : nil;
    goodsName = fristModel.goodsTitle;
    desc = fristModel.packingSpec;
    goodsImage = img_url = fristModel.goodsImg;
    item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/mallcenter/order/orderList.shtml?orderNo=%@",orderNo];
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
                chat.title = weakSelf.detailModel.sellerFirmName;;
                chat.goodsModel = [DCChatGoodsModel mj_objectWithKeyValues:dic];
                chat.sellerFirmName = weakSelf.detailModel.sellerFirmName;;
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

#pragma mark - 请求 获取未读消息数量
- (void)requestNoReadMsgCount
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestNoReadMsgCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"]) {
                NSInteger count = [response[@"data"] integerValue];
                weakSelf.topToolView.count = count;
            }
        }
    } failture:^(NSError *_Nullable error) {
        
    }];
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
