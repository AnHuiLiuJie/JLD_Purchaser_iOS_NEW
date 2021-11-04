//
//  GLPEtpWithdrawController.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "GLPEtpWithdrawController.h"
#import "EtpWithdrawCell.h"
#import "EtpWithdrawTwoCell.h"
//#import "EtpWithdrawFooterView.h"
#import "EtpWithdrawHeaderView.h"
#import "GLPEtpBankCardListController.h"
#import "GLPEtpAddBankCardController.h"
#import "EtpRuleDescriptionView.h"
#import "DCAPIManager+PioneerRequest.h"
#import "GLPEtpWithdrawalsRecordVC.h"
#import "GLPEtpBillDetailViewController.h"

static NSString *const EtpWithdrawCellID = @"EtpWithdrawCell";
static NSString *const EtpWithdrawTwoCellID = @"EtpWithdrawTwoCell";

@interface GLPEtpWithdrawController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *applicationBtn;

/* headerView */
@property (strong , nonatomic)EtpWithdrawHeaderView *headerView;
/* FootView */
//@property (strong , nonatomic)EtpWithdrawFooterView *footerView;

@property (nonatomic, strong) WithDrawAmountModel *dataModel;

@property (strong , nonatomic) NSMutableArray <EtpBankCardListModel *> *dataList;
@property (strong , nonatomic) NSMutableArray <EtpBillListModel *> *billList;

@property (strong , nonatomic) EtpBankCardListModel *selctedModel;

@property (nonatomic, assign) BOOL isNeedLoad;//YES不要请求
@end

@implementation GLPEtpWithdrawController

#pragma mark - 请求 列表 获取可提现金额，个税，实际到账金额
- (void)requestLoadData{
    
    [SVProgressHUD show];

    WEAKSELF;
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_amountWithSuccess:^(id response) {
        NSString *withdrawAmount = response[@"data"];
        //WithDrawAmountModel *dataModel = [WithDrawAmountModel mj_objectWithKeyValues:userDic];
        WithDrawAmountModel *dataModel = [[WithDrawAmountModel alloc] init];
        dataModel.withdrawAmount = withdrawAmount;
        weakSelf.dataModel = dataModel;
        dispatch_group_leave(group);
        //[weakSelf updataViewUI];
    } failture:^(NSError *error) {
        dispatch_group_leave(group);
    }];

    dispatch_group_enter(group);
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_bank_listWithSuccess:^(id response) {
        NSArray *arr = response[@"data"];
        [weakSelf.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:[EtpBankCardListModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_group_leave(group);
    } failture:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_bill_listWithYear:@"" success:^(id  _Nullable response) {
        NSArray *arr = response[@"data"];
        [weakSelf.billList removeAllObjects];
        [weakSelf.billList addObjectsFromArray:[EtpBillListModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_group_leave(group);
    } failture:^(NSError * _Nullable error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (weakSelf.dataList.count == 0) {
            weakSelf.headerView.hidden = YES;
            weakSelf.headerView.frame = CGRectMake(0, 0, kScreenW, 0);
        }else{
            weakSelf.headerView.hidden = NO;
            weakSelf.headerView.frame = CGRectMake(0, 0, kScreenW, 90);
            [weakSelf selectedDefault];
            weakSelf.headerView.model = weakSelf.selctedModel;
        }
        [weakSelf updataViewUI];
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - 请求 提现
- (void)requestLoadData2{
    
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_bank_applyWithCardId:self.selctedModel.cardId Success:^(id response) {
        [[DCAlterTool shareTool] showCancelWithTitle:@"提现成功" message:@"可在提现记录中查看详情" cancelTitle:@"我知道了"];
        //[weakSelf requestLoadData];
        GLPEtpWithdrawalsRecordVC *vc = [GLPEtpWithdrawalsRecordVC new];
        [weakSelf dc_pushNextController:vc];
    } failture:^(NSError *error) {
        
    }];
}

- (void)updataViewUI
{
    if ([self.dataModel.withdrawAmount floatValue]  > 0) {
        self.applicationBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        self.applicationBtn.userInteractionEnabled = YES;
    }else{
        self.applicationBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#cdcdcd"];
        self.applicationBtn.userInteractionEnabled = NO;
    }
    [self.tableView reloadData];
}

//选择默认银行 如果没默认就选第一个
- (void)selectedDefault{
    BOOL ishave = NO;
    for (EtpBankCardListModel *model in self.dataList) {
        if ([model.isDefault isEqual:@"1"]) {
            self.selctedModel = model;
            ishave = YES;
            break;
        }
    }
    
    if (!ishave && self.dataList.count >0) {
        self.selctedModel = self.dataList[0];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_isNeedLoad) {
        [self requestLoadData];
        _isNeedLoad = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
    [self setUpHeaderCenterView];
    [self setUpFooterCenterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"GLPEtpAddBankCardControllerNotification" object:nil];
}

- (void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification userInfo];
    EtpBankCardListModel *model = [dic objectForKey:@"info"];
    self.selctedModel = model;
    self.headerView.model = self.selctedModel;
    [self.tableView reloadData];
    _isNeedLoad = YES;
}

#pragma mark - 初始化头尾
- (void)setUpHeaderCenterView{
    self.tableView.tableHeaderView = self.headerView;
    WEAKSELF;
    
    __block EtpWithdrawHeaderView *waekHeaderView = self.headerView;
    self.headerView.etpWithdrawHeaderViewClickBlock = ^(NSString *title) {
        GLPEtpBankCardListController *vc = [[GLPEtpBankCardListController alloc] init];
        vc.dataList = weakSelf.dataList;
        
        vc.GLPEtpBankCardListController_back_block = ^(EtpBankCardListModel *_Nonnull model) {
            waekHeaderView.model = model;
            weakSelf.selctedModel = model;
            weakSelf.isNeedLoad = YES;;
        };
        [weakSelf dc_pushNextController:vc];
    };
}

#pragma mark - setUpFooterCenterView
- (void)setUpFooterCenterView{
//    self.tableView.tableFooterView = self.footerView;
//    WEAKSELF;
//    self.footerView.etpWithdrawFooterViewClickBlock = ^(NSString *title) {
//
//        if (weakSelf.dataList.count >= 3) {
//            [[DCAlterTool shareTool] showCancelWithTitle:@"当前银行卡数已大于3张" message:@"如有需要请编辑或删除已有的银行卡" cancelTitle:@"我知道了"];
//        }else{
//            GLPEtpAddBankCardController *vc = [[GLPEtpAddBankCardController alloc] init];
//            vc.showType = EtpAddBankCardTypeAdd;
//            [weakSelf dc_pushNextController:vc];
//        }
//    };
}

- (void)setUpViewUI
{
    self.title = @"提现";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;;
    }else
        return self.billList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        EtpWithdrawCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpWithdrawCellID forIndexPath:indexPath];
        cell.model = self.dataModel;
        cell.etpWithdrawCellClickBlock = ^{
            EtpRuleDescriptionView *view = [[EtpRuleDescriptionView alloc] init];
            view.showType = EtpRuleDescriptionViewTypeWithdraw;
            view.titile_str = @"提现规则";
            view.frame = DC_KEYWINDOW.bounds;
            [DC_KEYWINDOW addSubview:view];
        };
        
        WEAKSELF;
        cell.etpWithdrawAddCellClickBlock = ^{
            if (weakSelf.dataList.count >= 3) {
                [[DCAlterTool shareTool] showCancelWithTitle:@"当前银行卡数已大于3张" message:@"如有需要请编辑或删除已有的银行卡" cancelTitle:@"我知道了"];
            }else{
                GLPEtpAddBankCardController *vc = [[GLPEtpAddBankCardController alloc] init];
                vc.showType = EtpAddBankCardTypeAdd;
                [weakSelf dc_pushNextController:vc];
            }
        };
        
//        cell.layer.borderWidth = 1;
//        cell.layer.borderColor = [UIColor redColor].CGColor;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        EtpWithdrawTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpWithdrawTwoCellID forIndexPath:indexPath];
        if (indexPath.row+1 == _billList.count) {
            cell.index_row = YES;
        }else
            cell.index_row = NO;
        
        cell.model = _billList[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 140;
    }else
        return 70;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        EtpBillListModel *model = _billList[indexPath.row];
        GLPEtpBillDetailViewController *vc = [[GLPEtpBillDetailViewController alloc] init];
        vc.billList = _billList;
        vc.billId = model.billId;
        [self dc_pushNextController:vc];
    }
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

//#pragma mark - UIGestureRecognizerDelegate iOS当手势方法和tableview方法冲突时的解决方法
////iOS当手势方法和tableview方法冲突时的解决方法
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-10-self.applicationBtn.dc_height)];
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.layer.borderWidth = 1;
//        _tableView.layer.borderColor = [UIColor redColor].CGColor;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[EtpWithdrawCell class] forCellReuseIdentifier:EtpWithdrawCellID];
        [_tableView registerClass:[EtpWithdrawTwoCell class] forCellReuseIdentifier:EtpWithdrawTwoCellID];

    }
    return _tableView;
}

- (UIButton *)applicationBtn{
    if (!_applicationBtn) {
        _applicationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applicationBtn addTarget:self action:@selector(applicationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_applicationBtn setTitle:@"申请提现" forState:UIControlStateNormal];
        [_applicationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applicationBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        _applicationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _applicationBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
        _applicationBtn.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-10-44, kScreenW-30, 44);
        [DCSpeedy dc_changeControlCircularWith:_applicationBtn AndSetCornerRadius:_applicationBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
        [self.view addSubview:_applicationBtn];
    }
    return _applicationBtn;
}

- (EtpWithdrawHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[EtpWithdrawHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenW, 90);
    }
    return _headerView;
}

//- (EtpWithdrawFooterView *)footerView{
//    if (!_footerView) {
//        _footerView = [[EtpWithdrawFooterView alloc] init];
//        _footerView.frame = CGRectMake(0, 0, kScreenW, 50);
//    }
//    return _footerView;
//}

- (NSMutableArray<EtpBankCardListModel *> *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray<EtpBillListModel *> *)billList{
    if (!_billList) {
        _billList = [[NSMutableArray alloc] init];
    }
    return _billList;
}

- (EtpBankCardListModel *)selctedModel{
    if (!_selctedModel) {
        _selctedModel = [[EtpBankCardListModel alloc] init];
    }
    return _selctedModel;
}


#pragma mark - 申请提现
- (void)applicationBtnAction:(UIButton *)button
{
    if (self.selctedModel == nil || self.selctedModel.cardId.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先添加银行卡账户"];
        return;;
    }
    
    [[DCAlterTool shareTool] showDefaultWithTitle:@"是否确定立即提现?" message:@"" defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
        [self requestLoadData2];
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
