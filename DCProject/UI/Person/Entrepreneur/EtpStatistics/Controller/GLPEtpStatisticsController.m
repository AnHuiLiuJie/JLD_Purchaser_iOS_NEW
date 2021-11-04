//
//  GLPEtpStatisticsController.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "GLPEtpStatisticsController.h"
#import "EtpStatisticsCell.h"
#import "DCNoDataView.h"
#import "DCAPIManager+PioneerRequest.h"

static NSString *const EtpStatisticsCellID = @"EtpStatisticsCell";

@interface GLPEtpStatisticsController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic, strong) EtpStatisticsFeesModel *model1;
@property (nonatomic, strong) EtpStatisticsUserModel *model2;

@end

@implementation GLPEtpStatisticsController

#pragma mark - 请求 列表 获取可提现金额，个税，实际到账金额
- (void)requestLoadData{
    
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_fee_statistWithSuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        EtpStatisticsFeesModel *commonModel = [EtpStatisticsFeesModel mj_objectWithKeyValues:dic];
        weakSelf.model1 = commonModel;
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
    
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_extend_user_statistWithSuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        EtpStatisticsUserModel *commonModel = [EtpStatisticsUserModel mj_objectWithKeyValues:dic];
        weakSelf.model2 = commonModel;
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
    
    [self requestLoadData];
}

- (void)setUpViewUI
{
    self.title = @"数据统计";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
//    self.noDataView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpStatisticsCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model1 = self.model1;
    cell.model2 = self.model2;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 650;
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
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        [self.view addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"EtpStatisticsCell" bundle:nil] forCellReuseIdentifier:EtpStatisticsCellID];
        
    }
    return _tableView;
}

- (DCNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight) image:[UIImage imageNamed:@"dc_bg_noData"] button:nil tip:@"暂无数据"];
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

