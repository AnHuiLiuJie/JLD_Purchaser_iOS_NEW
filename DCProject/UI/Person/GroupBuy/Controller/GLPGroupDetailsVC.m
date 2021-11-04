//
//  GLPGroupDetailsVC.m
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import "GLPGroupDetailsVC.h"
// Controllers
//#import "GLPGoodsDetailsController.h"
#import "GLPOrderDetailsViewController.h"
#import "GLPToPayViewController.h"
#import "GLPConfirmOrderViewController.h"
// Models
#import "GLPNewShoppingCarModel.h"
// Views
#import "DCNoDataView.h"
#import "GLPGroupDetailsFootterView.h"
/* cell */

/* head */
#import "DCUMShareTool.h"
/* foot */
// Vendors
// Categories
#import "DCAPIManager+Activity.h"

@interface GLPGroupDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) DCNoDataView *noorderDataView;

/* footterView */
@property (strong , nonatomic) GLPGroupDetailsFootterView *footterView;
@end

static CGFloat const submitBtnH = 45;
static NSString *const GLPGroupDetailsCellID = @"GLPGroupDetailsCell";
static NSString *const submitBtnStr1 = @"去付款";
static NSString *const submitBtnStr2 = @"再开一团";
static NSString *const submitBtnStr3 = @"请好友参团";

@implementation GLPGroupDetailsVC

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-10-submitBtnH);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = NO;
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPGroupDetailsCell class]) bundle:nil] forCellReuseIdentifier:GLPGroupDetailsCellID];
    }
    return _tableView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:submitBtnStr3 forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _submitBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
        _submitBtn.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-10-submitBtnH, kScreenW-30, submitBtnH);
        [DCSpeedy dc_changeControlCircularWith:_submitBtn AndSetCornerRadius:_submitBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
        [self.view addSubview:_submitBtn];
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#42E5A6"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#00B7AB"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0,0);
        gradientLayer2.endPoint = CGPointMake(1,0);
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = _submitBtn.bounds;
        [_submitBtn.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [_submitBtn dc_cornerRadius:_submitBtn.dc_height/2];
    }
    return _submitBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.bounds image:[UIImage imageNamed:@"p_dindan"] button:nil tip:@"暂无更多数据～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}

- (GLPGroupDetailsFootterView *)footterView{
    if (!_footterView) {
        _footterView = [[GLPGroupDetailsFootterView alloc] init];
        _footterView.frame = CGRectMake(0, 0, kScreenW, 200);
        WEAKSELF;
        _footterView.GLPGroupDetailsFootterView_block = ^() {
            GLPOrderDetailsViewController *vc = [[GLPOrderDetailsViewController alloc] init];
            vc.orderNo_Str = weakSelf.model.orderNo;
            vc.GLPOrderDetailsViewController_block = ^{
                weakSelf.isFirstLoad = NO;
            };
            [weakSelf dc_pushNextController:vc];
        };
    }
    return _footterView;
}

- (void)getlistData{
    NSString *joinId = self.model.joinId;
//    NSString *orderNo = self.model.orderNo;//穿一个
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_activity_collage_mycollageDetailWithCurrentPage:@"1" joinId:joinId orderNo:@"" success:^(id  _Nullable response) {
        DCMyCollageListModel *model = [DCMyCollageListModel mj_objectWithKeyValues:response[@"data"]];
        weakSelf.model = model;
        [weakSelf changeViewUI];
        [weakSelf.tableView reloadData];
//        [weakSelf.dataArray addObject:model];

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
        

}

#pragma makr - set model


#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self.dataArray removeAllObjects];
        [self getlistData];
        _isFirstLoad = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"拼团详情";
    
    [self.view addSubview:self.tableView];

    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    self.tableView.tableFooterView = self.footterView;
}

- (void)changeViewUI{
    
    self.footterView.model = self.model;
    [self.dataArray addObject:self.model];
    
    for (UIView *subview in self.view.subviews) {
        if (subview.tag == 1122) {
            [subview removeFromSuperview];
        }
    }

    //参与状态：0-等待参与，1-成功，2-失败，3-等待付款
    if ([self.model.joinState isEqualToString:@"0"]) {
        [self.submitBtn setTitle:submitBtnStr3 forState:UIControlStateNormal];
    }else if([self.model.joinState isEqualToString:@"1"]){
        [self.submitBtn setTitle:submitBtnStr3 forState:UIControlStateNormal];
    }else if([self.model.joinState isEqualToString:@"2"]){
        [self.submitBtn setTitle:submitBtnStr2 forState:UIControlStateNormal];
    }else if([self.model.joinState isEqualToString:@"3"]){
        [self.submitBtn setTitle:submitBtnStr1 forState:UIControlStateNormal];
    }
    
    if ([self.model.collageState integerValue] == 1) {
        //进行中
    }else if ([self.model.collageState integerValue] == 2 || [self.model.collageState integerValue] == 2) {
        //已结束
        UILabel *tipsLab = [[UILabel alloc] init];
        tipsLab.tag = 1122;
        tipsLab.font = [UIFont fontWithName:PFRMedium size:18];
        tipsLab.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-10-submitBtnH, kScreenW-30, submitBtnH);
        if ([self.model.collageState integerValue] == 3) {
            tipsLab.text = @"已售罄";
        }else
            tipsLab.text = @"活动结束";
        tipsLab.textColor = [UIColor dc_colorWithHexString:@"#666666"];
        tipsLab.backgroundColor = [UIColor clearColor];
        tipsLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tipsLab];
    }else{
        //未开始
    }
    
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPGroupDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPGroupDetailsCellID forIndexPath:indexPath];
    cell.myModel = _dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - 邀请
- (void)submitBtnAction:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:submitBtnStr1]) {
        GLPToPayViewController *vc = [[GLPToPayViewController alloc] init];
        vc.orderNoStr = _model.orderNo;
        vc.isNeedBackOrder = NO;
        vc.firmIdStr = _model.sellerFirmId;
        [self dc_pushNextController:vc];
    }else if([button.titleLabel.text isEqualToString:submitBtnStr2]){
        [self requestBuyGoods:_model];
    }else if([button.titleLabel.text isEqualToString:submitBtnStr3]){
        NSString *orderNo = _model.orderNo;
        NSString *joinId = _model.joinId;
        if ([_model.joinType isEqualToString:@"2"]) {
            joinId = _model.sourceJoinId;
        }
        [[DCUMShareTool shareClient] shareInfoWithImage:_model.goodsImg WithTitle:_model.goodsName orderNo:orderNo joinId:joinId goodsId:@"" content:@"金利达" url:[NSString stringWithFormat:@"%@//pages/drug/collage_detail?orderNo=%@&joinId=%@",Person_H5BaseUrl,orderNo,joinId] completion:^(id result, NSError *error) {
        }];
    }
}

#pragma mark - 数据提交 购买
- (void)requestBuyGoods:(DCMyCollageListModel *)model{
    //立刻开团
    NSString *goodsId = model.goodsId;//-*-
    NSString *batchId = model.batchId;//-*-
    NSString *quantity = @"1";//-*-
    NSString *sellerFirmId = model.sellerFirmId;//-*-
    NSString *tradeType = @"4";//1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
    NSArray *cart = @[];
    
    __block NSString *actType = @"2";//1-秒杀；2-拼团；
    __block NSString *actId = model.collageId;//秒杀或者拼团的Id
    NSString *joinId = @"";//参与时存发起拼团ID（拼团购买使用）
    NSString *mixId = @"";//组合装Id

    NSDictionary *paramDic = @{@"goodsId":goodsId,
                          @"batchId":batchId,
                          @"quantity":quantity,
                          @"sellerFirmId":sellerFirmId,
                          @"tradeType":tradeType,
                          @"cart":cart,
                          @"actType":actType,
                          @"actId":actId,
                          @"joinId":joinId,
                          @"mixId":mixId};
    WEAKSELF;
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_confirmOrder_newWith:paramDic success:^(id  _Nullable response) {
        GLPNewShoppingCarModel *model = [GLPNewShoppingCarModel mj_objectWithKeyValues:response[@"data"]];
        NSArray *firmList = [GLPFirmListModel mj_objectArrayWithKeyValuesArray:model.firmList];
        for (GLPFirmListModel *firmModel in firmList) {
            NSArray *actInfoList = [ActInfoListModel mj_objectArrayWithKeyValuesArray:firmModel.actInfoList];
            NSArray *cartGoodsList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:firmModel.cartGoodsList];
            NSArray *couponList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.couponList];
            NSArray *defaultCoupon = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.defaultCoupon];
            for (ActInfoListModel *actModel in actInfoList) {
                NSArray *actInfoList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:actModel.actGoodsList];
                actModel.actGoodsList = [actInfoList mutableCopy];
            }
            firmModel.actInfoList = [actInfoList mutableCopy];
            firmModel.cartGoodsList = [cartGoodsList mutableCopy];
            firmModel.couponList = couponList;
            firmModel.defaultCoupon = defaultCoupon;
        }
        model.firmList = firmList;
        GLPConfirmOrderViewController *vc = [GLPConfirmOrderViewController new];
        vc.actDic = paramDic;
        vc.ispay = @"1";
        vc.mainModel = model;
        NSDictionary *dict = @{@"type":@"创建订单详情页"};//UM统计 自定义搜索关键词事件
        [MobClick event:UMEventCollection_31 attributes:dict];
        //            vc.shoppingcarArray = array;
        //            vc.ispay = @"1";
        //            vc.goodsId = self.goodsId;
        //            vc.quanlity = [NSString stringWithFormat:@"%ld",self.buyCount];
        
        [weakSelf dc_pushNextController:vc];
        
    } failture:^(NSError * _Nullable error) {
    }];
}


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
