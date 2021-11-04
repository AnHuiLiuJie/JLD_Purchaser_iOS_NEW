//
//  GLBRepayRecordController.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayRecordController.h"

#import "GLBRepayRecordCell.h"

static NSString *const listCellID = @"GLBRepayRecordCell";

@interface GLBRepayRecordController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITableView *tableView;

// 详情模型
@property (nonatomic, strong) GLBRepayRecordModel *recordModel;

@end

@implementation GLBRepayRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    if (_repayListModel) {
        [self requestRepayRecord];
    }
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.recordModel && self.recordModel.payments) {
        return  [self.recordModel.payments count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBRepayRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    if (self.recordModel && self.recordModel.payments) {
        [cell setValueWithRepayRecordModel:self.recordModel indexPath:indexPath];
    }
    return cell;
}


#pragma mark - action
- (void)bgBtnClick:(UIButton *)button
{
    [self cancelBtnClick:nil];
}

- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view removeFromSuperview];
}


#pragma mark - 请求 还款记录
- (void)requestRepayRecord
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestRepayRecordWithOrderNo:_repayListModel.orderNo success:^(id response) {
        if (response && [response isKindOfClass:[GLBRepayRecordModel class]]) {
            weakSelf.recordModel = response;
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.text = @"还款记录";
    [_bgView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.font = [UIFont fontWithName:PFR size:14];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _subLabel.text = @"待还总金额：￥0.00";
    [_bgView addSubview:_subLabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_placeholder_bg"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.sectionHeaderHeight = 0.01f;
    _tableView.sectionFooterHeight = 0.01f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [_bgView addSubview:_tableView];
    
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(-kNavBarHeight/2);
        make.width.equalTo(0.85*kScreenW);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.bgView.top).offset(15);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(0);
        make.right.equalTo(self.bgView.right).offset(-0);
        make.top.equalTo(self.titleLabel.bottom).offset(40);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.bgView.top);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.subLabel.bottom).offset(40);
        make.bottom.equalTo(self.bgView.bottom).offset(-40);
        make.height.equalTo(160);
    }];
}


@end
