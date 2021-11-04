//
//  DeliveryInformationVC.m
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import "DeliveryInformationVC.h"

#import "DCAPIManager+PioneerRequest.h"
#import "DCAPIManager+PioneerRequest.h"
#import "TRStorePageVC.h"
#import "DeliveryInfoHeaderView.h"

@interface DeliveryInformationVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger indexCell;

@property (nonatomic, strong) DeliveryInfoHeaderView *headerView;

@end

static NSString *const DeliveryInformationCellID = @"DeliveryInformationCell";


@implementation DeliveryInformationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.listModel == nil) {
        [self requestDeliverList];
    }else{
        self.headerView.model = self.listModel;
        id restaurantsObjects = [self toArrayOrNSDictionaryWithJsonString:self.listModel.logisticsInfo];
        NSArray *logisticsInfoArr = [DeliveryInfoListModel mj_objectArrayWithKeyValuesArray:restaurantsObjects];
        self.dataArray = [logisticsInfoArr mutableCopy];
    }
}

#pragma mark - 请求 物流列表
- (void)requestDeliverList
{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_deliverListWithOrderNo:self.orderNoStr success:^(id  _Nullable response) {
        DeliveryInfoModel *infoModel = [DeliveryInfoModel mj_objectWithKeyValues:response[@"data"]];
        NSArray *listArr = [DeliveryListModel mj_objectArrayWithKeyValuesArray:infoModel.deliveryList];
        for (DeliveryListModel *model in listArr) {
            NSArray *orderGoodsList = [GLPOrderGoodsListModel mj_objectArrayWithKeyValuesArray:model.orderGoodsList];
            model.orderGoodsList = orderGoodsList;
        }
        infoModel.deliveryList = listArr;
        
        weakSelf.listModel = [infoModel.deliveryList firstObject];

        weakSelf.headerView.model = weakSelf.listModel;
        id restaurantsObjects = [weakSelf toArrayOrNSDictionaryWithJsonString:weakSelf.listModel.logisticsInfo];
        NSArray *logisticsInfoArr = [DeliveryInfoListModel mj_objectArrayWithKeyValuesArray:restaurantsObjects];
        weakSelf.dataArray = [logisticsInfoArr mutableCopy];
        [weakSelf.tableView reloadData];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

//json 字符串转 字典 或者数组
- (id)toArrayOrNSDictionaryWithJsonString:(NSString *)responseObject{
    NSData *jsonData = [[NSData alloc] initWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        NSLog(@"解析错误解析错误解析错误解析错误解析错误解析错误解析错误解析错误解析错误");
        return nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.indexCell = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"物流信息";

    self.tableView.hidden = NO;
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeliveryInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:DeliveryInformationCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    cell.model = _dataArray[indexPath.section];
    if (indexPath.section == 0) {
        cell.isLastCell = YES;
    }else
        cell.isLastCell = NO;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryInfoListModel *model = _dataArray[indexPath.section];

    CGFloat height = [DCSpeedy getLabelHeightWithText:model.context width:(kScreenW-30-10-50) font:[UIFont fontWithName:PFR size:15]];
    return height+50;
    
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.headerView.frame )+10, kScreenW-30, kScreenH-CGRectGetMaxY(self.headerView.frame )-LJ_TabbarSafeBottomMargin-20) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 10;
        _tableView.backgroundColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DeliveryInformationCell class]) bundle:nil] forCellReuseIdentifier:DeliveryInformationCellID];

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

- (DeliveryInfoHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [DeliveryInfoHeaderView dc_viewFromXib];
        _headerView.frame = CGRectMake(0, kNavBarHeight, kScreenW, 80);
        
        [self.view addSubview:_headerView];

    }
    return _headerView;
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
