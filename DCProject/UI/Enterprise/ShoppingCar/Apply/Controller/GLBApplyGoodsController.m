//
//  GLBGoodsListController.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBApplyGoodsController.h"
#import "GLBGoodsListCell.h"

#import "GLBGoodsDetailController.h"

static NSString *const listCellID = @"GLBGoodsListCell";

@interface GLBApplyGoodsController ()

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray<GLBShoppingCarGoodsModel *> *dataArray;

@end

@implementation GLBApplyGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = self.carModel.suppierFirmName;

    [self setUpTableView];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.goodsModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBShoppingCarGoodsModel *goodsModel = self.dataArray[indexPath.row];
    
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
    vc.goodsId = goodsModel.goodsId;
    vc.batchId = goodsModel.batchId;
    [self dc_pushNextController:vc];
}



#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(10, kNavBarHeight + 10, kScreenW - 20, kScreenH - kNavBarHeight - 10);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    
    
    
    
    
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = self.bottomView;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 20, 72)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW  - 40, 36)];
        subLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
        subLabel.font = PFRFont(15);
        subLabel.textAlignment = NSTextAlignmentRight;
        subLabel.text = @"优惠：￥0";
        [_bottomView addSubview:subLabel];
        
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, kScreenW  - 40, 36)];
        totalLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
        totalLabel.font = PFRFont(15);
        totalLabel.textAlignment = NSTextAlignmentRight;
        totalLabel.text = @"小计：￥0";
        [_bottomView addSubview:totalLabel];
    }
    return _bottomView;
}

- (NSMutableArray<GLBShoppingCarGoodsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - setter
- (void)setCarModel:(GLBShoppingCarModel *)carModel
{
    _carModel = carModel;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_carModel.cartGoodsList];
    [self reloadTableViewWithDatas:self.dataArray hasNextPage:NO];
    
    self.navigationItem.title = _carModel.suppierFirmName;
    
    CGFloat money = 0;
    for (int i=0; i<_carModel.cartGoodsList.count; i++) {
        GLBShoppingCarGoodsModel *goodsModel = _carModel.cartGoodsList[i];
        money += (goodsModel.price *goodsModel.quantity);
    }
    
    UILabel *label1 = self.bottomView.subviews.firstObject;
    UILabel *label2 = self.bottomView.subviews.lastObject;
    
    label1.hidden = YES;
    label2.text = [NSString stringWithFormat:@"小计：￥%.2f",money];
}

@end
