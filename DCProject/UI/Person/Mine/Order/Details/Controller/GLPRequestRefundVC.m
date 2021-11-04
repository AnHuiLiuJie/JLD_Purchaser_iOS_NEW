//
//  GLPRequestRefundVC.m
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "GLPRequestRefundVC.h"
#import "RequestRefundListCell.h"
#import "DCAPIManager+PioneerRequest.h"
#import "PersonOrderPageController.h"
@interface GLPRequestRefundVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) BOOL isFirstLoad;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger indexCell;

@end

static CGFloat kBottomView_H = 100;
static NSString *const RequestRefundListCellID = @"RequestRefundListCell";


@implementation GLPRequestRefundVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleLightContent];
    [self dc_navBarBackGroundcolor:[UIColor dc_colorWithHexString:@"#FC4516"]];
    [self dc_navBarTitleWithFont:[UIFont fontWithName:PFRMedium size:17] color:[UIColor whiteColor]];//与对称出现 [UIColor dc_colorWithHexString:@"#333333"]
    if (!_isFirstLoad) {
        [self requestMainDataIsShowHUD:YES];
        _isFirstLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self dc_statusBarStyle:UIStatusBarStyleDefault];
//    [self dc_navBarBackGroundcolor:[UIColor whiteColor]];
//    [self dc_navBarTitleWithFont:[UIFont fontWithName:PFRMedium size:17] color:[UIColor dc_colorWithHexString:@"#333333"]];
}


- (void)requestMainDataIsShowHUD:(BOOL)isHUD
{
    !isHUD ?  : [SVProgressHUD show];
    WEAKSELF;
    NSString *type = @"2";
    if (self.showType == 2) {
        self.title = @"申请退款";
    }else{
        self.title = @"取消订单";
        type = @"1";
    }
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_refundReasonWithType:type success:^(id  _Nullable response) {
        self.dataArray = response;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.indexCell = -1;
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    if (self.showType == 2) {
        self.title = @"申请退款";
    }else{
        self.title = @"取消订单";
    }
    
    self.bottomView.backgroundColor = self.tableView.backgroundColor;
    
    [self changeDefineBtnState];
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestRefundListCell *cell = [tableView dequeueReusableCellWithIdentifier:RequestRefundListCellID forIndexPath:indexPath];
    cell.titleLab.text = self.dataArray[indexPath.section];
    if (self.indexCell == indexPath.section) {
        cell.isSelected = YES;
    }else
        cell.isSelected = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexCell = indexPath.section;
    [self.tableView reloadData];
    [self changeDefineBtnState];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60.0f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return 1.00f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UILabel *title = [[UILabel alloc] init];
        if (self.showType == 2) {
            title.text = @"请选择申请退款原因，帮助我们改进！";
        }else{
            title.text = @"请选择取消订单原因，帮助我们改进！";
        }
        title.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        title.font = [UIFont fontWithName:PFR size:17];
        [view addSubview:title];
        view.frame = CGRectMake(0, 0, kScreenW, 60);
        title.frame = CGRectMake(15, 0, kScreenW-30, 60);
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kBottomView_H-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RequestRefundListCell class]) bundle:nil] forCellReuseIdentifier:RequestRefundListCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), kScreenW, kBottomView_H);
        [self.view addSubview:_bottomView];
        
        _confirmBtn = [[UIButton alloc] init];
        [_bottomView addSubview:_confirmBtn];
        [_confirmBtn dc_layerBorderWith:0 color:[UIColor whiteColor] radius:10];
        _confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.frame = CGRectMake(15,kBottomView_H*0.5/2, _bottomView.dc_width-30, kBottomView_H*0.5);
    }
    return _bottomView;
}

- (void)confirmBtnAction
{
    if (self.showType == 2) {
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否申请退款" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [self requestBuyerReturnApply];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }else{
        [[DCAlterTool shareTool] showCustomWithTitle:@"是否确定取消订单" message:@"" customTitle1:@"确定" handler1:^(UIAlertAction *_Nonnull action) {
            [self requestCancelOrder];
        } customTitle2:@"取消" handler2:^(UIAlertAction *_Nonnull action) {
        }];
    }
}

#pragma mark 申请退款
- (void)requestBuyerReturnApply{
    NSString *reasonText = self.dataArray[self.indexCell];
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_buyerReturnApplyWithOrderNo:self.orderNoStr reasonDesc:@"" reasonText:reasonText success:^(id  _Nullable response) {
        [[DCAlterTool shareTool] showDoneWithTitle:@"申请退款提交成功" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            !weakSelf.GLPRequestRefundVC_Block ? :  weakSelf.GLPRequestRefundVC_Block();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark 取消订单
- (void)requestCancelOrder{
    NSString *reasonDesc = self.dataArray[self.indexCell];
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_order_manage_cancelOrderWithOrderNo:self.orderNoStr closedDesc:reasonDesc modifyTimeParam:self.modifyTimeParamStr success:^(id  _Nullable response) {
        !weakSelf.GLPRequestRefundVC_Block ? :  weakSelf.GLPRequestRefundVC_Block();
        [[DCAlterTool shareTool] showDoneWithTitle:@"取消订单提交成功" message:@"" defaultTitle:@"我知道了" handler:^(UIAlertAction * _Nonnull action) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonOrderPageController class]]) {
                    PersonOrderPageController *vc = (PersonOrderPageController *)controller;
                    !weakSelf.GLPRequestRefundVC_Block ? :  weakSelf.GLPRequestRefundVC_Block();
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)changeDefineBtnState{
    if (self.indexCell >=0 ) {
        self.confirmBtn.userInteractionEnabled = YES;
        self.confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    }else{
        self.confirmBtn.userInteractionEnabled = NO;
        self.confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#b9b9b9"];
    }
}

- (BOOL)isActiveState:(BOOL)isNeedToast{
    return YES;
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
