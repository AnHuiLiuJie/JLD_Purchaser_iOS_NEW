//
//  GLPEtpPioneerCollegeListVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "GLPEtpPioneerCollegeListVC.h"
#import "EtpPioneerCollegeListCell.h"
#import "DCNoDataView.h"
#import "GLPEtpDetailsViewController.h"
#import "DCAPIManager+PioneerRequest.h"

static NSString *const EtpPioneerCollegeListCellID = @"EtpPioneerCollegeListCell";

@interface GLPEtpPioneerCollegeListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allpage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic, assign) BOOL isNeedLoad;
@end

@implementation GLPEtpPioneerCollegeListVC

#pragma mark - 请求 资讯列表//是否热门：取热门资讯时传1 是否推荐：取推荐资讯是传1
- (void)requestLoadData{
    NSString *isHot = @"0";
    if ([self.catIdStr isEqualToString:@"HOT"]) {
        isHot = @"1";
    }
    
    NSString *isRecommend = @"0";
    if ([self.catIdStr isEqualToString:@"REC"]) {
        isRecommend = @"1";
    }
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_news_listWithCurrentPage:[NSString stringWithFormat:@"%zi",self.page]  catId:self.catIdStr isHot:isHot isRecommend:isRecommend success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        NSArray *arr1 = [PioneerCollegeListModel mj_objectArrayWithKeyValuesArray:arr];
    
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
    [super viewWillAppear:animated];
    if (!_isNeedLoad) {
        [self.dataArray removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
        _isNeedLoad = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
//    self.tableView.layer.borderColor = [UIColor redColor].CGColor;
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
    EtpPioneerCollegeListCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpPioneerCollegeListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PioneerCollegeListModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLPEtpDetailsViewController *vc = [GLPEtpDetailsViewController alloc];
    PioneerCollegeListModel *model = self.dataArray[indexPath.section];
    vc.newsId = model.newsId;
    _isNeedLoad = YES;
    [self dc_pushNextController:vc];
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
        _tableView.frame = CGRectMake(0,0, kScreenW, kScreenH - kNavBarHeight - 32 - LJ_TabbarSafeBottomMargin-5);
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"EtpPioneerCollegeListCell" bundle:nil] forCellReuseIdentifier:EtpPioneerCollegeListCellID];
        
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
- (void)setCatIdStr:(NSString *)catIdStr{
    _catIdStr = catIdStr;
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
