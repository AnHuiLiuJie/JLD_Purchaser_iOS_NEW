//
//  GLPRefundDetailsVC.m
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "GLPRefundDetailsVC.h"
#import "DCAPIManager+PioneerRequest.h"
#import "RefundDetailsListCell.h"
#import "DCAPIManager+PioneerRequest.h"
#import "TRStorePageVC.h"
@interface GLPRefundDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger indexCell;

@end

static NSString *const RefundDetailsListCellID = @"RefundDetailsListCell";


@implementation GLPRefundDetailsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleLightContent];
    [self dc_navBarBackGroundcolor:[UIColor dc_colorWithHexString:@"#FC4516"]];
    [self dc_navBarTitleWithFont:[UIFont fontWithName:PFRMedium size:17] color:[UIColor whiteColor]];//与对称出现 [UIColor dc_colorWithHexString:@"#333333"]
    
    if (!_isFirstLoad) {
        [self requestMainDataIsShowHUD:YES];
        _isFirstLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self dc_statusBarStyle:UIStatusBarStyleDefault];
//    [self dc_navBarBackGroundcolor:[UIColor whiteColor]];
//    [self dc_navBarTitleWithFont:[UIFont fontWithName:PFRMedium size:17] color:[UIColor dc_colorWithHexString:@"#333333"]];
}

- (void)loadNewData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_detailOrderGoodsReturnWithOrderNo:self.detailModel.orderNo orderGoodsId:self.orderGoodsIdStr success:^(id  _Nullable response) {
        NSArray *listArr = [GLPDetailReturnModel mj_objectArrayWithKeyValuesArray:response];
        weakSelf.dataArray = [listArr mutableCopy];
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)requestMainDataIsShowHUD:(BOOL)isHUD
{
    !isHUD ?  : [SVProgressHUD show];
    [self loadNewData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.indexCell = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"已退款商品";
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RefundDetailsListCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundDetailsListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    cell.model = _dataArray[indexPath.section];
    cell.detailModel = self.detailModel;
    WEAKSELF;
    cell.RefundDetailsListCell_block = ^{
        TRStorePageVC *vc = [[TRStorePageVC alloc] init];
        vc.firmId = weakSelf.detailModel.sellerFirmId;
        [weakSelf dc_pushNextController:vc];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexCell = indexPath.section;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RefundDetailsListCell class]) bundle:nil] forCellReuseIdentifier:RefundDetailsListCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
