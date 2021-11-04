//
//  GLBRepayListController.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayListController.h"

#import "GLBRepayHeadView.h"
#import "GLBRepayListCell.h"
#import "GLBRepayListSectionView.h"

#import "GLBRepayFullController.h"
#import "GLBRepayStageController.h"
#import "GLBRepayOverdueController.h"
#import "GLBOverdueRecordController.h"
#import "GLBRepayRecordController.h"
#import "CGXPickerView.h"
static NSString *const listCellID = @"GLBRepayListCell";
static NSString *const sectionID = @"GLBRepayListSectionView";

@interface GLBRepayListController ()

@property (nonatomic, strong) GLBRepayHeadView *headView;

@property (nonatomic, strong) NSMutableArray<GLBRepayListModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;
@property(nonatomic,copy) NSString *typeStr;
@end

@implementation GLBRepayListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"账期还款";
//    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F1EA"];
    self.typeStr=@"0";
    WEAKSELF;
    self.headView.clickblock = ^{
        NSArray *arr = @[@"全部",@"在途",@"待还款",@"还款中",@"已还款",@"还款结束"];//账期状态：0-全部；1-在途；2-待还款；3-还款中；4-已还款；5-逾期还款结束.
        [CGXPickerView showStringPickerWithTitle:@"选择状态" DataSource:arr DefaultSelValue:0 IsAutoSelect:NO ResultBlock:^(id selectValue, id selectRow) {
            [weakSelf.headView.typeBtn setTitle:[NSString stringWithFormat:@"%@",selectValue] forState:UIControlStateNormal];
            
            weakSelf.typeStr = [NSString stringWithFormat:@"%@",selectRow];
            
            
        }];
    };
    self.headView.resetblock = ^{
        weakSelf.headView.beginTF.text = @"";
        weakSelf.headView.endTF.text = @"";
         [weakSelf.headView.typeBtn setTitle:@"全部" forState:UIControlStateNormal];
        weakSelf.typeStr=@"0";
        [weakSelf requestRepayList:YES];
    };
    self.headView.lookblock = ^{
       [weakSelf requestRepayList:YES];
    };
    self.headView.begainblock = ^{
        NSDate *now = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString *nowStr = [fmt stringFromDate:now];
        
        [CGXPickerView showDatePickerWithTitle:@"开始时间" DateType:UIDatePickerModeDate DefaultSelValue:nowStr MinDateStr:@"1999-12-31" MaxDateStr:nowStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
            weakSelf.headView.beginTF.text = selectValue;
        }];
    };
    self.headView.endblock = ^{
        NSDate *now = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString *nowStr = [fmt stringFromDate:now];
        
        [CGXPickerView showDatePickerWithTitle:@"结束时间" DateType:UIDatePickerModeDate DefaultSelValue:nowStr MinDateStr:@"1999-12-31" MaxDateStr:nowStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
            weakSelf.headView.endTF.text = selectValue;
        }];
    };
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(kNavBarHeight);
        make.height.equalTo(124);
    }];
    [self setUpTableView];
    
    [self addRefresh:YES];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestRepayList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestRepayList:NO];
}



#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    GLBRepayListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.repayListModel = self.dataArray[indexPath.section];
    cell.btnClickBlock = ^{
        [weakSelf pushOverdueRecordController:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    GLBRepayListModel *listModel = self.dataArray[section];
    if (listModel.periodState == 1) {
        return 0.01f;
    }
    return 40.0f;
}

- (GLBRepayListSectionView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    GLBRepayListSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    header.repayListModel = self.dataArray[section];
    WEAKSELF;
    header.successBlock = ^(NSString *title) {
        [weakSelf dc_sectionViewBtnClick:title section:section];
    };
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - action
- (void)dc_sectionViewBtnClick:(NSString *)title section:(NSInteger)section
{
    WEAKSELF;
    if ([title isEqualToString:@"全额还款"]) {
        GLBRepayFullController *vc = [GLBRepayFullController new];
        vc.repayListModel = self.dataArray[section];
        vc.completeBlock = ^{
            GLBRepayListModel *model = weakSelf.dataArray[section];
            [weakSelf requestRepayMoney:model.paymentAmount orderNo:model.orderNo paymentId:@""];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if ([title isEqualToString:@"部分还款"]) {
        GLBRepayStageController *vc = [GLBRepayStageController new];
        vc.repayListModel = self.dataArray[section];
        vc.repayBlock = ^(CGFloat money) {
            GLBRepayListModel *model = weakSelf.dataArray[section];
            [weakSelf requestRepayMoney:money orderNo:model.orderNo paymentId:@""];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
    
    if ([title isEqualToString:@"逾期申请"]) {
        GLBRepayOverdueController *vc = [GLBRepayOverdueController new];
        vc.repayListModel = self.dataArray[section];
        vc.repayOverdueBlock = ^(NSString *time, NSString *remark) {
            GLBRepayListModel *model = weakSelf.dataArray[section];
            [weakSelf requestApplyOverdueDelayReason:remark orderNo:model.orderNo paymentEndDate:time];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
    
    
    if ([title isEqualToString:@"还款记录"]) {
        GLBRepayRecordController *vc = [GLBRepayRecordController new];
        vc.repayListModel = self.dataArray[section];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        
//        [self presentViewController:vc animated:NO completion:nil];
    }
}


#pragma mark -
- (void)pushOverdueRecordController:(NSIndexPath *)indexPath
{
    GLBOverdueRecordController *vc = [GLBOverdueRecordController new];
    vc.repayListModel = self.dataArray[indexPath.section];
    [self dc_pushNextController:vc];
}


#pragma mark - 请求 账期列表
- (void)requestRepayList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    
    
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestRepayListListWithCurrentPage:_page startDate:self.headView.beginTF.text endDate:self.headView.endTF.text orderNo:self.headView.searchTF.text state:self.typeStr success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
    } failture:^(NSError *error) {
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求 还款
- (void)requestRepayMoney:(CGFloat)amount orderNo:(NSInteger)orderNo paymentId:(NSString *)paymentId
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestRepayRepayWithAmount:amount orderNo:orderNo paymentId:paymentId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"请求成功"];
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 申请逾期
- (void)requestApplyOverdueDelayReason:(NSString *)delayReason orderNo:(NSInteger)orderNo paymentEndDate:(NSString *)paymentEndDate
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestApplyOverdueWithOrderNo:orderNo delayReason:delayReason paymentEndDate:paymentEndDate success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
            [weakSelf.tableView.mj_header becomeFirstResponder];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 124, kScreenW, kScreenH - kNavBarHeight - 124);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 40.0f;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID];
}


#pragma mark - lazy load
- (GLBRepayHeadView *)headView{
    if (!_headView) {
        _headView = [[GLBRepayHeadView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, 124)];
    }
    return _headView;
}


- (NSMutableArray<GLBRepayListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
