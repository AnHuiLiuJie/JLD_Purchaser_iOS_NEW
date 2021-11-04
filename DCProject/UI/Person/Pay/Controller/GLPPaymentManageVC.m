//
//  GLPPaymentManageVC.m
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import "GLPPaymentManageVC.h"

// Controllers
#import "GLPPaymentPasswordVC.h"
#import "GLPForgotPaymentPasswordVC.h"
// Models
// Views
/* cell */
#import "GLPPaymentManageListCell.h"
/* head */
/* foot */
// Vendors
// Categories
#import "DCAPIManager+Payment.h"
// Others

@interface GLPPaymentManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

static NSString *const GLPPaymentManageListCellID = @"GLPPaymentManageListCell";

@implementation GLPPaymentManageVC

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        [_tableView registerClass:NSClassFromString(GLPPaymentManageListCellID) forCellReuseIdentifier:GLPPaymentManageListCellID];

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
    [[DCAPIManager shareManager] payment_b2c_account_pay_isSetPayPwdWithSuccess:^(id  _Nullable response) {
        if ([response[@"data"] intValue] == 1) {
            weakSelf.dataArray = [@[@"修改支付密码",@"忘记支付密码"] mutableCopy];
        }else
            weakSelf.dataArray = [@[@"设置支付密码"] mutableCopy];
        [weakSelf.tableView reloadData];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

- (void)requestLoadData{
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付管理";
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    self.tableView.hidden = NO;
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPPaymentManageListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPPaymentManageListCellID forIndexPath:indexPath];
    if (cell==nil){
        cell = [[GLPPaymentManageListCell alloc] init];
    }
    cell.titleStr = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section];
    if ([title isEqualToString:@"设置支付密码"]) {
        GLPPaymentPasswordVC *vc = [[GLPPaymentPasswordVC alloc] init];
        WEAKSELF;
        vc.GLPPaymentPasswordVC_block = ^(NSString * _Nonnull md5Pwd) {
            weakSelf.isFirstLoad = NO;
        };
        vc.showType = PasswordFunctionTypeSite;
        [self dc_pushNextController:vc];
    }else if ([title isEqualToString:@"修改支付密码"]) {
        GLPPaymentPasswordVC *vc = [[GLPPaymentPasswordVC alloc] init];
        vc.showType = PasswordFunctionTypeConfirmForSet;
        [self dc_pushNextController:vc];
    }else if ([title isEqualToString:@"忘记支付密码"]) {
        GLPForgotPaymentPasswordVC *vc = [[GLPForgotPaymentPasswordVC alloc] init];
        [self dc_pushNextController:vc];
    }
}

#pragma mark - private method
- (void)addMoreBankCard
{
    
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
