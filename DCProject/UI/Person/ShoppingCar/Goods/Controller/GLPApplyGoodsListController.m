//
//  GLPApplyGoodsListController.m
//  DCProject
//
//  Created by bigbing on 2019/9/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPApplyGoodsListController.h"

#import "GLPApplyGoodsListCell.h"
#import "GLPShoppingCarGoodsSectionView.h"
#import "GLPGoodsDetailsController.h"

static NSString *const listCellID = @"GLPApplyGoodsListCell";
static NSString *const sectionID = @"GLPShoppingCarGoodsSectionView";

#define kRowHeight 186
#define KSectionHeight 53

@interface GLPApplyGoodsListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLPApplyGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _carModel.sellerFirmName;
    
    [self setUpUI];
    
    
    [self.dataArray removeAllObjects];
    if (_carModel.validActInfoList && _carModel.validActInfoList.count > 0) {
        for (int i=0; i<_carModel.validActInfoList.count; i++) {
            GLPShoppingCarActivityModel *activityModel = _carModel.validActInfoList[i];
            
            NSMutableArray *actCartGoodsList = [NSMutableArray array];
            for (int j = 0; j<activityModel.actCartGoodsList.count; j++) {
                GLPShoppingCarActivityGoodsModel *goodsModel = activityModel.actCartGoodsList[j];
                if (goodsModel.isSelected) {
                    [actCartGoodsList addObject:goodsModel];
                }
            }
            if (actCartGoodsList.count > 0) {
                activityModel.actCartGoodsList = actCartGoodsList;
                [self.dataArray addObject:@[activityModel]];
            }
        }
    }
    if (_carModel.validNoActGoodsList && _carModel.validNoActGoodsList.count > 0) {
        NSMutableArray *validNoActGoodsList = [NSMutableArray array];
        for (int i=0; i<_carModel.validNoActGoodsList.count; i++) {
            GLPShoppingCarNoActivityModel *noActivityModel = _carModel.validNoActGoodsList[i];
            if (noActivityModel.isSelected) {
                [validNoActGoodsList addObject:noActivityModel];
            }
        }
        if (validNoActGoodsList.count > 0) {
            [self.dataArray addObject:validNoActGoodsList];
        }
    }
    [self.tableView reloadData];
}


- (void)setUpUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kRowHeight;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    _tableView.tableFooterView = [UIView new];
    
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [_tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID];
    [self.view addSubview:_tableView];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
    
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) {
            
            GLPShoppingCarActivityModel *carActivityModel = class;
            return [carActivityModel.actCartGoodsList count];
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
            return [array count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPApplyGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
            
            GLPShoppingCarActivityModel *carActivityModel = class;
            cell.actGoodsModel = carActivityModel.actCartGoodsList[indexPath.row];
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
            cell.noActgoodsModel = array[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) {
            return KSectionHeight;
        }
    }
    return 0.01;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if (![class isKindOfClass:[GLPShoppingCarActivityModel class]]) {
            return [UITableViewHeaderFooterView new];
        }
    } else {
        return [UITableViewHeaderFooterView new];
    }
    
    GLPShoppingCarGoodsSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    header.acticityModel = array[0];
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *goodsId = @"";
    
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
            
            GLPShoppingCarActivityModel *carActivityModel = class;
            GLPShoppingCarActivityGoodsModel *goodsModel = carActivityModel.actCartGoodsList[indexPath.row];
            
            goodsId = goodsModel.goodsId;
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
            GLPShoppingCarNoActivityModel *noActivityModel = array[indexPath.row];
            
            goodsId = noActivityModel.goodsId;
        }
    }
    
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = goodsId;
    vc.firmId = [NSString stringWithFormat:@"%ld",self.carModel.sellerFirmId];
    vc.detailType = GLPGoodsDetailTypeNormal;
    [self dc_pushNextController:vc];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
