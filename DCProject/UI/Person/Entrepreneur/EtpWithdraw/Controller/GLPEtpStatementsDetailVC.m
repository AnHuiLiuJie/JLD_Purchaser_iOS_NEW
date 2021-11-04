//
//  GLPEtpStatementsDetailVC.m
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import "GLPEtpStatementsDetailVC.h"
#import "DCNoDataView.h"
#import "DCAPIManager+PioneerRequest.h"

static NSString *const StatementsDetailListCellID = @"StatementsDetailListCell";

@interface GLPEtpStatementsDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allpage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNoDataView *noDataView;

@end

@implementation GLPEtpStatementsDetailVC

#pragma mark - 请求 服务费明细列表
- (void)requestLoadData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_extend_order_detailWithOrderNo:self.orderNo success:^(id  _Nullable response) {
        NSDictionary *dic = response[@"data"];
        EtpOrderPageListModel *mainModel = [EtpOrderPageListModel mj_objectWithKeyValues:dic];
        NSArray *arr1 = [[NSArray alloc] initWithObjects:mainModel, nil];

        [arr1 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EtpOrderPageListModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSArray *arr2 = [PSFGoodsListModel mj_objectArrayWithKeyValuesArray:obj.goodsList];
            obj.goodsList = arr2;
        }];

        [weakSelf.dataArray addObjectsFromArray:arr1];
        if (weakSelf.dataArray.count == 0) {
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
    [self.dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"对账单明细";
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatementsDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:StatementsDetailListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EtpOrderPageListModel *model = self.dataArray[indexPath.section];
    cell.orderModel = model;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        EtpOrderPageListModel *model = self.dataArray[indexPath.section];
        NSArray *arr = model.goodsList;
        return 100*arr.count+ (50+30+8+5+1+30);
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
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"StatementsDetailListCell" bundle:nil] forCellReuseIdentifier:StatementsDetailListCellID];
        
        self.page = 1;

        [self requestLoadData];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;;
}

- (DCNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) image:[UIImage imageNamed:@"dc_bg_noData"] button:nil tip:@"暂无数据"];
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

