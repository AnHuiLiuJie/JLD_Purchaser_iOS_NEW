//
//  GLBMessageListController.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMessageListController.h"
#import "GLBMessageListCell.h"
#import "DCLoginController.h"
#import "GLBNotificationMsgController.h"
#import "DCNavigationController.h"

#import "HConversationsViewController.h"

static NSString *const listCellID = @"GLBMessageListCell";

@interface GLBMessageListController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *subTitles;

@property (nonatomic, strong) NSDictionary *countDict;// 未读消息数量


@end

@implementation GLBMessageListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 本地token是否存在
       NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
    if (token.length>0)
    {
         [self requestNoReadMessageCount];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"我的消息";
    
    [self setUpTableView];
    
    [self.dataArray addObjectsFromArray:@[@"客户服务",@"系统消息",@"订单消息"]];
    
    self.subTitles = @[@"点击查看您与客服的沟通记录",@"点击查看系统消息",@"点击查看订单消息"];
    self.images = @[@"kehufuwu",@"xitxiaoxi",@"dindanxiaoxi"];
    
    NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
    if (token.length>0){
      [self reloadTableViewWithDatas:self.dataArray hasNextPage:NO];
    }
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    cell.image = self.images[indexPath.row];
    cell.subTitle = self.subTitles[indexPath.row];
    if (self.countDict) {
        [cell setCountDictValue:self.countDict indexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *token = [DCObjectManager dc_readUserDataForKey:DC_Token_Key];
    if (token.length>0)
    {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[HConversationsViewController new] animated:YES];
            
        } else {
            GLBNotificationMsgController *vc = [GLBNotificationMsgController new];
            vc.type = indexPath.row - 1;
            [self dc_pushNextController:vc];
        }
    }
    else{
        DCLoginController *vc = [DCLoginController new];
        vc.isPresent = YES;
        DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


#pragma mark - 请求 未读消息数量
- (void)requestNoReadMessageCount
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestNoReadMessageCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            weakSelf.countDict = response;
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
        
    }];
}

#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
