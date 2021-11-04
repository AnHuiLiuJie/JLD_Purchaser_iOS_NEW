//
//  GLBShoppingCarController.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBShoppingCarController.h"

#import "GLBShoppingCarCell.h"
#import "GLBShoppingCarBottomView.h"
#import "DCNoDataView.h"

#import "GLBSgnTicketSelectController.h"
#import "GLBApplyController.h"
#import "GLBGoodsDetailController.h"

#import "GLBCountTFView.h"

static NSString *const listCellID = @"GLBShoppingCarCell";

@interface GLBShoppingCarController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLBShoppingCarBottomView *bottomView;
@property (nonatomic, strong) DCNoDataView *noDataView;
@property (nonatomic, strong) GLBCountTFView *countTFView;

@property (nonatomic, strong) NSMutableArray<GLBShoppingCarModel *> *dataArray;
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) NSInteger changeCount; // 每次加减的数量
@property (nonatomic, assign) NSInteger minCount; //最小起订量

@end

@implementation GLBShoppingCarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[DCLoginTool shareTool] dc_isLogin]) {
        
        [self.dataArray removeAllObjects];
        [self dc_reloadView];
        
    } else {
        [self requestShoppingCarList];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" color:[UIColor dc_colorWithHexString:@"#303D55"] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(managerAction:)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.noDataView];
    
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
    GLBShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.shoppingCarModel = self.dataArray[indexPath.section];
    cell.reloadBlock = ^{
        [weakSelf.tableView reloadData];
    };
    cell.ticketBtnBlock = ^{
        [weakSelf presentTicketSelectController:indexPath];
    };
    cell.countViewBlock = ^(GLBEditCountView *countView, NSInteger type, NSInteger index) {
        [weakSelf dc_responseCountActionWith:countView type:type index:index indexPath:indexPath];
    };
    cell.cellEditBlock = ^(GLBShoppingCarModel *shoppingCarModel) {
        [weakSelf dc_responseEventWith:shoppingCarModel indexPath:indexPath];
    };
    cell.carGoodsBlock = ^(GLBShoppingCarGoodsModel *goodsModel) {
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


#pragma mark - action
- (void)managerAction:(id)sender
{
    _isEdit =! _isEdit;
    
    if (_isEdit) {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"取消" color:[UIColor dc_colorWithHexString:@"#303D55"] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(managerAction:)];
        
    } else {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"管理" color:[UIColor dc_colorWithHexString:@"#303D55"] font:[UIFont fontWithName:PFRMedium size:14] target:self action:@selector(managerAction:)];
    }
    
    self.bottomView.isEdit = _isEdit;
}



#pragma mark -
- (void)presentTicketSelectController:(NSIndexPath *)indexPath
{
    GLBShoppingCarModel *carModel = self.dataArray[indexPath.section];
    NSString *goodsId = @"";
    if (carModel.cartGoodsList && [carModel.cartGoodsList count] > 0) {
        for (int i=0; i<carModel.cartGoodsList.count; i++) {
            GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[i];
            if (goodsId.length == 0) {
                goodsId = goodsModel.goodsId;
            } else {
                goodsId = [NSString stringWithFormat:@"%@,%@",goodsId,goodsModel.goodsId];
            }
        }
    }
    
    GLBSgnTicketSelectController *vc = [GLBSgnTicketSelectController new];
    vc.storeId = [carModel suppierFirmId];
    vc.goodsId = goodsId;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [DC_KeyWindow.rootViewController addChildViewController:vc];
    [DC_KeyWindow.rootViewController.view addSubview:vc.view];
    
//    [DC_KeyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}


#pragma mark -
- (void)dc_pushGoodsDetailController:(GLBShoppingCarGoodsModel *)goodsModel
{
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
    vc.goodsId = goodsModel.goodsId;
    vc.batchId = goodsModel.batchId;
    [self dc_pushNextController:vc];
}

#pragma mark - 响应cell上的选择事件
- (void)dc_responseEventWith:(GLBShoppingCarModel *)carModel indexPath:(NSIndexPath *)indexPath
{
    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:carModel];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    self.bottomView.dataArray = self.dataArray;
}


#pragma mark - 响应cell上的数量事件
- (void)dc_responseCountActionWith:(GLBEditCountView *)countView type:(NSInteger)type index:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    // 计算步长 与最小起订量
    [self dc_setValueWith:countView type:type index:index indexPath:indexPath];
    
    if (type == 1) { // 加
        
        NSInteger count = [countView.countTF.text integerValue];
        count += _changeCount;
        [self requestChangeCarGoodsCountWithCount:count index:index indexPath:indexPath];
        
    } else if (type == 2) { // 减
        
        NSInteger count = [countView.countTF.text integerValue];
        count -= _changeCount;
        if (count < _minCount) {
            [SVProgressHUD showInfoWithStatus:@"不能小于最小起订量"];
            return;
        }
        [self requestChangeCarGoodsCountWithCount:count index:index indexPath:indexPath];
        
    } else if (type == 3) { // 编辑
        
        if (![DC_KeyWindow.subviews containsObject:self.countTFView]) {
            [DC_KeyWindow addSubview:self.countTFView];
            self.countTFView.textField.text = countView.countTF.text;
            WEAKSELF;
            self.countTFView.successBlock = ^{
                NSInteger count = [weakSelf.countTFView.textField.text integerValue];
                if (count < weakSelf.minCount) {
                    [SVProgressHUD showInfoWithStatus:@"不能小于最小起订量"];
                    return;
                }
                NSInteger aaaaaa = count % weakSelf.changeCount;
                if (aaaaaa != 0) {
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"该产品的包装量为%ld瓶,购买数量只能为%ld的整数倍！",weakSelf.changeCount,weakSelf.changeCount]];
                    return;
                }
                
                [weakSelf requestChangeCarGoodsCountWithCount:count index:index indexPath:indexPath];
            };
            
            [self.countTFView.textField becomeFirstResponder];
            [self.countTFView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(DC_KeyWindow);
            }];
        }
    }
}


#pragma mark - 计算数量
- (void)dc_setValueWith:(GLBEditCountView *)countView type:(NSInteger)type index:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    GLBShoppingCarModel *carModel = self.dataArray[indexPath.section];
    GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[index];
    GLBShoppingCarGoodsInfoModel *infoModel = goodsModel.goodsAttribute;
    
    // 单价
    CGFloat price = goodsModel.price;
    if (goodsModel.hasCtrl) {
        price = goodsModel.ctrlPrice;
    }
    
    if (infoModel.sellType == 2) { //整售
        NSInteger pkgCount = [infoModel.pkgPackingNum integerValue]; // 件装量
        NSInteger minCount = [infoModel.wholeMinBuyNum integerValue]; // 最小起订量
        
        _changeCount = pkgCount;
        _minCount = minCount;
        
        //  TODO 这里未区分整售与零售并存的情况，统一按零售处理了
    } else if (infoModel.sellType == 4 || infoModel.sellType == 3) { // 零售
        
        if ([infoModel.zeroSellType isEqualToString:@"1"]) { // 拆零中包
            
            if ([infoModel.zeroMinType isEqualToString:@"1"]) { // 按最小起订数量计算
                NSInteger pkgCount = [infoModel.zeroPackNum integerValue]; // 中包件装量
                NSInteger minCount = [infoModel.zeroMinBuy integerValue]; // 最小起订量
                
                _changeCount = pkgCount;
                _minCount = minCount;
                
            } else if ([infoModel.zeroMinType isEqualToString:@"2"]) { // 按最小起订金额计算
                
                CGFloat minPrice = [infoModel.zeroMinBuy floatValue]; // 最小起金额
                CGFloat mine = minPrice / price; // 最小起订量 带小数点
                NSInteger minCount = mine;
                NSString *string = [NSString stringWithFormat:@"%f",mine];
                if ([string containsString:@"."]) {
                    string = [[NSString stringWithFormat:@"%f",mine] componentsSeparatedByString:@"."][1];
                }
 
                if ([string floatValue] > 0) {
                    minCount += 1;
                }
                NSInteger pkgCount = [infoModel.zeroPackNum integerValue]; // 中包件装量
                
                _changeCount = pkgCount;
                _minCount = minCount;
            }
            
        } else if ([infoModel.zeroSellType isEqualToString:@"2"]) { // 拆零小包
            
            if ([infoModel.zeroMinType isEqualToString:@"1"]) { // 按最小起订数量计算
                
                NSInteger minCount = [infoModel.zeroMinBuy integerValue]; // 最小起订量
                
                _changeCount = 1;
                _minCount = minCount;
                
            } else if ([infoModel.zeroMinType isEqualToString:@"2"]) { // 按最小起订金额计算
                
                NSInteger minPrice = [infoModel.zeroMinBuy integerValue]; // 最小起金额
                CGFloat mine = minPrice / price; // 最小起订量 带小数点
                NSInteger minCount = mine; // 转化为最小起订数量
                NSString *string = [NSString stringWithFormat:@"%f",mine];
                if ([string containsString:@"."]) {
                    string = [[NSString stringWithFormat:@"%f",mine] componentsSeparatedByString:@"."][1];
                }
                if ([string floatValue] > 0) {
                    minCount += 1;
                } // 转化为最小起订数量
                
                _changeCount = 1;
                _minCount = minCount;
            }
        }
    }
}


#pragma mark - 点击底部按钮 全选按钮
- (void)dc_bottomViewSelectBtnClick:(UIButton *)button
{
    for (int i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarModel *carModel = self.dataArray[i];
        carModel.isSelected = button.selected;
        
        NSMutableArray *goodsArray = [carModel.cartGoodsList mutableCopy];
        for (int j=0; j<goodsArray.count; j++) {
            GLBShoppingCarGoodsModel *goodsModel = goodsArray[j];
            goodsModel.isSelected = button.isSelected;
            [goodsArray replaceObjectAtIndex:j withObject:goodsModel];
        }
        carModel.cartGoodsList = [goodsArray copy];
        
        [self.dataArray replaceObjectAtIndex:i withObject:carModel];
    }
    
    [self dc_reloadView];
    self.bottomView.dataArray = self.dataArray;
}


#pragma mark - 点击底部按钮 删除
- (void)dc_bottomViewDeleteBtnClick:(UIButton *)button
{
    NSString *cartIds = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarModel *carModel = self.dataArray[i];
        for (int j=0; j<carModel.cartGoodsList.count; j++) {
            GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[j];
            if (goodsModel.isSelected) {
                if (cartIds.length == 0) {
                    cartIds = [NSString stringWithFormat:@"%ld",goodsModel.cartId];
                } else {
                    cartIds = [NSString stringWithFormat:@"%@,%@",cartIds,[NSString stringWithFormat:@"%ld",goodsModel.cartId]];
                }
            }
        }
    }
    
    if ([cartIds length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择删除的商品"];
        return;
    }
    
    [self requestDeleteCarGoodsWithCarIds:cartIds];
}


#pragma mark - 点击底部按钮 加入收藏
- (void)dc_bottomViewCollectBtnClick:(UIButton *)button
{
    NSString *cartIds = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarModel *carModel = self.dataArray[i];
        for (int j=0; j<carModel.cartGoodsList.count; j++) {
            GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[j];
            if (goodsModel.isSelected) {
                if (cartIds.length == 0) {
                    cartIds = [NSString stringWithFormat:@"%ld",goodsModel.cartId];
                } else {
                    cartIds = [NSString stringWithFormat:@"%@,%@",cartIds,[NSString stringWithFormat:@"%ld",goodsModel.cartId]];
                }
            }
        }
    }
    
    if ([cartIds length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择收藏的商品"];
        return;
    }
    
    [self requestCollectCarGoodsWithCarIds:cartIds];
}

#pragma mark - 点击底部按钮 结算
- (void)dc_bottomViewPayBtnClick:(UIButton *)button
{
    NSString *cartIds = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarModel *carModel = self.dataArray[i];
        for (int j=0; j<carModel.cartGoodsList.count; j++) {
            GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[j];
            if (goodsModel.isSelected) {
                if (cartIds.length == 0) {
                    cartIds = [NSString stringWithFormat:@"%ld",goodsModel.cartId];
                } else {
                    cartIds = [NSString stringWithFormat:@"%@,%@",cartIds,[NSString stringWithFormat:@"%ld",goodsModel.cartId]];
                }
            }
        }
    }
    
    if ([cartIds length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择结算的商品"];
        return;
    }
    
    [self requestPayCarGoodsWithCarIds:cartIds];
}


#pragma mark - 刷新
- (void)dc_reloadView
{
    if (self.dataArray.count == 0) {
        self.noDataView.hidden = NO;
        self.bottomView.hidden = YES;
    } else {
        self.noDataView.hidden = YES;
        self.bottomView.hidden = NO;
    }
    [self.tableView reloadData];
}


#pragma mark - 请求 购物车商品
- (void)requestShoppingCarList
{
    [self.dataArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestShoppingCarListWithSuccess:^(id response) {
        if (response && [response count]>0) {
            [weakSelf.dataArray addObjectsFromArray:response];
        }
        [weakSelf dc_reloadView];
        
    } failture:^(NSError *error) {
        [weakSelf dc_reloadView];
    }];
}


#pragma mark - 请求 改变购物车商品数量
- (void)requestChangeCarGoodsCountWithCount:(NSInteger)count index:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    GLBShoppingCarModel *carModel = self.dataArray[indexPath.section];
    GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[index];
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestChangeGoodsCountWithBatchId:goodsModel.batchId goodsId:goodsModel.goodsId cartId:[NSString stringWithFormat:@"%ld",(long)goodsModel.cartId] quantity:count success:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictionary = response[@"data"];
                NSString *price = dictionary[@"price"];
                if (!price || [price dc_isNull] || price.length == 0) {
                    price = [NSString stringWithFormat:@"%.2f",goodsModel.price];
                }
                
                NSMutableArray *newArray = [carModel.cartGoodsList mutableCopy];
                goodsModel.price = [price floatValue];
                goodsModel.quantity = count;
                [newArray replaceObjectAtIndex:index withObject:goodsModel];
                carModel.cartGoodsList = newArray;
                [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:carModel];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                
                weakSelf.bottomView.dataArray = weakSelf.dataArray;
            }
//            [weakSelf requestShoppingCarList];
        }
    } failture:^(NSError *error) {
        
        [weakSelf dc_reloadView];
    }];
}

#pragma mark - 请求 删除商品
- (void)requestDeleteCarGoodsWithCarIds:(NSString *)carIds
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDeleteShoppingCarWithCartIds:carIds success:^(id response) {
        if (response) {
            [weakSelf requestShoppingCarList];
        }
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark - 请求 收藏商品
- (void)requestCollectCarGoodsWithCarIds:(NSString *)carIds
{
    [[DCAPIManager shareManager] dc_requestAddCollectWithInfoId:carIds success:^(id response) {
        if (response ) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 下单
- (void)requestPayCarGoodsWithCarIds:(NSString *)carIds
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestShoppingCarCommintWithCartIds:carIds success:^(id response) {
        if (response && [response count] > 0) {
            
            NSArray *array = response;
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSInteger i=0; i<array.count; i++) {
                GLBShoppingCarModel *shoppingCarModel = array[i];
                if (shoppingCarModel.coupon && shoppingCarModel.coupon.cashCouponId > 0) {
                    shoppingCarModel.ticketModel = shoppingCarModel.coupon;
                }
                [dataArray addObject:shoppingCarModel];
            }
            
            GLBApplyController *vc = [GLBApplyController new];
            vc.listArray = dataArray;
            [weakSelf dc_pushNextController:vc];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat tabHeight = self.navigationController.childViewControllers.count > 1 ? 0 : kTabBarHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - tabHeight - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 10.0f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    }
    return _tableView;
}

- (GLBShoppingCarBottomView *)bottomView{
    if (!_bottomView) {
        
        CGFloat tabHeight = self.navigationController.childViewControllers.count > 1 ? 0 : kTabBarHeight;
        
        _bottomView = [[GLBShoppingCarBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - tabHeight - 50, kScreenW, 50)];
        WEAKSELF;
        _bottomView.payBtnClick = ^{
            [weakSelf dc_bottomViewPayBtnClick:nil];
        };
        _bottomView.selectBtnClick = ^(UIButton *button) {
            [weakSelf dc_bottomViewSelectBtnClick:button];
        };
        _bottomView.deleteBtnClick = ^{
            [weakSelf dc_bottomViewDeleteBtnClick:nil];
        };
        _bottomView.collectBtnClick = ^{
            [weakSelf dc_bottomViewCollectBtnClick:nil];
        };
        
    }
    return _bottomView;
}


#pragma mark - lazy load
- (GLBCountTFView *)countTFView{
    if (!_countTFView) {
        _countTFView = [[GLBCountTFView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _countTFView;
}


- (DCNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight) image:[UIImage imageNamed:@"none"] button:nil tip:@""];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}


- (NSMutableArray<GLBShoppingCarModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
