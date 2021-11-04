//
//  GLBAddressEditController.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddressEditController.h"

#import "GLBAddressTFCell.h"
#import "GLBAddressTVCell.h"
#import "GLBAddressSwitchCell.h"

#import "GLBSelectAreaController.h"

static NSString *const tfCellID = @"GLBAddressTFCell";
static NSString *const tvCellID = @"GLBAddressTVCell";
static NSString *const switchCellID = @"GLBAddressSwitchCell";

@interface GLBAddressEditController ()

@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) DCAlterView *alterView;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *placeholders;

@property (nonatomic, assign) NSInteger areaId;

@end

@implementation GLBAddressEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titles = @[@[@"联系人",@"手机号码",@"所在地区",@"详细地址"],@[@"设置为默认"]];
    self.placeholders = @[@[@"请输入联系人姓名",@"请输入手机号码",@"选择所在地区",@"填写详细地址"],@[@""]];
    
    [self setUpTableView];
    
    if (self.addressModel) {
        self.navigationItem.title = @"编辑地址";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_rightItemWithTitle:@"保存" target:self action:@selector(saveItemAction:)];
        self.tableView.tableFooterView = self.deleteView;
        
        DCTextField *userTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textFiled];
        DCTextField *phoneTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textFiled];
        DCTextField *areaTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textFiled];
        DCTextView *addressTV = [(GLBAddressTVCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] textView];
        UISwitch *defaultSwitch = [(GLBAddressSwitchCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] defaultSwitch];
        
        userTF.text = self.addressModel.recevier;
        phoneTF.text = self.addressModel.cellphone;
        areaTF.text = self.addressModel.areaName;
        addressTV.content = self.addressModel.streetInfo;
        self.areaId = [self.addressModel.areaId integerValue];
        [defaultSwitch setOn:(self.addressModel.isDefault == 1 ? YES : NO)];
        
    } else {
        
        self.navigationItem.title = @"新建地址";
        [self.view addSubview:self.commintBtn];
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
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 3) {
            
            GLBAddressTVCell *tvCell = [tableView dequeueReusableCellWithIdentifier:tvCellID forIndexPath:indexPath];
            cell = tvCell;
            
        } else {
            
            GLBAddressTFCell *tfCell = [tableView dequeueReusableCellWithIdentifier:tfCellID forIndexPath:indexPath];
            [tfCell setValueWithTitles:self.titles placeholders:self.placeholders indexPath:indexPath];
            cell = tfCell;
        }
        
    } else if (indexPath.section == 1) {
        
        GLBAddressSwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:switchCellID forIndexPath:indexPath];
        cell = switchCell;
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self dc_presentSelectAreaController];
    }
}


#pragma mark - 选择地区
- (void)dc_presentSelectAreaController
{
    DCTextField *userTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textFiled];
    DCTextField *phoneTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textFiled];
    DCTextField *areaTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textFiled];
    DCTextView *addressTV = [(GLBAddressTVCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] textView];
    
    [userTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [areaTF resignFirstResponder];
    [addressTV resignFirstResponder];
    
    WEAKSELF;
    GLBSelectAreaController *vc = [GLBSelectAreaController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.areaBlock = ^(NSString *areaFullName, NSInteger areaId) {
        weakSelf.areaId = areaId;
        DCTextField *areaTF = [(GLBAddressTFCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textFiled];
        areaTF.text = areaFullName;
    };
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:NO completion:nil];
}



#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    DCTextField *userTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textFiled];
    DCTextField *phoneTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textFiled];
    DCTextField *areaTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textFiled];
    DCTextView *addressTV = [(GLBAddressTVCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] textView];
    
    if (userTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人姓名"];
        return;
    }
    
    if (phoneTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (areaTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择所在地区"];
        return;
    }
    
    if (addressTV.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写详细地址"];
        return;
    }
    
    [self requestAddAddressWithUser:userTF.text phone:phoneTF.text address:addressTV.text];
}

- (void)saveItemAction:(id)sender
{
    DCTextField *userTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textFiled];
    DCTextField *phoneTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textFiled];
    DCTextField *areaTF = [(GLBAddressTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textFiled];
    DCTextView *addressTV = [(GLBAddressTVCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] textView];
    
    if (userTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人姓名"];
        return;
    }
    
    if (phoneTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (areaTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择所在地区"];
        return;
    }
    
    if (addressTV.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写详细地址"];
        return;
    }
    
    [self requestEditAddressWithUser:userTF.text phone:phoneTF.text address:addressTV.text];
}

- (void)deleteBtnClick:(UIButton *)button
{
    if (![DC_KeyWindow.subviews.lastObject isKindOfClass:[DCAlterView class]]) {
        [DC_KeyWindow addSubview:self.alterView];
        [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
}


#pragma mark - 请求 添加地址
- (void)requestAddAddressWithUser:(NSString *)user phone:(NSString *)phone address:(NSString *)address
{
    UISwitch *defaultSwitch = [(GLBAddressSwitchCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] defaultSwitch];
    NSInteger isDefault = defaultSwitch.isOn ? 1 : 0;
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAddAddressWithAreaId:self.areaId recevier:user cellphone:phone isDefault:isDefault streetInfo:address success:^(id response) {
        
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 编辑地址
- (void)requestEditAddressWithUser:(NSString *)user phone:(NSString *)phone address:(NSString *)address
{
    UISwitch *defaultSwitch = [(GLBAddressSwitchCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] defaultSwitch];
    NSInteger isDefault = defaultSwitch.isOn ? 1 : 0;
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestEditAddressWithAddrId:self.addressModel.addrId areaId:self.areaId recevier:user cellphone:phone isDefault:isDefault streetInfo:address success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 删除地址
- (void)requestDeleteAddress
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDeleteAddressWithAddrId:self.addressModel.addrId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - 45 - 20);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(tfCellID) forCellReuseIdentifier:tfCellID];
    [self.tableView registerClass:NSClassFromString(tvCellID) forCellReuseIdentifier:tvCellID];
    [self.tableView registerClass:NSClassFromString(switchCellID) forCellReuseIdentifier:switchCellID];
}


#pragma mark - lazy load
- (UIButton *)commintBtn{
    if (!_commintBtn) {
        _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commintBtn.frame = CGRectMake(10, kScreenH - 10 - 45, kScreenW - 20, 45);
        _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [_commintBtn setTitle:@"确认添加" forState:0];
        [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
        _commintBtn.titleLabel.font = PFRFont(16);
        [_commintBtn dc_cornerRadius:2];
        [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commintBtn;
}

- (UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        _deleteView.backgroundColor = [UIColor clearColor];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(0, 10, kScreenW, 40);
        deleteBtn.backgroundColor = [UIColor whiteColor];
        [deleteBtn setTitle:@"删除" forState:0];
        [deleteBtn setTitleColor:[UIColor dc_colorWithHexString:@"#EA5514"] forState:0];
        deleteBtn.titleLabel.font = PFRFont(14);
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteView addSubview:deleteBtn];
    }
    return _deleteView;
}


- (DCAlterView *)alterView{
    if (!_alterView) {
        WEAKSELF;
        _alterView = [[DCAlterView alloc] initWithTitle:@"温馨提示" content:@"确定要删除地址？"];
        [_alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [_alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            [weakSelf requestDeleteAddress];
        }];
    }
    return _alterView;
}

@end
