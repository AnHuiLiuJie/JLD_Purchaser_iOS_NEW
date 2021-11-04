//
//  DCMineController.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineController.h"

#import "GLBMineHeadView.h"
#import "GLBMineCertificationCell.h"
#import "GLBMineOrderCell.h"
#import "GLBMineToolCell.h"
#import "GLBMineLogoutCell.h"

#import "GLBUserInfoController.h"
#import "GLBCollectListController.h"
#import "GLBCareListController.h"
#import "GLBBrowseListController.h"
#import "GLBOrderPageController.h"
#import "GLBIntentionPageController.h"
#import "GLBSetController.h"
#import "GLBRepayListController.h"
#import "GLBZizhiPageController.h"
#import "GLBMessageListController.h"
#import "GLBAddInfoController.h"

//#import "HDChatViewController.h"//lj_will_change

static NSString *const certificationCellID = @"GLBMineCertificationCell";
static NSString *const orderCellID = @"GLBMineOrderCell";
static NSString *const toolCellID = @"GLBMineToolCell";
static NSString *const logoutCellID = @"GLBMineLogoutCell";

@interface GLBMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLBMineHeadView *headView;
@property (nonatomic, strong) DCAlterView *alterView;
@property (nonatomic, strong) DCAlterView *logoutView;

// 用户模型
@property (nonatomic, strong) GLBUserInfoModel *userInfo;
// 企业信息
@property (nonatomic, strong) NSDictionary *infoDict;
// 数量
@property (nonatomic, strong) NSDictionary *countDict;

@property (nonatomic, assign) NSInteger unReadCount;

@end

@implementation GLBMineController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES];
    
    if ([[DCLoginTool shareTool] dc_isLogin]) {
        
        [self requestShowCount];
        [self requestCompanyInfo];
        [self requestUserInfo];
        
        [self requestNoReadMessageCount];
        
    } else {
        
        self.headView.count = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.left);
        make.top.equalTo(self.tableView.top);
        make.width.equalTo(kScreenW);
//        make.height.equalTo(kScreenW/4 + 80 + kNavBarHeight);
        make.height.equalTo(0.8*kScreenW/4 + 80 + kNavBarHeight + 19);
    }];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        GLBMineCertificationCell *cerCell = [tableView dequeueReusableCellWithIdentifier:certificationCellID forIndexPath:indexPath];
        if (self.infoDict) {
            cerCell.infoDict = self.infoDict;
        }
        cell = cerCell;
        
    } else if (indexPath.section == 1) {
        
        GLBMineOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:orderCellID forIndexPath:indexPath];
        if (self.countDict) {
            orderCell.infoDict = self.countDict;
        }
        orderCell.orderCellBlock = ^(NSInteger tag) {
            [weakSelf orderCellClick:tag];
        };
        cell = orderCell;
        
    } else if (indexPath.section == 2) {
        
        GLBMineToolCell *toolCell = [tableView dequeueReusableCellWithIdentifier:toolCellID forIndexPath:indexPath];
        toolCell.toolCellBlock = ^(NSInteger tag) {
            [weakSelf toolCellClick:tag];
        };
        cell = toolCell;
        
    } else {
        
        GLBMineLogoutCell *logoutCell = [tableView dequeueReusableCellWithIdentifier:logoutCellID forIndexPath:indexPath];
        cell = logoutCell;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self requestCompanyZizhiInfo];
    }
    
    if (indexPath.section == 3) {
        if (![DC_KeyWindow.subviews.lastObject isKindOfClass:[DCAlterView class]]) {
            [DC_KeyWindow addSubview:self.logoutView];
            [self.logoutView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(DC_KeyWindow);
            }];
        }
    }
}


#pragma mark - action
- (void)headViewButtonClick:(NSInteger)tag
{
    WEAKSELF;
    if (tag == 201) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
           [[DCLoginTool shareTool] dc_logoutWithCompany];
           return;
        }
        
        if (![DC_KeyWindow.subviews.lastObject isKindOfClass:[DCAlterView class]]) {
            [DC_KeyWindow addSubview:self.alterView];
            [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(DC_KeyWindow);
            }];
        }
    }
    
    if (tag == 202) {
        [self dc_pushNextController:[GLBMessageListController new]];
    }
    
    if (tag == 203) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushWebController:@"/qiye/sign.html" params:nil];
    }
    
    if (tag == 204) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushNextController:[GLBCollectListController new]];
    }
    
    if (tag == 205) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushNextController:[GLBCareListController new]];
    }
    
    if (tag == 206) { // 积分
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushWebController:@"/qiye/integral.html" params:nil];
    }
    
    if (tag == 207) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushNextController:[GLBBrowseListController new]];
    }
    
    if (tag == 208) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        if (self.userInfo) {
            GLBUserInfoController *vc = [GLBUserInfoController new];
            vc.userInfo = self.userInfo;
            vc.successBlock = ^{
                [weakSelf requestUserInfo];
            };
            [self dc_pushNextController:vc];
        }
    }
    
    
}


- (void)orderCellClick:(NSInteger)tag
{
    if (![[DCLoginTool shareTool] dc_isLogin]) {
        [[DCLoginTool shareTool] dc_pushLoginController];
        return;
    }
    
    if (tag == 306) {
        [self dc_pushWebController:@"/qiye/sale.html" params:nil];
        return;
    }
    if (tag == 301) {
        GLBOrderPageController *pageVC = [GLBOrderPageController new];
        pageVC.index = 0;
        [self dc_pushNextController:pageVC];
        return;
    }
    
    GLBOrderPageController *pageVC = [GLBOrderPageController new];
    pageVC.index = (int)(tag - 300);
    [self dc_pushNextController:pageVC];
}


- (void)toolCellClick:(NSInteger)tag
{
    if (tag == 100) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushWebController:@"/qiye/discounts_ticket.html" params:nil];
    }
    
    if (tag == 101) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushWebController:@"/qiye/my_evaluate.html" params:nil];
    }
    
    if (tag == 102) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushNextController:[GLBIntentionPageController new]];
    }
    
    if (tag == 103) {
        
        [[DCHelpTool shareClient] dc_callMobile:@"400-880-6638"];
        
        //HDChatViewController *chatController = [[HDChatViewController alloc] initWithConversationChatter:@"b2b_129" conversationType:EMConversationTypeChat];
        //chatController.title = @"客服";
        //[self.navigationController pushViewController:chatController animated:YES];
    }
    
    if (tag == 104) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        [self dc_pushWebController:@"/qiye/payment_pay.html" params:nil];
    }
    
    if (tag == 105) {
        [self dc_pushWebController:@"/public/about_us.html" params:nil];
    }
    
    if (tag == 106) {
        [self dc_pushWebController:@"/qiye/help.html" params:nil];
    }
    
    if (tag == 107) {
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginController];
            return;
        }
        GLBSetController *vc = [GLBSetController new];
        vc.userInfo = self.userInfo;
        [self dc_pushNextController:vc];
    }
    
}


#pragma mark - 跳转资质展示页面
- (void)dc_pushZizhiPageController
{
    GLBZizhiPageController *vc = [GLBZizhiPageController new];
    if (self.infoDict) {
        vc.infoDict = self.infoDict;
    }
    [self dc_pushNextController:vc];
}


#pragma mark - 跳转资质提交页面
- (void)dc_pushAddInfoController
{
    GLBAddInfoController *vc = [GLBAddInfoController new];
    vc.hiddedSkipBtn = YES;
    [self dc_pushNextController:vc];
}


#pragma mark - 请求 用户详情
- (void)requestUserInfo
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestUserInfoWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[GLBUserInfoModel class]]) {
            weakSelf.userInfo = response;
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 数量显示
- (void)requestShowCount
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestMineCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            weakSelf.countDict = response;
            weakSelf.headView.countDic = response;
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 请求 企业详情
- (void)requestCompanyInfo
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyInfoWithSuccess:^(id response) {
        if (response) {
            weakSelf.infoDict = response;
            
            weakSelf.headView.infoDict = weakSelf.infoDict;
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 企业资质详情
- (void)requestCompanyZizhiInfo
{
    NSString *auditState = @"";
    if (self.infoDict && _infoDict[@"auditState"]) {
        auditState = _infoDict[@"auditState"];
    }
    
    if (auditState && [auditState isEqualToString:@"2"]) { // 已认证企业
        [self dc_pushZizhiPageController];
        return;
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyQualificateWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[GLBQualificateModel class]]) {
            GLBQualificateModel *model = response;
            if (model.firmCat1.length == 0 && model.firmCat2List.length == 0 && model.qcList.count == 0) { // 未提交资质
                
                [weakSelf dc_pushAddInfoController];
                
            } else { // 已提交资质
                [weakSelf dc_pushZizhiPageController];
            }
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
    
    [[DCAPIManager shareManager] dc_requestCompanyInfoWithSuccess:^(id response) {
        if (response) {
            weakSelf.infoDict = response;
            
            weakSelf.headView.infoDict = weakSelf.infoDict;
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 未读消息数量
- (void)requestNoReadMessageCount
{
    self.unReadCount = 0;
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestNoReadMessageCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = response;
            
            weakSelf.unReadCount = 0;
            
            NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
            long unreadCount = 0;
            for (HDConversation *conv in hConversations) {
                unreadCount += conv.unreadMessagesCount;
            }
            
            weakSelf.unReadCount += unreadCount;

             if (dict && dict[@"sysMsgCount"]) {
                 NSInteger sysMsgCount = [dict[@"sysMsgCount"] integerValue];
                 
                 weakSelf.unReadCount += sysMsgCount;
             }

            if (dict && dict[@"orderMsgCount"]) {
                NSInteger orderMsgCount = [dict[@"orderMsgCount"] integerValue];
                
                weakSelf.unReadCount += orderMsgCount;
            }
        }
        
        weakSelf.headView.count = weakSelf.unReadCount;
    } failture:^(NSError *_Nullable error) {
    }];
}




#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 5.0f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.headView;
        
        [_tableView registerClass:NSClassFromString(certificationCellID) forCellReuseIdentifier:certificationCellID];
        [_tableView registerClass:NSClassFromString(orderCellID) forCellReuseIdentifier:orderCellID];
        [_tableView registerClass:NSClassFromString(toolCellID) forCellReuseIdentifier:toolCellID];
        [_tableView registerClass:NSClassFromString(logoutCellID) forCellReuseIdentifier:logoutCellID];
    }
    return _tableView;
}

- (GLBMineHeadView *)headView{
    if (!_headView) {
        _headView = [[GLBMineHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.8*kScreenW/4 + 80 + kNavBarHeight + 19)];
        WEAKSELF;
        _headView.buttonClickBlock = ^(NSInteger tag) {
            [weakSelf headViewButtonClick:tag];
        };
    }
    return _headView;
}

- (DCAlterView *)alterView{
    if (!_alterView) {
        _alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"切换个人版需要退出当前账号重新登录,是否切换？"];
        [_alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [_alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            
            [[DCAPIManager shareManager] dc_requestLogoutWithSuccess:^(id response) {
                
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                          
                                      } seq:0];
                [JPUSHService deleteTags:[NSSet setWithObject:@"jld_enterprise"] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    
                } seq:0];
                [[DCLoginTool shareTool] dc_logoutWithCompany];
                
            } failture:^(NSError *_Nullable error) {
    }];
            
            
        }];
    }
    return _alterView;
}

- (DCAlterView *)logoutView{
    if (!_logoutView) {
        _logoutView = [[DCAlterView alloc] initWithTitle:@"温馨提示" content:@"确定要退出登录？"];
        [_logoutView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [_logoutView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            
            [[DCAPIManager shareManager] dc_requestLogoutWithSuccess:^(id response) {
                
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                               
                           } seq:0];
                [JPUSHService deleteTags:[NSSet setWithObject:@"jld_enterprise"] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                               
                           } seq:0];
                [[DCLoginTool shareTool] dc_logoutWithCompany];
                
            } failture:^(NSError *_Nullable error) {
    }];
        }];
    }
    return _logoutView;
}


@end
