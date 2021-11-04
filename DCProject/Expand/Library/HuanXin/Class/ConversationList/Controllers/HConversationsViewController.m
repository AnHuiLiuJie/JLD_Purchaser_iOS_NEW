//
//  HConversationsViewController.m
//  CustomerSystem-ios
//
//  Created by afanda on 6/8/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HConversationsViewController.h"
#import "HConversationTableViewCell.h"
#import "HDChatViewController.h"
#import "DCNoDataView.h"

@interface HConversationsViewController ()

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) DCNoDataView *noorderDataView;

@end

@implementation HConversationsViewController
{
    BOOL _isLoading;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    [self refreshData];
    self.title = @"客服消息";
    [self networkStateView];
    
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
}

#pragma mark - getter

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"当前网络连接失败";
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(HConnectionState)connectionState
{
    if (connectionState == HConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
    HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:conversation.conversationId];
    [self.navigationController pushViewController:chat animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 删除会话
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除
        NSArray *datas = self.dataArray;
        HDConversation *conv = [datas objectAtIndex:indexPath.row];
        BOOL delete = [[HDClient sharedClient].chatManager deleteConversation:conv.conversationId deleteMessages:NO];
        if (delete) {
            [self tableViewDidTriggerHeaderRefresh];
        }
    }
}

#pragma mark - refreshData

- (void)refreshData {
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)tableViewDidTriggerHeaderRefresh {
    NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
    long badgeValue = 0;
    for (HDConversation *conv in hConversations) {
        badgeValue += conv.unreadMessagesCount;
    }
    NSString *badge = nil;
    if (badgeValue == 0) {
        badge = nil;
    } else {
        badge = [NSString stringWithFormat:@"%ld",badgeValue];
        if (badgeValue > 99) {
            badge = @"99+";
        }
    }
    self.tabBarItem.badgeValue = badge;
    self.dataArray = [hConversations mutableCopy];
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
    
    if (self.dataArray.count>0)
    {
        self.noorderDataView.hidden = YES;
    }
    else{
        self.noorderDataView.hidden = NO;
    }
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.frame image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"暂无更多数据～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
