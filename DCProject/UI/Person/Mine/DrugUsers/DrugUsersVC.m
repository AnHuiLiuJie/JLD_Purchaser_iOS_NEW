//
//  DrugUsersVC.m
//  DCProject
//
//  Created by Apple on 2021/3/17.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "DrugUsersVC.h"
#import "DrugUsersCell.h"
#import "DrugUsersAddVC.h"

static NSString *const DrugUsersCellID = @"DrugUsersCell";

@interface DrugUsersVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation DrugUsersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用药人";
    
    
    [self setupUI];
}

- (void)setupUI{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(70);
    }];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn addTarget:self action:@selector(addBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"添加用药人" forState:0];
    [addBtn setTitleColor:[UIColor whiteColor] forState:0];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 25;
    addBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    [footView addSubview:addBtn];
    [addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footView).offset(UIEdgeInsetsMake(10, 30, 10, 30));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(footView.top);
    }];
    [self.tableView reloadData];
}

#pragma mark - TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 379.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:NSClassFromString(DrugUsersCellID) forCellReuseIdentifier:DrugUsersCellID];
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getData];
        }];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DrugUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:DrugUsersCellID forIndexPath:indexPath];
    cell.idx = indexPath;
    //__weak typeof(self) weakSelf = self;
    cell.block = ^(NSIndexPath *_Nonnull idx, NSInteger type) {
        
    };
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)getData{
    
}

- (void)addBtnMethod{
    [self.navigationController pushViewController:[DrugUsersAddVC new] animated:YES];
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
