//
//  GLPEtpWithdrawalsRecordVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "GLPEtpWithdrawalsRecordVC.h"
#import "GLPEtpWithdrawalsDetailsVC.h"
#import "EtpWithdrawalsRecordCell.h"
#import "DCAPIManager+PioneerRequest.h"
#import "DCNoDataView.h"


static NSString *const EtpWithdrawalsRecordCellID = @"EtpWithdrawalsRecordCell";

@interface GLPEtpWithdrawalsRecordVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allpage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNoDataView *noDataView;

@end

@implementation GLPEtpWithdrawalsRecordVC

#pragma mark - 请求 提现记录列表
- (void)requestLoadData{
    
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_listWithCurrentPage:[NSString stringWithFormat:@"%zi",self.page] endTime:@"" startTime:@"" state:@"" success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        [weakSelf.dataArray addObjectsFromArray:[EtpWithdrawalsListModel mj_objectArrayWithKeyValuesArray:arr]];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.title = @"提现记录";
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
    EtpWithdrawalsRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpWithdrawalsRecordCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.section];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLPEtpWithdrawalsDetailsVC *vc = [[GLPEtpWithdrawalsDetailsVC alloc] init];
    EtpWithdrawalsListModel *model = self.dataArray[indexPath.section];
    vc.withdrawId = model.withdrawId;
    [self dc_pushNextController:vc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
        [_tableView registerNib:[UINib nibWithNibName:@"EtpWithdrawalsRecordCell" bundle:nil] forCellReuseIdentifier:EtpWithdrawalsRecordCellID];
        
        self.page = 1;
        [self requestLoadData];
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
