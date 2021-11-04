//
//  GLBTicketSelectController.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTicketSelectController.h"

#import "GLBTickListCell.h"

static NSString *const listCellID = @"GLBTickListCell";

@interface GLBTicketSelectController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UISegmentedControl *control;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *completeBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLBTicketSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_ticketType == GLBTicketTypeGoods) {

//        if (self.goodsTicketArray) {
//            [self.dataArray removeAllObjects];
//            [self.dataArray addObjectsFromArray:self.goodsTicketArray];
//        }
        
        [self requestGoodsTicket];

    } else if (_ticketType == GLBTicketTypeStore) {

//        if (self.storeTicketArray) {
//            [self.dataArray removeAllObjects];
//            [self.dataArray addObjectsFromArray:self.storeTicketArray];
//        }
        
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
    GLBTickListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    if (_ticketType == GLBTicketTypeGoods) {
        cell.goodsTicketModel = self.dataArray[indexPath.section];
    } else if (_ticketType == GLBTicketTypeStore) {
        cell.storeTicketModel = self.dataArray[indexPath.section];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_ticketType == GLBTicketTypeGoods) {
        
        GLBGoodsTicketModel *ticketModel = self.dataArray[indexPath.section];
        if (ticketModel.receive == 2) { // 未领取
            [self requestGetGoodsTicket:ticketModel indexPath:indexPath];
        }
        
    } else if (_ticketType == GLBTicketTypeStore) {
        
        GLBStoreTicketModel *ticketModel = self.dataArray[indexPath.section];
        if (ticketModel.receive == NO) { // 未领取
            [self requestGetStoreTicket:ticketModel indexPath:indexPath];
        }
        
    }
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
    [[DCAPIManager shareManager] dc_requestGoodsTicketWithGoodsId:_goodsId success:^(id response) {
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
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestStoreTicketWithFirmId:_storeId success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:response];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 领取商品专享券
- (void)requestGetGoodsTicket:(GLBGoodsTicketModel *)ticketModel indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestGetGoodsTicketWithCouponId:ticketModel.cashCouponId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:ticketModel];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 领取店铺优惠券
- (void)requestGetStoreTicket:(GLBStoreTicketModel *)ticketModel indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestGetStoreTicketWithCouponId:ticketModel.cashCouponId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:ticketModel];
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
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    [_bgView addSubview:_titleLabel];
    
    if (_ticketType == GLBTicketTypeGoods) {
        _titleLabel.text = @"商品专享券";
    } else if (_ticketType == GLBTicketTypeStore) {
        _titleLabel.text = @"店铺券";
    } else {
        _titleLabel.text = @"平台券";
    }
//
//    _control = [[UISegmentedControl alloc] initWithItems:@[@"店铺券",@"平台券"]];
//    _control.selectedSegmentIndex = 0;
//    _control.tintColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
////    [_control dc_cornerRadius:16];
//    _control.layer.cornerRadius = 16;
//    _control.layer.masksToBounds = YES;
//    _control.layer.borderWidth = 1;
//    _control.layer.borderColor = [UIColor dc_colorWithHexString:@"#00B7AB"].CGColor;
//    [_bgView addSubview:_control];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_completeBtn setTitle:@"完成" forState:0];
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:0];
    _completeBtn.titleLabel.font = PFRFont(16);
    [_completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_completeBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 88.0f;
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
        make.height.equalTo(385);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(20);
        make.size.equalTo(CGSizeMake(140, 32));
    }];
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
        make.height.equalTo(45);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.bottom.equalTo(self.completeBtn.top).offset(-10);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
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
