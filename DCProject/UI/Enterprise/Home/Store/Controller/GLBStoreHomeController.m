//
//  GLBStoreHomeController.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreHomeController.h"

#import "GLBStoreNoticeCell.h"
#import "GLBStoreTicketCell.h"
#import "GLBStoreGoodsCell.h"

#import "GLBGoodsDetailController.h"
#import "DCLoginController.h"
#import "DCNavigationController.h"
static NSString *const noticeCellID = @"GLBStoreNoticeCell";
static NSString *const ticketCellID = @"GLBStoreTicketCell";
static NSString *const goodsCellID = @"GLBStoreGoodsCell";
static NSString *const sectionID = @"UITableViewHeaderFooterView";

@interface GLBStoreHomeController ()

@property (nonatomic, strong) NSMutableArray<GLBStoreGoodsModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GLBStoreTicketModel *> *ticketArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBStoreHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTableView];
    
    if (_storeModel) {
        
        [self removeRefresh];
        [self addRefresh:YES];
        [self requestStoreTicket];
    }
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestStoreGoodsList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestStoreGoodsList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    if (self.storeModel && self.storeModel.notice && [self.storeModel.notice length] > 0) {
        count ++;
    }
    if ([self.ticketArray count] > 0) {
        count ++;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == tableView.numberOfSections - 1 ? self.dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WEAKSELF;
    if (indexPath.section == 0 && self.storeModel && self.storeModel.notice && [self.storeModel.notice length] > 0) {
        
        GLBStoreNoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:noticeCellID forIndexPath:indexPath];
        if (self.storeModel) {
            noticeCell.storeModel = self.storeModel;
        }
        cell = noticeCell;
        
    } else if (self.ticketArray.count > 0 && ((indexPath.section == 1 && self.storeModel && self.storeModel.notice && [self.storeModel.notice length] > 0) || (indexPath.section == 0 && !(self.storeModel && self.storeModel.notice && [self.storeModel.notice length] > 0)))) {
        
        GLBStoreTicketCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:ticketCellID forIndexPath:indexPath];
        if (self.ticketArray.count > 0) {
            ticketCell.ticketArray = self.ticketArray;
        }
        ticketCell.ticketCellBlock = ^(NSInteger index) {
            GLBStoreTicketModel *ticketModel = weakSelf.ticketArray[index];
            if (ticketModel.receive == 2) {
                [weakSelf requestGetTicket:index];
            }
        };
        cell = ticketCell;
        
    } else {
        
        GLBStoreGoodsCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:goodsCellID forIndexPath:indexPath];
        goodsCell.goodsModel = self.dataArray[indexPath.row];
        goodsCell.loginBlcok = ^{
//            [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:DC_LoginSucess_Notification object:nil];
//            }];
            // 清除本地字段
                      [[DCLoginTool shareTool] dc_removeLoginDataWithCompany];

                      DCLoginController *vc = [DCLoginController new];
                      vc.isPresent = YES;
                      vc.modalPresentationStyle =UIModalPresentationFullScreen;
                      DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
                   [self presentViewController:nav animated:YES completion:^{
                         [[NSNotificationCenter defaultCenter] postNotificationName:DC_LoginSucess_Notification object:nil];
                   }];
        };
        cell = goodsCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == tableView.numberOfSections - 1 ? 35 : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != tableView.numberOfSections - 1) {
        return [UITableViewHeaderFooterView new];
    }
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    if (![header.contentView.subviews.lastObject isKindOfClass:[UILabel class]]) {
        
        header.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        label.font = [UIFont fontWithName:PFRMedium size:15];
        label.text = @"店铺商品";
        [header.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.contentView.left).offset(15);
            make.right.equalTo(header.contentView.right);
            make.bottom.equalTo(header.contentView.bottom);
        }];
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == tableView.numberOfSections - 1) {
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.detailType = GLBGoodsDetailTypeNormal;
        vc.goodsId = [self.dataArray[indexPath.row] goodsId];
        vc.batchId = [self.dataArray[indexPath.row] batchId];
        [self dc_pushNextController:vc];
    }
}


#pragma mark - 请求 获取商家优惠券
- (void)requestStoreTicket
{
    [self.ticketArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestStoreTicketWithFirmId:_storeModel.storeInfoVO.firmId success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.ticketArray addObjectsFromArray:response];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - 请求 领取商户优惠券
- (void)requestGetTicket:(NSInteger)index
{
    GLBStoreTicketModel *model = self.ticketArray[index];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestGetStoreTicketWithCouponId:model.cashCouponId success:^(id response) {
        
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            model.receive = YES;
            [weakSelf.ticketArray replaceObjectAtIndex:index withObject:model];
            [weakSelf.tableView reloadData];
        }
        
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - 请求 获取商铺商品列表
- (void)requestStoreGoodsList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestStoreGoodsListWithCurrentPage:_page firmId:self.storeModel.storeInfoVO.firmId success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        weakSelf.tableView.hidden = NO;
        weakSelf.noDataView.hidden = YES;
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:NO];
        weakSelf.tableView.hidden = NO;
        weakSelf.noDataView.hidden = YES;
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, 1, kScreenW, kScreenH - kNavBarHeight - 61);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 5.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:NSClassFromString(noticeCellID) forCellReuseIdentifier:noticeCellID];
    [self.tableView registerClass:NSClassFromString(ticketCellID) forCellReuseIdentifier:ticketCellID];
    [self.tableView registerClass:NSClassFromString(goodsCellID) forCellReuseIdentifier:goodsCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID];
}


#pragma mark - lazy load
- (NSMutableArray<GLBStoreGoodsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLBStoreTicketModel *> *)ticketArray{
    if (!_ticketArray) {
        _ticketArray = [NSMutableArray array];
    }
    return _ticketArray;
}


#pragma mark - setter
- (void)setStoreModel:(GLBStoreModel *)storeModel
{
    _storeModel = storeModel;
}

@end
