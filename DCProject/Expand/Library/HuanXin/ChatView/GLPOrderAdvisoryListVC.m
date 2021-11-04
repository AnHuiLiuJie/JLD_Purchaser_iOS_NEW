//
//  GLPOrderAdvisoryListVC.m
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import "GLPOrderAdvisoryListVC.h"
#import "DCNoDataView.h"
#import "KFOrderListCell.h"
#import "KFCommodityRecordCell.h"

static NSString *const KFOrderListCellID = @"KFOrderListCell";
static NSString *const KFCommodityRecordCellID = @"KFCommodityRecordCell";

@interface GLPOrderAdvisoryListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allpage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic, assign) BOOL isNeedLoad;

@end

@implementation GLPOrderAdvisoryListVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isNeedLoad) {
        [self.dataArray removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
        _isNeedLoad = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViewUI];
}

#pragma mark - UIView
- (void)setUpViewUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
//    self.tableView.layer.borderColor = [UIColor greenColor].CGColor;
//    self.tableView.layer.borderWidth = 1;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.customerType == OrderAdvisoryListTypeOrder) {
        KFOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:KFOrderListCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }else{
        KFCommodityRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:KFCommodityRecordCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.customerType = self.customerType;
        if (self.customerType == 2) {
            cell.model2 = self.dataArray[indexPath.section];;
        }else if(self.customerType == 3){
            cell.model3 = self.dataArray[indexPath.section];;
        }else{
            cell.model4 = self.dataArray[indexPath.section];;
        }
        return cell;
    }

}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.customerType == OrderAdvisoryListTypeOrder) {
        return 130;
    }else{
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *goodsName = @"";
    NSString *order_title = @"";
    NSString *price = @"";
    NSString *desc = @"";
    NSString *goodsImage = @"";
    NSString *item_url = @"";
    NSString *orderNo = @"";
    NSString *img_url = @"";

    if (self.customerType == OrderAdvisoryListTypeOrder) {
        OrderListModel *model1 = self.dataArray[indexPath.section];
        NSArray *arr = [OredrGoodsModel mj_objectArrayWithKeyValuesArray:model1.orderGoodsList];
        OredrGoodsModel *fristModel = arr.count > 0  ?  arr[0] : nil;
        goodsName = fristModel.goodsTitle;
        order_title = [NSString stringWithFormat:@"订单号:%@",model1.orderNo];
        price = model1.payableAmount;
        desc = fristModel.packingSpec;
        goodsImage = img_url = fristModel.goodsImg;
        orderNo = model1.orderNo;
        item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/mallcenter/order/orderList.shtml?orderNo=%@",model1.orderNo];
    }else if(self.customerType == 2) {
        GLPMineSeeGoodsModel *model2 = self.dataArray[indexPath.section];
        goodsName = model2.goodsName;
        price = model2.marketPrice;
        desc = model2.packingSpec;
        goodsImage = model2.goodsImg1;
        item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/goods/%@.html",model2.goodsId];
    }else if(self.customerType == 3){
        GLPMineCollectModel *model3 = self.dataArray[indexPath.section];
        goodsName = model3.goodsName;
        price = model3.marketPrice;
        desc = model3.packingSpec;
        goodsImage = model3.goodsImg;
        item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/goods/%@.html",model3.goodsId];
    }else{
        GLPShoppingCarNoActivityModel *model4 = self.dataArray[indexPath.section];
        goodsName = model4.goodsTitle;
        price = [NSString stringWithFormat:@"%0.2f",model4.sellPrice];
        desc = model4.packingSpec;
        goodsImage = model4.goodsImg;
        item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/goods/%@.html",model4.goodsId];
    }
    NSDictionary *dic = @{@"goodsName":goodsName,@"img_url":img_url,@"order_title":order_title,@"price":price,@"desc":desc,@"orderNo":orderNo,@"item_url":item_url,@"goodsImage":goodsImage};
    !_GLPOrderAdvisoryListVCBlock ? : _GLPOrderAdvisoryListVCBlock(dic);
}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //_tableView.frame = CGRectMake(0,0, self.view.dc_width, self.view.dc_height - 36 - LJ_TabbarSafeBottomMargin-1);
        _tableView.frame = CGRectMake(self.viewFrame.origin.x, self.viewFrame.origin.y, self.viewFrame.size.width, self.viewFrame.size.height-LJ_TabbarSafeBottomMargin);
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"KFOrderListCell" bundle:nil] forCellReuseIdentifier:KFOrderListCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"KFCommodityRecordCell" bundle:nil] forCellReuseIdentifier:KFCommodityRecordCellID];

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
        _noDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.frame image:[UIImage imageNamed:@"dc_bg_noData"] button:nil tip:@"暂无数据"];
        [self.view addSubview:_noDataView];
    }
    return _noDataView;
}

#pragma makr - set model
//- (void)setViewFrame:(CGRect)viewFrame{
//    _viewFrame = viewFrame;
//    self.view.frame = viewFrame;
//}

#pragma mark - 请求 订单 收藏 浏览 购物车
- (void)requestLoadData
{
    if (self.customerType == OrderAdvisoryListTypeOrder) {
        [self getOrderlistData];
    }else if (self.customerType == OrderAdvisoryListType1){
        [self requestSeeGoodsList];
    }else if (self.customerType == OrderAdvisoryListType2){
        [self requestCollectGoodsList];
    }else{
        [self requestShoppingCarList];
    }
    
}

- (void)getOrderlistData
{
    NSString *orderState = @"";
    NSString *evalState = @"";
    NSString *sellerFirmName = self.sellerFirmName ? self.sellerFirmName : @"";
    [[DCAPIManager shareManager]person_getOrderListWithbuyerDelState:@"" currentPage:[NSString stringWithFormat:@"%ld",(long)self.page] endDate:@"" evalState:evalState orderNo:@"" orderState:orderState refundState:@"" sellerFirmName:sellerFirmName startDate:@"" searchName:@"" goodsName:@"" success:^(id response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            OrderListModel *listModel = [[OrderListModel alloc]initWithDic:dic];
            [self.dataArray addObject:listModel];
        }
        
        [self.tableView reloadData];
        if (self.dataArray.count>0)
        {
            self.noDataView.hidden = YES;
        }
        else{
            self.noDataView.hidden = NO;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 请求 浏览记录
- (void)requestSeeGoodsList
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestSeeGoodsListWithCurrentPage:_page success:^(NSArray *array, BOOL hasNextPage,CommonListModel *commonModel) {
        self.allpage = [commonModel.totalPage integerValue];
        if (array && [array count] > 0) {
            NSMutableArray *needArr = [[NSMutableArray alloc] init];
            for (GLPMineSeeModel *model in array) {
                NSArray *listArr = [GLPMineSeeGoodsModel mj_objectArrayWithKeyValuesArray:model.accessList];
                [needArr addObjectsFromArray:listArr];
            }
            [weakSelf.dataArray addObjectsFromArray:needArr];
        }
        
        [self.tableView reloadData];
        if (self.dataArray.count>0)
        {
            self.noDataView.hidden = YES;
        }
        else{
            self.noDataView.hidden = NO;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 请求 收藏记录
- (void)requestCollectGoodsList
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestCollectGoodsListWithCurrentPage:_page goodsName:@"" success:^(NSArray *array, BOOL hasNextPage,CommonListModel *commonModel) {
        self.allpage = [commonModel.totalPage integerValue];
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        
        [self.tableView reloadData];
        if (self.dataArray.count>0)
        {
            self.noDataView.hidden = YES;
        }
        else{
            self.noDataView.hidden = NO;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 请求 购物车商品
- (void)requestShoppingCarList
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestShoppingCarListWithSuccess:^(id response) {
        self.allpage = 1;
        if (response && [response count] > 0) {
            NSMutableArray *needArr = [[NSMutableArray alloc] init];
            for (GLPShoppingCarModel *model in response) {
                NSArray *listArr = [GLPShoppingCarNoActivityModel mj_objectArrayWithKeyValuesArray:model.validNoActGoodsList];
                [needArr addObjectsFromArray:listArr];
            }
            [weakSelf.dataArray addObjectsFromArray:needArr];
        }//

        [self.tableView reloadData];
        if (self.dataArray.count>0)
        {
            self.noDataView.hidden = YES;
        }
        else{
            self.noDataView.hidden = NO;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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

///**
// *设置位置宽高
// */
//- (void)viewWillLayoutSubviews {
//    self.view.frame = CGRectMake(self.view.frame.origin.x, kScreenH / 2, kScreenW, kScreenH / 2);
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.868f];
//}


@end
