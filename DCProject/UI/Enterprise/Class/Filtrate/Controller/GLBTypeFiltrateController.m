//
//  GLBTypeFiltrateController.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTypeFiltrateController.h"

#import "GLBTypeFiltrateCell.h"

static NSString *const listCellID = @"GLBTypeFiltrateCell";
static NSString *const sectionID = @"UITableViewHeaderFooterView";

@interface GLBTypeFiltrateController ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *restBtn;
@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) NSMutableArray<GLBTypeModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GLBTypeModel *> *selectArray;

@end

@implementation GLBTypeFiltrateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0];
    
    
    [self requestDrugTypeData];
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray[section] son] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBTypeFiltrateCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithTypeModel:[self.dataArray[indexPath.section] son][indexPath.row] selectArray:self.selectArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    header.contentView.backgroundColor = [UIColor whiteColor];
    
    for (id class in header.contentView.subviews) {
        [class removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    titleLabel.font = PFRFont(15);
    titleLabel.text = [self.dataArray[section] catName];
    [header.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.contentView.left).offset(15);
        make.bottom.equalTo(header.contentView.bottom).offset(-10);
    }];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBTypeModel *typeModel = [self.dataArray[indexPath.section] son][indexPath.row];
    
    GLBTypeModel *model = nil;
    for (int i=0; i<self.selectArray.count; i++) {
        GLBTypeModel *selectModel = self.selectArray[i];
        if ([selectModel.catId isEqualToString:typeModel.catId]) {
            model = selectModel;
        }
    }
    
    if (model) {
        [self.selectArray removeObject:model];
    } else {
//        [self.selectArray removeAllObjects];
        [self.selectArray addObject:typeModel];
    }
    
    [self.tableView reloadData];
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
        _successBlock(self.selectArray);
    }
    
    [self cancelBtnClick:nil];
}

- (void)restBtnClick:(UIButton *)button
{
    [self.selectArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - 获取药品分类
- (void)requestDrugTypeData
{
    [self.dataArray removeAllObjects];
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDrugTypeWithCatIds:_catIds success:^(id response) {
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
          self.tableView.frame = CGRectMake(0, [_frameType floatValue] , kScreenW, 36.5*6);
    }
    else{
          self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, 36.5*6);
    }
  
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 36.0f;
    self.tableView.sectionHeaderHeight = 50.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID
     ];
    
}


#pragma mark - lazy load
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40)];
        _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
        if (self.frameType)
        {
            _bgView.frame = CGRectMake(0, [self.frameType floatValue], kScreenW, kScreenH - [self.frameType floatValue]);
        }
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

- (NSMutableArray<GLBTypeModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLBTypeModel *> *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


#pragma mark - setter
- (void)setUserTypeArray:(NSMutableArray *)userTypeArray
{
    _userTypeArray = userTypeArray;
    
    [self.selectArray removeAllObjects];
    [self.selectArray addObjectsFromArray:_userTypeArray];
}

@end
