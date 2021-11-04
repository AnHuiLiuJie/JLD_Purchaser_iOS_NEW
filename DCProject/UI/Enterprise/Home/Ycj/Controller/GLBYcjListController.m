//
//  GLBYcjListController.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBYcjListController.h"
#import "GLBYcjHeadView.h"
#import "GLBYcjListCell.h"

#import "GLBGoodsDetailController.h"

static NSString *const listCellID = @"GLBYcjListCell";

@interface GLBYcjListController ()

@property (nonatomic, strong) GLBYcjHeadView *headView;

@property (nonatomic, strong) NSMutableArray<GLBYcjGoodsModel *> *dataArray;
@property (nonatomic, strong) GLBYcjModel *ycjModel;

@end

@implementation GLBYcjListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"药集采";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_rightItemWithImage:[UIImage imageNamed:@"ycj_gz"] target:self action:@selector(rightItemAction:)];
    
    [self setUpTableView];
    
    [self requestYcjData];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBYcjListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.goodsModel = self.dataArray[indexPath.row];
    if ([self.ycjModel.yicIsEnd isEqualToString:@"2"])
    {
        [cell.buyBtn setTitle:@"备货中" forState:UIControlStateNormal];
        cell.buyBtn.backgroundColor = RGB_COLOR(98, 137, 210);
        cell.buyBtn.userInteractionEnabled = NO;
    }
    else{
        [cell.buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        cell.buyBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
        cell.buyBtn.userInteractionEnabled = YES;
    }
    cell.buyBtn.tag = indexPath.row;
    [cell.buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)buyClick:(UIButton*)btn
{
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
    vc.detailType = GLBGoodsDetailTypeYjc;
    vc.goodsId = [self.dataArray[btn.tag] goodsId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action
- (void)rightItemAction:(id)sender
{
    [self dc_pushWebController:@"/public/jc_rule.html" params:nil];
}


#pragma mark - 请求 药采集
- (void)requestYcjData
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDrugCollectWithSuccess:^(id response) {
        
        if (response && [response isKindOfClass:[GLBYcjModel class]]) {
            weakSelf.ycjModel = (GLBYcjModel *)response;
            [weakSelf.dataArray addObjectsFromArray:weakSelf.ycjModel.goods];
            
            if (weakSelf.ycjModel.actTitle) {
                weakSelf.navigationItem.title = weakSelf.ycjModel.actTitle;
            }
            weakSelf.headView.ycjModel = weakSelf.ycjModel;
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
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headView;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (GLBYcjHeadView *)headView{
    if (!_headView) {
        _headView = [[GLBYcjHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*0.26 + 40)];
    }
    return _headView;
}

- (NSMutableArray<GLBYcjGoodsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
