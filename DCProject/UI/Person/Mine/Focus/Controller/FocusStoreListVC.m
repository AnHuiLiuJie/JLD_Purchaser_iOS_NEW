//
//  FocusStoreListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "FocusStoreListVC.h"
#import "TRFocusListCell.h"
#import "TRStorePageVC.h"
#import "DCNoDataView.h"
@interface FocusStoreListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,assign) int page;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,assign) int allpage;
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@end

@implementation FocusStoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注店铺";
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"TRFocusListCell" bundle:nil] forCellReuseIdentifier:@"TRFocusListCell"];
    [self.view addSubview:self.tableview];
    self.page = 1;
    self.listArray = [NSMutableArray arrayWithCapacity:0];
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
    [[DCAPIManager shareManager]person_getFocusLisFirstwithcurrentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        [self.listArray addObjectsFromArray:arr];
        if (self.listArray.count>0)
                      {
                          self.noorderDataView.hidden = YES;
                      }
                      else{
                          self.noorderDataView.hidden = NO;
                      }
        [self.tableview reloadData];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRFocusListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRFocusListCell"];
    if (cell== nil)
    {
        cell = [[TRFocusListCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.listArray[indexPath.section];
    [cell.storeImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logoImg"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.storeNameLab.text = [NSString stringWithFormat:@"%@",dic[@"firmName"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.listArray[indexPath.section];
    [[DCAPIManager shareManager]person_deleNewFocusFirstwithcollectionIds:[NSString stringWithFormat:@"%@",dic[@"objectId"]] success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
        [self.listArray removeObjectAtIndex:indexPath.section];
        [self.tableview reloadData];
    } failture:^(NSError *error) {
        
    }];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消关注";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.listArray[indexPath.section];
    TRStorePageVC *vc = [[TRStorePageVC alloc] init];
    vc.firmId = [NSString stringWithFormat:@"%@",dic[@"objectId"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        //_noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight) image:[UIImage imageNamed:@"p_shouc"] button:nil tip:@"您还没有关注任何店铺哦～"];
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableview.bounds image:[UIImage imageNamed:@"p_shouc"] button:nil tip:@"您还没有关注任何店铺哦～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}
@end
