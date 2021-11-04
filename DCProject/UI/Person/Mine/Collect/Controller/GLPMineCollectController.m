//
//  GLPMineCollectController.m
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMineCollectController.h"
#import "DCTextField.h"
#import "TRGoodsCell.h"
#import "GLPMineCollectBottomView.h"

#import "GLPGoodsDetailsController.h"

#define kRowHeight 174

static NSString *const listCellID = @"TRGoodsCell";

@interface GLPMineCollectController ()<UITextFieldDelegate>

@property (nonatomic, strong) DCTextField *searchTF;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) GLPMineCollectBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray<GLPMineCollectModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<GLPMineCollectModel *> *selectedArray; // 选中的数组

@end

@implementation GLPMineCollectController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"收藏夹";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_rightItemWithTitle:@"管理" target:self action:@selector(editAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchImage];
    [self setUpTableView];
    [self.view addSubview:self.bottomView];
    
    [self addRefresh:NO];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestCollectGoodsList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestCollectGoodsList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
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
    
    GLPMineCollectModel *collectModel = self.dataArray[indexPath.item];
    
    if (tableView.isEditing) {
        
        [self.selectedArray addObject:collectModel];
        if (self.selectedArray.count == self.dataArray.count) {
            self.bottomView.selectBtn.selected = YES;
        } else {
            self.bottomView.selectBtn.selected = NO;
        }
        
    } else { // 页面跳转
        
        GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
        vc.goodsId = collectModel.goodsId;
        vc.firmId = [NSString stringWithFormat:@"%ld",collectModel.sellerFirmId];
        [self dc_pushNextController:vc];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPMineCollectModel *collectModel = self.dataArray[indexPath.item];
    [self.selectedArray removeObject:collectModel];
    
    if (self.selectedArray.count == self.dataArray.count) {
        self.bottomView.selectBtn.selected = YES;
    } else {
        self.bottomView.selectBtn.selected = NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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
        
        [self.selectedArray removeAllObjects];
        self.tableView.bounces = NO;
        self.searchTF.userInteractionEnabled = NO;
        
        
    } else {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" target:self action:@selector(editAction:)];
        self.bottomView.hidden = YES;
        
        self.tableView.bounces = YES;
        self.searchTF.userInteractionEnabled = YES;
    }
}


#pragma mark - 请求 收藏记录
- (void)requestCollectGoodsList:(BOOL)isReload
{
    _page++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    NSString *goodsName = self.searchTF.text.length > 0 ? self.searchTF.text : @"";
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestCollectGoodsListWithCurrentPage:_page goodsName:goodsName success:^(NSArray *array, BOOL hasNextPage,CommonListModel *commonModel) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求 移除收藏
- (void)requestDeleteCollect
{
    NSString *goodsId = @"";
    for (int i = 0; i<self.selectedArray.count; i++) {
        GLPMineCollectModel *collectModel = self.selectedArray[i];
        if (goodsId.length == 0) {
            goodsId = [NSString stringWithFormat:@"%@",collectModel.goodsId];
        } else {
            goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,collectModel.goodsId];
        }
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_deleNewFocusFirstwithcollectionIds:goodsId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"移出收藏成功"];
            [weakSelf.dataArray removeObjectsInArray:weakSelf.selectedArray];
            [weakSelf.selectedArray removeAllObjects];
            [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:YES];
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 50, kScreenW, kScreenH - LJ_TabbarSafeBottomMargin - kNavBarHeight - 50);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = kRowHeight;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:listCellID bundle:nil] forCellReuseIdentifier:listCellID];
    
    self.noDataImg.image = [UIImage imageNamed:@"p_shouc"];
    self.noDataLabel.text = @"暂时还没有哦";
}


#pragma mark - lazy load
- (DCTextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[DCTextField alloc] initWithFrame:CGRectMake(16, kNavBarHeight + 10, kScreenW - 16*2, 30)];
        _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F6F7F8"];
        [_searchTF dc_cornerRadius:15];
        _searchTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"搜索收藏商品"];
        _searchTF.font = PFRFont(14);
        _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
        _searchTF.textColor = [UIColor blackColor];
    }
    return _searchTF;
}

- (UIImageView *)searchImage{
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc] init];
        _searchImage.frame = CGRectMake(CGRectGetMinX(_searchTF.frame) + 8, CGRectGetMinY(_searchTF.frame) + 8, 14, 14);
        _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    }
    return _searchImage;
}

- (GLPMineCollectBottomView *)bottomView{
    if (!_bottomView) {
        WEAKSELF;
        _bottomView = [[GLPMineCollectBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-LJ_TabbarSafeBottomMargin-50, kScreenW, 50)];
        _bottomView.hidden = YES;
        _bottomView.selectBtnBlock = ^{
            [weakSelf.selectedArray removeAllObjects];
            if (weakSelf.bottomView.selectBtn.selected) {
                [weakSelf.selectedArray addObjectsFromArray:weakSelf.dataArray];
                for (int i=0; i<weakSelf.dataArray.count; i++) {
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            } else {
                [weakSelf.tableView reloadData];
            }
        };
        _bottomView.removeBtnBlock = ^{
            if (weakSelf.selectedArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"请选择需要移除收藏"];
            } else {
                [weakSelf requestDeleteCollect];
            }
        };
    }
    return _bottomView;
}

- (NSMutableArray<GLPMineCollectModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLPMineCollectModel *> *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

@end
