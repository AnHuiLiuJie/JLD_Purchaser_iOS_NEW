//
//  GLBCareListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCareListController.h"

#import "GLBCareBottomView.h"
#import "GLBCareListCell.h"

#import "GLBStorePageController.h"

static NSString *const listCellID = @"GLBCareListCell";

@interface GLBCareListController ()

@property (nonatomic, strong) GLBCareBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray<GLBCareModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GLBCareModel *> *selectArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBCareListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"关注店铺";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" target:self action:@selector(editAction:)];
    
    [self setUpTableView];
    [self.view addSubview:self.bottomView];
    
    [self addRefresh:NO];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestCareStoreList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestCareStoreList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBCareListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.careModel = self.dataArray[indexPath.section];
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
        GLBCareModel *model = self.dataArray[indexPath.section];
        if (![self.selectArray containsObject:model]) {
            [self.selectArray addObject:model];
        }
        
        if (self.selectArray.count == self.dataArray.count) {
            self.bottomView.selectBtn.selected = YES;
        } else {
            self.bottomView.selectBtn.selected = NO;
        }
        
    } else {
        
        GLBStorePageController *vc = [GLBStorePageController new];
        vc.firmId = [self.dataArray[indexPath.section] objectId];
        [self dc_pushNextController:vc];
        
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        GLBCareModel *model = self.dataArray[indexPath.section];
        if ([self.selectArray containsObject:model]) {
            [self.selectArray removeObject:model];
        }
        
        if (self.selectArray.count == self.dataArray.count) {
            self.bottomView.selectBtn.selected = YES;
        } else {
            self.bottomView.selectBtn.selected = NO;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



#pragma mark - action
- (void)editAction:(id)sender
{
    self.tableView.editing =! self.tableView.editing;
    
    if (self.tableView.editing) {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"完成" target:self action:@selector(editAction:)];
        self.bottomView.hidden = NO;
        
        [self.selectArray removeAllObjects];
        self.tableView.bounces = NO;
        
    } else {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" target:self action:@selector(editAction:)];
        self.bottomView.hidden = YES;
        
        self.tableView.bounces = YES;
    }
}


#pragma mark - 请求 关注店铺列表
- (void)requestCareStoreList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCareListWithCurrentPage:_page success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求 删除收藏
- (void)requestDeleteCollect
{
    NSMutableArray *idArray = [NSMutableArray array];
    [self.selectArray enumerateObjectsUsingBlock:^(GLBCareModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [idArray addObject:@(obj.collectionId)];
    }];
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDeleteCollectWithCollectionId:idArray success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakSelf.dataArray removeObjectsInArray:weakSelf.selectArray];
            [weakSelf.selectArray removeAllObjects];
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:YES];
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}



#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(15, kNavBarHeight, kScreenW - 15*2, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (GLBCareBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GLBCareBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
        _bottomView.hidden = YES;
        WEAKSELF;
        _bottomView.selectBtnBlock = ^{
            [weakSelf.selectArray removeAllObjects];
            if (weakSelf.bottomView.selectBtn.selected) {
                [weakSelf.selectArray addObjectsFromArray:weakSelf.dataArray];
                for (int i=0; i<weakSelf.dataArray.count; i++) {
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            } else {
                [weakSelf.tableView reloadData];
            }
        };
        _bottomView.removeBtnBlock = ^{
            if (weakSelf.selectArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"请选择需要移除收藏"];
            } else {
                [weakSelf requestDeleteCollect];
            }
        };
    }
    return _bottomView;
}

- (NSMutableArray<GLBCareModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLBCareModel *> *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


@end
