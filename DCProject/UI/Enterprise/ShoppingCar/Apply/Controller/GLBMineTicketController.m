//
//  GLBMineTicketController.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineTicketController.h"
#import "GLBMineTicketCell.h"

static NSString *const listCellID = @"GLBMineTicketCell";

@interface GLBMineTicketController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray; // 已选择的券
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBMineTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择优惠券";
    [self setUpTableView];
    
    [self addRefresh:YES];
}

#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestMineTicketList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestMineTicketList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBMineTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithDataArray:self.dataArray seletcedArray:self.selectArray carModel:self.carModel indexPath:indexPath];
    WEAKSELF;
    cell.ticketBlock = ^(BOOL isCanUse) {
        if (isCanUse && weakSelf.ticketClickBlock) {
            weakSelf.ticketClickBlock(self.dataArray[indexPath.row]);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 请求 获取已领取券列表
- (void)requestMineTicketList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        [self.dataArray removeAllObjects];
        _page = 1;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestMineTicketListWithCurrentPage:_page state:@"1" type:@"" success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count]>0) {
            for (int i=0; i<array.count; i++) {
                GLBMineTicketModel *model = array[i];
                if (model.coupons && [model.coupons count] > 0) {
                    [weakSelf.dataArray addObjectsFromArray:model.coupons];
                }
            }
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
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


- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


#pragma mark - setter
- (void)setSelectTicketArray:(NSMutableArray *)selectTicketArray {
    _selectTicketArray = selectTicketArray;
    
    [self.selectArray removeAllObjects];
    [self.selectArray addObjectsFromArray:_selectTicketArray];
}

@end
