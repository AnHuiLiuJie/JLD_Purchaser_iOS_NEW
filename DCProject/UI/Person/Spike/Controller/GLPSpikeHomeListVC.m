//
//  GLPSpikeHomeListVC.m
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "GLPSpikeHomeListVC.h"
// Controllers
#import "GLPGoodsDetailsController.h"
// Models
// Views
#import "DCNoDataView.h"
#import "GLPSpikeHomeHeaderView.h"
/* cell */
#import "GLPSpikeHomeListCell.h"
/* head */
/* foot */
// Vendors
// Categories
#import "DCAPIManager+Activity.h"
// Others
@interface GLPSpikeHomeListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int allpage;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) DCNoDataView *noorderDataView;

@property (nonatomic, copy) NSString *currentEndTime;
@property (nonatomic, copy) NSString *nextStartTime;

/* headerView */
@property (strong , nonatomic)GLPSpikeHomeHeaderView *headerView;
@end


static NSString *const GLPSpikeHomeListCellID = @"GLPSpikeHomeListCell";

@implementation GLPSpikeHomeListVC

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPSpikeHomeListCell class]) bundle:nil] forCellReuseIdentifier:GLPSpikeHomeListCellID];
//        [_tableView dc_cornerRadius:5];
//        [_tableView dc_layerBorderWith:1 color:[UIColor redColor] radius:0];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma makr - set model
-(void)setGoodsType:(NSInteger)goodsType{
    _goodsType = goodsType;
    
    self.headerView.goodsType = _goodsType;
    
    if (self.goodsType == 1) {
        self.headerView.timeStr = self.currentEndTime;
    }else{
        self.headerView.timeStr = self.currentEndTime;
    }

}

- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(15, 125, kScreenW-30, self.tableView.dc_height-125-10) image:[UIImage imageNamed:@"dc_no_goods"] button:nil tip:@"暂无秒杀商品～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}

- (GLPSpikeHomeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[GLPSpikeHomeHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenW, 125);
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_headerView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(50, 50)];

        WEAKSELF;
        _headerView.GLPSpikeHomeHeaderView_switchBlock = ^(int goodsType) {
            !weakSelf.GLPSpikeHomeListVC_switchBlock ? : weakSelf.GLPSpikeHomeListVC_switchBlock(goodsType);
        };
        
        _headerView.GLPSpikeHomeHeaderView_block = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _headerView;
}

- (void)getlistData{
    NSString *currentPage = [NSString stringWithFormat:@"%d",_page];
    NSString *type = [NSString stringWithFormat:@"%ld",self.goodsType];
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_activity_seckillWithCurrentPage:currentPage type:type success:^(id  _Nullable response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        NSArray *listArr = [DCSeckillListModel mj_objectArrayWithKeyValuesArray:arr];
        [weakSelf.dataArray addObjectsFromArray:listArr];

        [weakSelf.tableView reloadData];
        if (weakSelf.dataArray.count>0)
        {
            weakSelf.headerView.timeBgView.hidden = NO;
            weakSelf.noorderDataView.hidden = YES;
        }
        else{
            weakSelf.headerView.timeBgView.hidden = YES;
            weakSelf.noorderDataView.hidden = NO;
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)getSeckillTimeData{
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_activity_seckill_tabWithSuccess:^(id  _Nullable response) {
        weakSelf.currentEndTime = response[@"data"][@"currentEndTime"];
        weakSelf.nextStartTime = response[@"data"][@"nextStartTime"];
        if (weakSelf.goodsType == 1) {
            weakSelf.headerView.timeStr = weakSelf.currentEndTime;
        }else{
            weakSelf.headerView.timeStr = weakSelf.currentEndTime;
        }
    } failture:^(NSError * _Nullable error) {
        
    }];
}

- (void)setGoodsSubscribe:(DCSeckillListModel *)model{
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_activity_seckill_subscribeWithBatchId:model.batchId goodsId:model.goodsId seckillId:model.seckillId success:^(id  _Nullable response) {
        [weakSelf.view makeToast:@"设置成功" duration:Toast_During position:CSToastPositionCenter];
        [weakSelf.dataArray enumerateObjectsUsingBlock:^(DCSeckillListModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.goodsId isEqual:model.goodsId]) {
                obj.isSubscribe = @"1";
            }
        }];
        [weakSelf.tableView reloadData];
    } failture:^(NSError * _Nullable error) {
    
    }];
}

#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self.dataArray removeAllObjects];
        [self getlistData];
        [self getSeckillTimeData];
        _isFirstLoad = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
    
    self.page = 1;

    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#8736E2"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.dataArray removeAllObjects];
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
            footView.backgroundColor = [UIColor clearColor];
            self.tableView.tableFooterView = footView;
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        self.tableView.tableFooterView = nil;
        [self getlistData];
    }];
    
    [self setUpHeaderCenterView];
}

#pragma mark - 初始化头尾
- (void)setUpHeaderCenterView{
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
    GLPSpikeHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPSpikeHomeListCellID forIndexPath:indexPath];
    cell.goodsType = self.goodsType;
    cell.model = _dataArray[indexPath.section];
    WEAKSELF;
    cell.GLPSpikeHomeListCell_btnBlock = ^(NSString * _Nonnull btnTitle, DCSeckillListModel * _Nonnull model) {
        if([btnTitle isEqualToString:@"立即抢购"]){
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId = model.goodsId;
            vc.batchId = model.batchId;
            [weakSelf dc_pushNextController:vc];
        }else if([btnTitle isEqualToString:@"已售完"]){
            [weakSelf.view makeToast:@"该商品已售完"];
        }else if([btnTitle isEqualToString:@"提醒我"]){
            [weakSelf setGoodsSubscribe:model];
        }else if([btnTitle isEqualToString:@"已设置"]){
            [weakSelf.view makeToast:@"已经设置订阅了"];
        }
    };
    if (self.dataArray.count > 0) {
        if (indexPath.section == 0 ) {
            cell.radiusType = 1;
        }
        if (indexPath.section == self.dataArray.count-1) {
            cell.radiusType = 2;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
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
    DCSeckillListModel *model = _dataArray[indexPath.section];
    if (self.goodsType == 2) {//下期预告
        GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
        vc.goodsId = model.goodsId;
        vc.batchId = model.batchId;
        [self dc_pushNextController:vc];
    }else{
//        if ([model.isSellOut integerValue] != 1) {
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId = model.goodsId;
            vc.batchId = model.batchId;
            [self dc_pushNextController:vc];
//        }
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
