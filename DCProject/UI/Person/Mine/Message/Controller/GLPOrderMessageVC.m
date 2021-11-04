//
//  GLPOrderMessageVC.m
//  DCProject
//
//  Created by LiuMac on 2021/6/28.
//

#import "GLPOrderMessageVC.h"
#import "GLPOrderDetailsViewController.h"
#import "OrderMessageListCell.h"
#import "DCNoDataView.h"
#import "DCAPIManager+PioneerRequest.h"
#import "GLPGoodsDetailsController.h"
@interface GLPOrderMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, strong) DCNoDataView *noorderDataView;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) int allpage;

@end

static NSString *const OrderMessageListCellID = @"OrderMessageListCell";


@implementation GLPOrderMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.msgType intValue] == 1) {
        self.navigationItem.title = @"订单消息";
    }else if([self.msgType intValue] == 3){
        self.navigationItem.title = @"最新消息";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.hidden = NO;
    
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.listArray removeAllObjects];
        self.tableView.tableFooterView = nil;
        [self getlistData];
    }];
    
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self.tableView.mj_header beginRefreshing];
        self.isFirstLoad = YES;
    }
}

- (void)getlistData
{
    NSString *msgType = self.msgType.length == 0 ? @"" : self.msgType;
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_info_infomessage_publishsWithCurrentPage:[NSString stringWithFormat:@"%ld",(long)_page] beginTime:@"" endTime:@"" hasRead:@"0" msgContent:@"" msgType:msgType recvNameList:@"" sendRecvFlag:@"0" senderUserName:@"" success:^(id  _Nullable response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        NSArray *listArr = [OrderMessageListModel mj_objectArrayWithKeyValuesArray:arr];
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

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderMessageListCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderMessageListModel *model = self.listArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderMessageListModel *model = self.listArray[indexPath.section];

    if ([self.msgType intValue] == 1 && model.msgInfoId.length > 0) {
        GLPOrderDetailsViewController *vc = [[GLPOrderDetailsViewController alloc] init];
        vc.orderNo_Str = model.msgInfoId;
        WEAKSELF;
        vc.GLPOrderDetailsViewController_block = ^{
            weakSelf.isFirstLoad = NO;
        };
        [self dc_pushNextController:vc];
    }else if([self.msgType intValue] == 3 && model.goodsId.length > 0){
        GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
        vc.goodsId = model.goodsId;
        vc.batchId = model.batchId;
        [self dc_pushNextController:vc];
    }

}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
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
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getlistData)];
//        [self.tableView registerNib:[UINib nibWithNibName:@"OrderMessageListCell" bundle:nil] forCellReuseIdentifier:OrderMessageListCellID];
        [_tableView registerClass:NSClassFromString(OrderMessageListCellID) forCellReuseIdentifier:OrderMessageListCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.bounds image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂无更多数据～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}

@end
