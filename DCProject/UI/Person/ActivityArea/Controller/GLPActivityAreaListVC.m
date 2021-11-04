//
//  GLPActivityAreaListVC.m
//  DCProject
//
//  Created by LiuMac on 2021/8/10.
//

#import "GLPActivityAreaListVC.h"
// Controllers
#import "GLPGoodsDetailsController.h"
// Models
// Views
#import "DCNoDataView.h"
#import "ActivityAreaTopToolView.h"
/* cell */
#import "GLPActivityAreaCell.h"
/* head */
/* foot */
// Vendors
// Categories
// Others

@interface GLPActivityAreaListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int allpage;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@property (nonatomic, strong) ActivityAreaTopToolView *topToolView;

@end

static NSString *const GLPActivityAreaCellID = @"GLPActivityAreaCell";

@implementation GLPActivityAreaListVC

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
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
        [_tableView registerClass:NSClassFromString(GLPActivityAreaCellID) forCellReuseIdentifier:GLPActivityAreaCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.bounds image:[UIImage imageNamed:@"p_dindan"] button:nil tip:@"暂无更多数据～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}

- (ActivityAreaTopToolView *)topToolView{
    if (!_topToolView) {
        _topToolView = [[ActivityAreaTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _topToolView.leftItemClickBlock = ^{ //点击了左侧
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        [self.view addSubview:_topToolView];
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#F2010E"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#F2490E"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0.5,0.0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
        gradientLayer2.endPoint = CGPointMake(0.5,1.0);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = CGRectMake(0, 0, kScreenW, kNavBarHeight);
        [self.topToolView.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
    }
    return _topToolView;
}

- (void)getlistData{
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_activityWithCurrentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id  _Nullable response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        weakSelf.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        NSArray *listArr = [ActivityAreaModel mj_objectArrayWithKeyValuesArray:arr];
        for (ActivityAreaModel *listModel in listArr) {
            NSArray *list = [ActivityAreaGoodsVOModel mj_objectArrayWithKeyValuesArray:listModel.goodsVO];
            listModel.goodsVO = list;
        }
        [weakSelf.dataArray addObjectsFromArray:listArr];

        [weakSelf.tableView reloadData];
        if (weakSelf.dataArray.count>0)
        {
            weakSelf.noorderDataView.hidden = YES;
        }
        else{
            weakSelf.noorderDataView.hidden = NO;
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动专区";
    
    self.page = 1;
    [self dc_navBarLucency:YES];//解决侧滑显示白色

    
    UIImageView *topImage = [[UIImageView alloc] init];
    [topImage setImage:[UIImage imageNamed:@"dc_activity_bg"]];
    [self.view addSubview:topImage];
    topImage.frame = CGRectMake(0, 0, kScreenW, kScreenW);
    [self.view sendSubviewToBack:topImage];

    
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
    
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
            self.page = self.page-1;
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleLightContent];
    [self dc_navBarHidden:YES animated:animated];
    [self setUpNavTopView];
    if (!_isFirstLoad) {
        [self.dataArray removeAllObjects];
        [self getlistData];
        _isFirstLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dc_navBarHidden:NO animated:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    self.topToolView.hidden = NO;
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#f3ca9a"];
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPActivityAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPActivityAreaCellID forIndexPath:indexPath];
    if (cell==nil){
        cell = [[GLPActivityAreaCell alloc] init];
    }
    ActivityAreaModel *model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    WEAKSELF;
    cell.GLPActivityAreaCell_block = ^(NSString * _Nonnull goodsId) {
        GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
        vc.goodsId = goodsId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        ActivityAreaModel *listmodel = self.dataArray[indexPath.section];
        NSArray *arr = listmodel.goodsVO;
        return (AreaListCell_H)*arr.count+AreaListHeader_H;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.01f;
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
