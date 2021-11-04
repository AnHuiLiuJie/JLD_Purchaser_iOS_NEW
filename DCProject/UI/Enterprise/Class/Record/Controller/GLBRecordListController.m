//
//  GLBRecordListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRecordListController.h"
#import "GLBRecordListCell.h"

static NSString *const listCellID = @"GLBRecordListCell";

@interface GLBRecordListController ()

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSMutableArray<GLBRecordModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBRecordListController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"采购记录";
    [self setUpTableView];
    [self.view addSubview:self.headView];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestGoodsList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestGoodsList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.recordModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


#pragma mark - 请求 采购记录
- (void)requestGoodsList:(BOOL)isReload
{
    if (self.detailModel == nil) {
        [self reloadTableViewWithDatas:self.dataArray hasNextPage:NO];
        return;
    }
    
    _page++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestGoodsRecordListWithCurrentPage:_page goodsId:self.detailModel.goodsId success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - attributeStr
- (NSMutableAttributedString *)dc_attrbuteStr:(NSString *)str
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"累计已采购%@盒",str]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(5, str.length)];
    return attrStr;
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 36.0;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 40)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 40)];
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
        titleLabel.text = @"采购记录（0笔）";
        [_headView addSubview:titleLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, kScreenW - 15 - CGRectGetMaxX(titleLabel.frame), 40)];
        countLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        countLabel.font = PFRFont(12);
        countLabel.attributedText = [self dc_attrbuteStr: @"0"];
        countLabel.textAlignment = NSTextAlignmentRight;
        [_headView addSubview:countLabel];
        
        if (self.detailModel) {
            titleLabel.text = [NSString stringWithFormat:@"采购记录（%ld笔）",(long)self.detailModel.orderCount];
            countLabel.attributedText = [self dc_attrbuteStr: [NSString stringWithFormat:@"%ld",(long)self.detailModel.quantityCount]];
        }
    }
    return _headView;
}

- (NSMutableArray<GLBRecordModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
