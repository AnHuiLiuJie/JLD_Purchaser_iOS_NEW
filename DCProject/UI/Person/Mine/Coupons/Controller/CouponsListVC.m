//
//  CouponsListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/4.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "CouponsListVC.h"
#import "CouponListCell.h"
#import "CouponsListModel.h"
#import "CouponsHistoryVC.h"
#import "DCNoDataView.h"
#import "TRCouponCentrePageVC.h"
#import "TRStorePageVC.h"
#import "CouponsModel.h"
#import "GLPGoodsDetailsController.h"
@interface CouponsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UILabel *lineLab;
@property(nonatomic,copy) NSString *couponsClass;//优惠券类型1：平台通用券 2：店铺通用券 3：商品通用券 0:全部
@property(nonatomic,copy)NSString *isConsume;//是否已消费，0：已过期，1：未消费，2：已消费
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allPage;
@property(nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, strong) DCNoDataView *noorderDataView;
@end

@implementation CouponsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.storebtn.selected = YES;
    self.goodsbtn.selected = NO;
    self.platformbtn.selected = NO;
    self.historybtn.layer.masksToBounds = YES;
    self.historybtn.layer.cornerRadius = 6;
    self.getbtn.layer.masksToBounds = YES;
    self.getbtn.layer.cornerRadius = 6;
    self.lineLab = [[UILabel alloc] init];
    self.lineLab.frame = CGRectMake(kScreenW/6-30, kNavBarHeight+38, 60, 2);
    self.lineLab.backgroundColor = RGB_COLOR(0, 183, 171);
    [self.view addSubview:self.lineLab];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    self.couponsClass=@"2";
    self.isConsume = @"1";
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
    [[DCAPIManager shareManager]person_getCouponsListWithcouponsClass:self.couponsClass isConsume:self.isConsume currentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allPage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            CouponsListModel *model = [[CouponsListModel alloc] initWithDic:dic];
            [self.listArray addObject:model];
        }
        if (self.listArray.count>0)
        {
            self.noorderDataView.hidden = YES;
        }
        else{
            self.noorderDataView.hidden = NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (IBAction)getCouponsClick:(id)sender {
    TRCouponCentrePageVC *vc = [[TRCouponCentrePageVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)couponsHistoryClick:(id)sender {
    CouponsHistoryVC *vc = [[CouponsHistoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)storeClick:(id)sender {
    self.storebtn.selected = YES;
    self.goodsbtn.selected = NO;
    self.platformbtn.selected = NO;
    self.lineLab.frame = CGRectMake(kScreenW/6-30, kNavBarHeight+38, 60, 2);
    self.couponsClass=@"2";
    self.page = 1;
    [self.listArray removeAllObjects];
    [self getlist];
}

- (IBAction)goodsClick:(id)sender {
    self.storebtn.selected = NO;
    self.goodsbtn.selected = YES;
    self.platformbtn.selected = NO;
    self.lineLab.frame = CGRectMake(kScreenW/2-30, kNavBarHeight+38, 60, 2);
    self.couponsClass=@"3";
    self.page = 1;
    [self.listArray removeAllObjects];
    [self getlist];
}

- (IBAction)platformClick:(id)sender {
    self.storebtn.selected = NO;
    self.goodsbtn.selected = NO;
    self.platformbtn.selected = YES;
    self.lineLab.frame = CGRectMake(kScreenW*5/6-30, kNavBarHeight+38, 60, 2);
    self.couponsClass=@"1";
    [self.listArray removeAllObjects];
    [self getlist];
    
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr;
    CouponsListModel *model = self.listArray[indexPath.section];
    if ([self.couponsClass isEqualToString:@"3"])
    {
        arr = model.couponsGoods;
    }
    else{
        arr = model.coupons;
    }
    return 60+95*arr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponListCell *cell = [CouponListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    cell.couponsClass=self.couponsClass;
    CouponsListModel *model = self.listArray[indexPath.section];
    if ([self.couponsClass isEqualToString:@"3"])
    {
        cell.dataArray=model.couponsGoods;
    }
    else{
        cell.dataArray=model.coupons;//
    }
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.logo]] placeholderImage:[UIImage imageNamed:@"dc_placeholder_bg"]];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",model.storeName];
    cell.imageV.tag = indexPath.section;
    cell.imageV.userInteractionEnabled = YES;
    cell.nameLab.tag = indexPath.section;
    cell.nameLab.userInteractionEnabled = YES;
    UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goStore:)];
    [cell.imageV addGestureRecognizer:tap1];
    UITapGestureRecognizer*tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goStore:)];
    [cell.nameLab addGestureRecognizer:tap2];
    
    cell.userkblock = ^(NSInteger clickId) {
        if ([self.couponsClass isEqualToString:@"3"])
        {
            NSArray *arr1 = model.couponsGoods;
            CouponsModel *model1 = [[CouponsModel alloc]initWithDic:arr1[clickId]];
            GLPGoodsDetailsController*vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId = [NSString stringWithFormat:@"%@",model1.goodsId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([self.couponsClass isEqualToString:@"2"])
        {
            NSArray *arr2 = model.coupons;
            CouponsModel *model2 = [[CouponsModel alloc]initWithDic:arr2[clickId]];
            TRStorePageVC *vc = [[TRStorePageVC alloc] init];
            vc.firmId = [NSString stringWithFormat:@"%@",model2.firmId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
        }
        
    };
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

- (BOOL)isNotchScreen {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height *100;
    
    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }
    
    return NO;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        BOOL notch = [self isNotchScreen];
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+40, kScreenW, kScreenH - kNavBarHeight-40-55-(notch?34:0)) image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂未发现领取的优惠券"];
        
//        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.bounds image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂未发现领取的优惠券"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}

- (void)goStore:(UITapGestureRecognizer*)tap
{
    CouponsListModel *model = self.listArray[tap.view.tag];
    TRStorePageVC *vc = [[TRStorePageVC alloc] init];
    vc.firmId = [NSString stringWithFormat:@"%@",model.firmId];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
