//
//  GLBOverdueRecordController.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOverdueRecordController.h"
#import "GLBOverdueRecodeCell.h"

static NSString *const listCellID = @"GLBOverdueRecodeCell";
static NSString *const sectionID = @"UITableViewHeaderFooterView";

@interface GLBOverdueRecordController ()

@property (nonatomic, strong) NSMutableArray<GLBRepayListDelayModel *> *dataArray;

@end

@implementation GLBOverdueRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"逾期申请记录";
    
    [self setUpTableView];
    
    if (_repayListModel) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:_repayListModel.delays];
        [self.tableView reloadData];
    }
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBOverdueRecodeCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithDelayModel:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    header.contentView.backgroundColor = [UIColor whiteColor];

    for (id class in header.contentView.subviews) {
        [class removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:PFR size:16];
    titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    titleLabel.text = @"还款时间：-";
    [header.contentView addSubview:titleLabel];
    
    if (_repayListModel) {
        NSString *time = _repayListModel.repaymentEndDate;
        if ([time containsString:@" "]) {
            time = [time componentsSeparatedByString:@" "][0];
        }
        titleLabel.text = [NSString stringWithFormat:@"还款时间：%@",time];
    }
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.font = [UIFont fontWithName:PFR size:14];
    dayLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    dayLabel.text = @"0天";
    dayLabel.textAlignment = NSTextAlignmentRight;
    [header.contentView addSubview:dayLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.contentView.left).offset(15);
        make.top.equalTo(header.contentView.top).offset(23);
    }];
    
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.centerY);
        make.right.equalTo(header.contentView.right).offset(-15);
    }];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(10, kNavBarHeight + 10, kScreenW - 20, kScreenH - kNavBarHeight - 20);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 65.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
