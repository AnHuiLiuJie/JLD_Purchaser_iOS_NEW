//
//  GLPEtpAddBankCardController.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "GLPEtpAddBankCardController.h"
#import "EtpAddBankCardFooterView.h"
#import "GLPEtpWithdrawController.h"
#import "DCAPIManager+PioneerRequest.h"
static NSString *const EtpAddBankCardCellID = @"EtpAddBankCardCell";

@interface GLPEtpAddBankCardController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, copy) NSString *receiveStr;
@property (nonatomic, copy) NSString *payeeStr;
@property (nonatomic, copy) NSString *bankNameStr;
@property (nonatomic, copy) NSString *banchStr;
@property (nonatomic, copy) NSString *isDefault;


/* FootView */
@property (strong , nonatomic)EtpAddBankCardFooterView *footerView;

@end

@implementation GLPEtpAddBankCardController

#pragma mark - 请求 银行卡添加 编辑
- (void)requestLoadData{
    if (self.receiveStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"收款账号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkBankNumber:self.receiveStr]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的收款账号"];
        return;
    }
    
    if (self.payeeStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入收款人姓名"];
        return;
    }
    
    if (self.bankNameStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入银行名称"];
        return;
    }
    
    if (self.banchStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入支行名称"];
        return;
    }
    
    
    WEAKSELF;
    if (self.showType == EtpAddBankCardTypeAdd) {
        [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_bank_addWithBankAccount:self.receiveStr bankAccountName:self.payeeStr bankBranchName:self.banchStr bankName:self.bankNameStr isDefault:self.isDefault success:^(id response) {
            [[DCAlterTool shareTool] showCustomWithTitle:@"银行卡添加成功" message:@"恭喜您已添加" customTitle1:@"返回" handler1:^(UIAlertAction *_Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } customTitle2:@"继续添加" handler2:^(UIAlertAction *_Nonnull action) {
                [weakSelf setUpViewUI];
            }];
        } failture:^(NSError *error) {
            
        }];
    }else{
        
        [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_bank_editWithBankAccount:self.receiveStr bankAccountName:self.payeeStr bankBranchName:self.banchStr bankName:self.bankNameStr cardId:self.model.cardId isDefault:self.isDefault success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"该银行卡编辑成功并使用"];
            [weakSelf jumpIndexVC];
        } failture:^(NSError *error) {
            
        }];
    }
}
#pragma mark - jump到指定vc
- (void)jumpIndexVC
{
    self.model.bankAccount = self.receiveStr;
    self.model.bankAccountName = self.payeeStr;
    self.model.bankName = self.bankNameStr;
    self.model.bankBranchName = self.banchStr;;
    self.model.isDefault = self.isDefault;
    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:self.model forKey:@"info"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLPEtpAddBankCardControllerNotification" object:nil userInfo:dataDic];
    
    NSInteger num = self.navigationController.viewControllers.count;
    if (num > 3) {
        GLPEtpWithdrawController *popVC = self.navigationController.viewControllers[num - 3];
       [self.navigationController popToViewController:popVC animated:YES];
    }
}

#pragma mark - 请求 删除
- (void)requestLoadData2{
    
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_bank_deleteWithCardId:self.model.cardId Success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"银行卡删除成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];

//        [[DCAlterTool shareTool] showDoneWithTitle:@"银行卡删除成功" message:@"" defaultTitle:@"返回" handler:^(UIAlertAction *_Nonnull action) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }];
    } failture:^(NSError *error) {
        
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
    
    [self setUpFooterCenterView];
}

- (void)setUpViewUI
{
    if (self.showType == EtpAddBankCardTypeAdd) {
        self.title = @"添加账户";
        self.submitBtn.hidden = YES;
        
        self.receiveStr = @"";
        self.payeeStr = @"";
        self.bankNameStr = @"";
        self.banchStr = @"";
        self.isDefault = @"1";
        [self.tableView reloadData];
    }else{
        self.title = @"修改账户";
        self.submitBtn.hidden = NO;
    }
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
}

#pragma mark - set model
- (void)setModel:(EtpBankCardListModel *)model{
    _model = model;
    self.receiveStr = self.model.bankAccount;
    self.payeeStr = self.model.bankAccountName;
    self.bankNameStr = self.model.bankName;
    self.banchStr = self.model.bankBranchName;
    self.isDefault = self.model.isDefault;
    
    [self.tableView reloadData];
}

#pragma mark - setUpFooterCenterView
- (void)setUpFooterCenterView{
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpAddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpAddBankCardCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showType = self.showType;
    cell.model = self.model;
    WEAKSELF;
    cell.etpAddBankCardCellClick_block = ^(NSInteger tag) {
        if (tag == 3) {//确定
            [weakSelf submitBtnAction:nil];
        }else if(tag == 2){//删除
            [[DCAlterTool shareTool] showDefaultWithTitle:@"是否删除该银行卡?" message:@"" defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
                [weakSelf requestLoadData2];
            }];
        }else if(tag == 1){
            weakSelf.isDefault = @"1";//默认
        }else{
            weakSelf.isDefault = @"2";//不默认
        }
    };
    
    cell.etpApplicationCell_receive_tf_block = ^(NSString *_Nonnull text) {
        //weakSelf.model.bankAccount = text;
        weakSelf.receiveStr = text;
    };
    
    cell.etpApplicationCell_payee_tf_block = ^(NSString *_Nonnull text) {
        //weakSelf.model.bankAccountName = text;
        weakSelf.payeeStr = text;
    };
    
    cell.etpApplicationCell_bankName_tf_block = ^(NSString *_Nonnull text) {
        //weakSelf.model.bankName = text;
        weakSelf.bankNameStr = text;
    };
    
    cell.etpApplicationCell_banch_tf_block = ^(NSString *_Nonnull text) {
        //weakSelf.model.bankBranchName = text;
        weakSelf.banchStr = text;
    };
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 450;
}

#pragma mark - 确定 保存并使用
- (void)submitBtnAction:(UIButton *)button
{
    [self requestLoadData];
}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-10-self.submitBtn.dc_height);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[EtpAddBankCardCell class] forCellReuseIdentifier:EtpAddBankCardCellID];
    }
    return _tableView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _submitBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
        _submitBtn.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-10-44, kScreenW-30, 44);
        [DCSpeedy dc_changeControlCircularWith:_submitBtn AndSetCornerRadius:_submitBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
        [self.view addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (EtpAddBankCardFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[EtpAddBankCardFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, kScreenW, 50);
    }
    return _footerView;
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

/*
#pragma mark - Navigation

// In a storyboard-based submit, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
