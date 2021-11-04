//
//  GLBStoreFiltrateController.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreFiltrateController.h"
#import "DCTextField.h"

#import "GLBStoreFiltrateCell.h"

static NSString *const listCellID = @"GLBStoreFiltrateCell";

@interface GLBStoreFiltrateController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) UIView *searchView;
//@property (nonatomic, strong) DCTextField *searchTF;
//@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UIButton *restBtn;
@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) NSMutableArray<GLBStoreFiltrateModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GLBStoreFiltrateModel *> *selectedArray;

@end

@implementation GLBStoreFiltrateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0];
    
    
    [self requestStoreList];
}


- (void)setUpUI
{
    if ([self.view.subviews containsObject:self.tableView]) {
        return;
    }
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.cancelBtn];
//    [self.view addSubview:self.searchView];
//    [self.searchView addSubview:self.searchTF];
//    [self.searchView addSubview:self.searchImage];
    
    [self setUpTableView];
    
    [self.view addSubview:self.restBtn];
    [self.view addSubview:self.commintBtn];
    [self.view addSubview:self.line];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBStoreFiltrateCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithStoreModel:self.dataArray[indexPath.row] selectArray:self.selectedArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBStoreFiltrateModel *model = self.dataArray[indexPath.row];
    if (self.selectedArray.count == 0) {
        [self.selectedArray addObject:model];
    } else {
        
        GLBStoreFiltrateModel *selectedModel = nil;
        for (int i=0; i<self.selectedArray.count; i++) {
            GLBStoreFiltrateModel *subModel = self.selectedArray[i];
            if ([subModel.suppierFirmId isEqualToString:model.suppierFirmId]) {
                selectedModel = subModel;
            }
        }
        
        if (selectedModel) {
            [self.selectedArray removeObject:selectedModel];
        } else {
            [self.selectedArray addObject:model];
        }
    }
    
    [tableView reloadData];
    
    if (_filtrateBlock) {
        _filtrateBlock(self.selectedArray);
    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestStoreList];
    return YES;
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
    if (_completeBlock) {
        _completeBlock(self.selectedArray);
    }
    
    [self cancelBtnClick:nil];
}

- (void)restBtnClick:(UIButton *)button
{
    [self.selectedArray removeAllObjects];
    [self.tableView reloadData];
    
    if (_filtrateBlock) {
        _filtrateBlock(self.selectedArray);
    }
}



#pragma mark - 请求 获取商户数据
- (void)requestStoreList
{
    NSString *goodsName = _searchName ? _searchName : @"";
    NSString *catIds = _catIds ? _catIds : @"";
    
    [self.dataArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSearchStoreListWithBrand:@"" classify:catIds goodsName:goodsName goodsTagName:@"" isHot:@"" isPromotion:@"" manufactory:@"" packingSpec:@"" saleCtrl:@"" sort:@"" suppierFirmId:@"" suppierFirmName:@"" zyc:@"" currentPage:0 success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:response];
        }
        
        [weakSelf setUpUI];
        [weakSelf.tableView reloadData];
        
    } failture:^(NSError *_Nullable error) {
        
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    
    
    if (_frameType)
    {
          self.tableView.frame = CGRectMake(0, [_frameType floatValue] , kScreenW, 50*6);
    }
    else{
          self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, 50*6);
    }
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIView *)bgView{
    if (!_bgView) {
        
        
        CGFloat y = _frameType ? [_frameType floatValue] : kNavBarHeight + 40;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,  y, kScreenW, kScreenH -  y)];
        _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
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

//- (UIView *)searchView{
//    if (!_searchView) {
//        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 40, kScreenW, 50)];
//        _searchView.backgroundColor = [UIColor whiteColor];
//    }
//    return _searchView;
//}

//- (DCTextField *)searchTF{
//    if (!_searchTF) {
//        _searchTF = [[DCTextField alloc] initWithFrame:CGRectMake(15, 10, kScreenW - 30, 30)];
//        _searchTF.type = DCTextFieldTypeDefault;
//        _searchTF.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
//        _searchTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//        _searchTF.placeholder = @"输入商家名称";
//        _searchTF.font = PFRFont(12);
//        _searchTF.returnKeyType = UIReturnKeySearch;
//        _searchTF.delegate = self;
//        [_searchTF dc_cornerRadius:15];
//        _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
//        _searchTF.leftViewMode = UITextFieldViewModeAlways;
//    }
//    return _searchTF;
//}

//- (UIImageView *)searchImage{
//    if (!_searchImage) {
//        _searchImage = [[UIImageView alloc] init];
//        _searchImage.frame = CGRectMake(29, 18, 14, 14);
//        _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
//    }
//    return _searchImage;
//}

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

- (NSMutableArray<GLBStoreFiltrateModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLBStoreFiltrateModel *> *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


#pragma mark - setter
- (void)setSelectStoreArray:(NSMutableArray *)selectStoreArray
{
    _selectStoreArray = selectStoreArray;
    
    [self.selectedArray removeAllObjects];
    [self.selectedArray addObjectsFromArray:_selectStoreArray];
}

@end
