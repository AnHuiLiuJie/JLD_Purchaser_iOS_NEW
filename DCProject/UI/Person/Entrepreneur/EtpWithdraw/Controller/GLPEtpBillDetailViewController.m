//
//  GLPEtpBillDetailViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "GLPEtpBillDetailViewController.h"
#import "EtpBillDetailHeaderView.h"
#import "DCNoDataView.h"
#import "DCAPIManager+PioneerRequest.h"
#import "EtpRuleDescriptionView.h"
#import "UIBarButtonItem+Extension.h"
#import "HVWNavigationBarTitleButton.h"
#import "STPickerSingle.h"
#import "GLPEtpStatementsDetailVC.h"

static NSString *const EtpBillDetailCellID = @"EtpBillDetailCell";

@interface GLPEtpBillDetailViewController ()<UITableViewDataSource,UITableViewDelegate,STPickerSingleDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allpage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNoDataView *noDataView;

/* headerView */
@property (strong , nonatomic)EtpBillDetailHeaderView *headerView;
/** 导航栏标题按钮 */
@property(nonatomic, strong) HVWNavigationBarTitleButton *titleButton;
/** 导航栏标题按钮展开标识 */
@property(nonatomic, assign, getter=isTitleButtonExtended) BOOL titleButtonExtended;


@property(nonatomic, assign) BOOL isFirstLoad;
@end

@implementation GLPEtpBillDetailViewController

#pragma mark - 请求 服务费明细列表
- (void)requestLoadData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_bill_detailWithCurrentPage:[NSString stringWithFormat:@"%zi",self.page] billId:self.billId success:^(id  _Nullable response) {
        
        EtpWithdrawBillModel *mainModel = [EtpWithdrawBillModel mj_objectWithKeyValues:response[@"data"]];
        if (weakSelf.page == 1) {
            weakSelf.sectedModel = mainModel.billVo;
            weakSelf.headerView.model = weakSelf.sectedModel;
        }
        
        CommonListModel *commonModel = [CommonListModel mj_objectWithKeyValues:mainModel.orderDateList];
        weakSelf.allpage = [commonModel.totalPage intValue];
        
        NSString *title = [NSString stringWithFormat:@"%@对账单",[NSString getFirstNoZoneStr:weakSelf.sectedModel.billMonth]];
        [weakSelf.titleButton setTitle:title forState:UIControlStateNormal];

        NSArray *arr1 = [EtpOrderListModel mj_objectArrayWithKeyValuesArray:commonModel.pageData];
        
        EtpOrderListModel *lastModel = [weakSelf.dataArray lastObject];

        EtpOrderListModel *firstModel = [arr1 firstObject];
        if ([lastModel.settleDateId isEqual:firstModel.settleDateId]) {
            NSMutableArray *newarr = [NSMutableArray arrayWithArray:lastModel.orderList];
            [arr1 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EtpOrderListModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSArray *arr2 = [EtpOrderPageListModel mj_objectArrayWithKeyValuesArray:obj.orderList];
                obj.orderList = arr2;
            }];
            [newarr addObjectsFromArray:firstModel.orderList];
            lastModel.orderList = newarr;
        }else{
            [arr1 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EtpOrderListModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSArray *arr2 = [EtpOrderPageListModel mj_objectArrayWithKeyValuesArray:obj.orderList];
                obj.orderList = arr2;
            }];
        
            [weakSelf.dataArray addObjectsFromArray:arr1];
        }
    
        if (weakSelf.dataArray.count == 0 && weakSelf.sectedModel==nil) {
            weakSelf.tableView.hidden = YES;
            weakSelf.noDataView.hidden = NO;
        }else{
            weakSelf.tableView.hidden = NO;
            weakSelf.noDataView.hidden = YES;
        }

        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self.dataArray removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
        _isFirstLoad = YES;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    
    [self setUpViewUI];
    
    [self setUpHeaderCenterView];
}

#pragma mark 设置导航栏
- (void) setupNavigationBar {
    HVWNavigationBarTitleButton *titleButton = [[HVWNavigationBarTitleButton alloc] init];
    titleButton.dc_height = 35;
    self.titleButton = titleButton;
    [titleButton setTitle:@"对账单" forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"dc_arrow_down_hei"] forState:UIControlStateNormal];
    [titleButton setBackgroundImage:[UIImage resizedImage:@""] forState:UIControlStateHighlighted];
    // 监听按钮点击事件，替换图标
    [titleButton addTarget:self action:@selector(titleButtonClickd:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}

/** 标题栏按钮点击事件 */
- (void) titleButtonClickd:(UIButton *) button {
    self.titleButtonExtended = !self.titleButtonExtended;
    
    if (self.isTitleButtonExtended) {
        [button setImage:[UIImage imageNamed:@"dc_arrow_up_hei"] forState:UIControlStateNormal];
        NSMutableArray *titleArr = [[NSMutableArray alloc] init];
        __block NSString *nowTitle = @"";
        [self.billList enumerateObjectsUsingBlock:^(EtpBillListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleArr addObject:obj.billMonth];
            if ([self.billId isEqualToString:obj.billId]) {
                nowTitle = obj.billMonth;
            }
        }];
        [self createSTPickerSingleWithTitle:@"请选择对账日期" selectedTitle:nowTitle datas:titleArr];
    } else {
        [button setImage:[UIImage imageNamed:@"dc_arrow_down_hei"] forState:UIControlStateNormal];
    }
}

#pragma mark - 创建时间选择器
- (void)createSTPickerSingleWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle datas:(NSArray *)datas
{
    if ([DC_KeyWindow.subviews.lastObject isKindOfClass:[STPickerSingle class]]) {
        return;
    }
    STPickerSingle *single = [[STPickerSingle alloc] init];
    [single setTitle:title];
    single.font = [UIFont fontWithName:PFR size:14];
    single.titleColor = [UIColor dc_colorWithHexString:@"#3D444D"];
    single.widthPickerComponent = kScreenW;
    single.heightPickerComponent = 35;
    [single setContentMode:STPickerContentModeBottom];
    [single setDelegate:self];
    single.selectedTitle = selectedTitle;
    [single setArrayData:[datas mutableCopy]];
    WEAKSELF;
    single.removeView_Block = ^{
        [weakSelf titleButtonClickd:weakSelf.titleButton];
    };
    [single show];
}

#pragma mark - <STPickerSingleDelegate>
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    [self.billList enumerateObjectsUsingBlock:^(EtpBillListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([selectedTitle isEqualToString:obj.billMonth]) {
            self.billId = obj.billId;
            return;
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 初始化view

- (void)setUpViewUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
}

- (void)setUpHeaderCenterView{
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.EtpBillDetailHeaderViewClickBlock = ^{
        EtpRuleDescriptionView *view = [[EtpRuleDescriptionView alloc] init];
        view.showType = EtpRuleDescriptionViewTypeTaxAmount;
        view.titile_str = @"代缴个税";
        view.frame = DC_KEYWINDOW.bounds;
        [DC_KEYWINDOW addSubview:view];
    };
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpBillDetailCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EtpOrderListModel *model = self.dataArray[indexPath.section];
    cell.orderModel = model;
    WEAKSELF;
    cell.EtpBillDetailCell_Block = ^(EtpOrderPageListModel * _Nonnull model) {
        GLPEtpStatementsDetailVC *vc = [[GLPEtpStatementsDetailVC alloc] init];
        vc.orderNo = model.orderNo;
        [weakSelf dc_pushNextController:vc];
    };
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        EtpOrderListModel *model = self.dataArray[indexPath.section];
        NSArray *arr = model.orderList;
        return 60*arr.count+ (50+5);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // 设置section背景颜色
    view.tintColor = [UIColor clearColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

//#pragma -mark 控制section不悬停
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat sectionHeaderHeight = 8;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//
//    }
//}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F3F3F3"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0,kNavBarHeight, self.view.dc_width, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"EtpBillDetailCell" bundle:nil] forCellReuseIdentifier:EtpBillDetailCellID];
        
        self.page = 1;
        [_tableView.mj_header beginRefreshing];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self.dataArray removeAllObjects];
            self.tableView.tableFooterView = nil;
            [self requestLoadData];
        }];
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page = self.page+1;
            if (self.page > self.allpage)
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
            [self requestLoadData];
        }];
    }
    return _tableView;
}

- (EtpBillDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[EtpBillDetailHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenW, 120);
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;;
}

- (DCNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.bounds image:[UIImage imageNamed:@"dc_bg_noData"] button:nil tip:@"暂无数据~"];
        [self.view addSubview:_noDataView];
    }
    return _noDataView;
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

