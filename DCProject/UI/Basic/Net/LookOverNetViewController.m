//
//  LookOverNetViewController.m
//  Pole
//
//  Created by 赤道 on 2020/1/14.
//  Copyright © 2020 刘伟. All rights reserved.
//

#import "LookOverNetViewController.h"
#import "NetWorkCell.h"

@interface LookOverNetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation LookOverNetViewController

- (void)dealloc{
//    !_back_superVC_Block ? : _back_superVC_Block();
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"查看网络方法";
    
    
    self.dataArray = @[@"bg_tip_setting_1",@"bg_tip_setting_2",@"bg_tip_setting_3",@"bg_tip_setting_4",@"bg_tip_setting_5",@"bg_tip_setting_6",@"bg_tip_setting_7"];
    
    [self setUpViewUI];
}

#pragma mark - 导航栏颜色 状态栏颜色
- (void)createNavgationView:(UIColor *)barTintColor titleTextFont:(CGFloat)fontSize
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = barTintColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)setUpViewUI{
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
}

#pragma mark UITableView  UITableViewDataSource 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = CellIdentifier = @"_tableViewCell";
    NetWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([NetWorkCell class])owner:nil options:nil] lastObject];
    }
    cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate 代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

#pragma mark 初始化
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH-kStatusBarHeight-44) style:UITableViewStylePlain];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.dataSource = self;
        tableView.delegate = self;
        //解决分隔线不到头
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
