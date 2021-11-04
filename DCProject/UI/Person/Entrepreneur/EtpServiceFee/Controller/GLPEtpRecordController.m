//
//  GLPEtpRecordController.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "GLPEtpRecordController.h"
#import "EtpServiceRecordCell.h"
#import "DCAPIManager+PioneerRequest.h"


static NSString *const EtpServiceRecordCellID = @"EtpServiceRecordCell";

@interface GLPEtpRecordController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PioneerServiceFeeModel *dataModel;

@end

@implementation GLPEtpRecordController

#pragma mark - 请求 申请创业者
- (void)requestLoadData{

    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_service_feeWithSuccess:^(id response) {
        NSDictionary *userDic = response[@"data"];
        PioneerServiceFeeModel *dataModel = [PioneerServiceFeeModel mj_objectWithKeyValues:userDic];
        weakSelf.dataModel = dataModel;
        [weakSelf updataViewUI];
    } failture:^(NSError *error) {
        
    }];
}

- (void)updataViewUI
{
    [self.tableView reloadData];
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
    self.title = @"服务费记录";
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
    EtpServiceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpServiceRecordCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataModel;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
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
        
        [_tableView registerClass:[EtpServiceRecordCell class] forCellReuseIdentifier:EtpServiceRecordCellID];
    }
    return _tableView;
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
