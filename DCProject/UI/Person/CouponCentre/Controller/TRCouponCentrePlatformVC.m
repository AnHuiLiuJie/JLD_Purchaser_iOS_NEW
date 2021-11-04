//
//  TRCouponCentrePlatformVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRCouponCentrePlatformVC.h"
#import "CouponCenterGoodsCell.h"
#import "DCNoDataView.h"
@interface TRCouponCentrePlatformVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allPage;
@property(nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@end

@implementation TRCouponCentrePlatformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-40) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCenterGoodsCell" bundle:nil] forCellReuseIdentifier:@"CouponCenterGoodsCell"];
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
    [[DCAPIManager shareManager]person_CouponCenterPlatformwithcurrentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id response) {
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
    CouponCenterGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCenterGoodsCell"];
    if (cell==nil)
    {
        cell = [[CouponCenterGoodsCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    NSDictionary *dic = self.listArray[indexPath.section];
    NSString *isreceive = [NSString stringWithFormat:@"%@",dic[@"isReceive"]];
    if ([isreceive isEqualToString:@"1"])
    {
        [cell.getBtn setTitle:@"去使用" forState:UIControlStateNormal];
        cell.bgImageV.image = [UIImage imageNamed:@"yilingqu"];
        cell.haveImageV.hidden = NO;
    }
    else{
        [cell.getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
         cell.bgImageV.image = [UIImage imageNamed:@"weilingqu"];
        cell.haveImageV.hidden = YES;
    }
    [cell.goodImageV sd_setImageWithURL:[NSURL URLWithString:dic[@""]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.discountLab.text = [NSString stringWithFormat:@"¥%@",dic[@"discountAmount"]];
    cell.discountLab = [UILabel setupAttributeLabel:cell.discountLab textColor:cell.discountLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    cell.requestLab.text = [NSString stringWithFormat:@"满%@元可用",dic[@"requireAmount"]];
    cell.getBtn.tag = indexPath.section;
    [cell.getBtn addTarget:self action:@selector(getbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
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

- (void)getbtnClick:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"立即领取"])
    {
        NSDictionary *couponsDic=self.listArray[btn.tag];
        [[DCAPIManager shareManager]person_receiveCouponswithcouponsId:[NSString stringWithFormat:@"%@",couponsDic[@"couponsId"]] success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            [self performSelector:@selector(refreshClick) withObject:nil afterDelay:1.0];
        } failture:^(NSError *error) {
            
        }];
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
