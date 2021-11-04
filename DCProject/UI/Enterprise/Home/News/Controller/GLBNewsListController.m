//
//  GLBNewsListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBNewsListController.h"
#import "DCTextField.h"

#import "GLBNewsListCell.h"

static NSString *const listCellID = @"GLBNewsListCell";

@interface GLBNewsListController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) DCTextField *searchTF;
@property (nonatomic, strong) UIImageView *searchImage;

@property (nonatomic, strong) NSMutableArray<GLBNewsModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBNewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"新闻资讯";
    
    [self setUpTableView];
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.searchTF];
    [self.searchView addSubview:self.searchImage];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestNewsList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestNewsList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.newsModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *params = [NSString stringWithFormat:@"id=%@",[self.dataArray[indexPath.row] iD]];
    [self dc_pushWebController:@"/public/infor_detail.html" params:params];
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTF resignFirstResponder];
    [self.tableView scrollsToTop];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}


#pragma mark - 请求 咨询列表
- (void)requestNewsList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestNewsListWithCatId:@"" searchName:self.searchTF.text currentPage:_page success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 40)];
        _searchView.backgroundColor = [UIColor whiteColor];
    }
    return _searchView;
}

- (DCTextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[DCTextField alloc] initWithFrame:CGRectMake(12, 5, kScreenW - 12*2, 30)];
        _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
        [_searchTF dc_cornerRadius:15];
        _searchTF.placeholder = @"搜索资讯名称";
        _searchTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        _searchTF.font = PFRFont(14);
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        UIView *image = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        image.image = [UIImage imageNamed:@"dc_ss_hei"];
        _searchTF.leftView = image;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTF;
}

- (UIImageView *)searchImage{
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 13,14, 14)];
        _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    }
    return _searchImage;
}

- (NSMutableArray<GLBNewsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
