//
//  GLPBankCardManageVC.m
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import "GLPBankCardManageVC.h"

// Controllers
#import "GLPBankCardViewController.h"
#import "GLPPaymentPasswordVC.h"
// Models
// Views
/* cell */
#import "GLPBankCardManageListCell.h"
/* head */
/* foot */
// Vendors
// Categories
#import "DCAPIManager+Payment.h"
// Others

@interface GLPBankCardManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

static NSString *const GLPBankCardManageListCellID = @"GLPBankCardManageListCell";

@implementation GLPBankCardManageVC

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = NO;
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        [_tableView registerClass:NSClassFromString(GLPBankCardManageListCellID) forCellReuseIdentifier:GLPBankCardManageListCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)getlistData{
    
    WEAKSELF;
    [[DCAPIManager shareManager] payment_b2c_account_pay_bankCardListWithSuccess:^(id  _Nullable response) {
        NSArray *list = [GLPBankCardListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        weakSelf.dataArray = [list mutableCopy];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestLoadData{
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"银行卡管理";
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.tableView.tableFooterView = nil;
        [self getlistData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self.dataArray removeAllObjects];
        [self getlistData];
        _isFirstLoad = YES;
    }
    [self dc_navBarLucency:NO];//设置导航栏是否透明
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        GLPBankCardManageListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPBankCardManageListCellID forIndexPath:indexPath];
        if (cell==nil){
            cell = [[GLPBankCardManageListCell alloc] init];
        }
        
        GLPBankCardListModel *model = _dataArray[indexPath.section];
        cell.model = model;
        
        WEAKSELF;
        cell.GLPBankCardManageListCell_block = ^{
            [weakSelf clickeCellButtonAction:model.iD];
        };
        return cell;
    }else{
        UITableViewCell *cell1 = [[UITableViewCell alloc] init];
        return cell1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellH = self.dataArray.count == 0 ? 10.01f : 60.0f;
    return cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerH = self.dataArray.count != 0 ? 0.01f : 30.0f;
    return headerH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 55.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(15, 10, kScreenW, 20);
    titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [view addSubview:titleLab];
    if (self.dataArray.count == 0) {
        titleLab.text = @"您暂未添加银行卡";
    }else
        titleLab.text = @"";
        
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor whiteColor];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10, 5, kScreenW-20, 45);
    [view addSubview:addBtn];
    [DCSpeedy dc_changeControlCircularWith:addBtn AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#999999"] canMasksToBounds:YES];
    [addBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addMoreBankCard) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - private method
- (void)addMoreBankCard
{
    GLPBankCardViewController *vc = [[GLPBankCardViewController alloc] init];
    WEAKSELF;
    vc.GLPBankCardViewController_block = ^{
        weakSelf.isFirstLoad = NO;
    };
    [self dc_pushNextController:vc];
}

- (void)clickeCellButtonAction:(NSString *)idStr
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您是否解除该银行卡绑定"] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WEAKSELF;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"解除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GLPPaymentPasswordVC *vc = [[GLPPaymentPasswordVC alloc] init];
        vc.showType = PasswordFunctionTypeConfirmForVerify;
        vc.GLPPaymentPasswordVC_block = ^(NSString * _Nonnull md5Pwd) {
            [weakSelf requestLoadData:idStr andPwd:md5Pwd];
        };
        [weakSelf dc_pushNextController:vc];
    }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action3];
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (void)requestLoadData:(NSString *)idStr andPwd:(NSString *)pwd{
    WEAKSELF;
    [[DCAPIManager shareManager] paymentRequest_b2c_account_pay_unbindWithIdStr:idStr payPwd:pwd success:^(id  _Nullable response) {
        [weakSelf.view makeToast:@"解除成功" duration:Toast_During position:CSToastPositionBottom];
        [weakSelf.tableView.mj_header beginRefreshing];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
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
