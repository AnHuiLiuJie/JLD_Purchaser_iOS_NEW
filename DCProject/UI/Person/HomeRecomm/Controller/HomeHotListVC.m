//
//  HomeHotListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "HomeHotListVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HomeHotListCell.h"
#import "GLPGoodsDetailsController.h"
@interface HomeHotListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,strong) UIImageView *headImageV;
@property(nonatomic,strong) UILabel *titLab;
@end

@implementation HomeHotListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    UIImageView*navImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
    navImageV.image = [UIImage imageNamed:@"hot_navbg"];
    [self.view addSubview:navImageV];
    UIImageView*topImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 201)];
    topImageV.image = [UIImage imageNamed:@"rexiaobbg"];
    [self.view addSubview:topImageV];
    UIImageView*bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200+kNavBarHeight, kScreenW,kScreenH-200-kNavBarHeight)];
    bgImageV.image = [UIImage imageNamed:@"hot_navbg"];
    [self.view addSubview:bgImageV];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, kStatusBarHeight+14, 20, 20);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _titLab = [[UILabel alloc]initWithFrame:CGRectMake(30, kStatusBarHeight+14, kScreenW-60, 20)];
    _titLab.textColor = [UIColor whiteColor];
    _titLab.text = @"热销商品";
    _titLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titLab];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(15, kNavBarHeight+15, kScreenW-30, kScreenH-kNavBarHeight-15-LJ_TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"HomeHotListCell" bundle:nil] forCellReuseIdentifier:@"HomeHotListCell"];
    [self.view addSubview:self.tableview];
    //[self.tableview dc_cornerRadius:5];
//    [_tableview dc_layerBorderWith:1 color:[UIColor redColor] radius:0];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-30, 160)];
    self.tableview.tableHeaderView = headview;
    UIImageView*headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-30, 135)];
    headImageV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.tableview];
    [headImageV dc_cornerRadius:5];
    [headview addSubview:headImageV];
    self.headImageV = headImageV;
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    [self getdata];
    
    if (self.title.length>1) {
        _titLab.text= self.title;
    }
}

- (void)getdata
{
    WEAKSELF;
    [[DCAPIManager shareManager]person_requestHomeRecommendWithZoneCode:@"HOTSALES_ZONE_INDEX" type:@"2" success:^(id response) {
        GLPHomeDataModel *mode = response;
        weakSelf.titLab.text = weakSelf.title = mode.spaceName;
        [weakSelf.headImageV sd_setImageWithURL:[NSURL URLWithString:mode.spacePic] placeholderImage:[UIImage imageNamed:@"ppic"]];
        if (mode.spacePic.length < 6) {
            weakSelf.tableview.tableHeaderView = nil;
        }else{
            //weakSelf.headImageV.hidden = NO;
        }
        NSArray *arr = mode.dataList;
        [weakSelf.listArray addObjectsFromArray:arr];
        [weakSelf.tableview reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeHotListCell"];
    if (cell == nil){
        cell = [[HomeHotListCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.listArray[indexPath.row];
    
    if (self.listArray.count > 0) {
        if (indexPath.row == 0 ) {
            cell.radiusType = 1;
            //[cell.contentView dc_cornerRadius:5 rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
        }
        if (indexPath.row == self.listArray.count-1) {
            cell.radiusType = 2;
            //[cell.contentView dc_cornerRadius:5 rectCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLPHomeDataListModel *model = self.listArray[indexPath.row];
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = [NSString stringWithFormat:@"%@",model.infoId];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
