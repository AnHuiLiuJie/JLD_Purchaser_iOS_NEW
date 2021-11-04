//
//  GLBApplySuccessController.m
//  DCProject
//
//  Created by bigbing on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBApplySuccessController.h"
#import "GLBApplySuccessCell.h"
#import "GLBApplySuccessSectionView.h"

#import "DCTabbarController.h"
#import "GLBOrderPageController.h"

static NSString *const listCellID = @"GLBApplySuccessCell";
static NSString *const sectionID = @"GLBApplySuccessSectionView";

@interface GLBApplySuccessController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *footerView;

@end


@implementation GLBApplySuccessController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_popBackDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_popBackDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单提交成功";
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dc_leftItemWithImage:[UIImage imageNamed:@"dc_fanhui_hei"] target:self action:@selector(backAction:)];
    
    [self setUpTableView];
    self.tableView.tableFooterView = self.footerView;
    
    [self requestOrderList];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBApplySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.successModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - action
- (void)backBtnClick:(UIButton *)button
{
    DC_KeyWindow.rootViewController = [[DCTabbarController alloc] init];
}

- (void)orderBtnClick:(UIButton *)button
{
    GLBOrderPageController *vc = [GLBOrderPageController new];
    vc.selectIndex = 1;
    [self dc_pushNextController:vc];
}

- (void)backAction:(id)sender
{
    DC_KeyWindow.rootViewController = [[DCTabbarController alloc] init];
}


#pragma mark - 请求 订单列表
- (void)requestOrderList
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestApplyOrderSuccessWithOrders:_order success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:response];
        }
        [weakSelf.tableView reloadData];
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
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


- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        tipLabel.text = @"温馨提示：若您对订单有任何疑问，请随时联系我们。药品交易网及供应商不会以订单异常、体统升级为由要求您点击任何链接进行退款。联系电话：400-800-1268";
        tipLabel.font = PFRFont(12);
        tipLabel.numberOfLines = 0;
        [_footerView addSubview:tipLabel];
        
        CGSize size = [tipLabel sizeThatFits:CGSizeMake(kScreenW - 30, MAXFLOAT)];
        tipLabel.frame = CGRectMake(15, 0, kScreenW - 30, size.height + 20);
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回首页" forState:0];
        [backBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
        backBtn.titleLabel.font = PFRFont(16);
        [backBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:3];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:backBtn];
        
        backBtn.frame = CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 10, (kScreenW-40)/2, 45);
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"查看订单" forState:0];
        [orderBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
        orderBtn.titleLabel.font = PFRFont(16);
        orderBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [orderBtn dc_cornerRadius:3];
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:orderBtn];
        
        
        orderBtn.frame = CGRectMake(CGRectGetMaxX(backBtn.frame) + 20, CGRectGetMinY(backBtn.frame), (kScreenW-40)/2, 45);
        
        _footerView.frame = CGRectMake(0, 0, kScreenW, CGRectGetMaxY(orderBtn.frame) + 10);
    }
    return _footerView;
}

@end
