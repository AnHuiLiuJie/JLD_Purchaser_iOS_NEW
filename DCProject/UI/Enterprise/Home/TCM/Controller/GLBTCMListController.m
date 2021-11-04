//
//  GLBTCMListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTCMListController.h"
#import "GLBTCMHeadView.h"
#import "GLBTCMShopCell.h"

#import "GLBAdvModel.h"

#import "GLBTCMGoodsController.h"
#import "GLBStorePageController.h"
#import "GLBGoodsDetailController.h"
#import "GLBExhibtPageController.h"

static NSString *const listCellID = @"GLBTCMShopCell";

@interface GLBTCMListController ()<UITextFieldDelegate>

@property (nonatomic, strong) GLBTCMHeadView *headView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<GLBAdvModel *> *bannerArray;

@end

@implementation GLBTCMListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"中药馆";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F1EA"];
    
    [self setUpTableView];
    
    [self addRefresh:YES];
    [self requestBannerData];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestTCMStoreList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestTCMStoreList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBTCMShopCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.listModel = self.dataArray[indexPath.section];
    WEAKSELF;
    cell.goodsBlock = ^(GLBStoreListGoodsModel *goodsModel) {
        [weakSelf dc_pushGoodsDetailController:goodsModel];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBStorePageController *vc = [GLBStorePageController new];
    vc.firmId = [self.dataArray[indexPath.section] firmId];
    [self dc_pushNextController:vc];
}


#pragma mark -
- (void)dc_pushGoodsDetailController:(GLBStoreListGoodsModel *)goodsModel
{
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
    vc.goodsId = goodsModel.goodsId;
    [self dc_pushNextController:vc];
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜素内容"];
        return NO;
    }
    
    [textField resignFirstResponder];
    GLBTCMGoodsController *vc = [GLBTCMGoodsController new];
    vc.searchStr = textField.text;
    [self dc_pushNextController:vc];
    return YES;
}

#pragma mark - action
- (void)headViewBtnClick:(NSInteger)tag
{
    GLBTCMGoodsController *vc = [GLBTCMGoodsController new];
    if (tag == 100) {
        vc.goodsType = GLBTCMGoodsTypeJrth;
    } else if (tag == 101) {
        vc.goodsType = GLBTCMGoodsTypeZshy;
    } else if (tag == 102) {
        vc.goodsType = GLBTCMGoodsTypeJptj;
    }
    [self dc_pushNextController:vc];
}


#pragma mark - aciton
- (void)dc_pushController:(GLBAdvModel *)model
{
    if ([model.adType isEqualToString:@"1"]) { // 商品广告
        
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.goodsId = model.adInfoId;
        [self dc_pushNextController:vc];
        
    } else if ([model.adType isEqualToString:@"2"]) { //企业广告
        
        GLBStorePageController *vc = [GLBStorePageController new];
        vc.firmId = model.adInfoId;
        [self dc_pushNextController:vc];
        
    } else if ([model.adType isEqualToString:@"3"]) { //资讯广告
        
        NSString *params = [NSString stringWithFormat:@"id=%@",model.adInfoId];
        [self dc_pushWebController:@"/public/infor_detail.html" params:params];
        
    } else if ([model.adType isEqualToString:@"4"]) { //展会广告
        
        GLBExhibtPageController *vc = [GLBExhibtPageController new];
        vc.iD = model.adInfoId;
        [self dc_pushNextController:vc];
        
    } else {
        
        if (DC_CanOpenUrl(model.adLinkUrl)) {
            DC_OpenUrl(model.adLinkUrl);
        }
    }
}


#pragma mark - 请求 banner图数据
- (void)requestBannerData
{
    [self.bannerArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAdvWithCode:@"AD_APP_CHA" success:^(id response) {
        if (response && [response count]>0) {
            [weakSelf.bannerArray addObjectsFromArray:response];
            
            NSMutableArray *imgurlArray = [NSMutableArray array];
            [weakSelf.bannerArray enumerateObjectsUsingBlock:^(GLBAdvModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSString *imageUrl = obj.adContent;
                [imgurlArray addObject:imageUrl];
            }];
            
            weakSelf.headView.scrollView.imageURLStringsGroup = nil;
            weakSelf.headView.scrollView.imageURLStringsGroup = imgurlArray;
        }
    } failture:^(NSError *_Nullable error) {
        
    }];
}


#pragma mark - 请求 中药馆店铺列表
- (void)requestTCMStoreList:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestTCMStoreListWithCurrentPage:_page coupon:@"" firmName:@"" isShowGoods:@"" maxMoney:0 minMoney:0 promotion:@"" scope:@"" sortField:@"" sortMode:@"" success:^(NSArray *array, BOOL hasNextPage) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
        
    } failture:^(NSError *error) {
        
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
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
    self.tableView.tableHeaderView = self.headView;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (GLBTCMHeadView *)headView{
    if (!_headView) {
        
        CGFloat height = 0.46*kScreenW + 13 + (kScreenW - 10*2 - 1)/2 + 20 + 0.16*0.76*kScreenW + 13;
        
        _headView = [[GLBTCMHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, height)];
        _headView.textField.returnKeyType = UIReturnKeySearch;
        WEAKSELF;
        _headView.headViewBlock = ^(NSInteger tag) {
            [weakSelf headViewBtnClick:tag];
        };
        _headView.scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            [weakSelf dc_pushController:weakSelf.bannerArray[currentIndex]];
        };
        _headView.textField.delegate = self;
    }
    return _headView;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLBAdvModel *> *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

@end
