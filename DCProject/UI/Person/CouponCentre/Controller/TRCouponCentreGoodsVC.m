//
//  TRCouponCentrePlatformVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRCouponCentreGoodsVC.h"
#import "CouponcenterFirmCell.h"
#import "TRStorePageVC.h"
#import "GLPGoodsDetailsController.h"
#import "DCNoDataView.h"
@interface TRCouponCentreGoodsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allPage;
@property(nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, strong) DCNoDataView *noorderDataView;

@end

@implementation TRCouponCentreGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-40) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponcenterFirmCell" bundle:nil] forCellReuseIdentifier:@"CouponcenterFirmCell"];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    self.noorderDataView.hidden = YES;
       [self.view addSubview:self.noorderDataView];
    self.page = 1;
    [self getlist];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.listArray removeAllObjects];
         self.tableView.tableFooterView = nil;
        [self getlist];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
            self.tableView.tableFooterView = footView;
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
         self.tableView.tableFooterView = nil;
        [self getlist];
    }];
}

- (void)getlist
{
    [[DCAPIManager shareManager]person_CouponCenterGoodswithcurrentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allPage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        [self.listArray addObjectsFromArray:arr];
        if (self.listArray.count>0)
                             {
                                 self.noorderDataView.hidden = YES;
                             }
                             else{
                                 self.noorderDataView.hidden = NO;
                             }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponcenterFirmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponcenterFirmCell"];
    if (cell== nil)
    {
        cell = [[CouponcenterFirmCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = self.listArray[indexPath.section];
    NSArray *arr = dic[@"goodsCouponsList"];
    [cell.logoImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",dic[@"storeName"]];
    cell.storeBtn.layer.masksToBounds = YES;
    cell.storeBtn.layer.cornerRadius = 12.5;
    cell.dataArray = arr;
    cell.couponblock = ^(NSInteger selectId) {
        NSDictionary *couponsDic = arr[selectId];
        [[DCAPIManager shareManager]person_receiveCouponswithcouponsId:[NSString stringWithFormat:@"%@",couponsDic[@"couponsId"]] success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            [self performSelector:@selector(refreshClick) withObject:nil afterDelay:1.0];
        } failture:^(NSError *error) {
            
        }];
    };
    cell.couponuserblock = ^(NSInteger selectId) {
        NSDictionary *goodsDic = arr[selectId];
        GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
        vc.goodsId = [NSString stringWithFormat:@"%@",goodsDic[@"goodsId"]];
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.storeBtn.tag = indexPath.section;
    [cell.storeBtn addTarget:self action:@selector(gotoStoreClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = self.listArray[indexPath.section];
    NSArray *arr = dic[@"goodsCouponsList"];
    return 68+95*arr.count;
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

- (void)gotoStoreClick:(UIButton*)btn
{
    NSDictionary *dic = self.listArray[btn.tag];
    TRStorePageVC *vc = [[TRStorePageVC alloc] init];
    vc.firmId = [NSString stringWithFormat:@"%@",dic[@"firmId"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshClick
{
    [self.listArray removeAllObjects];
    self.page = 1;
    [self getlist];
}
- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        //_noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+40, kScreenW, kScreenH - kNavBarHeight-40) image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂无此类优惠券～"];
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.bounds image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂无此类优惠券～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}
@end
