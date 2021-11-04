//
//  GLBAddressListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddressListController.h"

#import "GLBAddressListCell.h"

#import "GLBAddressEditController.h"

static NSString *listCellID = @"GLBAddressListCell";

@interface GLBAddressListController ()

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray<GLBAddressModel *> *dataArray;

@end

@implementation GLBAddressListController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestAddressListData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"收货地址";
    
    [self setUpTableView];
    [self.view addSubview:self.addBtn];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.addressModel = self.dataArray[indexPath.section];
    WEAKSELF;
    cell.editBtnBlock = ^{
        GLBAddressEditController *vc = [GLBAddressEditController new];
        vc.addressModel = weakSelf.dataArray[indexPath.section];
        [weakSelf dc_pushNextController:vc];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedBlock) {
        _selectedBlock(self.dataArray[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - action
- (void)addBtnClick:(UIButton *)button
{
    [self dc_pushNextController:[GLBAddressEditController new]];
}


#pragma mark - 请求 获取收货地址列表
- (void)requestAddressListData
{
    [self.dataArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAddressListWithSuccess:^(id response) {
        if (response && [response count]>0) {
            [weakSelf.dataArray addObjectsFromArray:response];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(10, kNavBarHeight, kScreenW - 20, kScreenH - kNavBarHeight - 45 - 20);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(10, kScreenH - 10 - 45, kScreenW - 20, 45);
        _addBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [_addBtn setTitle:@"新增收货地址" forState:0];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:0];
        _addBtn.titleLabel.font = PFRFont(16);
        [_addBtn dc_cornerRadius:2];
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (NSMutableArray<GLBAddressModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
