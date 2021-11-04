//
//  GLPDetailTicketController.m
//  DCProject
//
//  Created by bigbing on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPDetailTicketController.h"

#import "GLPDetailTicketSelectCell.h"

static NSString *const listCellID = @"GLPDetailTicketSelectCell";

@interface GLPDetailTicketController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLPDetailTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_ticketType == GLPTicketTypeWithGoods) {
        [self requestGoodsTicket];
    } else if (_ticketType == GLPTicketTypeWithStore) {
        [self requestStoreTicket];
    }
    
    [self setUpUI];
}



#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPDetailTicketSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.ticketModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPGoodsTicketModel *ticketModel = self.dataArray[indexPath.section];
    if ([ticketModel.isReceive isEqualToString:@"1"]) {
        // 已领取
        return;
    }
    
    [self requestGetGoodsTicket:ticketModel indexPath:indexPath];
}


#pragma mark - action
- (void)completeBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
}

- (void)bgButtonClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
}


#pragma mark - 请求 商品专享券
- (void)requestGoodsTicket
{
    [self.dataArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestGoodsTicketWithGoodsId:_detailModel.goodsId success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:response];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 店铺券
- (void)requestStoreTicket
{
    [self.dataArray removeAllObjects];
    NSString *firmId = [NSString stringWithFormat:@"%ld",self.detailModel.sellerFirmId];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestStoreTicketWithFirmId:firmId success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:response];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 领取商品专享券
- (void)requestGetGoodsTicket:(GLPGoodsTicketModel *)ticketModel indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_receiveCouponswithcouponsId:ticketModel.couponsId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            
            GLPGoodsTicketModel *model = weakSelf.dataArray[indexPath.section];
            model.isReceive = @"1";
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
            [weakSelf.tableView reloadData];
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#000000" alpha:0.5];
    
    _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgButton addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgButton];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.bounds = CGRectMake(0, 0, kScreenW, kScreenH/3*2);
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLabel.text = @"领券";
    [_bgView addSubview:_titleLabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_completeBtn setTitle:@"完成" forState:0];
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:0];
    _completeBtn.titleLabel.font = PFRFont(16);
    [_completeBtn dc_cornerRadius:22];
    [_completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_completeBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 85.0;
    _tableView.sectionHeaderHeight = 10.0f;
    _tableView.sectionFooterHeight = 0.01f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    _tableView.showsVerticalScrollIndicator = NO;
    [_bgView addSubview:_tableView];
    
    
    [_bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(kScreenH/3*2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(16);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.bottom.equalTo(self.bgView).offset(-15-LJ_TabbarSafeBottomMargin);
        make.height.equalTo(45);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(0);
        make.right.equalTo(self.bgView.right).offset(0);
        make.bottom.equalTo(self.completeBtn.top).offset(-5);
        make.top.equalTo(self.titleLabel.bottom).offset(15);
    }];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
