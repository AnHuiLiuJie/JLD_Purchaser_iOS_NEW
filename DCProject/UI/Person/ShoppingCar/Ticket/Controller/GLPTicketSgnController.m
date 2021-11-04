//
//  GLPTicketSgnController.m
//  DCProject
//
//  Created by bigbing on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPTicketSgnController.h"
#import "GLPTicketSgnCell.h"

static NSString *const listCellID = @"GLPTicketSgnCell";

@interface GLPTicketSgnController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLPTicketSgnController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self requestGoodsTicket];
}



#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPTicketSgnCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.ticketModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self requestGetTicket:self.dataArray[indexPath.section] indexPath:indexPath];
}


#pragma mark - action
- (void)completeBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
    if (_dissmissBlock) {
        _dissmissBlock();
    }
}

- (void)bgButtonClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
    if (_dissmissBlock) {
        _dissmissBlock();
    }
}


#pragma mark - 请求 券
- (void)requestGoodsTicket
{
    [self.dataArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestShoppingCarTicketWithFirmId:_storeId goodsIds:_goodsId success:^(id response) {
        if (response && [response isKindOfClass:[GLPTicketSgnModel class]]) {
            GLPTicketSgnModel *model = response;
            if (model.coupfirmvo) {
                [weakSelf.dataArray addObjectsFromArray:model.coupfirmvo];
            }
            if (model.coupGoodsvo) {
                [weakSelf.dataArray addObjectsFromArray:model.coupGoodsvo];
            }
        }
        [weakSelf.tableView reloadData];
        
    } failture:^(NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 请求 领取店铺优惠券
- (void)requestGetTicket:(GLPTicketSgnTicketModel *)ticketModel indexPath:(NSIndexPath *)indexPath
{
    // 已领取
    if (ticketModel.isReceive && [ticketModel.isReceive isEqualToString:@"1"]) {
        return;
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_receiveCouponswithcouponsId:ticketModel.couponsId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            ticketModel.isReceive = @"1";
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:ticketModel];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
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
    _bgButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgButton];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#F8F8F8"];
    _bgView.bounds = CGRectMake(0, 0, kScreenW, 1.44*kScreenW);
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFR size:18];
    _titleLabel.text = @"优惠券";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#8B8B8B"];
    _subLabel.font = [UIFont fontWithName:PFR size:14];
    _subLabel.text = @"可领取优惠券";
    [_bgView addSubview:_subLabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:0];
    [_cancelBtn addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_bgView addSubview:_cancelBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44.0f;
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
        make.height.equalTo(1.44*kScreenW);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(10);
        make.size.equalTo(CGSizeMake(140, 32));
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel.centerX);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.bottom.equalTo(self.bgView.bottom).offset(-10);
        make.top.equalTo(self.subLabel.bottom).offset(10);
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
