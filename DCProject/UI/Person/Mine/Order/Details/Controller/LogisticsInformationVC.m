//
//  LogisticsInformationVC.m
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "LogisticsInformationVC.h"
#import "DeliveryInformationVC.h"
#import "DCAPIManager+PioneerRequest.h"
#import "DCAPIManager+PioneerRequest.h"
#import "TRStorePageVC.h"
#import "DeliveryInfoHeaderView.h"

@interface LogisticsInformationVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger indexCell;

@property (nonatomic, strong) DeliveryInfoHeaderView *headerView;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

static NSString *const LogisticsInfoListCellID = @"LogisticsInfoListCell";


@implementation LogisticsInformationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self requestDeliverList];
        _isFirstLoad = YES;
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
        NSArray *haveGoods = [infoModel.goodsIds componentsSeparatedByString:@","];
        NSMutableArray *noGoodsList = [weakSelf.allGoodsArr mutableCopy];
        
        [noGoodsList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(GLPOrderGoodsListModel * _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [haveGoods enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([goodsModel.goodsId isEqualToString:obj] || [goodsModel.quantity isEqualToString:goodsModel.returnNum]) {
                    [noGoodsList removeObject:goodsModel];
                }
            }];
        }];
        NSMutableArray *newAllList = [listArr mutableCopy];

        if (noGoodsList.count != 0) {
            DeliveryListModel *model = [[DeliveryListModel alloc] init];
            model.orderGoodsList = noGoodsList;
            [newAllList addObject:model];
        }
    
        weakSelf.dataArray = newAllList;
        [weakSelf.tableView reloadData];
    } failture:^(NSError * _Nullable error) {

    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.indexCell = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"配送信息";
    
    self.tableView.tableHeaderView = self.headerView;

}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:LogisticsInfoListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    DeliveryListModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    WEAKSELF;
    cell.LogisticsInfoListCell_Block = ^{
        if (model.logisticsNo.length != 0 && model.deliveryId.length != 0) {
            DeliveryInformationVC *vc = [[DeliveryInformationVC alloc] init];
            vc.listModel = model;
            [weakSelf dc_pushNextController:vc];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryListModel *model = self.dataArray[indexPath.section];
    if (model.logisticsNo.length != 0 && model.deliveryId.length != 0) {
        DeliveryInformationVC *vc = [[DeliveryInformationVC alloc] init];
        vc.listModel = model;
        [self dc_pushNextController:vc];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    if (section == 0) {
        //view.backgroundColor = [UIColor clearColor];
        UILabel *titile = [[UILabel alloc] init];
        [view addSubview:titile];
        titile.textColor = [UIColor dc_colorWithHexString:@"#666666"];
        titile.frame = CGRectMake(0, -10, kScreenW, 30);
        titile.text = @"      该订单已分开发货";
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 25.0f;
    }
    return 10.00f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}


#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-LJ_TabbarSafeBottomMargin-kNavBarHeight) style:UITableViewStyleGrouped];
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
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 10;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LogisticsInfoListCell class]) bundle:nil] forCellReuseIdentifier:LogisticsInfoListCellID];

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
