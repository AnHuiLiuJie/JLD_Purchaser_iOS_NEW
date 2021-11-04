//
//  GLPAddShoppingCarController.m
//  DCProject
//
//  Created by bigbing on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPAddShoppingCarController.h"

#import "GLPAddShoppingCarCell.h"
#import "GLPEditCountView.h"

static NSString *const listCellID = @"GLPAddShoppingCarCell";

@interface GLPAddShoppingCarController ()<UITableViewDelegate,UITableViewDataSource,GLPEditCountViewDelegate>

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) GLPEditCountView *countView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLPAddShoppingCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPAddShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.detailModel = self.detailModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - <GLPEditCountViewDelegate>
// 加
- (void)dc_personCountAddWithCountView:(GLPEditCountView *)countView
{
    NSInteger count = [countView.countTF.text integerValue];
    count ++;
    
    if (self.detailModel && self.detailModel.totalStock > 0) {
        if (count > self.detailModel.totalStock) {
            [SVProgressHUD showInfoWithStatus:@"超过库存啦～"];
            return;
        }
        
        countView.countTF.text = [NSString stringWithFormat:@"%ld",count];
    }
    
    countView.countTF.text = [NSString stringWithFormat:@"%ld",count];
}

// 减
- (void)dc_personCountSubWithCountView:(GLPEditCountView *)countView
{
    NSInteger count = [countView.countTF.text integerValue];
    count --;
    
    countView.countTF.text = [NSString stringWithFormat:@"%ld",count];
}

// 改变
- (void)dc_personCountChangeWithCountView:(GLPEditCountView *)countView
{
//    countView.countTF.userInteractionEnabled = NO;
//    [countView.countTF resignFirstResponder];
}


#pragma mark - action
- (void)completeBtnClick:(UIButton *)button
{
    if (!self.detailModel) {
        return;
    }
    
    [self requestAddShoppingCar];
}

- (void)bgButtonClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
    if (_carCellBlock) {
        _carCellBlock(self.countView.countTF.text);
    }
}



#pragma mark - 请求 加入购物车
- (void)requestAddShoppingCar
{
    NSString *quantity = [NSString stringWithFormat:@"%@",self.countView.countTF.text];
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestAddShoppingCarWithGoodsId:self.detailModel.goodsId batchId:@"" quantity:quantity success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.view removeFromSuperview];
                
                if (weakSelf.carCellBlock) {
                    weakSelf.carCellBlock(weakSelf.countView.countTF.text);
                }
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
    [self.view addSubview:_bgButton];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.bounds = CGRectMake(0, 0, kScreenW, 385);
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 144.0;
    _tableView.sectionHeaderHeight = 0.01f;
    _tableView.sectionFooterHeight = 0.01f;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.bounces = NO;
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    _tableView.showsVerticalScrollIndicator = NO;
    [_bgView addSubview:_tableView];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _countLabel.font = PFRFont(15);
    _countLabel.text = @"购买数量";
    [_bgView addSubview:_countLabel];
    
    _countView = [[GLPEditCountView alloc] init];
    _countView.delegate = self;
    _countView.countTF.text = [NSString stringWithFormat:@"%ld",_buyCount];
    [_bgView addSubview:_countView];
    
    [_bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(385);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top).offset(10);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.bottom.equalTo(self.bgView).offset(-46);
        make.height.equalTo(45);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(16);
        make.bottom.equalTo(self.completeBtn.top).offset(-43);
    }];
    
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel.centerY);
        make.right.equalTo(self.bgView.right).offset(-16);
        make.size.equalTo(CGSizeMake(100, 40));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(0);
        make.right.equalTo(self.bgView.right).offset(0);
        make.bottom.equalTo(self.countLabel.top).offset(-10);
        make.top.equalTo(self.cancelBtn.bottom).offset(5);
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
