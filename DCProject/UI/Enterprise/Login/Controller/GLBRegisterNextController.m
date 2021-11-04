//
//  GLBAddInfoController.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRegisterNextController.h"

#import "GLBAddInfoTFCell.h"
#import "GLBAddInfoTVCell.h"

#import "GLBAddInfoController.h"
#import "GLBSelectAreaController.h"
#import "GLBSelectCompanyController.h"
#import "DCNavigationController.h"
#import "GLBGuideController.h"

#import "GLBRegisterModel.h"

static NSString *const tfCellID = @"GLBAddInfoTFCell";
static NSString *const tvCellID = @"GLBAddInfoTVCell";

@interface GLBRegisterNextController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger areaId;

// 如果已注册的企业，将会有值
@property (nonatomic, strong) GLBRegisterModel *registerModel;
// 企业类型
@property (nonatomic, strong) GLBCompanyTypeModel *typeModel;
// 企业子类型
@property (nonatomic, strong) GLBCompanyTypeModel *subTypeModel;

@end

@implementation GLBRegisterNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"完善资料";
    
    [self.dataArray addObjectsFromArray:@[@[@"",@"",@""],@[@"",@""],@[@""]]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commintBtn];
    [self.view addSubview:self.tipLabel];
    
}


#pragma mark - <UITableViewDataSource && UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : section == 1 ? 2 : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WEAKSELF;
    
    GLBAddInfoTFCell *tfCell = [tableView dequeueReusableCellWithIdentifier:tfCellID forIndexPath:indexPath];
    [tfCell setRegrsterValueWithContents:self.dataArray indexPath:indexPath];
    tfCell.tfClickBlock = ^{
        [weakSelf dc_presentSelectAreaController];
    };
    tfCell.companyBlock = ^(NSString *companyName) {
        [weakSelf requestCompanyIsRegister:companyName];
    };
    cell = tfCell;
//
//    if (indexPath.section == 2) {
//
//        if (indexPath.row == 0) {
//
//            GLBAddInfoTFCell *tfCell = [tableView dequeueReusableCellWithIdentifier:tfCellID forIndexPath:indexPath];
//            [tfCell setRegrsterValueWithContents:self.dataArray indexPath:indexPath];
//            tfCell.tfClickBlock = ^{
//                [weakSelf dc_presentSelectAreaController];
//            };
//            cell = tfCell;
//
//        } else {
//
//            GLBAddInfoTVCell *tvCell = [tableView dequeueReusableCellWithIdentifier:tvCellID forIndexPath:indexPath];
//            cell = tvCell;
//        }
//
//    } else {
//
//
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    DCTextField *userTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textField];
    DCTextField *psdTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField];
    DCTextField *againTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textField];
    DCTextField *companyTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] textField];
    DCTextField *nameTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]] textField];
//    DCTextField *typeTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]] textField];
    DCTextField *areaTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] textField];
//    DCTextView *addressTV = [(GLBAddInfoTVCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]] textView];
    
    if (userTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }
//    if (![DCCheckRegular dc_checkUserName:userTF.text]) {
//        [SVProgressHUD showErrorWithStatus:@"用户名为6-20位数字、字母或下划线组合"];
//        return;
//    }
    
    if (psdTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入登录密码"];
        return;
    }
    if (againTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请确认登录密码"];
        return;
    }
    if (![psdTF.text isEqualToString:againTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入的密码不一致，请确认输入的密码"];
        return;
    }
    if (companyTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入企业名称"];
        return;
    }
    if (nameTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人姓名"];
        return;
    }
//    if (typeTF.text.length == 0) {
//        [SVProgressHUD showInfoWithStatus:@"请选择企业类型"];
//        return;
//    }
    if (areaTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择所在地区"];
        return;
    }
//    if (addressTV.text.length == 0) {
//        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
//        return;
//    }
    
    [self requestCompanyRegiseterWithAddress:@"" firmArea:areaTF.text firmContact:nameTF.text password:psdTF.text firmName:companyTF.text userName:userTF.text];
}


#pragma mark - 选择地区
- (void)dc_presentSelectAreaController
{
    DCTextField *userTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textField];
    DCTextField *psdTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField];
    DCTextField *againTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textField];
    DCTextField *companyTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] textField];
    DCTextField *nameTF = [(GLBAddInfoTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]] textField];
    [userTF resignFirstResponder];
    [psdTF resignFirstResponder];
    [againTF resignFirstResponder];
    [companyTF resignFirstResponder];
    [nameTF resignFirstResponder];
    
    WEAKSELF;
    GLBSelectAreaController *vc = [GLBSelectAreaController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.areaBlock = ^(NSString *areaFullName, NSInteger areaId) {
        weakSelf.areaId = areaId;
        
        DCTextField *areaTF = [(GLBAddInfoTFCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] textField];
        areaTF.text = areaFullName;
    };
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:NO completion:nil];
}


#pragma mark - 选择公司类型
- (void)dc_presentSelectCompanyTypeController
{
    WEAKSELF;
    GLBSelectCompanyController *vc = [GLBSelectCompanyController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.typeBlock = ^(GLBCompanyTypeModel *type, GLBCompanyTypeModel *subType) {
        weakSelf.typeModel = type;
        weakSelf.subTypeModel = subType;
        
        DCTextField *typeTF = [(GLBAddInfoTFCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]] textField];
        typeTF.text = [NSString stringWithFormat:@"%@-%@",weakSelf.typeModel.catName,weakSelf.subTypeModel.catName];
    };
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:NO completion:nil];
}


#pragma mark - 请求 查询企业是否被注册
- (void)requestCompanyIsRegister:(NSString *)firmName
{
    self.registerModel = nil;
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestIsRegisterWithFirmName:firmName success:^(id response) {
        if (response && [response isKindOfClass:[GLBRegisterModel class]]) {
            weakSelf.registerModel = response;
        }
        
        if (weakSelf.registerModel && weakSelf.registerModel.firmArea) {
            weakSelf.areaId = weakSelf.registerModel.firmAreaId;
            
            DCTextField *areaTF = [(GLBAddInfoTFCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] textField];
            areaTF.text = weakSelf.registerModel.firmArea;
            weakSelf.tipLabel.hidden = NO;
            
        } else {
            
            weakSelf.tipLabel.hidden = YES;
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 注册
- (void)requestCompanyRegiseterWithAddress:(NSString *)address firmArea:(NSString *)firmArea firmContact:(NSString *)firmContact password:(NSString *)password firmName:(NSString *)firmName userName:(NSString *)userName
{
    NSInteger cellphone = [_phone integerValue];
    NSInteger tempUserId = [_userId integerValue];
    NSString *firmCat1 = [NSString stringWithFormat:@"%ld",self.typeModel.catId];
    NSString *firmCat2List = [NSString stringWithFormat:@"%ld",self.subTypeModel.catId];
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyRegisterWithApplyType:1 cellphone:cellphone firmAddress:address firmArea:firmArea firmAreaId:_areaId firmCat1:firmCat1 firmCat2List:firmCat2List firmContact:firmContact firmLoginPwd:password firmName:firmName loginName:userName tempUserId:tempUserId success:^(id response) {
        if (response) { // 注册成功
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBGuideController new]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 注册用户登录
                [[NSNotificationCenter defaultCenter] postNotificationName:DC_RegisterLogin_Notification object:weakSelf userInfo:@{@"loginName":userName,@"firmLoginPwd":password}];
            });
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0;
        _tableView.sectionHeaderHeight = 5.0f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        
        [_tableView registerClass:NSClassFromString(tfCellID) forCellReuseIdentifier:tfCellID];
        [_tableView registerClass:NSClassFromString(tvCellID) forCellReuseIdentifier:tvCellID];
    }
    return _tableView;
}

- (UIButton *)commintBtn{
    if (!_commintBtn) {
        _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commintBtn.frame = CGRectMake(15, kScreenH - 44 - 20, kScreenW - 15*2, 44);
        _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [_commintBtn setTitle:@"完成注册" forState:0];
        [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
        _commintBtn.titleLabel.font = PFRFont(16);
        [_commintBtn dc_cornerRadius:22];
        [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commintBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kNavBarHeight + 50*3 + 5*2 + 30, kScreenW - 30, 30)];
        _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#EA504A"];
        _tipLabel.font = PFRFont(10);
        _tipLabel.text = @"*该企业信息已完成注册";
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
