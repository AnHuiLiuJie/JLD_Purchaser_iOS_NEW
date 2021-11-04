//
//  GLBNotificationMsgController.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBNotificationMsgController.h"
#import "GLBNotificationMsgCell.h"

static NSString *const listCellID = @"GLBNotificationMsgCell";
static NSString *const sectionID = @"UITableViewHeaderFooterView";

@interface GLBNotificationMsgController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBNotificationMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_type == 1) {
        self.navigationItem.title = @"订单消息";
    } else {
        self.navigationItem.title = @"系统消息";
    }
    
    [self setUpTableView];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    if (_type == 1) {
        [self requestOrderMessageList:YES];
    } else {
        [self requestMessageList:YES];
    }
    
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    if (_type == 1) {
        [self requestOrderMessageList:NO];
    } else {
        [self requestMessageList:NO];
    }
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBNotificationMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.messageModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    
    for (id class in header.contentView.subviews) {
        [class removeFromSuperview];
    }
    
    header.contentView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = [self.dataArray[section] msgTime];
    label.font = PFRFont(11);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    [header.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header.contentView);
    }];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark - 请求
- (void)requestMessageList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSysMessageWithCurrentPage:_page success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        
         [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求
- (void)requestOrderMessageList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestOrderMessageWithCurrentPage:_page success:^(NSArray *array, BOOL hasNextPage) {
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
    self.tableView.frame = CGRectMake(10, kNavBarHeight, kScreenW - 20, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 30.0f;
    self.tableView.sectionFooterHeight = 10.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
