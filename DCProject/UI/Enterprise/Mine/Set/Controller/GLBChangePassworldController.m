//
//  GLBChangePassworldController.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBChangePassworldController.h"

#import "GLBChangePassworldCell.h"

static NSString *const listCellID = @"GLBChangePassworldCell";

@interface GLBChangePassworldController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *placeholders;

@property (nonatomic, strong) UIButton *commintBtn;

@end

@implementation GLBChangePassworldController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"登录密码修改";
    self.titles = @[@"原密码",@"新密码",@"确认密码"];
    self.placeholders = @[@"请输入原密码",@"请输入新密码",@"请输入新密码"];
    
    [self setUpTableView];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commintBtn.frame = CGRectMake(30, kNavBarHeight + 50*3 +30, kScreenW - 60, 44);
    _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_commintBtn setTitle:@"确认" forState:0];
    [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
    _commintBtn.titleLabel.font = PFRFont(16);
    [_commintBtn dc_cornerRadius:22];
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commintBtn];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBChangePassworldCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithTitles:self.titles placeholders:self.placeholders indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    GLBChangePassworldCell *oldTF = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    GLBChangePassworldCell *newTF = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    GLBChangePassworldCell *againTF = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (oldTF.textFiled.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入原密码"];
        return;
    }
    
    if (newTF.textFiled.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入新密码"];
        return;
    }
    
    if (againTF.textFiled.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入确认密码"];
        return;
    }
    if (![newTF.textFiled.text isEqualToString:againTF.textFiled.text]) {
        [SVProgressHUD showInfoWithStatus:@"确认密码与新密码不一致"];
        return;
    }
    
    [self requestChangePasswordWithOldPhone:oldTF.textFiled.text newPhone:newTF.textFiled.text];
}


#pragma mark - 请求 修改密码
- (void)requestChangePasswordWithOldPhone:(NSString *)oldPhone newPhone:(NSString *)newPhone
{
    [[DCAPIManager shareManager] dc_requestResetPasswordWithNewPwd:newPhone oldPwd:oldPhone success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功，请重新登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[DCAPIManager shareManager] dc_requestLogoutWithSuccess:^(id response) {
                    [[DCLoginTool shareTool] dc_logoutWithCompany];
                } failture:^(NSError *_Nullable error) {
    }];
                
            });
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
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


@end
