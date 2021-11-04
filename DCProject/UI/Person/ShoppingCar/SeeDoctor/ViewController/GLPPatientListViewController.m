//
//  GLPPatientListViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/6/10.
//

#import "GLPPatientListViewController.h"
#import "GLPAddPatientViewController.h"

#import "DCNoDataView.h"

@interface GLPPatientListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL haveData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end


static NSString *const PatientListCellID = @"PatientListCell";


static CGFloat kBottomView_H = 60;

@implementation GLPPatientListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_navBarBackGroundcolor:[UIColor whiteColor]];

    if (!_isFirstLoad) {
        WEAKSELF;
        self.tableView.mj_header = [[DCRefreshTool shareTool] headerDefaultWithBlock:^{
            [weakSelf requestLoadData];
        }];
        _isFirstLoad = YES;
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.title = @"新增用药人";
    
    self.bottomView.backgroundColor = self.tableView.backgroundColor;
}

- (void)requestLoadData{
//    NSString *level = [self changeState];
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_druguser_listWithSuccess:^(id  _Nullable response) {
        [weakSelf.dataArray removeAllObjects];
        
        NSArray *arr1 = [MedicalPersListModel mj_objectArrayWithKeyValuesArray:response];

        [weakSelf.dataArray addObjectsFromArray:arr1];
        if (weakSelf.dataArray.count == 0) {
            weakSelf.tableView.hidden = YES;
            weakSelf.noDataView.hidden = NO;
        }else{
            weakSelf.tableView.hidden = NO;
            weakSelf.noDataView.hidden = YES;
        }

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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    PatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:PatientListCellID forIndexPath:indexPath];
    MedicalPersListModel *model = _dataArray[indexPath.section];
    cell.model = model;
    cell.PatientListCellDel_block = ^{
        [[DCAlterTool shareTool] showDefaultWithTitle:@"是否删除该信息?" message:@"" defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            [weakSelf removeIndexListCell:indexPath];
        }];
    };
    cell.PatientListCellEid_block = ^{
        GLPAddPatientViewController *vc = [[GLPAddPatientViewController alloc] init];
        vc.drugId = model.drugId;
        vc.model = model;
        vc.GLPAddPatientViewController_block = ^{
            weakSelf.isFirstLoad = NO;
        };
        [weakSelf dc_pushNextController:vc];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
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

// 删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
}

// 改变删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

// 删除用到的函数
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self removeIndexListCell:indexPath];
/*
   [self.dataArr  removeObjectAtIndex:idx];  //删除cell
   [self.tableV deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
*/
    }

}

#pragma mark - remove
- (void)removeIndexListCell:(NSIndexPath *)indexPath {
    MedicalPersListModel *model = _dataArray[indexPath.section];
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_druguser_removeWithDrugId:model.drugId success:^(id  _Nullable response) {
        //
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]                     withRowAnimation:UITableViewRowAnimationAutomatic]; //删除对应数据的cell
        //[weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView reloadData];
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kBottomView_H-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        [_tableView registerNib:[UINib nibWithNibName:PatientListCellID bundle:nil] forCellReuseIdentifier:PatientListCellID];

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
        [_confirmBtn setTitle:@"新增用药人" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.frame = CGRectMake(15, CGRectGetMaxY(promptLab.frame), _bottomView.dc_width-30, kBottomView_H*0.8);
    }
    return _bottomView;
}

- (DCNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.frame image:[UIImage imageNamed:@"dc_bg_noData"] button:nil tip:@"暂无数据"];
        [self.view addSubview:_noDataView];
    }
    return _noDataView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;;
}


- (void)confirmBtnAction
{
    GLPAddPatientViewController *vc = [[GLPAddPatientViewController alloc] init];
    [self dc_pushNextController:vc];
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
