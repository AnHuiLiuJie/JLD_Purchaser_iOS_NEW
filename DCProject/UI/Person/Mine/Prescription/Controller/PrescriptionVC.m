//
//  PrescriptionVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PrescriptionVC.h"
#import "PrescriptionCell.h"
#import "RequestListVC.h"
@interface PrescriptionVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allpage;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation PrescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的处方";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, kNavBarHeight, kScreenW-30, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tr_chufandan"] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    [self getData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.dataArray removeAllObjects];
        self.tableView.tableFooterView = nil;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page=self.page+1;
        
        if (self.page>self.allpage)
        {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
            footView.backgroundColor = RGB_COLOR(247, 247, 247);
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 20)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = RGB_COLOR(51, 51, 51);
            lab.font = [UIFont systemFontOfSize:14];
            lab.text = @"已经到底了";
            [footView addSubview:lab];
            self.tableView.tableFooterView = footView;
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
         self.tableView.tableFooterView = nil;
        [self getData];
    }];
}

- (void)getData
{
    [[DCAPIManager shareManager]person_getPrescriptionsWithorderNo:@"" currentPage:[NSString stringWithFormat:@"%d",self.page] endDate:@"" orderState:@"" sellerFirmName:@"" startDate:@"" success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allpage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        [self.dataArray addObjectsFromArray:arr];
        [self.tableView reloadData];
         [self.tableView.mj_footer endRefreshing];
         [self.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)rightClick
{
    RequestListVC *vc = [[RequestListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = dic[@"orderGoodsList"];
    return 92*arr.count+68;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrescriptionCell *cell = [PrescriptionCell cellWithTableView:tableView];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = dic[@"orderGoodsList"];
    cell.dataArray = arr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeLab.text = [NSString stringWithFormat:@"提交时间：%@",dic[@"orderTime"]];
    cell.lookBtn.tag = indexPath.section;
    [cell.lookBtn addTarget:self action:@selector(lookClick:) forControlEvents:UIControlEventTouchUpInside];
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
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)lookClick:(UIButton*)btn
{
     NSDictionary *dic = self.dataArray[btn.tag];
    NSString *idStr = [NSString stringWithFormat:@"%@",dic[@"orderNo"]];
    [self dc_pushPersonWebController:@"/geren/recipe_detail.html" params:[NSString stringWithFormat:@"id=%@",idStr]];
}
@end
