//
//  GLBOtherFiltrateController.m
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOtherFiltrateController.h"

#import "GLBOtherFiltrateCell.h"
#import "GLBRankFiltrateCell.h"
#import "GLBOtherFiltrateHeadView.h"

static NSString *otherCellID = @"GLBOtherFiltrateCell";
static NSString *rankCellID = @"GLBRankFiltrateCell";
static NSString *sectionID = @"GLBOtherFiltrateHeadView";

@interface GLBOtherFiltrateController ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *restBtn;
@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) NSMutableArray *companyArray;
@property (nonatomic, strong) NSMutableArray *selectCompanyArray;
@property (nonatomic, strong) NSMutableArray *packageArray;
@property (nonatomic, strong) NSMutableArray *selectPackageArray;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) NSMutableArray *selectTypeArray;
@property (nonatomic, assign) BOOL companyIsOpen;
@property (nonatomic, assign) BOOL packageIsOpen;


@end

@implementation GLBOtherFiltrateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0];
    
    [self.typeArray addObjectsFromArray:@[@"有促销活动",@"可领券"]];
    
    [self requestCompanyList];
    [self requestPackageList];
    
    [self setUpUI];
}


- (void)setUpUI
{
    if ([self.view.subviews containsObject:self.tableView]) {
        return;
    }
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.cancelBtn];
    [self setUpTableView];
    [self.view addSubview:self.restBtn];
    [self.view addSubview:self.commintBtn];
    [self.view addSubview:self.line];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (self.companyArray.count > 5 && !self.companyIsOpen) {
            NSArray *array = [self.companyArray subarrayWithRange:NSMakeRange(0, 5)];
            return array.count;
        }
        return self.companyArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WEAKSELF;
    if (indexPath.section == 0) {
        
        GLBOtherFiltrateCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherCellID forIndexPath:indexPath];
        [otherCell setTypeValueWithTypeArray:self.typeArray selectTypeArray:self.selectTypeArray];
        otherCell.otherCellBlock = ^(NSInteger tag) {
            [weakSelf dc_clickTypeItem:tag];
        };
        cell = otherCell;
        
    } else if (indexPath.section == 1) {
        
        GLBRankFiltrateCell *rankCell = [tableView dequeueReusableCellWithIdentifier:rankCellID forIndexPath:indexPath];
        if (self.companyArray.count > 9 && !self.companyIsOpen) {
            NSArray *array = [self.companyArray subarrayWithRange:NSMakeRange(0, 9)];
            [rankCell setCompanyValueWithCompanyArray:array indexPath:indexPath selectCompanyArray:self.selectCompanyArray];
        } else {
            [rankCell setCompanyValueWithCompanyArray:self.companyArray indexPath:indexPath selectCompanyArray:self.selectCompanyArray];
        }
        cell = rankCell;
        
    } else {
        
        GLBOtherFiltrateCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherCellID forIndexPath:indexPath];
        if (self.packageArray.count > 9 && !self.packageIsOpen) {
            NSArray *array = [self.packageArray subarrayWithRange:NSMakeRange(0, 9)];
            [otherCell setPackageValueWithPackageArray:array selectPackageArray:self.selectPackageArray];
        } else {
            [otherCell setPackageValueWithPackageArray:self.packageArray selectPackageArray:self.selectPackageArray];
        }
        otherCell.otherCellBlock = ^(NSInteger tag) {
            [weakSelf dc_clickPackageItem:tag];
        };
        cell = otherCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    if (indexPath.section == 1) {
        return 40;
    }
    
    
    NSArray *array = [self.packageArray copy];
    if (self.packageArray.count > 9 && !self.packageIsOpen) {
        array = [self.packageArray subarrayWithRange:NSMakeRange(0, 9)];
    }
    NSInteger line = 0;
    if (array.count > 0) {
        line = (array.count - 1)/3 + 1;
    }
    CGFloat height = 0;
    if (line > 0) {
        height = 10 + (40+10)*line;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UITableViewHeaderFooterView new];
    }
    GLBOtherFiltrateHeadView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    if (section == 1) {
        header.titleLabel.text = @"厂家";
    } else {
        header.titleLabel.text = @"规格包装";
    }
    WEAKSELF;
    header.openBtnBlock = ^{
        if (section == 1) {
            weakSelf.companyIsOpen =! weakSelf.companyIsOpen;
        }
        if (section == 2) {
            weakSelf.packageIsOpen =! weakSelf.packageIsOpen;
        }
        
        [weakSelf.tableView reloadData];
    };
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        GLBFactoryModel *companyModel = self.companyArray[indexPath.row];
    
        GLBFactoryModel *isSelectedModel = nil;
        for (int i=0; i<self.selectCompanyArray.count; i++) {
            GLBFactoryModel *selectModel = self.selectCompanyArray[i];
            if ([selectModel.factoryName isEqualToString:companyModel.factoryName]) {
                isSelectedModel = selectModel;
            }
        }
        
        if (isSelectedModel) {
            [self.selectCompanyArray removeObject:isSelectedModel];
        } else {
            [self.selectCompanyArray addObject:companyModel];
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - 点击类型按钮
- (void)dc_clickTypeItem:(NSInteger)tag
{
    NSString *title = self.typeArray[tag];
    if ([self.selectTypeArray containsObject:title]) {
        [self.selectTypeArray removeObject:title];
    } else {
        [self.selectTypeArray addObject:title];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - 点击规格按钮
- (void)dc_clickPackageItem:(NSInteger)tag
{
    GLBPackageModel *model = self.packageArray[tag];
    
    GLBPackageModel *isSelectModel = nil;
    for (int j = 0; j<self.selectPackageArray.count; j++) {
        GLBPackageModel *selectModel = self.selectPackageArray[j];
        if ([selectModel.specs isEqualToString:model.specs]) {
            isSelectModel = selectModel;
        }
    }
    
    if (isSelectModel) { //已选中
        [self.selectPackageArray removeObject:isSelectModel];
    } else {
        [self.selectPackageArray addObject:model];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view removeFromSuperview];
    
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)commintBtnClick:(UIButton *)button
{
    if (_successBlock) {
        _successBlock(self.selectTypeArray,self.selectCompanyArray,self.selectPackageArray);
    }
    
    [self cancelBtnClick:nil];
}

- (void)restBtnClick:(UIButton *)button
{
    [self.selectTypeArray removeAllObjects];
    [self.selectCompanyArray removeAllObjects];
    [self.selectPackageArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - 请求 厂家列表
- (void)requestCompanyList
{
    NSString *catIds = _catIds ? _catIds : @"";
    NSString *goodsName = _searchName ? _searchName : @"";
    NSString *entrance = _entrance ? _entrance : @"";
    NSString *prodType = _prodType ? _prodType : @"";
    NSString *isPromotion = _isPromotion ? _isPromotion : @"";
    
    NSString *suppierFirmId = @"";
    if (self.userStoreArray.count > 0) {
        for (int i=0; i<self.userStoreArray.count; i++) {
            GLBStoreFiltrateModel *storeModel = self.userStoreArray[i];
            if (i == 0) {
                suppierFirmId = [NSString stringWithFormat:@"%@",storeModel.suppierFirmId];
            } else {
                suppierFirmId = [NSString stringWithFormat:@"%@,%@",suppierFirmId,storeModel.suppierFirmId];
            }
        }
    }
    
    [self.companyArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSearchCompanyListWithCurrentPage:1 catIds:catIds entrance:entrance goodsName:goodsName isCoupon:@"" isPromotion:isPromotion manufactory:@"" packingSpec:@"" prodType:prodType sort:@"" suppierFirmId:suppierFirmId success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.companyArray addObjectsFromArray:response];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 规格列表
- (void)requestPackageList
{
    NSString *catIds = _catIds ? _catIds : @"";
    NSString *goodsName = _searchName ? _searchName : @"";
    NSString *entrance = _entrance ? _entrance : @"";
    NSString *prodType = _prodType ? _prodType : @"";
    NSString *isPromotion = _isPromotion ? _isPromotion : @"";
    
    NSString *suppierFirmId = @"";
    if (self.userStoreArray.count > 0) {
        for (int i=0; i<self.userStoreArray.count; i++) {
            GLBStoreFiltrateModel *storeModel = self.userStoreArray[i];
            if (i == 0) {
                suppierFirmId = [NSString stringWithFormat:@"%@",storeModel.suppierFirmId];
            } else {
                suppierFirmId = [NSString stringWithFormat:@"%@,%@",suppierFirmId,storeModel.suppierFirmId];
            }
        }
    }
    
    [self.packageArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSearchPackageListWithCurrentPage:1 catIds:catIds entrance:entrance goodsName:goodsName isCoupon:@"" isPromotion:isPromotion manufactory:@"" packingSpec:@"" prodType:prodType sort:@"" suppierFirmId:suppierFirmId success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.packageArray addObjectsFromArray:response];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if (_frameType)
    {
          self.tableView.frame = CGRectMake(0, [_frameType floatValue] , kScreenW, kScreenH - [_frameType floatValue] - 44);
    }
    else{
          self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40 - 44);
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 36.0f;
    self.tableView.sectionHeaderHeight = 50.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(otherCellID) forCellReuseIdentifier:otherCellID];
    [self.tableView registerClass:NSClassFromString(rankCellID) forCellReuseIdentifier:rankCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID
     ];
    
}


#pragma mark - lazy load
- (UIView *)bgView{
    if (!_bgView) {
        
        CGFloat y = _frameType ? [_frameType floatValue] : kNavBarHeight + 40;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,  y, kScreenW, kScreenH -  y)];

        _bgView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor alpha:1];
    }
    return _bgView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = [UIScreen mainScreen].bounds;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)restBtn{
    if (!_restBtn) {
        _restBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _restBtn.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenW/2, 44);
        _restBtn.backgroundColor = [UIColor whiteColor];
        [_restBtn setTitle:@"重置" forState:0];
        [_restBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
        _restBtn.titleLabel.font = PFRFont(14);
        [_restBtn addTarget:self action:@selector(restBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restBtn;
}

- (UIButton *)commintBtn{
    if (!_commintBtn) {
        _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commintBtn.frame = CGRectMake(kScreenW/2, CGRectGetMaxY(self.tableView.frame), kScreenW/2, 44);
        _commintBtn.backgroundColor = [UIColor whiteColor];
        [_commintBtn setTitle:@"确定" forState:0];
        [_commintBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
        _commintBtn.titleLabel.font = PFRFont(14);
        [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commintBtn;
}

- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc] init];
        _line.frame = CGRectMake(kScreenW/2, CGRectGetMinY(self.restBtn.frame), 1, CGRectGetHeight(self.restBtn.frame));
        _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    }
    return _line;
}

- (NSMutableArray *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (NSMutableArray *)selectTypeArray{
    if (!_selectTypeArray) {
        _selectTypeArray = [NSMutableArray array];
    }
    return _selectTypeArray;
}

- (NSMutableArray *)companyArray{
    if (!_companyArray) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}

- (NSMutableArray *)selectCompanyArray{
    if (!_selectCompanyArray) {
        _selectCompanyArray = [NSMutableArray array];
    }
    return _selectCompanyArray;
}

- (NSMutableArray *)packageArray{
    if (!_packageArray) {
        _packageArray = [NSMutableArray array];
    }
    return _packageArray;
}

- (NSMutableArray *)selectPackageArray{
    if (!_selectPackageArray) {
        _selectPackageArray = [NSMutableArray array];
    }
    return _selectPackageArray;
}


#pragma mark - setter
- (void)setUserTypeArray:(NSArray *)userTypeArray
{
    _userTypeArray = userTypeArray;
    
    [self.selectTypeArray removeAllObjects];
    [self.selectTypeArray addObjectsFromArray:_userTypeArray];
}


- (void)setUserCompanyArray:(NSArray *)userCompanyArray
{
    _userCompanyArray = userCompanyArray;
    
    [self.selectCompanyArray removeAllObjects];
    [self.selectCompanyArray addObjectsFromArray:_userCompanyArray];
}


- (void)setUserPackageArray:(NSArray *)userPackageArray
{
    _userPackageArray = userPackageArray;
    
    [self.selectPackageArray removeAllObjects];
    [self.selectPackageArray addObjectsFromArray:_userPackageArray];
}


@end
