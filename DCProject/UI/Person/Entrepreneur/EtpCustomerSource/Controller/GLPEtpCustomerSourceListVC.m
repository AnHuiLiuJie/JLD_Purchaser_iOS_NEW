//
//  GLPEtpCustomerSourceListVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "GLPEtpCustomerSourceListVC.h"
#import "CustomerSourceListCell.h"
#import "DCAPIManager+PioneerRequest.h"
#import "DCNoDataView.h"


static NSString *const CustomerSourceListCellID = @"CustomerSourceListCell";

@interface GLPEtpCustomerSourceListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allpage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic,copy) NSString *feeSortStr;//服务费排序方式：1-升序，2-降序 默认2

@end

@implementation GLPEtpCustomerSourceListVC

#pragma mark - 请求 客户源列表
- (void)requestLoadData{
    NSString *level = [self changeState];
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_extend_user_listWithCurrentPage:[NSString stringWithFormat:@"%zi",self.page] level:level feeSort:self.feeSortStr success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        NSArray *arr1 = [CustomerSourceListModel mj_objectArrayWithKeyValuesArray:arr];

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
    self.feeSortStr = @"2";
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.bgView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerSourceListCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomerSourceListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.section];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
//        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.bgView addSubview:_tableView];
        
        [_tableView registerClass:[CustomerSourceListCell class] forCellReuseIdentifier:CustomerSourceListCellID];
        
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
        [self.bgView addSubview:_noDataView];
    }
    return _noDataView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        //_bgView.frame = CGRectMake(15,15, self.view.dc_width-30, self.view.dc_height-30);
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgView];
        
        UILabel *title1 = [[UILabel alloc] init];
        title1.text = @"客源账号";
        title1.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        title1.font = [UIFont fontWithName:PFRMedium size:14];
        title1.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:title1];
        
        UILabel *title2 = [[UILabel alloc] init];
        title2.text = @"获客日期";
        title2.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        title2.font = [UIFont fontWithName:PFRMedium size:14];
        title2.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:title2];
        
        UILabel *title3 = [[UILabel alloc] init];
        title3.text = @"累计服务费";
        title3.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        title3.font = [UIFont fontWithName:PFRMedium size:14];
        title2.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:title3];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"shaux1"] forState:UIControlStateNormal];
        [_bgView addSubview:button];
        
        CGFloat label_w = (self.view.dc_width - 30)/3;
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(15, 15, 15+LJ_TabbarSafeBottomMargin, 15));
        }];
        
        [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView);
            make.top.equalTo(self.bgView).offset(0);
            make.size.equalTo(CGSizeMake(label_w, 30));
        }];

        [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title1.right);
            make.centerY.equalTo(title1);
            make.size.equalTo(title1);
        }];

        [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title2.right);
            make.centerY.equalTo(title1);
            make.size.equalTo(title1);
        }];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title3.right).offset(-45);
            make.centerY.equalTo(title1);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self.bgView);
            make.top.equalTo(title1.bottom);
        }];
        
        [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];

    }
    return _bgView;
}

#pragma mark - 排序
- (void)clickButtonAction:(UIButton *)button{//服务费排序方式：1-升序，2-降序
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"shgaix2"] forState:UIControlStateSelected];
        self.feeSortStr = @"1";
    }else{
        [button setImage:[UIImage imageNamed:@"shaux1"] forState:UIControlStateNormal];
        self.feeSortStr = @"2";
    }
    
    [self.dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - set
- (void)setCustomerType:(EtpCustomerSource)customerType{
    _customerType = customerType;
}

- (NSString *)changeState
{
    NSString *level = @"";
    if (_customerType == EtpCustomerSourceOne) {
        level = @"2";
    }else if(_customerType == EtpCustomerSourceTwo){
        level = @"3";
    }else{
        level = @"";
    }
    return level;

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
