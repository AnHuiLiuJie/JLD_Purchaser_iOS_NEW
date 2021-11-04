//
//  GLPToPayViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//
//self.code4View = [[HWTFCursorView alloc] initWithCount:6 margin:20];
//self.code4View.frame = CGRectMake(0, 0, SCREEN_WIDTH-40, 60);
//self.code4View.backgroundColor = [UIColor whiteColor];
//[self.bgView addSubview:self.code4View];

#import "GLPToPayViewController.h"
// Controllers
#import "GLPGoodsDetailsController.h"
#import "GLPBankCardViewController.h"
#import "GLPPaymentPasswordVC.h"
#import "PersonOrderPageController.h"
// Models
// Views
/* cell */
#import "GLPToPayListCell.h"
/* head */
#import "GLPToPayHeadView.h"
/* foot */
// Vendors
// Categories
#import "DCAPIManager+Payment.h"
#import "UIViewController+BackButtonHandler.h"

// Others
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "DCPayTool.h"

@interface GLPToPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) GLPToPayHeadView *headerView;
@property (nonatomic, assign) NSInteger isSetPayPwd;// 1表示已经设置过密码了
@property (nonatomic, strong) GLPOrderForPayModel *payInfoModel;
@property (nonatomic, copy) NSString *toPayType;//1支付宝 2微信 0添加银行卡 其他事已添加的银行卡
@property (nonatomic, copy) NSString *idStr;

@end

static NSString *const GLPToPayListCellID = @"GLPToPayListCell";

@implementation GLPToPayViewController

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-10-self.submitBtn.dc_height);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = NO;
//        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        [_tableView registerClass:NSClassFromString(GLPToPayListCellID) forCellReuseIdentifier:GLPToPayListCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _submitBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
        _submitBtn.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-10-44, kScreenW-30, 44);
        [DCSpeedy dc_changeControlCircularWith:_submitBtn AndSetCornerRadius:_submitBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
        [self.view addSubview:_submitBtn];
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#42E5A6"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#00B7AB"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0,0);
        gradientLayer2.endPoint = CGPointMake(1,0);
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = _submitBtn.bounds;
        [_submitBtn.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [_submitBtn dc_cornerRadius:_submitBtn.dc_height/2];
    }
    return _submitBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)listArray{
    if (!_listArray){
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (GLPToPayHeadView *)headerView{
    if (!_headerView) {
        _headerView = [GLPToPayHeadView dc_viewFromXib];
        _headerView.frame = CGRectMake(0, 0, kScreenW, 180);
    }
    return _headerView;
}

- (void)getlistData{
    WEAKSELF;
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [[DCAPIManager shareManager] paymentRequest_b2c_order_manage_orderForPayWithOrderNo:self.orderNoStr success:^(id  _Nullable response) {
        GLPOrderForPayModel *model = [GLPOrderForPayModel mj_objectWithKeyValues:response[@"data"]];
        weakSelf.payInfoModel = model;
        dispatch_group_leave(group);
    } failture:^(NSError * _Nullable error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[DCAPIManager shareManager] paymentRequest_b2c_trade_pay_paymodeWithFirmId:self.firmIdStr success:^(id  _Nullable response) {
        NSArray *list = response[@"data"];
        if (list.count > 0) {
            [weakSelf.listArray removeAllObjects];
        }else{
            weakSelf.submitBtn.hidden = YES;
            UILabel *pro = [[UILabel alloc] init];
            pro.textAlignment = NSTextAlignmentCenter;
            pro.font = [UIFont fontWithName:PFR size:15];
            pro.textColor = [UIColor dc_colorWithHexString:@"#666666"];
            pro.text = @"该商家未提供收款方式";
            pro.frame = CGRectMake(30, kScreenH/2, kScreenW-60, 60);
//            pro.dc_centerX = weakSelf.view.dc_centerX;
//            pro.dc_centerY = weakSelf.view.dc_centerY;
            [weakSelf.view addSubview:pro];
        }
        for (NSString *name in list) {
            if ([name isEqualToString:@"03"]) {
                GLPBankCardListModel *model = [[GLPBankCardListModel alloc] init];
                model.titleName = @"支付宝支付";
                [weakSelf.listArray addObject:model];
            }else if([name isEqualToString:@"04"]){
                GLPBankCardListModel *model = [[GLPBankCardListModel alloc] init];
                model.titleName = @"微信支付";
                [weakSelf.listArray addObject:model];
            }else if([name isEqualToString:@"05"]){
                dispatch_group_enter(group);
                [weakSelf requestBankList:^{
                    dispatch_group_leave(group);
                }];
            }
        }
        dispatch_group_leave(group);
    } failture:^(NSError * _Nullable error) {
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        weakSelf.toPayType = [[weakSelf.listArray firstObject] titleName];//默认第一个

        weakSelf.headerView.model = weakSelf.payInfoModel;
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - 请求 银行卡列表
- (void)requestBankList:(dispatch_block_t)block
{
    WEAKSELF;
    [[DCAPIManager shareManager] payment_b2c_account_pay_bankCardListWithSuccess:^(id  _Nullable response) {
        NSArray *list = [GLPBankCardListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        if (list.count > 0) {
            [weakSelf.dataArray removeAllObjects];
        }
        weakSelf.dataArray = [list mutableCopy] ;
        if (list.count != 0) {
            weakSelf.isSetPayPwd = 1;
            [weakSelf.listArray addObjectsFromArray:list];
        }
        GLPBankCardListModel *model = [[GLPBankCardListModel alloc] init];
        model.titleName = @"绑定银行卡";
        [weakSelf.listArray addObject:model];
        block();
    } failture:^(NSError * _Nullable error) {
        block();
    }];
}

- (void)verifyIsSetPayPwd{
    WEAKSELF;
    [[DCAPIManager shareManager] payment_b2c_account_pay_isSetPayPwdWithSuccess:^(id  _Nullable response) {
        if ([response[@"data"] intValue] == 1) {
            weakSelf.isSetPayPwd = 1;
        }else
            weakSelf.isSetPayPwd = 2;
        [weakSelf addMoreBankCard];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - 确定 保存并使用
- (void)submitBtnAction:(UIButton *)button
{
    if ([_toPayType isEqualToString:@"支付宝支付"]) {
        [[DCAPIManager shareManager] paymentRequest_b2c_trade_pay_alipayWithOrderNo:self.orderNoStr success:^(id  _Nullable response) {
            [[AlipaySDK defaultService] payOrder:response[@"msg"] fromScheme:DCAlipay_AppScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"resultDic-->%@",resultDic);
            }];
        } failture:^(NSError * _Nullable error) {
            
        }];
    }else if([_toPayType isEqualToString:@"微信支付"]){//微信

        [[DCAPIManager shareManager] paymentRequest_b2c_trade_pay_apppayWithOrderNo:self.orderNoStr success:^(id  _Nullable response) {
            NSDictionary *tempDic = [self dictionaryWithJsonString:response[@"data"]];
            [[DCPayTool shareTool] dc_wxpay:tempDic];
        } failture:^(NSError * _Nullable error) {
            
        }];
    }else{
        WEAKSELF;
        GLPPaymentPasswordVC *vc = [[GLPPaymentPasswordVC alloc] init];
        vc.showType = PasswordFunctionTypeConfirmForVerify;
        vc.GLPPaymentPasswordVC_block = ^(NSString * _Nonnull md5Pwd) {
            [weakSelf requestLoadData:md5Pwd];
        };
        [self dc_pushNextController:vc];
    }
}

- (void)requestLoadData:(NSString *)pwd{
    //WEAKSELF;
    [[DCAPIManager shareManager] paymentRequest_b2c_trade_pay_quickpayWithOrderNo:self.orderNoStr idStr:self.idStr payPwd:pwd success:^(id  _Nullable response) {
        [[DCAlterTool shareTool] showDoneWithTitle:@"支付成功" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            //[weakSelf.view makeToast:@"支付成功" duration:Toast_During position:CSToastPositionCenter];
            PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
            vc.index = 2;
            UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付方式";
    self.isSetPayPwd = 0;//默认还没有请求是否设置支付密码
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.tableView.tableHeaderView = self.headerView;
    
    // 注册通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResult:) name:DC_AlipayResulkt_NotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayResult:) name:DC_WxPayResulkt_NotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self getlistData];
        _isFirstLoad = YES;
    }
    [self dc_navBarLucency:NO];//设置导航栏是否透明
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPToPayListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPToPayListCellID forIndexPath:indexPath];
    if (cell==nil){
        cell = [[GLPToPayListCell alloc] init];
    }
    
    GLPBankCardListModel *model = self.listArray[indexPath.section];
    cell.model = model;

    WEAKSELF;
    cell.GLPToPayListCell_block = ^(GLPBankCardListModel * _Nonnull model) {
        if ([model.titleName isEqualToString:@"支付宝支付"]) {
            weakSelf.toPayType = model.titleName;
        }else if ([model.titleName isEqualToString:@"微信支付"]) {
            weakSelf.toPayType = model.titleName;
        }else if ([model.titleName isEqualToString:@"绑定银行卡"]) {
            weakSelf.toPayType = model.titleName;
            //添加银行卡
            if (weakSelf.dataArray.count > 5) {
                [weakSelf.view makeToast:@"最多添加五张银行卡" duration:Toast_During position:CSToastPositionBottom];
            }else
                [weakSelf addMoreBankCard];
        }else{
            weakSelf.toPayType = model.accNo;
            weakSelf.idStr = model.iD;
        }
        [weakSelf.tableView reloadData];
    };
    
    if (![self.toPayType isEqualToString:@"绑定银行卡"]) {
        if ([self.toPayType isEqualToString:model.titleName] || [self.toPayType isEqualToString:model.accNo]) {
            cell.selectedBtn.selected = YES;
        }else
            cell.selectedBtn.selected = NO;
    }

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
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPBankCardListModel *model = self.listArray[indexPath.section];
    if ([model.titleName isEqualToString:@"支付宝支付"]) {
        self.toPayType = model.titleName;
    }else if ([model.titleName isEqualToString:@"微信支付"]) {
        self.toPayType = model.titleName;
    }else if ([model.titleName isEqualToString:@"绑定银行卡"]) {
        self.toPayType = model.titleName;
        //添加银行卡
        if (self.dataArray.count > 5) {
            [self.view makeToast:@"最多添加五张银行卡" duration:Toast_During position:CSToastPositionBottom];
        }else
            [self addMoreBankCard];
    }else{
        self.toPayType = model.accNo;
        self.idStr = model.iD;
    }
    [self.tableView reloadData];
}

- (void)addMoreBankCard{
    if (self.isSetPayPwd == 0) {
        [self verifyIsSetPayPwd];
    }else if (self.isSetPayPwd == 1) {
        WEAKSELF;
        GLPBankCardViewController *vc = [[GLPBankCardViewController alloc] init];
        vc.GLPBankCardViewController_block = ^{
            weakSelf.isFirstLoad = NO;
        };
        [self dc_pushNextController:vc];
    }else{
        WEAKSELF;
        GLPPaymentPasswordVC *vc = [[GLPPaymentPasswordVC alloc] init];
        vc.GLPPaymentPasswordVC_block = ^(NSString * _Nonnull md5Pwd) {
            weakSelf.isSetPayPwd = 1;
            [weakSelf addMoreBankCard];
        };

        vc.showType = PasswordFunctionTypeSite;
        [self dc_pushNextController:vc];
    }
}


#pragma mark - 监听到支付宝支付通知
- (void)alipayResult:(NSNotification *)notification
{
    [SVProgressHUD dismiss];
    NSDictionary *resultDic = notification.userInfo;
    if ([resultDic[@"resultStatus"] integerValue] == 9000) {
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"支付成功" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
            //[weakSelf.view makeToast:@"支付成功" duration:Toast_During position:CSToastPositionCenter];
            PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
            vc.index = 2;
            UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }];
        
    }
    else if([resultDic[@"resultStatus"] integerValue] == 4000){
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"支付失败" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
            //[weakSelf.view makeToast:@"支付失败" duration:Toast_During position:CSToastPositionCenter];
        }];
    }else if([resultDic[@"resultStatus"] integerValue] == 6001){
        
        [[DCAlterTool shareTool] showDoneWithTitle:@"取消支付" message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
            //[weakSelf.view makeToast:@"取消支付" duration:Toast_During position:CSToastPositionCenter];
        }];
    }
    else{
        [[DCAlterTool shareTool] showDoneWithTitle:resultDic[@"memo"] message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            
        }];
    }
}


#pragma mark - 获取微信支付结果通知
- (void)wxpayResult:(NSNotification *)notification{
    NSDictionary *resultDic = notification.userInfo;
    NSString *title = nil;
    if ([resultDic[@"errCode"] integerValue] == 0) {
        title = @"支付成功";
    }else if ([resultDic[@"errCode"] integerValue] == -2) {
        title = @"取消支付";
    }else {
        title = @"支付失败";
    }
    //WEAKSELF;
    [[DCAlterTool shareTool] showDoneWithTitle:title message:nil defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
        // 支付成功
        if ([title isEqualToString:@"支付成功"]) {
            NSLog(@"微信支付成功");
            NSDictionary *dict = @{@"type":@"微信支付成功"};//UM统计 自定义搜索关键词事件
            [MobClick event:UMEventCollection_33 attributes:dict];
            //返回到订单列表
            PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
            vc.index = 2;
            UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_AlipayResulkt_NotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DC_WxPayResulkt_NotificationName object:nil];
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}


//json 字符串转 字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - 跳转到我的订单
//方法二：在- (void)viewWillDisappear:(BOOL)animated中调用
- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound && _isNeedBackOrder) {
        PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
        vc.index = 1;
        [self.navigationController pushViewController:vc animated:YES];
        
//        if (_isNeedBackOrder) {
//            PersonOrderPageController *vc = [[PersonOrderPageController alloc] initWithIsRefund:NO];
//            vc.index = 1;
//            [self.navigationController pushViewController:vc animated:YES];
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }else{
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        }
//
//        self.navigationController.interactivePopGestureRecognizer.delegate
//            = (id<UIGestureRecognizerDelegate>)self;
    }
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
