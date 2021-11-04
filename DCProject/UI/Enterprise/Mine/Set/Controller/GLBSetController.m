//
//  GLBSetController.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSetController.h"

#import "GLBSetCell.h"

#import "GLBChangePhoneController.h"
#import "GLBChangePassworldController.h"
#import "GLBAddressListController.h"
#import "GLBXiaohuController.h"
#import "DCCacheTool.h"
#import "GLBUpdateModel.h"

static NSString *const listCellID = @"GLBSetCell";

@interface GLBSetController ()

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) DCAlterView *alterView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation GLBSetController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"个人设置";
    self.titles = @[@[@"账号安全",@"修改登录密码",@"修改认证手机",@"注销账号"],@[@"收货地址管理",@"清除缓存",@"接收消息推送",@"免责声明",@"当前版本"]];
    self.images =@[@[@"sz_zhaq",@"",@"",@""],@[@"sz_shdzgl",@"sz_qlhc",@"sz_jsxx",@"sz_mzsm",@"sz_jcgx"]];
    
    [self setUpTableView];
    
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, kScreenH - 110, kScreenW - 60, 20)];
//    label.text = DC_RequestUrl;
//    [self.view addSubview:label];
//
//    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, kScreenH - 80, kScreenW - 60, 40)];
//    _textField.placeholder = @"请输入域名，如：http://192.168.0.104:8085";
//    [_textField dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#333333"] radius:20];
//    [self.view addSubview:_textField];
    

}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBSetCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithTitles:self.titles icons:self.images indexPath:indexPath cellPhone:[NSString stringWithFormat:@"%@",self.userInfo.cellphone]];
    WEAKSELF;
    cell.switchBlock = ^{
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
            [self dc_pushNextController:[GLBChangePassworldController new]];
        }
        
        if (indexPath.row == 2) {
            GLBChangePhoneController *vc = [GLBChangePhoneController new];
            vc.userInfo = self.userInfo;
            [self dc_pushNextController:vc];
        }
        
        if (indexPath.row == 3) {
            GLBXiaohuController *vc = [GLBXiaohuController new];
            [self dc_pushNextController:vc];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [self dc_pushNextController:[GLBAddressListController new]];
        }
        
        if (indexPath.row == 1) {
            
            if (![DC_KeyWindow.subviews containsObject:self.alterView]) {
                [DC_KeyWindow addSubview:self.alterView];
                
                [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(DC_KeyWindow);
                }];
            }
        }
        
        if (indexPath.row == 3) {
            [self dc_pushWebController:@"/public/disclaimer.html" params:nil];
        }
        
        if (indexPath.row == 4) {
            [self dc_requestNewVersion];
        }
    }
}



#pragma mark - 请求 最新版本
- (void)dc_requestNewVersion
{
    [[DCAPIManager shareManager] dc_requestCheckUpdateWithAppBusType:@"1" appType:@"1" versionNo:APP_VERSION success:^(id response) {
        if (response && [response isKindOfClass:[GLBUpdateModel class]]) {
            GLBUpdateModel *updateModel = response;
            if (updateModel.need2Update && [updateModel.need2Update isEqualToString:@"1"]) { // 需要更新
                
                if (updateModel.isForced && [updateModel.isForced isEqualToString:@"1"]) { // 强制更新
                    
                    [[DCUpdateTool shareClient] dc_showMustUpdateTipWithUrl:updateModel.uri];
                    
                } else { // 非强制更新
                    BOOL isNeed = [[DCUpdateTool shareClient] judgeNeedVersionUpdate];
                    if (isNeed) {
                        [[DCUpdateTool shareClient] dc_showUpdateTipWithUrl:updateModel.uri];
                    }
                }
                
            } else {
                [SVProgressHUD showInfoWithStatus:@"已是最新版本"];
            }
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
    self.tableView.rowHeight = 45.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
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

@end
