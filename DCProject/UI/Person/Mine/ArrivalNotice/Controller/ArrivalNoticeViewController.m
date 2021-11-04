//
//  ArrivalNoticeViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/7/6.
//

#import "ArrivalNoticeViewController.h"
#import "ArrivalNoticeHeaderView.h"
#import "DCAPIManager+PioneerRequest.h"
#import "DCAPIManager+PersonRequest.h"
@interface ArrivalNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL haveData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ArrivalNoticeHeaderView *headerView;

@property (strong, nonatomic) UITableView *detailTableView;
@property (nonatomic, assign) NSInteger selectedTypeIndex;

@property (nonatomic, strong) ArrivalNoticeModel *noticeModel;
@property (nonatomic, copy) NSString *phoneStr;

@end


static NSString *const UITableViewCellID = @"UITableViewCell";


static CGFloat kBottomView_H = 60;

@implementation ArrivalNoticeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_navBarBackGroundcolor:[UIColor whiteColor]];

    if (!_isFirstLoad) {
        [self requestLoadData];
        _isFirstLoad = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"到货通知";
    
    NSDictionary *userInfoModel = [DCObjectManager dc_readUserDataForKey:P_UserInfo_Key];//GLPUserInfoModel
    self.phoneStr =  userInfoModel[@"cellphone"];
    
    self.bottomView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)requestLoadData{
    NSString *goodsId = self.goodsId.length == 0 ? @"" : self.goodsId;
    NSString *serialId = self.serialId.length == 0 ? @"" : self.serialId;
    WEAKSELF;
    [[DCAPIManager shareManager] personRequest_b2c_goodsInfo_expect_time_listWithSuccess:^(id  _Nullable response) {
        [weakSelf.dataArray addObjectsFromArray:response[@"data"]];
        weakSelf.headerView.timeArr = weakSelf.dataArray;

    } failture:^(NSError * _Nullable error) {
        
    }];
    
    [[DCAPIManager shareManager] personRequest_b2c_goodsInfo_detail_arrival_noticeWithGoodsId:goodsId serialId:serialId success:^(id  _Nullable response) {
        ArrivalNoticeModel *model = [ArrivalNoticeModel mj_objectWithKeyValues:response[@"data"]];
        if (model.buyerCellphone.length == 0) {
            model.buyerCellphone = weakSelf.phoneStr;
        }
        weakSelf.noticeModel = model;
        weakSelf.headerView.model = model;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kBottomView_H-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0.01f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_tableView registerClass:NSClassFromString(UITableViewCellID) forCellReuseIdentifier:UITableViewCellID];

        //[_tableView registerNib:[UINib nibWithNibName:UITableViewCellID bundle:nil] forCellReuseIdentifier:PatientListCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenW, kBottomView_H);
        [self.view addSubview:_bottomView];
        
        UILabel *promptLab = [[UILabel alloc] init];
        promptLab.backgroundColor = [UIColor clearColor];
        promptLab.text = @"";
        promptLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
        promptLab.font = [UIFont fontWithName:PFR size:12];
        promptLab.textAlignment = NSTextAlignmentLeft;
        promptLab.frame = CGRectMake(15, 0, _bottomView.dc_width, 0);
        [_bottomView addSubview:promptLab];
        
        _confirmBtn = [[UIButton alloc] init];
        [_bottomView addSubview:_confirmBtn];
        [_confirmBtn dc_layerBorderWith:0 color:[UIColor whiteColor] radius:10];
        _confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.frame = CGRectMake(15, CGRectGetMaxY(promptLab.frame), _bottomView.dc_width-30, kBottomView_H*0.8);
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#42E5A6"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#00B7AB"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0,0);
        gradientLayer2.endPoint = CGPointMake(1,0);
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = _confirmBtn.bounds;
        [_confirmBtn.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [_confirmBtn dc_cornerRadius:_confirmBtn.dc_height/2];
    }
    return _bottomView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;;
}

- (ArrivalNoticeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [ArrivalNoticeHeaderView dc_viewFromXib];
        _headerView.phoneTf.text = self.phoneStr;
        WEAKSELF;
        _headerView.ArrivalNoticeHeaderView_block = ^(NSString * _Nonnull isSms) {
            weakSelf.noticeModel.isSms = isSms;
            [weakSelf changeDefineBtnState];
        };
        _headerView.ArrivalNoticeHeaderView_block2 = ^(NSString * _Nonnull expectTime) {
            weakSelf.noticeModel.expectTime = expectTime;
            [weakSelf changeDefineBtnState];
        };
        _headerView.ArrivalNoticeHeaderView_block3 = ^(NSString * _Nonnull buyerCellphone) {
            weakSelf.noticeModel.buyerCellphone = buyerCellphone;
            [weakSelf changeDefineBtnState];
        };
    }
    return _headerView;
}

- (void)changeDefineBtnState{
    BOOL isYES = [self isActiveState:NO];
    if (isYES) {
        self.confirmBtn.userInteractionEnabled = YES;
        self.confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    }else{
        self.confirmBtn.userInteractionEnabled = NO;
        self.confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#b9b9b9"];
    }
}

- (BOOL)isActiveState:(BOOL)isNeedToast{
    if (![DCCheckRegular dc_checkTelNumber:self.noticeModel.buyerCellphone]) {
        //[SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return NO;
    }
    
    if ([self.noticeModel.isSms isEqualToString:@"0"]) {
        return NO;
    }
    
    if (self.noticeModel.expectTime.length == 0) {
        return NO;
    }
    return YES;
}

- (void)confirmBtnAction
{
    if (self.noticeModel.expectTime.length == 0) {
        [self.view makeToast:@"请选择期望时间" duration:Toast_During position:CSToastPositionBottom];
        return;
    }
    NSString *buyerCellphone = self.noticeModel.buyerCellphone;
    NSString *expectTime = self.noticeModel.expectTime;
    NSString *goodsId = self.goodsId.length == 0 ? @"" : self.goodsId;
    NSString *serialId = self.serialId.length == 0 ? @"" : self.serialId;
    NSString *isSms = self.noticeModel.isSms;
    
    WEAKSELF;
    [[DCAPIManager shareManager] personRequest_b2c_goodsInfo_subscribe_noticeWithGoodsId:goodsId buyerCellphone:buyerCellphone expectTime:expectTime isSms:isSms serialId:serialId success:^(id  _Nullable response) {
        [weakSelf requestCollectGoods];
        [[DCAlterTool shareTool] showDoneWithTitle:@"订阅成功，到货后系统将自动通知" message:@"" defaultTitle:@"知道了" handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - 收藏 商品
- (void)requestCollectGoods
{
    NSString *goodsId = self.goodsId.length == 0 ? @"" : self.goodsId;
    NSString *price = self.price.length == 0 ? @"" : self.price;
    [[DCAPIManager shareManager] person_addCollectionwithcollectionType:@"1" goodsPrice:price objectId:goodsId isPrompt:YES success:^(id response) {
        
    } failture:^(NSError *_Nullable error) {
        
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
