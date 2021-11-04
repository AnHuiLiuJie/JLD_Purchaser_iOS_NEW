//
//  GLBUserInfoController.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBUserInfoController.h"
#import "GLBUserInfoCell.h"

static NSString *const listCellID = @"GLBUserInfoCell";

@interface GLBUserInfoController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation GLBUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"个人资料";
    self.titles = @[@"姓名",@"座机",@"QQ",@"微信",@"邮箱"];
    self.placeholders = @[@"请填写姓名",@"请填写座机",@"请填写QQ",@"请填写微信",@"请填写邮箱"];
    
    if (self.userInfo) {
        NSString *userName = self.userInfo.userName ? self.userInfo.userName : @"";
        NSString *landline = self.userInfo.landline ? self.userInfo.landline : @"";
        NSString *qq = self.userInfo.qq ? self.userInfo.qq : @"";
        NSString *wechat = self.userInfo.wechat ? self.userInfo.wechat : @"";
        NSString *email = self.userInfo.email ? self.userInfo.email : @"";
        
        [self.contents addObjectsFromArray:@[userName,landline,qq,wechat,email]];
    }
    
    [self setUpTableView];
    [self.view addSubview:self.saveBtn];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithTitles:self.titles placeholders:self.placeholders contents:self.contents indexPath:indexPath];
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
- (void)saveBtnClick:(UIButton *)button
{
    DCTextField *phoneTF = [(GLBUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField];
    DCTextField *QQTF = [(GLBUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] textField];
    DCTextField *weichatTF = [(GLBUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] textField];
    DCTextField *emailTF = [(GLBUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] textField];
    
    
    if (phoneTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写座机"];
        return;
    }
    
    if (QQTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写QQ"];
        return;
    }
    
    if (weichatTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写微信"];
        return;
    }
    
    if (emailTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写邮箱"];
        return;
    }
    
    [self requestSaveInfoWithEmail:emailTF.text landline:phoneTF.text qq:QQTF.text wechat:weichatTF.text];
}



#pragma mark - 请求 保存信息
- (void)requestSaveInfoWithEmail:(NSString *)email landline:(NSString *)landline qq:(NSString *)qq wechat:(NSString *)wechat
{
    NSString *cellphone = @"";
    if (self.userInfo) {
        cellphone = [NSString stringWithFormat:@"%ld",(long)self.userInfo.cellphone];
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSaveUserInfoWithCellphone:cellphone email:email landline:landline qq:qq wechat:wechat     success:^(id response) {
        if (response) {
            
            if (weakSelf.successBlock) {
                weakSelf.successBlock();
            }
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
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
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(10, kScreenH - 44 - 20, kScreenW - 20, 44);
        [_saveBtn dc_cornerRadius:5];
        _saveBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [_saveBtn setTitle:@"保存" forState:0];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:0];
        _saveBtn.titleLabel.font = PFRFont(16);
        [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (NSMutableArray *)contents{
    if (!_contents) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}


@end
