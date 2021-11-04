//
//  GLPMessageListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMessageListVC.h"
#import "TRMessageListCell.h"
#import "HConversationsViewController.h"
#import "GLPOrderMessageVC.h"
#import "GLPSystemMessageVC.h"
@interface GLPMessageListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *contentArray;
@property(nonatomic,strong) NSMutableArray *redArray;
@end

@implementation GLPMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"TRMessageListCell" bundle:nil] forCellReuseIdentifier:@"TRMessageListCell"];
    self.contentArray = [NSMutableArray arrayWithCapacity:0];
    self.redArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.contentArray removeAllObjects];
    [self.redArray removeAllObjects];
    [self getmessage];
}

- (void)getmessage
{
    [[DCAPIManager shareManager]person_getmessageFirstsuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        NSString *actContent = [NSString stringWithFormat:@"%@",dic[@"actContent"]];//活动消息
        NSString *orderContent = [NSString stringWithFormat:@"%@",dic[@"orderContent"]];//订单消息
        NSString *sysContent = [NSString stringWithFormat:@"%@",dic[@"sysContent"]];//系统消息
        [self.contentArray addObject:@"点击查看您与客服的沟通记录"];
        if (sysContent.length==0)
        {
            [self.contentArray addObject:@"点击查看系统消息"];
        }
        else{
            [self.contentArray addObject:sysContent];
        }
        if (orderContent.length==0)
        {
            [self.contentArray addObject:@"点击查看订单消息"];
        }
        else{
            [self.contentArray addObject:orderContent];
        }
        if (actContent.length==0)
        {
            [self.contentArray addObject:@"点击查看最新优惠"];
        }
        else{
            [self.contentArray addObject:actContent];
        }
        NSString *actHasRead = [NSString stringWithFormat:@"%@",dic[@"actHasRead"]];//活动消息数
        NSString *orderHasRead = [NSString stringWithFormat:@"%@",dic[@"orderHasRead"]];//订单消息数
        NSString *sysHasRead = [NSString stringWithFormat:@"%@",dic[@"sysHasRead"]];//系统消息数
        
        NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
        long unreadCount = 0;
        for (HDConversation *conv in hConversations) {
            unreadCount += conv.unreadMessagesCount;
        }
        
        [self.redArray addObject:[NSString stringWithFormat:@"%ld",unreadCount]];
        [self.redArray addObject:sysHasRead];
        [self.redArray addObject:orderHasRead];
        [self.redArray addObject:actHasRead];
        [self.tableview reloadData];
    } failture:^(NSError *error) {
        NSArray *contentArr=@[@"点击查看您与客服的沟通记录",@"点击查看系统消息",@"点击查看订单消息",@"点击查看最新优惠"];
        [self.contentArray addObjectsFromArray:contentArr];
        [self.tableview reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRMessageListCell"];
    if (cell== nil)
    {
        cell = [[TRMessageListCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titleArr=@[@"客户服务",@"系统消息",@"订单消息",@"最新优惠"];
    NSArray *imageArr=@[@"kehufuwu",@"xitxiaoxi",@"dindanxiaoxi",@"zuixinyouhui"];
    cell.topLab.text=titleArr[indexPath.section];
    cell.bottomLab.text=self.contentArray[indexPath.section];
    cell.ImageV.image = [UIImage imageNamed:imageArr[indexPath.section]];
    cell.redLab.layer.masksToBounds = YES;
    cell.redLab.layer.cornerRadius = 5;
    NSString *num=self.redArray[indexPath.section];
    if ([num intValue]>0)
    {
        cell.redLab.hidden = NO;
    }
    else{
        cell.redLab.hidden = YES;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
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
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[HConversationsViewController new] animated:YES];
    }
    if (indexPath.section == 1) {//@"9"
        GLPSystemMessageVC *vc = [[GLPSystemMessageVC alloc] init];
        [self dc_pushNextController:vc];
        //[self dc_pushPersonWebController:@"/geren/system_news.html" params:nil];
    }
    else if (indexPath.section==2)
    {
        GLPOrderMessageVC *vc = [[GLPOrderMessageVC alloc] init];
        vc.msgType = @"1";
        [self dc_pushNextController:vc];
    }
    else if (indexPath.section==3)
    {
        GLPOrderMessageVC *vc = [[GLPOrderMessageVC alloc] init];
        vc.msgType = @"3";
        [self dc_pushNextController:vc];
        //[self dc_pushPersonWebController:@"/geren/sale_news.html" params:nil];
    }
}
@end
