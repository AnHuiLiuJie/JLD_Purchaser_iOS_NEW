//
//  GLBZizhiExchangeController.m
//  DCProject
//
//  Created by bigbing on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBZizhiExchangeController.h"
#import "GLBZizhiExchangeCell.h"

static NSString *const listCellID = @"GLBZizhiExchangeCell";

@interface GLBZizhiExchangeController ()


@property (nonatomic, strong) GLBQualificateModel *model;

@property (nonatomic, strong) NSMutableArray<GLBQualificateListModel *> *dataArray;

@end

@implementation GLBZizhiExchangeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTableView];
    self.navigationItem.title = @"变更资质";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"提交" color:[UIColor dc_colorWithHexString:@"#00B7AB"] font:[UIFont fontWithName:PFR size:13] target:self action:@selector(editAction:)];
    
//    [self addHeaderRefresh:NO];
    [self requestQualificateList:YES];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBZizhiExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.listModel = self.dataArray[indexPath.section];
    WEAKSELF;
    cell.changeBlock = ^(GLBQualificateListModel *listModel) {
        [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:listModel];
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark - action
- (void)editAction:(id)sender
{
    [self requestChangeQualificate];
}


#pragma mark - 请求 获取资质
- (void)requestQualificateList:(BOOL)isReload
{
    if (isReload) {
        [self.dataArray removeAllObjects];
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyQualificateWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[GLBQualificateModel class]]) {
            GLBQualificateModel *model = response;
            weakSelf.model = model;
            if (model.qcList && [model.qcList count] > 0) {
                [weakSelf.dataArray addObjectsFromArray:model.qcList];
            }
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
    }];
}


#pragma mark - 请求 资质变更提交
- (void)requestChangeQualificate
{
    NSString *address = self.model.firmAddress;
    NSString *firmArea = self.model.firmArea;
    NSInteger firmAreaId = self.model.firmAreaId;
    NSString *firmCat1 = self.model.firmCat1;
    NSString *firmCat2List = self.model.firmCat2List;
    NSString *firmContact = self.model.firmContact;
    NSInteger firmId = self.model.firmId;
    NSString *firmName = self.model.firmName;
    
    NSMutableArray *qcList = [NSMutableArray array];
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        GLBQualificateListModel *listModel = self.dataArray[i];
        
        if ([listModel.isRequired isEqualToString:@"1"]) { // 必须上传
            if (listModel.qcPic.length == 0) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请上传%@",listModel.qcName]];
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请上传%@",listModel.qcName]];
                return;
            }
        }
        
        NSDictionary *dict = @{@"isRequired":listModel.isRequired,
                                @"qcCode":listModel.qcCode,
                                @"qcName":listModel.qcName,
                                @"qcPic":listModel.qcPic};
        [qcList addObject:dict];
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCommintQualificateWithFirmAddress:address firmArea:firmArea firmAreaId:firmAreaId firmCat1:firmCat1 firmCat2List:firmCat2List firmContact:firmContact firmId:firmId firmName:firmName qcList:qcList success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failture:^(NSError *_Nullable error) {
    
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (NSMutableArray<GLBQualificateListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
