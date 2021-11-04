//
//  GLBCollectListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCollectListController.h"
#import "DCTextField.h"
#import "GLBCollectBottomView.h"

#import "GLBNormalGoodsCell.h"

#import "GLBGoodsDetailController.h"

static NSString *const listCellID = @"GLBNormalGoodsCell";

@interface GLBCollectListController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) DCTextField *searchTF;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) GLBCollectBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray<GLBCollectModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GLBCollectModel *> *selectArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBCollectListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"收藏夹";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" target:self action:@selector(editAction:)];
    
    [self setUpTableView];
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.searchTF];
    [self.searchView addSubview:self.searchImage];
    [self.view addSubview:self.bottomView];
    
    [self addRefresh:NO];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestCollectList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestCollectList:NO];
}



#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBNormalGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.collectModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        
        GLBCollectModel *model = self.dataArray[indexPath.row];
        [self.selectArray addObject:model];
        
        if (self.selectArray.count == self.dataArray.count) {
            self.bottomView.selectBtn.selected = YES;
        } else {
            self.bottomView.selectBtn.selected = NO;
        }
        
    } else {
     
        [tableView reloadData];
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.detailType = GLBGoodsDetailTypeNormal;
        vc.goodsId = [self.dataArray[indexPath.row] goodsId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        GLBCollectModel *model = self.dataArray[indexPath.row];
        [self.selectArray removeObject:model];
        
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


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTF resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
    return YES;
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
        self.searchTF.userInteractionEnabled = NO;
        
    } else {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"编辑" target:self action:@selector(editAction:)];
        self.bottomView.hidden = YES;
        
        self.tableView.bounces = YES;
        self.searchTF.userInteractionEnabled = YES;
    }
}


#pragma mark - 请求 收藏列表
- (void)requestCollectList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCollectListWithCurrentPage:_page goodsName:self.searchTF.text success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count]>0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求 收藏列表
- (void)requestDeleteCollect
{
    NSMutableArray *idArray = [NSMutableArray array];
    [self.selectArray enumerateObjectsUsingBlock:^(GLBCollectModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
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
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    
//    self.noDataImg.image = [UIImage imageNamed:@"p_shouc"];
//    self.noDataLabel.text = @"暂时还没有哦";
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
        _searchTF.placeholder = @"商品名称、批准文号、助记码、生产厂家……";
        _searchTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        _searchTF.font = PFRFont(14);
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.rightViewMode = UITextFieldViewModeUnlessEditing;
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

- (GLBCollectBottomView *)bottomView{
    if (!_bottomView) {
        WEAKSELF;
        _bottomView = [[GLBCollectBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
        _bottomView.hidden = YES;
        _bottomView.selectBtnBlock = ^{
            [weakSelf.selectArray removeAllObjects];
            if (weakSelf.bottomView.selectBtn.selected) {
                [weakSelf.selectArray addObjectsFromArray:weakSelf.dataArray];
                for (int i=0; i<weakSelf.dataArray.count; i++) {
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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

- (NSMutableArray<GLBCollectModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLBCollectModel *> *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
