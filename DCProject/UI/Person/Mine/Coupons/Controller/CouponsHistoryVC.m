//
//  CouponsHistoryVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "CouponsHistoryVC.h"
#import "TRHistoryListCell.h"
#import "CouponsListModel.h"
#import "CouponsModel.h"
#import "DCNoDataView.h"
@interface CouponsHistoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UILabel *lineLab;
@property(nonatomic,copy) NSString *couponsClass;//优惠券类型1：平台通用券 2：店铺通用券 3：商品通用券 0:全部
@property(nonatomic,copy) NSString *isConsume;//是否已消费，4：已过期，1：未消费，2：已消费
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allPage;
@property(nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@end

@implementation CouponsHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"优惠券使用记录";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
     self.tableview.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lineLab = [[UILabel alloc] init];
    self.lineLab.frame = CGRectMake(kScreenW/4-30, kNavBarHeight+36, 60, 2);
    self.lineLab.backgroundColor = RGB_COLOR(0, 183, 171);
    [self.view addSubview:self.lineLab];
    self.userBtn.selected = YES;
    self.timeBtn.selected = NO;
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    self.couponsClass=@"0";
    self.isConsume = @"2";
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
    [self getlist];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.listArray removeAllObjects];
         self.tableview.tableFooterView = nil;
        [self getlist];
    }];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page=self.page+1;
        if (self.page>self.allPage)
        {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
            footView.backgroundColor = RGB_COLOR(247, 247, 247);
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 20)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = RGB_COLOR(51, 51, 51);
            lab.font = [UIFont systemFontOfSize:14];
            lab.text = @"已经到底了";
            [footView addSubview:lab];
            self.tableview.tableFooterView = footView;
            [self.tableview.mj_footer endRefreshing];
            return ;
        }
         self.tableview.tableFooterView = nil;
        [self getlist];
    }];
}

- (void)getlist
{
    [[DCAPIManager shareManager]person_getCouponsListWithcouponsClass:self.couponsClass isConsume:self.isConsume currentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allPage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            CouponsListModel *model = [[CouponsListModel alloc]initWithDic:dic];
            [self.listArray addObject:model];
        }
        [self.tableview reloadData];
        if (self.listArray.count>0)
                {
                    self.noorderDataView.hidden = YES;
                }
                else{
                    self.noorderDataView.hidden = NO;
                }
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}
#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     CouponsListModel *model = self.listArray[indexPath.section];
    NSMutableArray *allArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *couponArr = model.coupons;
    NSArray *goodsCuoponArr = model.couponsGoods;
    [allArr addObjectsFromArray:couponArr];
    [allArr addObjectsFromArray:goodsCuoponArr];
    return 17+95*allArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRHistoryListCell *cell = [TRHistoryListCell cellWithTableView:tableView];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CouponsListModel *model = self.listArray[indexPath.section];
    cell.detailblock = ^(NSInteger clickId) {
           NSMutableArray *allArr = [NSMutableArray arrayWithCapacity:0];
           NSArray *couponArr = model.coupons;
           NSArray *goodsCuoponArr = model.couponsGoods;
           [allArr addObjectsFromArray:couponArr];
           [allArr addObjectsFromArray:goodsCuoponArr];
        CouponsModel *model = [[CouponsModel alloc]initWithDic:allArr[clickId]];
        NSString *params = [NSString stringWithFormat:@"id=%@",model.orderId];
        [self dc_pushPersonWebController:@"/geren/detail.html" params:params];
    };
    cell.listModel=model;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)userClick:(id)sender {
    self.userBtn.selected = YES;
    self.timeBtn.selected = NO;
     self.lineLab.frame = CGRectMake(kScreenW/4-30, kNavBarHeight+38, 60, 2);
    self.isConsume = @"2";
    self.page = 1;
    [self.listArray removeAllObjects];
    [self getlist];
}

- (IBAction)timeClick:(id)sender {
    self.userBtn.selected = NO;
    self.timeBtn.selected = YES;
     self.lineLab.frame = CGRectMake(kScreenW*3/4-30, kNavBarHeight+38, 60, 2);
    self.isConsume = @"4";
    self.page = 1;
    [self.listArray removeAllObjects];
    [self getlist];
}
- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        //_noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+40, kScreenW, kScreenH - kNavBarHeight-40) image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂无优惠券使用记录"];
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableview.bounds image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂无优惠券使用记录"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}
@end
