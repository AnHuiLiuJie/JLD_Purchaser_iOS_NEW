//
//  RequestListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "RequestListVC.h"
#import "TRRequestListCell.h"
#import "TRRequestListModel.h"
#import "RequestCommitVC.h"
@interface RequestListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton * rightBtn;
@property(nonatomic,strong) NSMutableArray *requestListArray;
@property(nonatomic,strong) NSMutableArray *selectGoodsList;
@end

@implementation RequestListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"需求清单";
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    self.collectBen.layer.masksToBounds = YES;
    self.collectBen.layer.cornerRadius = 22;
    self.collectBen.layer.borderWidth = 1;
    self.collectBen.layer.borderColor = RGB_COLOR(245, 88, 16).CGColor;
    self.CDBtn.layer.masksToBounds = YES;
    self.CDBtn.layer.cornerRadius = 22;
    self.collectBen.hidden = YES;
    [self.CDBtn setTitle:@"立即提交" forState:UIControlStateNormal];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.selected = NO;
    [self.rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self.rightBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
     [self.rightBtn setTitleColor:RGB_COLOR(0, 216, 191) forState:UIControlStateSelected];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightBar = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem=rightBar;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-62-kNavBarHeight-kTabBarHeight+49) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:0];

    [self.view addSubview:self.tableView];
     [_tableView registerClass:NSClassFromString(@"TRRequestListCell") forCellReuseIdentifier:@"TRRequestListCell"];
    self.requestListArray = [NSMutableArray arrayWithCapacity:0];
    self.selectGoodsList = [NSMutableArray arrayWithCapacity:0];
    [self getdata];
}

- (void)getdata
{
    [[DCAPIManager shareManager]person_getRequirementsLissuccess:^(id response) {
        NSArray *arr = response[@"data"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            TRRequestListModel *model = [[TRRequestListModel alloc]initWithDic:dic];
            //活动添加select
            NSArray *arr1 = model.validActInfoList;
            NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<arr1.count; i++)
            {
                NSDictionary *dic2=arr1[i];
                NSMutableDictionary *mdic2 = [NSMutableDictionary dictionaryWithCapacity:0];
                NSArray *arr2 = dic2[@"actCartGoodsList"];
                NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];
                for (int  j=0; j<arr2.count; j++)
                {
                    NSDictionary *dic3=arr2[j];
                    NSMutableDictionary *mdic1 = [NSMutableDictionary dictionaryWithCapacity:0];
                    [mdic1 addEntriesFromDictionary:dic3];
                    [mdic1 setObject:@"0" forKey:@"select"];
                    [array2 addObject:mdic1];
                }
                [mdic2 addEntriesFromDictionary:dic2];
                [mdic2 setObject:array2 forKey:@"actCartGoodsList"];
                [array1 addObject:mdic2];
            }
            model.validActInfoList=array1;
             //非活动添加select
            NSArray *arr3=model.validNoActGoodsList;
            NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<arr3.count; i++)
            {
                NSDictionary *dic4=arr3[i];
                NSMutableDictionary *mdic3 = [NSMutableDictionary dictionaryWithCapacity:0];
                [mdic3 addEntriesFromDictionary:dic4];
                [mdic3 setObject:@"0" forKey:@"select"];
                [array3 addObject:mdic3];
            }
            model.validNoActGoodsList=array3;
            [self.requestListArray addObject:model];
        }
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)rightClick
{
    self.rightBtn.selected = !self.rightBtn.selected;
    if (self.rightBtn.selected==YES)
    {
        self.collectBen.hidden = NO;
          [self.CDBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    else{
         self.collectBen.hidden = YES;
          [self.CDBtn setTitle:@"立即提交" forState:UIControlStateNormal];
    }
}
- (IBAction)choseClick:(id)sender {
    self.choseBtn.selected = !self.choseBtn.selected;
    if (self.choseBtn.selected==YES)
    {
        for (int i=0; i<self.requestListArray.count; i++)
        {
            TRRequestListModel *model = self.requestListArray[i];
            //活动添加select
            NSArray *arr1 = model.validActInfoList;
            NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<arr1.count; i++)
            {
                NSDictionary *dic2=arr1[i];
                NSMutableDictionary *mdic2 = [NSMutableDictionary dictionaryWithCapacity:0];
                NSArray *arr2 = dic2[@"actCartGoodsList"];
                NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];
                for (int  j=0; j<arr2.count; j++)
                {
                    NSDictionary *dic3=arr2[j];
                    NSMutableDictionary *mdic1 = [NSMutableDictionary dictionaryWithCapacity:0];
                    [mdic1 addEntriesFromDictionary:dic3];
                    [mdic1 setObject:@"1" forKey:@"select"];
                    [array2 addObject:mdic1];
                }
                [mdic2 addEntriesFromDictionary:dic2];
                [mdic2 setObject:array2 forKey:@"actCartGoodsList"];
                [array1 addObject:mdic2];
            }
            model.validActInfoList=array1;
            //非活动添加select
            NSArray *arr3=model.validNoActGoodsList;
            NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<arr3.count; i++)
            {
                NSDictionary *dic4=arr3[i];
                NSMutableDictionary *mdic3 = [NSMutableDictionary dictionaryWithCapacity:0];
                [mdic3 addEntriesFromDictionary:dic4];
                [mdic3 setObject:@"1" forKey:@"select"];
                [array3 addObject:mdic3];
            }
            model.validNoActGoodsList=array3;
            [self.requestListArray replaceObjectAtIndex:i withObject:model];
        }
        [self.tableView reloadData];
    }
    else{
        for (int i=0; i<self.requestListArray.count; i++)
        {
            TRRequestListModel *model = self.requestListArray[i];
            //活动添加select
            NSArray *arr1 = model.validActInfoList;
            NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<arr1.count; i++)
            {
                NSDictionary *dic2=arr1[i];
                NSMutableDictionary *mdic2 = [NSMutableDictionary dictionaryWithCapacity:0];
                NSArray *arr2 = dic2[@"actCartGoodsList"];
                NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];
                for (int  j=0; j<arr2.count; j++)
                {
                    NSDictionary *dic3=arr2[j];
                    NSMutableDictionary *mdic1 = [NSMutableDictionary dictionaryWithCapacity:0];
                    [mdic1 addEntriesFromDictionary:dic3];
                    [mdic1 setObject:@"0" forKey:@"select"];
                    [array2 addObject:mdic1];
                }
                [mdic2 addEntriesFromDictionary:dic2];
                [mdic2 setObject:array2 forKey:@"actCartGoodsList"];
                [array1 addObject:mdic2];
            }
            model.validActInfoList=array1;
            //非活动添加select
            NSArray *arr3=model.validNoActGoodsList;
            NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<arr3.count; i++)
            {
                NSDictionary *dic4=arr3[i];
                NSMutableDictionary *mdic3 = [NSMutableDictionary dictionaryWithCapacity:0];
                [mdic3 addEntriesFromDictionary:dic4];
                [mdic3 setObject:@"0" forKey:@"select"];
                [array3 addObject:mdic3];
            }
            model.validNoActGoodsList=array3;
            [self.requestListArray replaceObjectAtIndex:i withObject:model];
        }
        [self.tableView reloadData];
    }
    [self selectGoods];
}

- (IBAction)collectClick:(id)sender {
    NSString *cartIdStr=@"";
    for (int i=0; i<self.selectGoodsList.count; i++)
    {
        NSDictionary *dic = self.selectGoodsList[i];
        if (i==0)
        {
            cartIdStr = [NSString stringWithFormat:@"%@",dic[@"cartId"]];
        }
        else{
            cartIdStr = [NSString stringWithFormat:@"%@,%@",cartIdStr,dic[@"cartId"]];
        }
    }
    [[DCAPIManager shareManager]person_CollectionGoodswithobjectIds:cartIdStr success:^(id response){
        [SVProgressHUD showSuccessWithStatus:@"添加收藏成功"];
    } failture:^(NSError *error) {
        
    }];
}

- (IBAction)commitOrDeleClick:(id)sender {
    NSString *cartIdStr=@"";
    for (int i=0; i<self.selectGoodsList.count; i++)
    {
        NSDictionary *dic = self.selectGoodsList[i];
        if (i==0)
        {
            cartIdStr = [NSString stringWithFormat:@"%@",dic[@"cartId"]];
        }
        else{
            cartIdStr = [NSString stringWithFormat:@"%@,%@",cartIdStr,dic[@"cartId"]];
        }
    }
    if (self.selectGoodsList.count==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请先选择商品"];
        return;
    }
    if ([self.CDBtn.titleLabel.text isEqualToString:@"删除"])
    {
        [[DCAPIManager shareManager]person_DeleRequestGoodswithcartIds:cartIdStr success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.requestListArray removeAllObjects];
            [self.selectGoodsList removeAllObjects];
            [self getdata];
        } failture:^(NSError *error) {
            
        }];
    }
    else{
        [[DCAPIManager shareManager]person_CommitRequestGoodswithcartIds:cartIdStr success:^(id response) {
            NSDictionary *dic = response[@"data"];
            RequestCommitVC *vc = [[RequestCommitVC alloc] init];
            vc.goodsArray=self.selectGoodsList;
            vc.allPrice = [NSString stringWithFormat:@"%@",dic[@"orderTotalPrice"]];
            [self.navigationController pushViewController:vc animated:YES];
        } failture:^(NSError *error) {
            
        }];
    }
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.requestListArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRRequestListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRRequestListCell" forIndexPath:indexPath];
    cell.listnumblock = ^(TRRequestGoodsModel *_Nonnull model) {
        NSString *section = [NSString stringWithFormat:@"%@",model.section];
        NSString *row = [NSString stringWithFormat:@"%@",model.row];
        TRRequestListModel *lismodel = self.requestListArray[indexPath.section];
        NSArray *arr1 = lismodel.validActInfoList;
        NSArray *arr = lismodel.validNoActGoodsList;
        NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
        if ([section intValue]==arr1.count)
        {
            NSDictionary *dic = arr[[row intValue]];
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic1 addEntriesFromDictionary:dic];
            [dic1 setObject:model.quantity forKey:@"quantity"];
            [arr2 addObjectsFromArray:arr];
            [arr2 replaceObjectAtIndex:[row intValue] withObject:dic1];
            lismodel.validNoActGoodsList=arr2;
        }
        else{
             NSMutableArray *arr4 = [NSMutableArray arrayWithCapacity:0];
            NSDictionary *dic = arr1[[section intValue]];
            NSArray *arr3=dic[@"actCartGoodsList"];
            NSDictionary *dic2=arr3[[row intValue]];
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic1 addEntriesFromDictionary:dic2];
            [dic1 setObject:model.quantity forKey:@"quantity"];
            [arr4 addObjectsFromArray:arr3];
            [arr4 replaceObjectAtIndex:[row intValue] withObject:dic1];
             NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic3 addEntriesFromDictionary:dic];
            [dic3 setObject:arr4 forKey:@"actCartGoodsList"];
            [arr2 addObjectsFromArray:arr1];
            [arr2 replaceObjectAtIndex:[section intValue] withObject:dic3];
            lismodel.validActInfoList=arr2;
        }
        [self.requestListArray replaceObjectAtIndex:indexPath.section withObject:lismodel];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
         [self selectGoods];
    };
    cell.choseblock = ^(NSString *_Nonnull select) {
        TRRequestListModel *listmodel = self.requestListArray[indexPath.section];
        //活动添加select
        NSArray *arr1 = listmodel.validActInfoList;
        NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<arr1.count; i++)
        {
            NSDictionary *dic2=arr1[i];
            NSMutableDictionary *mdic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            NSArray *arr2 = dic2[@"actCartGoodsList"];
            NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];
            for (int  j=0; j<arr2.count; j++)
            {
                NSDictionary *dic3=arr2[j];
                NSMutableDictionary *mdic1 = [NSMutableDictionary dictionaryWithCapacity:0];
                [mdic1 addEntriesFromDictionary:dic3];
                [mdic1 setObject:select forKey:@"select"];
                [array2 addObject:mdic1];
            }
            [mdic2 addEntriesFromDictionary:dic2];
            [mdic2 setObject:array2 forKey:@"actCartGoodsList"];
            [array1 addObject:mdic2];
        }
        listmodel.validActInfoList=array1;
        //非活动添加select
        NSArray *arr3=listmodel.validNoActGoodsList;
        NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<arr3.count; i++)
        {
            NSDictionary *dic4=arr3[i];
            NSMutableDictionary *mdic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [mdic3 addEntriesFromDictionary:dic4];
            [mdic3 setObject:select forKey:@"select"];
            [array3 addObject:mdic3];
        }
        listmodel.validNoActGoodsList=array3;
         [self.requestListArray replaceObjectAtIndex:indexPath.section withObject:listmodel];
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
         [self selectGoods];
    };
    cell.rowblock = ^(TRRequestGoodsModel *_Nonnull model) {
        NSString *section = [NSString stringWithFormat:@"%@",model.section];
        NSString *row = [NSString stringWithFormat:@"%@",model.row];
        TRRequestListModel *lismodel = self.requestListArray[indexPath.section];
        NSArray *arr1 = lismodel.validActInfoList;
        NSArray *arr = lismodel.validNoActGoodsList;
        NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
        if ([section intValue]==arr1.count)
        {
            NSDictionary *dic = arr[[row intValue]];
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic1 addEntriesFromDictionary:dic];
            [dic1 setObject:model.select forKey:@"select"];
            [arr2 addObjectsFromArray:arr];
            [arr2 replaceObjectAtIndex:[row intValue] withObject:dic1];
            lismodel.validNoActGoodsList=arr2;
        }
        else{
            NSMutableArray *arr4 = [NSMutableArray arrayWithCapacity:0];
            NSDictionary *dic = arr1[[section intValue]];
            NSArray *arr3=dic[@"actCartGoodsList"];
            NSDictionary *dic2=arr3[[row intValue]];
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic1 addEntriesFromDictionary:dic2];
            [dic1 setObject:model.select forKey:@"select"];
            [arr4 addObjectsFromArray:arr3];
            [arr4 replaceObjectAtIndex:[row intValue] withObject:dic1];
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic3 addEntriesFromDictionary:dic];
            [dic3 setObject:arr4 forKey:@"actCartGoodsList"];
            [arr2 addObjectsFromArray:arr1];
            [arr2 replaceObjectAtIndex:[section intValue] withObject:dic3];
            lismodel.validActInfoList=arr2;
        }
        [self.requestListArray replaceObjectAtIndex:indexPath.section withObject:lismodel];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
         [self selectGoods];
    };
    TRRequestListModel *model = self.requestListArray[indexPath.section];
    cell.requestListModel=model;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     TRRequestListModel *model = self.requestListArray[indexPath.section];
     NSArray *arr = model.validActInfoList;
     NSArray *arr1 = model.validNoActGoodsList;
    CGFloat height = 0;
    CGFloat count = 0;
    for (int i=0; i<arr.count; i++)
    {
        NSDictionary *dic = arr[i];
        NSArray *arr2 = dic[@"actCartGoodsList"];
        count = count+arr2.count;
    }
    if (arr1.count==0)
    {
        if (arr.count==0)
        {
            height = 57;
        }
        else{
            height = count *186+48*arr.count+57;
        }

    }
    else{
        if (arr.count==0)
        {
            height = arr1.count *186+48+57;
        }
        else{
            height = count *186+48*arr.count+57+arr1.count *186+48;
        }
    }
    return height;
}
//找出所有勾选的方法
- (void)selectGoods
{
    [self.selectGoodsList removeAllObjects];
    BOOL selectAll=YES;
    for (int i=0; i<self.requestListArray.count; i++)
    {
        TRRequestListModel *model = self.requestListArray[i];
        //活动添加select
        NSArray *arr1 = model.validActInfoList;
        for (int i=0; i<arr1.count; i++)
        {
            NSDictionary *dic2=arr1[i];
            NSArray *arr2 = dic2[@"actCartGoodsList"];
            for (int  j=0; j<arr2.count; j++)
            {
                NSDictionary *dic3=arr2[j];
                NSString *select = [NSString stringWithFormat:@"%@",dic3[@"select"]];
                if ([select isEqualToString:@"1"])
                {
                    [self.selectGoodsList addObject:dic3];
                }
                else{
                    selectAll=NO;
                }
            }
        }
        //非活动添加select
        NSArray *arr3=model.validNoActGoodsList;
        for (int i=0; i<arr3.count; i++)
        {
            NSDictionary *dic4=arr3[i];
            NSString *select = [NSString stringWithFormat:@"%@",dic4[@"select"]];
            if ([select isEqualToString:@"1"])
            {
                [self.selectGoodsList addObject:dic4];
            }
            else{
                selectAll=NO;
            }
        }
    }
    if (selectAll==YES)
    {
        self.choseBtn.selected = YES;
    }
    else{
        self.choseBtn.selected = NO;
    }
    NSLog(@">>>>>>>%@",self.selectGoodsList);
}
@end
