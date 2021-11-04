//
//  GLPEtpWithdrawalsDetailsVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "GLPEtpWithdrawalsDetailsVC.h"
#import "DCNoDataView.h"
#import "DCAPIManager+PioneerRequest.h"

static NSString *const EtpWithdrawalsDetailsCellID = @"EtpWithdrawalsDetailsCell";

@interface GLPEtpWithdrawalsDetailsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DCNoDataView *noDataView;
@end

@implementation GLPEtpWithdrawalsDetailsVC

#pragma mark - 请求 提现详情
- (void)requestLoadData{
    
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_viewWithWithdrawId:self.withdrawId Success:^(id response) {
        NSDictionary *dic = response[@"data"];
        EtpWithdrawalsListModel *commonModel = [EtpWithdrawalsListModel mj_objectWithKeyValues:dic];
        weakSelf.model = commonModel;
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestLoadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.title = @"提现详情";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpWithdrawalsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpWithdrawalsDetailsCellID forIndexPath:indexPath];
    cell.model = self.model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.dc_height;
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"EtpWithdrawalsDetailsCell" bundle:nil] forCellReuseIdentifier:EtpWithdrawalsDetailsCellID];
        
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
