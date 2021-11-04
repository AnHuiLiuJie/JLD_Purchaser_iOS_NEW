//
//  GLPDonateRecordListVC.m
//  DCProject
//
//  Created by LiuMac on 2021/7/29.
//

#import "GLPDonateRecordListVC.h"
// Controllers
// Models
// Views
/* cell */
#import "DonateRecordListCell.h"
/* head */
/* foot */
// Vendors
// Categories
// Others

@interface GLPDonateRecordListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *const DonateRecordListCellID = @"DonateRecordListCell";

@implementation GLPDonateRecordListVC

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat height = kStatusBarHeight > 20 ? 27 : 0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - 56 - height - kNavBarHeight);
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = NO;
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DonateRecordListCell class]) bundle:nil] forCellReuseIdentifier:DonateRecordListCellID];
        
//        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsActivityGroupCellID) forCellReuseIdentifier:GLPGoodsDetailsActivityGroupCellID];
//        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsActivityPreSaleCellID) forCellReuseIdentifier:GLPGoodsDetailsActivityPreSaleCellID];
//        [_tableView registerClass:NSClassFromString(GLPNewGoodsDetailsTitleCellID) forCellReuseIdentifier:GLPNewGoodsDetailsTitleCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];//弹出的视图背景颜色
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //WEAKSELF;
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
