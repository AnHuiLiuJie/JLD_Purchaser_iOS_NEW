//
//  TRStoreHomeVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRStoreHomeVC.h"
#import "TRHomeCell1.h"
#import "TRHomeCell2.h"
#import "TRHomeCell3.h"
#import "TRHomeCell4.h"
#import "TRHomeCell5.h"
#import "CouponsModel.h"
#import "TRClassGoodsVC.h"
#import "GLPGoodsDetailsController.h"
#import "StoreFoolsGoodsVC.h"
@interface TRStoreHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *couponArray;
@property(nonatomic,strong)NSDictionary *teamDic;
@property(nonatomic,strong)NSDictionary *promotionDic1;
@property(nonatomic,strong)NSDictionary *promotionDic2;
@property(nonatomic,strong) NSMutableArray *foolArray;
@end

@implementation TRStoreHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenW, kScreenH-kStatusBarHeight-170-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRHomeCell3" bundle:nil] forCellReuseIdentifier:@"TRHomeCell3"];
    self.couponArray = [NSMutableArray arrayWithCapacity:0];
    self.foolArray = [NSMutableArray arrayWithCapacity:0];
//    [self getcouponsList];
//    [self getrecommend1];
//    [self getrecommend2];
//    [self getrecommend3];
//    [self getfools];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.couponArray removeAllObjects];
        [self getcouponsList];
        [self getrecommend1];
        [self getrecommend2];
        [self getrecommend3];
        [self.foolArray removeAllObjects];
        [self getfools];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//获取优惠券
- (void)getcouponsList
{
    [[DCAPIManager shareManager]person_getStoreCouponswithfirmId:self.firmId success:^(id response) {
        NSArray *arr = response[@"data"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            CouponsModel *model = [[CouponsModel alloc]initWithDic:dic];
            [self.couponArray addObject:model];
        }
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取推介位（团购）
- (void)getrecommend1
{
    [[DCAPIManager shareManager]person_getStoreRecommendwithfirmId:self.firmId spaceCode:@"DEFAULT_APP_INDEX_01" success:^(id response) {
        NSArray *arr = response[@"data"][@"dataList"];
        if (arr.count>0)
        {
           self.teamDic = [arr firstObject];
        }
        else{
            self.teamDic= nil;
        }
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取推介位（促销1）
- (void)getrecommend2
{
    [[DCAPIManager shareManager]person_getStoreRecommendwithfirmId:self.firmId spaceCode:@"DEFAULT_APP_INDEX_02" success:^(id response) {
        NSArray *arr = response[@"data"][@"dataList"];
        if (arr.count>0)
        {
            self.promotionDic1 = [arr firstObject];
        }
        else{
            self.promotionDic1= nil;
        }
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取推介位（促销2）
- (void)getrecommend3
{
    [[DCAPIManager shareManager]person_getStoreRecommendwithfirmId:self.firmId spaceCode:@"DEFAULT_APP_INDEX_03" success:^(id response) {
        NSArray *arr = response[@"data"][@"dataList"];
        if (arr.count>0)
        {
            self.promotionDic2 = [arr firstObject];
        }
        else{
            self.promotionDic2= nil;
        }
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取最下层
- (void)getfools
{
    [[DCAPIManager shareManager]person_getStoreFloorwithfirmId:self.firmId success:^(id response) {
        NSArray *arr = response[@"data"];
        [self.foolArray addObjectsFromArray:arr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0)
    {
        if (self.couponArray.count==0)
        {
            return 0;
        }
        else{
            return 1;
        }
        
    }
    else if (section==1)
    {
        if (self.teamDic!= nil||![self.teamDic isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.teamDic[@"groupVo"];
            if (dic==nil||[dic isEqualToDictionary:@{}])
            {
                return 0;
            }
            else{
                return 1;
            }
        }
        else{
            return 0;
        }
    }
    else if (section==2)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        if (self.promotionDic1!=nil&&![self.promotionDic1 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic1[@"actVo"];
            if (dic!=nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
        }
        if (self.promotionDic2!= nil&&![self.promotionDic2 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic2[@"actVo"];
            if (dic!= nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
            
        }
        if (arr.count==0)
        {
            return 0;
        }
        else{
            return 1;
        }
    }
    else{
        return self.foolArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        TRHomeCell1*cell = [TRHomeCell1 cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.dataArray=self.couponArray;
        cell.clickblock = ^(NSInteger clickId) {
            CouponsModel *model = self.couponArray[clickId];
            [[DCAPIManager shareManager]person_receiveCouponswithcouponsId:[NSString stringWithFormat:@"%@",model.couponsId] success:^(id response) {
                [SVProgressHUD showSuccessWithStatus:@"领取成功"];
                [self.couponArray removeAllObjects];
                [self getcouponsList];
            } failture:^(NSError *error) {
            }];
        };
        return cell;
    }
    
    else if(indexPath.section==1){
        TRHomeCell3*cell = [tableView dequeueReusableCellWithIdentifier:@"TRHomeCell3"];
        if (cell==nil)
        {
            cell = [[TRHomeCell3 alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        if (self.teamDic!= nil)
        {
            [cell.bgImageV sd_setImageWithURL:[NSURL URLWithString:self.teamDic[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"ppic"]];
            NSDictionary *dic = self.teamDic[@"groupVo"];
            NSString *endtime = [NSString stringWithFormat:@"%@",dic[@"actEndDate"]];
            NSDate *date = [[NSDate alloc] init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *curTime = [formatter stringFromDate:date];
            NSDate *endDate = [NSDate dateFromString:endtime];
            NSDate *currentDate = [NSDate dateFromString:curTime];
            NSTimeInterval vale = [endDate timeIntervalSinceDate:currentDate];
            int timenum=vale;
            if (vale>0)
            {
                int day=timenum/(3600*24);
                int a=timenum%(3600*24);
                int hou=a/3600;
                int b=a%3600;
                int m=b/60;
                if (day<10)
                {
                     cell.dayLab.text = [NSString stringWithFormat:@"0%d",day];
                }
                else{
                     cell.dayLab.text = [NSString stringWithFormat:@"%d",day];
                }
                if (hou<10)
                {
                     cell.hLab.text = [NSString stringWithFormat:@"0%d",hou];
                }
                else{
                     cell.hLab.text = [NSString stringWithFormat:@"%d",hou];
                }
                if (m<10)
                {
                    cell.mLab.text = [NSString stringWithFormat:@"0%d",m];
                }
                else{
                    cell.mLab.text = [NSString stringWithFormat:@"%d",m];
                }
                
            }
            else{
                cell.dayLab.text = @"00";
                cell.hLab.text = @"00";
                cell.mLab.text = @"00";
            }
            
        }
        return cell;
    }
    else if(indexPath.section==2){
       
        TRHomeCell4 *cell = [TRHomeCell4 cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
         NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        if (self.promotionDic1!= nil)
        {
            NSDictionary *dic = self.promotionDic1[@"actVo"];
            if (dic!= nil)
            {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
                [dic1 addEntriesFromDictionary:dic];
                [dic1 setObject:self.promotionDic1[@"imgUrl"] forKey:@"imgUrl"];
                [dic1 setObject:self.promotionDic1[@"subTitle"] forKey:@"subTitle"];
                [dic1 setObject:self.promotionDic1[@"infoId"] forKey:@"infoId"];
                [arr addObject:dic1];
            }
        }
        if (self.promotionDic2!= nil)
        {
            NSDictionary *dic = self.promotionDic2[@"actVo"];
            if (dic!= nil)
            {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
                [dic1 addEntriesFromDictionary:dic];
                [dic1 setObject:self.promotionDic2[@"imgUrl"] forKey:@"imgUrl"];
                [dic1 setObject:self.promotionDic2[@"subTitle"] forKey:@"subTitle"];
                [dic1 setObject:self.promotionDic2[@"infoId"] forKey:@"infoId"];
                [arr addObject:dic1];
            }
            
        }
        cell.dataArray = arr;
        cell.clickidblock = ^(NSString *_Nonnull idStr) {
            [self dc_pushPersonWebController:@"/geren/activity_detail.html" params:[NSString stringWithFormat:@"id=%@",idStr]];
        };
        return cell;
    }
    else{
        TRHomeCell5 *cell = [TRHomeCell5 cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        NSDictionary *dic = self.foolArray[indexPath.row];
        cell.bgLab.text = [NSString stringWithFormat:@"%@",dic[@"layerTitle"]];
        NSArray *arr1 = dic[@"layerContent"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        [arr addObjectsFromArray:arr1];
        cell.dataArray = arr;
        cell.foolsId = [NSString stringWithFormat:@"%@",dic[@"layerId"]];
        cell.foolblock = ^(NSString *_Nonnull infoId) {
            GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
            vc.goodsId = [NSString stringWithFormat:@"%@",infoId];
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.moreblock = ^(NSString *_Nonnull idStr) {
            StoreFoolsGoodsVC *vc = [[StoreFoolsGoodsVC alloc] init];
            vc.catidStr = [NSString stringWithFormat:@"%@",idStr];
            vc.titleStr = [NSString stringWithFormat:@"%@",dic[@"layerTitle"]];
            vc.firmStr = self.firmId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    if (section==0)
    {
        if (self.couponArray.count==0)
        {
             footView.frame = CGRectMake(0, 0, kScreenW, 0.01);
        }
        else{
             footView.frame = CGRectMake(0, 0, kScreenW, 5);
        }
       
    }
   
    else if (section==1)
    {
        if (self.teamDic!= nil||![self.teamDic isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.teamDic[@"groupVo"];
            if (dic==nil||[dic isEqualToDictionary:@{}])
            {
               footView.frame = CGRectMake(0, 0, kScreenW, 0.01);
            }
            else{
               footView.frame = CGRectMake(0, 0, kScreenW, 29);
            }
        }
        else{
            footView.frame = CGRectMake(0, 0, kScreenW, 0.01);
        }
        
    }
    else if (section==2)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        if (self.promotionDic1!= nil&&![self.promotionDic1 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic1[@"actVo"];
            if (dic!= nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
        }
        if (self.promotionDic2!= nil&&![self.promotionDic2 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic2[@"actVo"];
            if (dic!= nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
            
        }
        if (arr.count==0)
        {
            footView.frame = CGRectMake(0, 0, kScreenW, 0.01);
        }
        else{
            footView.frame = CGRectMake(0, 0, kScreenW, 10);
        }
       
    }
    else{
        footView.frame = CGRectMake(0, 0, kScreenW, 0.01);
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        if (self.couponArray.count==0)
        {
            return 0.01;
        }
        else{
             return 105;
        }
        
    }
    
    else if (indexPath.section==1){
        if (self.teamDic!= nil||![self.teamDic isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.teamDic[@"groupVo"];
            if (dic==nil||[dic isEqualToDictionary:@{}])
            {
                return 0.01;
            }
            else{
                return 197;
            }
        }
        else{
            return 0.01;
        }
        
    }
    else if (indexPath.section==2)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        if (self.promotionDic1!= nil&&![self.promotionDic1 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic1[@"actVo"];
            if (dic!= nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
        }
        if (self.promotionDic2!= nil&&![self.promotionDic2 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic2[@"actVo"];
            if (dic!= nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
            
        }
        if (arr.count==0)
        {
            return 0.01;
        }
        else{
            return 131*kScreenW/375+140*arr.count;
        }
        
    }
    else{
        NSDictionary *dic = self.foolArray[indexPath.row];
        NSArray *arr = dic[@"layerContent"];
        NSInteger a = arr.count/2;
        CGFloat b = 135+172*(kScreenW-36)/2/172;
        return a*(b+8)+64*kScreenW/375;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0)
    {
        if (self.couponArray.count==0)
        {
            return 0.01;
        }
        else{
            
        }return 5;
        
    }
    else if (section==1)
    {
        if (self.teamDic!= nil||![self.teamDic isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.teamDic[@"groupVo"];
            if (dic==nil||[dic isEqualToDictionary:@{}])
            {
                return 0.01;
            }
            else{
                return 29;
            }
        }
        else{
            return 0.01;
        }
    }
    else if (section==2)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        if (self.promotionDic1!= nil&&![self.promotionDic1 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic1[@"actVo"];
            if (dic!= nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
        }
        if (self.promotionDic2!= nil&&![self.promotionDic2 isEqualToDictionary:@{}])
        {
            NSDictionary *dic = self.promotionDic2[@"actVo"];
            if (dic!= nil&&![dic isEqualToDictionary:@{}])
            {
                [arr addObject:dic];
            }
            
        }
        if (arr.count==0)
        {
            return 0.01;
        }
        else{
            return 10;
        }
    }
    else{
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1)
    {
        NSDictionary *dict = self.teamDic[@"groupVo"];
        
        if (dict[@"goodsId"] && [dict[@"goodsId"] length] > 0) {
            GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
            vc.goodsId = dict[@"goodsId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.tableView)
    {
        CGFloat a = self.tableView.contentSize.height;
        CGFloat c = a-kScreenH+kStatusBarHeight+170-45-LJ_TabbarSafeBottomMargin;
        NSString *y = [NSString stringWithFormat:@"%f",scrollView.contentOffset.y];
        if (c<=70)
            {
            if ([y floatValue]<0) {
                              y=@"0";
                }
            if ([y floatValue]>c)
            {
                y = [NSString stringWithFormat:@"%f",c];
                          }
               }
        else{
                if ([y floatValue]<0) {
                              y=@"0";
                          }
                if ([y floatValue]>70) {
                              y=@"70";
                    }
               }
              
        [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil userInfo:@{@"move":y}];
        if (c<=70)
        {
                   if ([y floatValue]>=0&&[y floatValue]<=c)
                   {
                      self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-170+[y floatValue]-LJ_TabbarSafeBottomMargin);
                   }
        }
        else{
           if ([y floatValue]>=0&&[y floatValue]<=70)
            {
                self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-170+[y floatValue]-LJ_TabbarSafeBottomMargin);
            }
        }
           }

}

@end
