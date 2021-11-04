//
//  TRCouponCentreStoreVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRCouponCentreStoreVC.h"
#import "TRCouponStoreListCell.h"
#import "TRStorePageVC.h"
#import "DCNoDataView.h"
@interface TRCouponCentreStoreVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allPage;
@property(nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@end

@implementation TRCouponCentreStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH-kNavBarHeight-40-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRCouponStoreListCell" bundle:nil] forCellReuseIdentifier:@"TRCouponStoreListCell"];
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
    [[DCAPIManager shareManager]person_CouponCenterStorewithcurrentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id response) {
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
    TRCouponStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRCouponStoreListCell"];
    if (cell==nil)
    {
        cell = [[TRCouponStoreListCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    NSDictionary *dic = self.listArray[indexPath.section];
    [cell.logoImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    NSDictionary *couponsDic = dic[@"coupons"];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",dic[@"firmName"]];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@",couponsDic[@"discountAmount"]];
    cell.priceLab = [UILabel setupAttributeLabel:cell.priceLab textColor:cell.priceLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    cell.requestLab.text = [NSString stringWithFormat:@"满%@元可用",couponsDic[@"requireAmount"]];
    NSString *isReceive = [NSString stringWithFormat:@"%@",couponsDic[@"isReceive"]];
    if ([isReceive isEqualToString:@"1"])
    {
        cell.haveImageV.hidden = NO;
        [cell.getBtn setTitle:@"去使用" forState:UIControlStateNormal];
        [cell.getBtn setTitleColor:RGB_COLOR(255, 88, 0) forState:UIControlStateNormal];
        cell.getBtn.backgroundColor = [UIColor clearColor];
        cell.titleLab.textColor = RGB_COLOR(196, 196, 196);
        cell.priceLab.textColor = RGB_COLOR(196, 196, 196);
        cell.requestLab.textColor = RGB_COLOR(196, 196, 196);
    }
    else{
        cell.haveImageV.hidden = YES;
        [cell.getBtn setTitle:@"领取" forState:UIControlStateNormal];
        [cell.getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.getBtn.backgroundColor = RGB_COLOR(255, 88, 0);
        cell.titleLab.textColor = RGB_COLOR(255, 88, 0);
        cell.priceLab.textColor = RGB_COLOR(255, 88, 0);
        cell.requestLab.textColor = RGB_COLOR(255, 88, 0);
    }
    cell.getBtn.layer.masksToBounds = YES;
    cell.getBtn.layer.cornerRadius = 12.5;
    cell.getBtn.layer.borderColor = RGB_COLOR(255, 88, 0).CGColor;
    cell.getBtn.layer.borderWidth = 1;
    cell.getBtn.tag = indexPath.section;
    [cell.getBtn addTarget:self action:@selector(getClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *arr = dic[@"goodsList"];
    cell.dataArray = arr;
    return cell;;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 236;
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

- (void)getClick:(UIButton*)btn
{
    NSDictionary *dic = self.listArray[btn.tag];
    NSDictionary *couponsDic = dic[@"coupons"];
    if ([btn.titleLabel.text isEqualToString:@"领取"])
    {
        [[DCAPIManager shareManager]person_receiveCouponswithcouponsId:[NSString stringWithFormat:@"%@",couponsDic[@"couponsId"]] success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            [self performSelector:@selector(refreshClick) withObject:nil afterDelay:1.0];
        } failture:^(NSError *error) {
            
        }];
    }
    else{
        TRStorePageVC *vc = [[TRStorePageVC alloc] init];
        vc.firmId = [NSString stringWithFormat:@"%@",dic[@"firmId"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
