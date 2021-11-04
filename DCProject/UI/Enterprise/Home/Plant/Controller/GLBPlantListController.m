//
//  GLBPlantListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBPlantListController.h"

#import "GLBPlantListCell.h"
#import "GLBPlantSectionView.h"

static NSString *const listCellID = @"GLBPlantListCell";

@interface GLBPlantListController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBPlantListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self setUpTableView];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    if (_plantType == GLBPlantTypeZzh) {
        [self requestPlantPeople:YES];
    } else {
        [self requestPlantDrug:YES];
    }
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    if (_plantType == GLBPlantTypeZzh) {
        [self requestPlantPeople:NO];
    } else {
        [self requestPlantDrug:NO];
    }
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBPlantListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    if (_plantType == GLBPlantTypeZzh) {
        cell.peopleModel = self.dataArray[indexPath.row];
    } else {
        cell.drugModel = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_plantType == GLBPlantTypeZzh) {
        NSString *params = [NSString stringWithFormat:@"id=%ld",[self.dataArray[indexPath.row] growerId]];
        [self dc_pushWebController:@"/qiye/farmer_info.html" params:params];
    } else {
        NSString *params = [NSString stringWithFormat:@"id=%ld",[self.dataArray[indexPath.row] plantId]];
        [self dc_pushWebController:@"/qiye/raw_info.html" params:params];
    }
}


#pragma mark - 请求 种植户
- (void)requestPlantPeople:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSString *searchStr = _searchText ? _searchText : @"";
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestPlantPeopleListWithGrowerName:searchStr currentPage:_page success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求 原药品种植
- (void)requestPlantDrug:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSString *searchStr = _searchText ? _searchText : @"";
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestPlantDrugListWithVarietyName:searchStr currentPage:_page success:^(NSArray *array, BOOL hasNextPage) {
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
    self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH - kNavBarHeight - 0.4*kScreenW - 32);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
