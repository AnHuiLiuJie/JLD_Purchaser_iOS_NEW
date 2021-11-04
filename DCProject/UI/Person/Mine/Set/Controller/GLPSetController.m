//
//  GLPSetController.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPSetController.h"
#import "DCCacheTool.h"
#import "GLPSetCell.h"
#import "ZhuXVC.h"
#import "GLPChangePswController.h"
#import "GLPChangeBindController.h"
#import "GLBAddressListController.h"
#import "PersonWebVC.h"
#import "GLPXiaohuController.h"
#import "GLBProtocolModel.h"
#import "DCAPIManager+PioneerRequest.h"
#import "GLPPaymentManageVC.h"
#import "GLPBankCardManageVC.h"

static NSString *const listCellID = @"GLPSetCell";

@interface GLPSetController ()

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) DCAlterView *alterView;
@property (nonatomic, strong) DCAlterView *logoutView;
@property (nonatomic, strong) UIButton *logoutBtn;
@property (nonatomic, strong) NSMutableArray<GLBProtocolModel *> *protocolArray;

@property (nonatomic, strong)LocalCommonSetModel *setModel;
@end

@implementation GLPSetController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人设置";
    self.titles = @[@[@"账号安全",@"支付管理",@"银行卡管理",@"修改登录密码",@"修改认证手机"],@[@"清除缓存"],@[@"接收消息推送",@"个性化推送"],@[@"服务条款",@"商品验收标准",@"商品退换货政策"],@[@"隐私政策"],@[@"注销账户"]];
    
    [self setUpTableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:self.logoutBtn];
    self.logoutBtn.frame = CGRectMake(0, 25, kScreenW, 54);
    
    self.tableView.tableFooterView = view;
    
    //    [self.view addSubview:self.logoutBtn];
    _setModel = [DCObjectManager dc_getObjectByFileName:DC_LocalCommonSetModel_Key];
    if (_setModel == nil) {
        _setModel = [[LocalCommonSetModel alloc] init];
        _setModel.specific = @"1";
    }
    
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPSetCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    if ([_setModel.specific isEqualToString:@"2"]) {
        [cell setValueWithTitles:self.titles indexPath:indexPath withPhone:self.phone isOn:NO];
    }else
        [cell setValueWithTitles:self.titles indexPath:indexPath withPhone:self.phone isOn:YES];
    
    WEAKSELF;
    cell.switchBlock = ^{
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.switchBlock_two = ^(BOOL isOn) {
        NSString *open = isOn ? @"1" : @"2";
        [weakSelf requestRegisterSpecific:open] ;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self dc_pushNextController:[GLPPaymentManageVC new]];
        }
        
        if (indexPath.row == 2) {
            [self dc_pushNextController:[GLPBankCardManageVC new]];
        }
        
        if (indexPath.row == 3) {
            [self dc_pushNextController:[GLPChangePswController new]];
        }
        
        if (indexPath.row == 4) {
            [self dc_pushNextController:[GLPChangeBindController new]];
        }
    }
    
    if (indexPath.section == 1) {
        if (![DC_KeyWindow.subviews containsObject:self.alterView]) {
            [DC_KeyWindow addSubview:self.alterView];
            
            [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(DC_KeyWindow);
            }];
        }
    }
    if (indexPath.section==3)
    {
        if (indexPath.row==0)
        {
            [[DCAPIManager shareManager]person_HelpCenterwithhelpId:@"87" success:^(id response) {
                NSDictionary *dic = response[@"data"];
                PersonWebVC *vc = [[PersonWebVC alloc] init];
                vc.titleStr=@"服务条款";
                vc.urlContent=dic[@"helpContent"];
                [self.navigationController pushViewController:vc animated:YES];
            } failture:^(NSError *error) {
                
            }];
        }
        else if (indexPath.row==1)
        {
            [[DCAPIManager shareManager]person_HelpCenterwithhelpId:@"90" success:^(id response) {
                NSDictionary *dic = response[@"data"];
                PersonWebVC *vc = [[PersonWebVC alloc] init];
                vc.titleStr=@"商品验收标准";
                vc.urlContent=dic[@"helpContent"];
                [self.navigationController pushViewController:vc animated:YES];
            } failture:^(NSError *error) {
                
            }];
        }
        else{
            [[DCAPIManager shareManager]person_HelpCenterwithhelpId:@"74" success:^(id response) {
                NSDictionary *dic = response[@"data"];
                PersonWebVC *vc = [[PersonWebVC alloc] init];
                vc.titleStr=@"商品退换货政策";
                vc.urlContent=dic[@"helpContent"];
                [self.navigationController pushViewController:vc animated:YES];
            } failture:^(NSError *error) {
                
            }];
        }
        
    }
    
    if (indexPath.section == 4) {
        [self requestRegisterProtocol];
        
    }
    
    if (indexPath.section == 5) {
        //        GLPXiaohuController *vc = [GLPXiaohuController new];
        //        [self.navigationController pushViewController:vc animated:YES];
        ZhuXVC *vc = [[ZhuXVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 请求 获取注册协议
- (void)requestRegisterProtocol
{
    self.protocolArray = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    [[DCAPIManager shareManager] dc_requestRegisterProtocolWithSuccess:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.protocolArray addObjectsFromArray:response];
            
            if (self.protocolArray.count > 0) {
                for (NSInteger i = 0; i<self.protocolArray.count; i++) {
                    GLBProtocolModel *model = self.protocolArray[i];
                    if ([model.name containsString:@"隐私"] && [model.name containsString:@"政策"]) {
                        model.name = @"《金利达隐私政策》";
                        NSString *params = [NSString stringWithFormat:@"api=%@",model.api];
                        [self dc_pushWebController:@"/public/agree.html" params:params];
                    }
                }
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 请求 个性化推送
- (void)requestRegisterSpecific:(NSString *)open
{
    __weak typeof(self) weakSelf = self;
    [[DCAPIManager shareManager] pioneerRequest_b2c_common_specificWithFlag:open Ssuccess:^(id response) {
        NSString *isOn = response;
        if ([isOn isEqualToString:@"1"]) {
            weakSelf.setModel.specific = @"1";
        }else
            weakSelf.setModel.specific = @"2";
        
        [DCObjectManager dc_saveObject:weakSelf.setModel byFileName:DC_LocalCommonSetModel_Key];
        
        [self.tableView reloadData];
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - actiopm
- (void)logoutBtnClick:(UIButton *)button
{
    if (![DC_KeyWindow.subviews containsObject:self.logoutView]) {
        [DC_KeyWindow addSubview:self.logoutView];
        
        [self.logoutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
}

#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    self.tableView.separatorColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _logoutBtn.frame = CGRectMake(0, kNavBarHeight + 55*8 + 5*4 + 25, kScreenW, 54);
        _logoutBtn.frame = CGRectMake(0, 25, kScreenW, 54);
        _logoutBtn.backgroundColor = [UIColor whiteColor];
        [_logoutBtn setTitle:@"退出登录" forState:0];
        [_logoutBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
        _logoutBtn.titleLabel.font = PFRFont(16);
        [_logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _logoutBtn;
}

- (DCAlterView *)alterView{
    if (!_alterView) {
        WEAKSELF;
        _alterView = [[DCAlterView alloc] initWithTitle:@"清理缓存" content:@"确认清理缓存？"];
        [_alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [_alterView addActionWithTitle:@"确认" color:[UIColor dc_colorWithHexString:@"#00B7AB"] type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            
            [SVProgressHUD show];
            [[DCCacheTool shareTool] dc_cleanCache];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                [weakSelf.tableView reloadData];
            });
        }];
    }
    return _alterView;
}


- (DCAlterView *)logoutView{
    if (!_logoutView) {
        _logoutView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"确定要退出登录？"];
        [_logoutView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [_logoutView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            
            [[DCAPIManager shareManager] person_requestLogoutWithSuccess:^(id response) {
                
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                } seq:0];
                [JPUSHService deleteTags:[NSSet setWithObject:@"jld_person"] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    
                } seq:0];
                [[DCLoginTool shareTool] dc_logoutWithPerson];
                
            } failture:^(NSError *_Nullable error) {
            }];
            
        }];
    }
    return _logoutView;
}

@end
