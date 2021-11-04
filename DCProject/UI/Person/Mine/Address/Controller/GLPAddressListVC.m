//
//  GLPAddressListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPAddressListVC.h"
#import "AddressListCell.h"
#import "GLPAddAddressVC.h"
#import "DCNoDataView.h"


@interface GLPAddressListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, strong) DCNoDataView *noorderDataView;

@property (nonatomic, assign) BOOL isFirstLoad;

@end

static NSString *const AddressListCellID = @"AddressListCell";


@implementation GLPAddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收货地址";
    self.tableView.hidden = NO;
    
    UIButton*rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"新建地址" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem*rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightBar;
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    self.noorderDataView.hidden = YES;
    [self.view addSubview:self.noorderDataView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self getlist];
        _isFirstLoad = YES;
    }
}

- (void)getlist
{
    WEAKSELF;
    [[DCAPIManager shareManager]person_GetAddressListsuccess:^(id response) {
        [weakSelf.listArray removeAllObjects];
        NSArray *arr = response[@"data"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            GLPGoodsAddressModel *model = [GLPGoodsAddressModel mj_objectWithKeyValues:dic];
            [weakSelf.listArray addObject:model];
        }
        if (weakSelf.listArray.count>0)
        {
            weakSelf.noorderDataView.hidden = YES;
        }
        else{
            weakSelf.noorderDataView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)rightClick
{
    GLPAddAddressVC *vc = [[GLPAddAddressVC alloc] init];
    WEAKSELF;
    vc.GLPAddAddressVC_block = ^{
        weakSelf.isFirstLoad = NO;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListCell"];
    if (cell==nil){
        cell = [[AddressListCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GLPGoodsAddressModel *model = self.listArray[indexPath.section];
    cell.model = model;
    WEAKSELF;
    cell.AddressListCellEid_block = ^{
        GLPAddAddressVC *vc = [[GLPAddAddressVC alloc] init];
        vc.GLPAddAddressVC_block = ^{
            weakSelf.isFirstLoad = NO;
        };
        vc.addressModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.AddressListCellDel_block = ^{
        [[DCAlterTool shareTool] showDefaultWithTitle:@"是否删除该信息?" message:@"" defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
            [weakSelf removeIndexListCell:indexPath];
        }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.isChose isEqualToString:@"1"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        GLPGoodsAddressModel *model = self.listArray[indexPath.section];
        if (self.addressblock) {
            self.addressblock(model);
        }
    }
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
    }
    
}

#pragma mark - remove
- (void)removeIndexListCell:(NSIndexPath *)indexPath {
    GLPGoodsAddressModel *model = _listArray[indexPath.section];
    WEAKSELF;
    NSString *addrId = model.addrId.length == 0 ? @"" : model.addrId;
    [[DCAPIManager shareManager]person_deleAddressWithaddrId:addrId success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"删除收货地址成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakSelf.listArray removeObjectAtIndex:indexPath.section];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]                     withRowAnimation:UITableViewRowAnimationAutomatic]; //删除对应数据的cell
            //[weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView endUpdates];
        });
    } failture:^(NSError *error) {
        
    }];
    
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
        [self.tableView registerNib:[UINib nibWithNibName:@"AddressListCell" bundle:nil] forCellReuseIdentifier:AddressListCellID];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
        //_noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight) image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"还未添加收货地址～"];
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:self.tableView.bounds image:[UIImage imageNamed:@"p_qita"] button:nil tip:@"还未添加收货地址～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}

@end
