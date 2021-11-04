//
//  GLPEtpBankCardListController.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "GLPEtpBankCardListController.h"
#import "EtpBankCardListCell.h"
#import "GLPEtpAddBankCardController.h"
#import "DCAPIManager+PioneerRequest.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
static NSString *const EtpBankCardListCellID = @"EtpBankCardListCell";

@interface GLPEtpBankCardListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation GLPEtpBankCardListController

#pragma mark - 请求
- (void)requestLoadData{
    
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_withdraw_bank_listWithSuccess:^(id response) {
        NSArray *arr = response[@"data"];
        [weakSelf.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:[EtpBankCardListModel mj_objectArrayWithKeyValuesArray:arr]];
        [weakSelf updataViewUI];
    } failture:^(NSError *error) {
        
    }];
}

- (void)updataViewUI
{
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    
    [self requestLoadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpBankCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpBankCardListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataList[indexPath.section];
    WEAKSELF;
    cell.editBtnClick_block = ^{
        GLPEtpAddBankCardController *vc = [[GLPEtpAddBankCardController alloc] init];
        vc.GLPEtpAddBankCardController_back_block = ^(NSInteger type) {
            if (type == 2) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [weakSelf requestLoadData];
            }
        };
        vc.showType = EtpAddBankCardTypeEidt;
        vc.model = weakSelf.dataList[indexPath.section];
        [weakSelf dc_pushNextController:vc];
    };
    
    cell.slectedBtnClick_block = ^(UIButton *_Nonnull button) {
        [weakSelf changeDataArrayStatusIndex:indexPath.section];
    };

    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //EtpBankCardListCell *cell = (EtpBankCardListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self changeDataArrayStatusIndex:indexPath.section];
    
    !_GLPEtpBankCardListController_back_block ? : _GLPEtpBankCardListController_back_block(_dataList[indexPath.section]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeDataArrayStatusIndex:(NSInteger)index{
    
    for (NSInteger i=0;  i<_dataList.count;i++) {
        EtpBankCardListModel *model = _dataList[i];
        if (index == i) {
            model.isDefault = @"1";
        }else
            model.isDefault = @"2";
    }
    
    [self.tableView reloadData];

}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //刷新cell布局,解决有时候图片无法显示出来的问题
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setNeedsLayout];
//
//    UITableViewRowAction *delegateAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//
//    }];
//    delegateAction.backgroundColor = [UIColor redColor];
//    return @[delegateAction];
//}
//
//#pragma mark - iOS 13Cell 侧滑 与 UINavigationController+FDFullscreenPopGesture 冲突
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (@available(iOS 13.0, *)) {
//        // 禁用返回手势
//        if ([self.navigationController respondsToSelector:@selector(fd_fullscreenPopGestureRecognizer)]) {
//            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//        }
//    }
//}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[EtpBankCardListCell class] forCellReuseIdentifier:EtpBankCardListCellID];
    }
    return _tableView;
}

- (NSMutableArray<EtpBankCardListModel *> *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)setSelctedModel:(EtpBankCardListModel *)selctedModel{
    _selctedModel = selctedModel;
    
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
