//
//  GLBBrowseListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBBrowseListController.h"

#import "GLBBrowseCell.h"
#import "GLBBrowseTimeCell.h"

#import "GLBGoodsDetailController.h"

static NSString *const listCellID = @"GLBBrowseCell";
static NSString *const timeCellID = @"GLBBrowseTimeCell";
static NSString *const sectionID = @"UITableViewHeaderFooterView";

@interface GLBBrowseListController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBBrowseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的足迹";
    
    [self setUpTableView];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestBrowseRecode:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestBrowseRecode:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
//    if (indexPath.section == 0 || indexPath.section == 4) {
//
//        GLBBrowseTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:timeCellID forIndexPath:indexPath];
//        cell = timeCell;
//
//    } else {
    
    GLBBrowseCell *browseCell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    browseCell.browseModel = self.dataArray[indexPath.section];
    cell = browseCell;
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        
    } else {
        
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
//        vc.batchId = [NSString stringWithFormat:@"%@",[self.dataArray[indexPath.section] batchId]];
        vc.goodsId = [self.dataArray[indexPath.section] goodsId];
        vc.detailType = GLBGoodsDetailTypeNormal;
        [self dc_pushNextController:vc];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        //        if (![self.selectArray containsObject:@(indexPath.row)]) {
        //            [self.selectArray addObject:@(indexPath.row)]
        //        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// ios8 - 11
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
        [weakSelf requestAddCollection:indexPath];
    }];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
        [weakSelf requestDeleteBrowse:indexPath];
    }];
    
    
    action1.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    action2.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3F3F"];

    return @[action1, action2];
}

// ios11+
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){
    WEAKSELF;
    UIContextualAction *colloctAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"收藏" handler:^(UIContextualAction *_Nonnull action, __kindof UIView *_Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weakSelf requestAddCollection:indexPath];
    }];
    colloctAction.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction *_Nonnull action, __kindof UIView *_Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weakSelf requestDeleteBrowse:indexPath];
    }];
    deleteAction.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3F3F"];
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,colloctAction]];
    actions.performsFirstActionWithFullSwipe = NO;
    return actions;
}


#pragma mark - 请求 列表数据
- (void)requestBrowseRecode:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestBrowseRecordWithCurrentPage:_page success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 删除浏览记录
- (void)requestDeleteBrowse:(NSIndexPath *)indexPath
{
    GLBBrowseModel *model = self.dataArray[indexPath.section];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDeleteBrowseWithAccessId:model.accessId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:YES];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 添加收藏
- (void)requestAddCollection:(NSIndexPath *)indexPath
{
    GLBBrowseModel *model = self.dataArray[indexPath.section];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAddCollectWithInfoId:model.goodsId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(10, kNavBarHeight, kScreenW - 10*2, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [self.tableView registerClass:NSClassFromString(timeCellID) forCellReuseIdentifier:timeCellID];
}


#pragma mark - lazy load
- (NSMutableArray<GLBBrowseModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
