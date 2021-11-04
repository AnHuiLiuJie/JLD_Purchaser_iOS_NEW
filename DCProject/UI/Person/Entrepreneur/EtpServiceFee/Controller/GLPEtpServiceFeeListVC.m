//
//  GLPEtpServiceFeeListVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//[self.tableView.mj_header  beginRefreshing];

#import "GLPEtpServiceFeeListVC.h"
#import "DCNoDataView.h"
#import "DCAPIManager+PioneerRequest.h"

static NSString *const EtpServiceFeeListCellID = @"EtpServiceFeeListCell";

@interface GLPEtpServiceFeeListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allpage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNoDataView *noDataView;

@end

@implementation GLPEtpServiceFeeListVC

#pragma mark - 请求 服务费明细列表
- (void)requestLoadData{
    [self changeState];
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_extend_order_listWithCurrentPage:[NSString stringWithFormat:@"%zi",self.page]  startTime:self.model.startTime endTime:self.model.endTime goodsName:self.model.goodsName orderNo:self.model.orderNo state:self.model.state level:self.model.level success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        NSArray *arr1 = [PSFOrderListModel mj_objectArrayWithKeyValuesArray:arr];
        
        [arr1 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PSFOrderListModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSArray *arr2 = [PSFGoodsListModel mj_objectArrayWithKeyValuesArray:obj.extendGoodsListVO];
            obj.extendGoodsListVO = arr2;
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
    
    [self setUpViewUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"GLPEtpServiceFeeListVCNotification" object:nil];
}

- (void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification userInfo];
    PSFSearchConditionModel *model = [dic objectForKey:@"info"];
    self.model.orderNo = model.orderNo;
    self.model.goodsName = model.goodsName;
    self.model.startTime = model.startTime;
    self.model.endTime = model.endTime;
    self.model.level = model.level;
    [self.tableView.mj_header beginRefreshing];
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
    EtpServiceFeeListCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpServiceFeeListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PSFOrderListModel *model = self.dataArray[indexPath.section];
    cell.orderModel = model;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        PSFOrderListModel *model = self.dataArray[indexPath.section];
        NSArray *arr = model.extendGoodsListVO;
        return 85*arr.count+ (50+30+8+5+1);
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
        _tableView.frame = CGRectMake(0,0, self.view.dc_width, _view_H-5);
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"EtpServiceFeeListCell" bundle:nil] forCellReuseIdentifier:EtpServiceFeeListCellID];
        
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;;
}

- (DCNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0,0, self.view.dc_width, _view_H) image:[UIImage imageNamed:@"dc_bg_noData"] button:nil tip:@"暂无数据"];
        [self.view addSubview:_noDataView];
    }
    return _noDataView;
}

#pragma makr - set model
- (void)setModel:(PSFSearchConditionModel *)model{
    _model = model;
}

- (void)setCustomerType:(EtpServiceFeeType)customerType{
    _customerType = customerType;
    [self changeState];
}

- (void)changeState
{
    if (_customerType == EtpServiceFeeTypeWait) {
        _model.state = @"1";
    }else if(_customerType == EtpServiceFeeTypeEnd){
        _model.state = @"2";
    }else if(_customerType == EtpServiceFeeTypeInvalid){
        _model.state = @"3";
    }else{
        _model.state = @"";
    }
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

